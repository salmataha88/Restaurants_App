import Product from '../../DB/Models/product.js';
import Restaurant from '../../DB/Models/restaurant.js';

// Add a product to a restaurant
export const addProductToRestaurant = async (req, res) => {
  try {
    const { restaurantId } = req.params;
    const { name, price, details } = req.body;
    
    // Find the restaurant by ID
    const restaurant = await Restaurant.findById(restaurantId);
    if (!restaurant) {
      return res.status(404).json({ error: 'Restaurant not found' });
    }
    
    // Create a new product
    const product = new Product({ name, price, details });
    //product.restaurants.push(restaurantId);
    await product.save();

    // Add the product's ID to the restaurant's products array
    restaurant.products.push(product._id);
    await restaurant.save();

    res.status(201).json({ Message: 'Product added to restaurant successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// Get products for a specific restaurant
export const getProductsForRestaurant = async (req, res) => {
  try {
    const { restaurantId } = req.params;
    const restaurant = await Restaurant.findById(restaurantId).populate('products');
    if (!restaurant) {
      return res.status(404).json({ error: 'Restaurant not found' });
    }
    res.status(200).json(restaurant.products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Search products by name and return distinct products
export const searchProducts = async (req, res) => {
  try {
    const { productName } = req.query;
    const regex = new RegExp(productName, 'i'); // Case-insensitive search
    
    // Use aggregation to group products by name and return distinct products
    const products = await Product.aggregate([
      { $match: { name: regex } },
      { $group: { _id: '$name', products: { $push: '$$ROOT' } } },
      { $project: { _id: 0, products: { $arrayElemAt: ['$products', 0] } } }
    ]);

    res.status(200).json(products.map(item => item.products));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// Get all products
export const getAllProducts = async (req, res) => {
  try {
    const products = await Product.find();
    res.status(200).json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update product details
export const updateProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const { name, price, details } = req.body; 
    const updatedProduct = await Product.findByIdAndUpdate(
      productId,
      { name, price, details },
      { new: true }
    );
    if (!updatedProduct) {
      return res.status(404).json({ error: 'Product not found' });
    }

    // Update the product's restaurants array
    //updatedProduct.restaurants = restaurants;

    await updatedProduct.save();

    res.json(updatedProduct);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// Delete a product
export const deleteProduct = async (req, res) => {
  try {
    const { productId } = req.params;

    // Find all restaurants that have the product ID in their products array
    const restaurantsToUpdate = await Restaurant.find({ products: productId });

    // Iterate through each restaurant and remove the product ID from its products array
    await Promise.all(restaurantsToUpdate.map(async (restaurant) => {
      restaurant.products.pull(productId);
      await restaurant.save();
    }));

    // Delete the product itself
    const deletedProduct = await Product.findByIdAndDelete(productId);
    if (!deletedProduct) {
      return res.status(404).json({ error: 'Product not found' });
    }
    res.status(200).json({ message: 'Product deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


