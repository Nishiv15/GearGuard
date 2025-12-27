import mongoose from "mongoose";

const activityLogSchema = new mongoose.Schema(
  {
    companyId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Company",
      required: true,
    },

    entityType: {
      type: String,
      enum: ["EQUIPMENT", "REQUEST"],
      required: true,
    },

    entityId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
    },

    action: {
      type: String,
      required: true,
    },

    performedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    metadata: {
      type: Object,
    },
  },
  { timestamps: true }
);

export default mongoose.model("ActivityLog", activityLogSchema);
