import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
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

    email: {
      type: String,
      required: true,
      lowercase: true,
      trim: true,
    },

    password: {
      type: String,
      required: true,
    },

    role: {
      type: String,
      enum: ["MANAGER", "TECHNICIAN", "EMPLOYEE"],
      default: "EMPLOYEE",
    },

    permissions: {
      canOnboardUsers: {
        type: Boolean,
        default: false,
      },
      canCreateTeams: {
        type: Boolean,
        default: false,
      },
      canAssignRoles: {
        type: Boolean,
        default: false,
      },
    },

    maintenanceTeamId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "MaintenanceTeam",
      default: null,
    },

    isActive: {
      type: Boolean,
      default: true,
    },
  },
  { timestamps: true }
);

/* ---------- INDEX ---------- */
userSchema.index({ companyId: 1, email: 1 }, { unique: true });

export default mongoose.model("User", userSchema);