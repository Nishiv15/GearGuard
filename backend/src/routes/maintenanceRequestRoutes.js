import express from "express";
import {
  createRequest,
  getAllRequests,
  getRequestById,
  updateRequestStatus,
} from "../controllers/maintenanceRequestController.js";
import { protect } from "../middlewares/authMiddleware.js";
import { allowRoles } from "../middlewares/roleMiddleware.js";

const router = express.Router();

// Create request
router.post(
  "/create-request",
  protect,
  allowRoles("OWNER", "MANAGER", "EMPLOYEE"),
  createRequest
);

// Get all requests
router.get(
  "/",
  protect,
  allowRoles("OWNER", "MANAGER", "TECHNICIAN"),
  getAllRequests
);

// Get request by ID
router.get(
  "/:id",
  protect,
  allowRoles("OWNER", "MANAGER", "TECHNICIAN"),
  getRequestById
);

// Update status (Kanban)
router.put(
  "/:id/status",
  protect,
  allowRoles("TECHNICIAN"),
  updateRequestStatus
);

export default router;
