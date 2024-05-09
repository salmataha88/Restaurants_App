const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  gender: {
    type: String,
    enum: ["Male", "Female"],
  },
  email: {
    required: true,
    type: String,
    trim: true,
    unique: true, // Ensure unique email addresses
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  level: {
    type: Number,
    enum: [1, 2, 3, 4],
  },
  password: {
    required: true,
    type: String,
    minlength: 8,
  },
  confirmPassword: {
    required: true,
    type: String,
  },
  location: {
    type: {
      type: String,
      enum: ["Point"], // Specify that it's a point
      required: true,
    },
    coordinates: {
      type: [Number], // Array of numbers for [longitude, latitude]
      required: true,
      validate: {
        validator: (value) => value.length === 2,
        message: "Coordinates array must contain exactly 2 numbers",
      },
    },
  },
});


const User = mongoose.model("User", userSchema);
module.exports = User;
