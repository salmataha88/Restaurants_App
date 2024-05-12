import bcrypt from "bcryptjs";
import JWT from "jsonwebtoken";
import User from "../../DB/models/user.js";

export const signUp = async (req, res) => {
  try {
    const { name, gender, email, level, password, confirmPassword, location } = req.body;

    // Validate fields
    if (!name || !email || !password || !confirmPassword) {
      return res.status(400).json({ msg: "Please fill in all mandatory fields" });
    }

    // Additional field validations
    if (password.length < 8) {
      return res.status(400).json({ msg: "Password must be at least 8 characters long" });
    }
    if (password != confirmPassword) {
      return res.status(400).json({ msg: "Passwords do not match" });
    }
    // Optional field validations
    if (gender && !["Male", "Female"].includes(gender)) {
      return res.status(400).json({ msg: "Invalid gender" });
    }
    if (level && ![1, 2, 3, 4].includes(level)) {
      return res.status(400).json({ msg: "Invalid level" });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ msg: "User with the same email already exists!" });
    }

    const hashedPassword = await bcrypt.hash(password, 8);

    let user = new User({
      name,
      gender,
      email,
      level,
      password: hashedPassword,
      location: {
        type: "Point",
        coordinates: [location.longitude, location.latitude],
      },
    });

    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const signIn = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    const token = JWT.sign({ id: user._id}, "passwordKey");

    res.status(200).json(
    { 
      Message : "SignIn Successfully.." ,
      token, ...user._doc 
    });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const tokenIsValid = async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = JWT.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.status(200).json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export const getUserData = async (req, res) => {
  try {
    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ msg: "User not found" });
    }

    // Extracting raw user data and adding the token
    const userData = { ...user._doc};

    res.json(userData);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
