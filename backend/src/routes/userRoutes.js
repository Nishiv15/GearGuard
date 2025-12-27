import express from "express";
import { createUser } from "../controllers/userController.js";
import { protect } from "../middlewares/authMiddleware.js";
import { allowRoles } from "../middlewares/roleMiddleware.js";

const router = express.Router();

router.post(
    "/create-user",
    protect,
    allowRoles("OWNER", "MANAGER"),
    createUser
);

export default router;
