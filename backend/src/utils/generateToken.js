import jwt from "jsonwebtoken";

const generateToken = (user) => {
  return jwt.sign(
    {
      userId: user._id,
      companyId: user.companyId,
      role: user.role,
      permissions: user.permissions,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: process.env.JWT_EXPIRES_IN || "7d",
    }
  );
};

export default generateToken;
