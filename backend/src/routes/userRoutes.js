import express from "express";
import { createUser, updateUser, deleteUser, getAllUsers } from "../controllers/userController.js";
import { protect } from "../middlewares/authMiddleware.js";
import { allowRoles } from "../middlewares/roleMiddleware.js";

const router = express.Router();

router.post(
    "/create-user",
    protect,
    allowRoles("OWNER", "MANAGER"),
    createUser
);

router.put(
  "/:id",
  protect,
  allowRoles("OWNER", "MANAGER", "TECHNICIAN", "EMPLOYEE"),
  updateUser
);

router.delete(
  "/:id",
  protect,
  allowRoles("OWNER", "MANAGER"),
  deleteUser
);

router.get(
  "/",
  protect,
  allowRoles("OWNER", "MANAGER"),
  getAllUsers
);

export default router;
