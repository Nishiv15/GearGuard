import mongoose from "mongoose";

const maintenanceRequestSchema = new mongoose.Schema(
  {
    companyId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Company",
      required: true,
    },

    subject: {
      type: String,
      required: true,
      trim: true,
    },

    description: {
      type: String,
      trim: true,
    },

    type: {
      type: String,
      enum: ["CORRECTIVE", "PREVENTIVE"],
      required: true,
    },

    equipmentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Equipment",
      required: true,
    },

    maintenanceTeamId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "MaintenanceTeam",
      required: true,
    },

    status: {
      type: String,
      enum: ["NEW", "IN_PROGRESS", "REPAIRED", "SCRAP"],
      default: "NEW",
    },

    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    assignedTo: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },

    scheduledDate: {
      type: Date,
    },

    startedAt: {
      type: Date,
    },

    completedAt: {
      type: Date,
    },

    duration: {
      type: Number, // hours
    },

    isOverdue: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

/* ---------- INDEXES ---------- */
maintenanceRequestSchema.index({ companyId: 1, status: 1 });
maintenanceRequestSchema.index({ companyId: 1, maintenanceTeamId: 1 });
maintenanceRequestSchema.index({ companyId: 1, scheduledDate: 1 });

export default mongoose.model(
  "MaintenanceRequest",
  maintenanceRequestSchema
);
