import mongoose from "mongoose";
import MaintenanceRequest from "../models/MaintenanceRequest.js";
import Equipment from "../models/Equipment.js";
import User from "../models/User.js";

/**
 * @route POST /api/requests
 * @access OWNER, MANAGER, EMPLOYEE
 */
const createRequest = async (req, res) => {
  try {
    const { equipmentId, type, priority, scheduledDate } = req.body;

    if (!equipmentId || !type) {
      return res.status(400).json({
        message: "equipmentId and type are required",
      });
    }

    if (!mongoose.Types.ObjectId.isValid(equipmentId)) {
      return res.status(400).json({ message: "Invalid equipmentId" });
    }

    if (type === "PREVENTIVE" && !scheduledDate) {
      return res.status(400).json({
        message: "scheduledDate is required for preventive maintenance",
      });
    }

    const equipment = await Equipment.findOne({
      _id: equipmentId,
      companyId: req.user.companyId,
      isScrapped: false,
    });

    if (!equipment) {
      return res.status(404).json({
        message: "Equipment not found or scrapped",
      });
    }

    const request = await MaintenanceRequest.create({
      companyId: req.user.companyId,
      createdBy: req.user._id,
      equipmentId: equipment._id,
      equipmentCategory: equipment.category,
      maintenanceTeamId: equipment.maintenanceTeamId,
      type,
      priority,
      scheduledDate: scheduledDate || null,
    });

    res.status(201).json({
      success: true,
      request,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route GET /api/requests
 * @access OWNER, MANAGER, TECHNICIAN
 */
const getAllRequests = async (req, res) => {
  try {
    const filter = { companyId: req.user.companyId };

    // Technician sees only their team requests
    if (req.user.role === "TECHNICIAN") {
      filter.maintenanceTeamId = req.user.maintenanceTeamId;
    }

    const requests = await MaintenanceRequest.find(filter)
      .populate("equipmentId", "name serialNumber")
      .populate("maintenanceTeamId", "name")
      .populate("assignedTo", "name email")
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: requests.length,
      requests,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route GET /api/requests/:id
 * @access OWNER, MANAGER, TECHNICIAN
 */
const getRequestById = async (req, res) => {
  try {
    const request = await MaintenanceRequest.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    })
      .populate("equipmentId", "name serialNumber")
      .populate("maintenanceTeamId", "name")
      .populate("assignedTo", "name email");

    if (!request) {
      return res.status(404).json({ message: "Request not found" });
    }

    // Technician can only see requests from their team
    if (
      req.user.role === "TECHNICIAN" &&
      req.user.maintenanceTeamId?.toString() !==
        request.maintenanceTeamId.toString()
    ) {
      return res.status(403).json({ message: "Access denied" });
    }

    res.json({
      success: true,
      request,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route PUT /api/requests/:id/status
 * @access TECHNICIAN
 */
const updateRequestStatus = async (req, res) => {
  try {
    const { status, duration } = req.body;

    const request = await MaintenanceRequest.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    });

    if (!request) {
      return res.status(404).json({ message: "Request not found" });
    }

    if (req.user.role !== "TECHNICIAN") {
      return res.status(403).json({
        message: "Only technicians can update request status",
      });
    }

    if (
      req.user.maintenanceTeamId?.toString() !==
      request.maintenanceTeamId.toString()
    ) {
      return res.status(403).json({ message: "Not your team request" });
    }

    request.status = status;

    if (status === "IN_PROGRESS") {
      request.startedAt = new Date();
      request.assignedTo = req.user._id;
    }

    if (status === "REPAIRED") {
      if (typeof duration !== "number") {
        return res.status(400).json({
          message: "duration is required when repairing",
        });
      }
      request.duration = duration;
      request.completedAt = new Date();
    }

    await request.save();

    res.json({
      success: true,
      request,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export {
  createRequest,
  getAllRequests,
  getRequestById,
  updateRequestStatus,
};
