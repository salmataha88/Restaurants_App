import { Router } from "express";
import * as controller from "./restaurant.controller.js";

const restaurantRouter = Router();

restaurantRouter.post("/add/:restaurantId", controller.addRestaurant);
restaurantRouter.get("/", controller.getAllRestaurants);
restaurantRouter.get("/:productId", controller.getRestaurantsByProduct);
restaurantRouter.get("/:restaurantId", controller.getRestaurantById);
restaurantRouter.put("/update/:restaurantId", controller.updateRestaurant);
restaurantRouter.delete("/delete/:restaurantId", controller.deleteRestaurant);


export default restaurantRouter;
