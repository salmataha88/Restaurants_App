import { Router } from 'express';
import * as Controller from './product.controller.js';

const productRouter = Router();

productRouter.post('/add/:restaurantId', Controller.addProductToRestaurant);
productRouter.get('/',Controller.getAllProducts);
productRouter.get('/restaurant/:restaurantId',Controller.getProductsForRestaurant);
productRouter.get('/search',Controller.searchProducts);
productRouter.put('/update/:productId',Controller.updateProduct);
productRouter.delete('/delete/:productId',Controller.deleteProduct);

export default productRouter;