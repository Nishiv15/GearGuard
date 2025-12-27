import Equipment from "../models/Equipment.js";
import MaintenanceTeam from "../models/MaintenanceTeam.js";
import User from "../models/User.js";

/**
 * @route POST /api/equipment
 * @access OWNER, MANAGER
 */
const createEquipment = async (req, res) => {
  try {
    const {
      name,
      serialNumber,
      category,
      department,
      maintenanceTeamId,
      defaultTechnicianId,
      purchaseDate,
      warrantyExpiry,
      location,
    } = req.body;

    if (!name || !serialNumber || !category || !maintenanceTeamId) {
      return res.status(400).json({
        message: "name, serialNumber, category, maintenanceTeamId are required",
      });
    }

    const existing = await Equipment.findOne({
      companyId: req.user.companyId,
      serialNumber,
    });

    if (existing) {
      return res.status(400).json({
        message: "Equipment with this serial number already exists",
      });
    }

    const team = await MaintenanceTeam.findOne({
      _id: maintenanceTeamId,
      companyId: req.user.companyId,
    });

    if (!team) {
      return res.status(400).json({
        message: "Invalid maintenance team",
      });
    }

    if (defaultTechnicianId) {
      const tech = await User.findOne({
        _id: defaultTechnicianId,
        companyId: req.user.companyId,
        role: "TECHNICIAN",
      });

      if (!tech) {
        return res.status(400).json({
          message: "Default technician must be a technician",
        });
      }
    }

    const equipment = await Equipment.create({
      companyId: req.user.companyId,
      name,
      serialNumber,
      category,
      department,
      maintenanceTeamId,
      defaultTechnicianId,
      purchaseDate,
      warrantyExpiry,
      location,
    });

    res.status(201).json({
      success: true,
      equipment,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route GET /api/equipment
 * @access OWNER, MANAGER
 */
const getAllEquipment = async (req, res) => {
  try {
    const equipment = await Equipment.find({
      companyId: req.user.companyId,
    })
      .populate("maintenanceTeamId", "name")
      .populate("defaultTechnicianId", "name email");

    res.json({
      success: true,
      count: equipment.length,
      equipment,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route GET /api/equipment/:id
 * @access OWNER, MANAGER
 */
const getEquipmentById = async (req, res) => {
  try {
    const equipment = await Equipment.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    })
      .populate("maintenanceTeamId", "name")
      .populate("defaultTechnicianId", "name email");

    if (!equipment) {
      return res.status(404).json({ message: "Equipment not found" });
    }

    res.json({
      success: true,
      equipment,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route PUT /api/equipment/:id
 * @access OWNER, MANAGER
 */
const updateEquipment = async (req, res) => {
  try {
    const equipment = await Equipment.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    });

    if (!equipment) {
      return res.status(404).json({ message: "Equipment not found" });
    }

    Object.assign(equipment, req.body);

    await equipment.save();

    res.json({
      success: true,
      equipment,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * @route DELETE /api/equipment/:id
 * @access OWNER
 */
const deleteEquipment = async (req, res) => {
  try {
    if (req.user.role !== "OWNER") {
      return res.status(403).json({
        message: "Only owner can delete equipment",
      });
    }

    const equipment = await Equipment.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    });

    if (!equipment) {
      return res.status(404).json({ message: "Equipment not found" });
    }

    await equipment.deleteOne();

    res.json({
      success: true,
      message: "Equipment deleted successfully",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export {
  createEquipment,
  getAllEquipment,
  getEquipmentById,
  updateEquipment,
  deleteEquipment,
};
