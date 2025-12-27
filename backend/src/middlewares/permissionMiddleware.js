const canOnboardUsers = (req, res, next) => {
  if (!req.user.permissions.canOnboardUsers) {
    return res.status(403).json({ message: "Permission denied" });
  }
  next();
};

const canCreateTeams = (req, res, next) => {
  if (!req.user.permissions.canCreateTeams) {
    return res.status(403).json({ message: "Permission denied" });
  }
  next();
};

const canAssignRoles = (req, res, next) => {
  if (!req.user.permissions.canAssignRoles) {
    return res.status(403).json({ message: "Permission denied" });
  }
  next();
};

export {canOnboardUsers, canCreateTeams, canAssignRoles}