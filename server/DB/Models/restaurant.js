import { Schema, model } from "mongoose";

const restaurantSchema = Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  }, 
  address: {
    type: String,
    required: true,
    trim: true,
  },
  location: {
    type: {
      type: String,
      enum: ["Point"],
    },
    coordinates: {
      type: [Number],
      required: true,
      validate: {
        validator: (value) => value.length === 2,
        message: "Coordinates array must contain exactly 2 numbers",
      },
    },
  },
  products: [{
    type: Schema.Types.ObjectId,
    ref: 'Product'
  }]
});


const Restaurant = model("Restaurant", restaurantSchema);
export default Restaurant;
