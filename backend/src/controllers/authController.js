import bcrypt from "bcryptjs";
import Company from "../models/Company.js";
import User from "../models/User.js";
import generateToken from "../utils/generateToken.js";

const signup = async (req, res) => {
  try {
    console.log("REQ BODY:", req.body);

    const { companyName, name, email, password, repassword } = req.body;

    if (!companyName || !name || !email || !password || !repassword) {
      return res.status(400).json({
        message: "All fields are required",
      });
    }

    if (password !== repassword) {
      return res.status(400).json({
        message: "Password is not matching",
      });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        message: "Email already exists",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const company = await Company.create({
      name: companyName,
    });

    const user = await User.create({
      companyId: company._id,
      name,
      email,
      password: hashedPassword,
      role: "MANAGER",
      permissions: {
        canOnboardUsers: true,
        canCreateTeams: true,
        canAssignRoles: true,
      },
    });

    const token = generateToken(user);

    res.status(201).json({
      success: true,
      token,
      user,
      company,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: error.message });
  }
};


const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });

    if (!user || !user.isActive) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    const token = generateToken(user);

    res.json({
      success: true,
      token,
      user,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export { signup, login };
