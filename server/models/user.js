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
});

const User = mongoose.model("User", userSchema);
module.exports = User;
