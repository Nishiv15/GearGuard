import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import morgan from "morgan";
import connectDB from "./config/db.js";
import authRoutes from "./routes/authRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import maintenanceTeamRoutes from "./routes/maintenanceTeamRoutes.js";
import equipmentRoutes from "./routes/equipmentRoutes.js";
import maintenanceRequestRoutes from "./routes/maintenanceRequestRoutes.js";

dotenv.config();

const app = express();

/* ---------- MIDDLEWARE ---------- */
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

/* ---------- HEALTH CHECK ---------- */
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);
app.use("/api/teams", maintenanceTeamRoutes);
app.use("/api/equipments", equipmentRoutes);
app.use("/api/requests", maintenanceRequestRoutes);

/* ---------- START SERVER ---------- */
const PORT = process.env.PORT || 5000;

connectDB().then(() => {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT} 🚀`);
  });
});