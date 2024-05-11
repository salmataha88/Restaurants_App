import { Router } from "express";
import * as controller from "./user.controller.js";

const userRouter = Router();

userRouter.post("/signup", controller.signUp);

userRouter.post("/signin", controller.signIn);

export default userRouter;
