import { Schema, model } from "mongoose";

const productSchema = new Schema({
  name: { 
    type: String, 
    required: true 
  },
  details: { 
    type: String, 
    required: true 
  },
  price: { 
    type: Number, 
    required: true 
  },
  /* restaurants: [{ 
    type: Schema.Types.ObjectId, 
    ref: "Restaurant" 
  }], */
});

const Product = model("Product", productSchema);
export default Product;
