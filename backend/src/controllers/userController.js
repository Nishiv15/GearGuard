import bcrypt from "bcryptjs";
import User from "../models/User.js";

const createUser = async (req, res) => {
  try {
    const { name, email, password, repassword, role, maintenanceTeamId } =
      req.body;

    if (!name || !email || !password || !role) {
      return res.status(400).json({
        message: "name, email, password and role are required",
      });
    }

    if (password !== repassword) {
      return res.status(400).json({ messgae: "Password is not matching" });
    }

    // 🔒 EMPLOYEE cannot create anyone
    if (req.user.role === "EMPLOYEE" || req.user.role === "TECHNICIAN") {
      return res.status(403).json({
        message: "You are not allowed to create users",
      });
    }

    // 🔒 MANAGER restrictions
    if (req.user.role === "MANAGER") {
      if (role === "OWNER" || role === "MANAGER") {
        return res.status(403).json({
          message: "Manager cannot create owner or manager",
        });
      }
    }

    const existingUser = await User.findOne({
      email,
      companyId: req.user.companyId,
    });

    if (existingUser) {
      return res.status(400).json({
        message: "User already exists",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    let permissions = {
      canOnboardUsers: false,
      canCreateTeams: false,
      canAssignRoles: false,
    };

    // OWNER & MANAGER get all permissions
    if (role === "OWNER" || role === "MANAGER") {
      permissions = {
        canOnboardUsers: true,
        canCreateTeams: true,
        canAssignRoles: true,
      };
    }

    const user = await User.create({
      companyId: req.user.companyId,
      name,
      email,
      password: hashedPassword,
      role,
      permissions,
      maintenanceTeamId:
        role === "TECHNICIAN" ? maintenanceTeamId || null : null,
    });

    res.status(201).json({
      success: true,
      user,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export { createUser };
