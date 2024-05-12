import Restaurant from '../../DB/Models/restaurant.js';
import Product from '../../DB/Models/product.js';

// Add a new restaurant
export const addRestaurant = async (req, res) => {
  try {
    const { name, address, location } = req.body; // Added address field
    const newRestaurant = new Restaurant({
      name, 
      address,
      location: {
        type: "Point",
        coordinates: [location.longitude, location.latitude],
      },
    }); 
    await newRestaurant.save();
    res.status(201).json({Message: "Added Successfully.."});
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get all restaurants
export const getAllRestaurants = async (req, res) => {
  try {
    const restaurants = await Restaurant.find();
    res.status(200).json(restaurants);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get details of a specific restaurant by its ID
export const getRestaurantById = async (req, res) => {
  try {
    const { restaurantId } = req.params;
    const restaurant = await Restaurant.findById(restaurantId);
    if (!restaurant) {
      return res.status(404).json({ error: 'Restaurant not found' });
    }
    res.status(200).json(restaurant);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// Get restaurants that offer a specific product
export const getRestaurantsByProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }
    const restaurants = await Restaurant.find({ products: productId });
    res.status(200).json(restaurants);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update restaurant details
export const updateRestaurant = async (req, res) => {
  try {
    const { restaurantId } = req.params;
    const { name, address, location } = req.body;
    const updatedRestaurant = await Restaurant.findByIdAndUpdate(
      restaurantId,
      { name, address, location },
      { new: true }
    );
    if (!updatedRestaurant) {
      return res.status(404).json({ error: 'Restaurant not found' });
    }
    res.json(updatedRestaurant);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete a restaurant
export const deleteRestaurant = async (req, res) => {
  try {
    const { restaurantId } = req.params;
    const deletedRestaurant = await Restaurant.findByIdAndDelete(restaurantId);
    if (!deletedRestaurant) {
      return res.status(404).json({ error: 'Restaurant not found' });
    }
    res.json({ message: 'Restaurant deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};