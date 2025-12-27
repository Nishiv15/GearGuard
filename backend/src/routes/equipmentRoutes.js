import express from "express";
import {
  createEquipment,
  getAllEquipment,
  getEquipmentById,
  updateEquipment,
  deleteEquipment,
} from "../controllers/equipmentController.js";
import { protect } from "../middlewares/authMiddleware.js";
import { allowRoles } from "../middlewares/roleMiddleware.js";

const router = express.Router();

router.post("/create-equipment", protect, allowRoles("OWNER", "MANAGER"), createEquipment);
router.get("/", protect, allowRoles("OWNER", "MANAGER", "EMPLOYEE", "TECHNICIAN"), getAllEquipment);
router.get("/:id", protect, allowRoles("OWNER", "MANAGER", "EMPLOYEE", "TECHNICIAN"), getEquipmentById);
router.put("/:id", protect, allowRoles("OWNER", "MANAGER"), updateEquipment);
router.delete("/:id", protect, allowRoles("OWNER","Manager"), deleteEquipment);

export default router;
