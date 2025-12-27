import mongoose from "mongoose";

const maintenanceRequestSchema = new mongoose.Schema(
  {
    companyId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Company",
      required: true,
    },

    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    equipmentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Equipment",
      required: true,
    },

    equipmentCategory: {
      type: String, // auto-filled from Equipment
      required: true,
    },

    maintenanceTeamId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "MaintenanceTeam",
      required: true,
    },

    assignedTo: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User", // Technician
      default: null,
    },

    type: {
      type: String,
      enum: ["CORRECTIVE", "PREVENTIVE"],
      required: true,
    },

    priority: {
      type: String,
      enum: ["LOW", "MEDIUM", "HIGH"],
      default: "MEDIUM",
    },

    status: {
      type: String,
      enum: ["NEW", "IN_PROGRESS", "REPAIRED", "SCRAP"],
      default: "NEW",
    },

    scheduledDate: {
      type: Date, // required only for PREVENTIVE
    },

    duration: {
      type: Number, // hours
      default: 0,
    },

    startedAt: Date,
    completedAt: Date,

    isOverdue: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

export default mongoose.model(
  "MaintenanceRequest",
  maintenanceRequestSchema
);
