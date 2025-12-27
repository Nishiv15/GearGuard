import MaintenanceTeam from "../models/MaintenanceTeam.js";
import User from "../models/User.js";

/**
 * @route POST /api/teams
 * @access OWNER, MANAGER
 */
const createTeam = async (req, res) => {
  try {
    const { name, description } = req.body;

    if (!name) {
      return res.status(400).json({ message: "Team name is required" });
    }

    const existingTeam = await MaintenanceTeam.findOne({
      companyId: req.user.companyId,
      name,
    });

    if (existingTeam) {
      return res.status(400).json({
        message: "Team with this name already exists",
      });
    }

    const team = await MaintenanceTeam.create({
      companyId: req.user.companyId,
      name,
      description,
      createdBy: req.user._id,
    });

    res.status(201).json({
      success: true,
      team,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route GET /api/teams
 * @access OWNER, MANAGER
 */
const getAllTeams = async (req, res) => {
  try {
    const teams = await MaintenanceTeam.find({
      companyId: req.user.companyId,
    }).populate("members", "name email role");

    res.json({
      success: true,
      count: teams.length,
      teams,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route PUT /api/teams/:id
 * @access OWNER, MANAGER
 */
const updateTeam = async (req, res) => {
  try {
    const { name, description } = req.body;

    const team = await MaintenanceTeam.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    });

    if (!team) {
      return res.status(404).json({ message: "Team not found" });
    }

    if (name) team.name = name;
    if (description !== undefined) team.description = description;

    await team.save();

    res.json({
      success: true,
      team,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route DELETE /api/teams/:id
 * @access OWNER
 */
const deleteTeam = async (req, res) => {
  try {
    if (req.user.role !== "OWNER") {
      return res.status(403).json({
        message: "Only owner can delete teams",
      });
    }

    const team = await MaintenanceTeam.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    });

    if (!team) {
      return res.status(404).json({ message: "Team not found" });
    }

    await team.deleteOne();

    res.json({
      success: true,
      message: "Team deleted successfully",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route POST /api/teams/:id/members
 * @access OWNER, MANAGER
 */
const addMemberToTeam = async (req, res) => {
  try {
    const { userId } = req.body;

    const team = await MaintenanceTeam.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    });

    if (!team) {
      return res.status(404).json({ message: "Team not found" });
    }

    const user = await User.findOne({
      _id: userId,
      companyId: req.user.companyId,
      role: "TECHNICIAN",
    });

    if (!user) {
      return res.status(400).json({
        message: "Only technicians can be added to a team",
      });
    }

    if (team.members.includes(userId)) {
      return res.status(400).json({
        message: "User already in team",
      });
    }

    team.members.push(userId);
    user.maintenanceTeamId = team._id;

    await team.save();
    await user.save();

    res.json({
      success: true,
      message: "Technician added to team",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route DELETE /api/teams/:id/members/:userId
 * @access OWNER, MANAGER
 */
const removeMemberFromTeam = async (req, res) => {
  try {
    const { id, userId } = req.params;

    const team = await MaintenanceTeam.findOne({
      _id: id,
      companyId: req.user.companyId,
    });

    if (!team) {
      return res.status(404).json({ message: "Team not found" });
    }

    team.members = team.members.filter(
      (memberId) => memberId.toString() !== userId
    );

    await User.updateOne(
      { _id: userId, companyId: req.user.companyId },
      { $set: { maintenanceTeamId: null } }
    );

    await team.save();

    res.json({
      success: true,
      message: "Technician removed from team",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export {
  createTeam,
  getAllTeams,
  updateTeam,
  deleteTeam,
  addMemberToTeam,
  removeMemberFromTeam,
};
