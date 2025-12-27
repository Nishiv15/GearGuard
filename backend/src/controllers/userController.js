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

const updateUser = async (req, res) => {
  try {
    const targetUserId = req.params.id;
    const {
      name,
      email,
      password,
      role,
      permissions,
      maintenanceTeamId,
    } = req.body;

    const targetUser = await User.findOne({
      _id: targetUserId,
      companyId: req.user.companyId,
    });

    if (!targetUser) {
      return res.status(404).json({ message: "User not found" });
    }

    // 🔒 TECHNICIAN & EMPLOYEE: can update ONLY their own password
    if (
      req.user.role === "TECHNICIAN" ||
      req.user.role === "EMPLOYEE"
    ) {
      if (req.user._id.toString() !== targetUserId) {
        return res.status(403).json({
          message: "You can only update your own password",
        });
      }

      if (!password) {
        return res.status(400).json({
          message: "Password is required",
        });
      }

      targetUser.password = await bcrypt.hash(password, 10);
      await targetUser.save();

      return res.json({
        success: true,
        message: "Password updated successfully",
      });
    }

    // 🔐 OWNER / MANAGER logic
    if (name) targetUser.name = name;
    if (email) targetUser.email = email;
    if (maintenanceTeamId !== undefined)
      targetUser.maintenanceTeamId = maintenanceTeamId;

    // 🔒 MANAGER cannot assign OWNER or MANAGER
    if (role) {
      if (
        req.user.role === "MANAGER" &&
        (role === "OWNER" || role === "MANAGER")
      ) {
        return res.status(403).json({
          message: "Manager cannot assign OWNER or MANAGER role",
        });
      }
      targetUser.role = role;
    }

    // Permissions handled automatically by role
    if (role) {
      if (role === "OWNER" || role === "MANAGER") {
        targetUser.permissions = {
          canOnboardUsers: true,
          canCreateTeams: true,
          canAssignRoles: true,
        };
      } else {
        targetUser.permissions = {
          canOnboardUsers: false,
          canCreateTeams: false,
          canAssignRoles: false,
        };
      }
    }

    if (password) {
      targetUser.password = await bcrypt.hash(password, 10);
    }

    await targetUser.save();

    res.json({
      success: true,
      user: targetUser,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const deleteUser = async (req, res) => {
  try {
    const targetUserId = req.params.id;

    const targetUser = await User.findOne({
      _id: targetUserId,
      companyId: req.user.companyId,
    });

    if (!targetUser) {
      return res.status(404).json({ message: "User not found" });
    }

    // ❌ EMPLOYEE & TECHNICIAN cannot delete anyone
    if (
      req.user.role === "EMPLOYEE" ||
      req.user.role === "TECHNICIAN"
    ) {
      return res.status(403).json({
        message: "You are not allowed to delete users",
      });
    }

    // ❌ MANAGER restrictions
    if (req.user.role === "MANAGER") {
      if (
        targetUser.role === "MANAGER" ||
        targetUser.role === "OWNER"
      ) {
        return res.status(403).json({
          message: "Manager cannot delete manager or owner",
        });
      }

      // optional safety
      if (req.user._id.toString() === targetUserId) {
        return res.status(403).json({
          message: "Manager cannot delete themselves",
        });
      }
    }

    // ❌ OWNER cannot delete last OWNER
    if (targetUser.role === "OWNER") {
      const ownerCount = await User.countDocuments({
        companyId: req.user.companyId,
        role: "OWNER",
      });

      if (ownerCount <= 1) {
        return res.status(403).json({
          message: "Cannot delete the last owner",
        });
      }
    }

    await targetUser.deleteOne();

    res.json({
      success: true,
      message: "User deleted successfully",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getAllUsers = async (req, res) => {
  try {
    const users = await User.find({
      companyId: req.user.companyId,
    }).select("-password"); // 🔒 never expose password

    res.json({
      success: true,
      count: users.length,
      users,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export { createUser, updateUser, deleteUser, getAllUsers };
