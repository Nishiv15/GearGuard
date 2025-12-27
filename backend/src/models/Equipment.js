import mongoose from "mongoose";

const equipmentSchema = new mongoose.Schema(
  {
    companyId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Company",
      required: true,
    },

    name: {
      type: String,
      required: true,
      trim: true,
    },

    serialNumber: {
      type: String,
      required: true,
      trim: true,
    },

    category: {
      type: String,
      required: true,
      trim: true,
    },

    department: {
      type: String,
      trim: true,
    },

    assignedEmployeeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },

    maintenanceTeamId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "MaintenanceTeam",
      required: true,
    },

    defaultTechnicianId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },

    purchaseDate: {
      type: Date,
    },

    warrantyExpiry: {
      type: Date,
    },

    location: {
      type: String,
      trim: true,
    },

    isScrapped: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

/* ---------- INDEX ---------- */
equipmentSchema.index(
  { companyId: 1, serialNumber: 1 },
  { unique: true }
);

export default mongoose.model("Equipment", equipmentSchema);
