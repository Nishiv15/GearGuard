import express from "express";
import {
  createTeam,
  getAllTeams,
  updateTeam,
  deleteTeam,
  addMemberToTeam,
  removeMemberFromTeam,
} from "../controllers/maintenanceTeamController.js";
import { protect } from "../middlewares/authMiddleware.js";
import { allowRoles } from "../middlewares/roleMiddleware.js";

const router = express.Router();

router.post("/create-team", protect, allowRoles("OWNER", "MANAGER"), createTeam);
router.get("/", protect, allowRoles("OWNER", "MANAGER", "EMPLOYEE", "TECHNICIAN"), getAllTeams);
router.put("/:id", protect, allowRoles("OWNER", "MANAGER"), updateTeam);
router.delete("/:id", protect, allowRoles("OWNER"), deleteTeam);

router.post(
  "/:id/members",
  protect,
  allowRoles("OWNER", "MANAGER"),
  addMemberToTeam
);

router.delete(
  "/:id/members/:userId",
  protect,
  allowRoles("OWNER", "MANAGER"),
  removeMemberFromTeam
);

export default router;
