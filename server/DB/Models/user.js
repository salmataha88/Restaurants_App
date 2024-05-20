import { Schema, model } from "mongoose";

const userSchema = Schema({
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
  location: {
    type: {
      type: String,
      enum: ["Point"],
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


const User = model("User", userSchema);
export default User;
