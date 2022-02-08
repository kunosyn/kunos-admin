local groupvitals = require(script.Parent.Parent.GroupVitals);

local module = {};

module.system = {
	["CommandPrefix"] = "!",
	["ChatColor"] = Color3.new(0, 0.317647, 1),
	["ChatName"] = "[SYSTEM]: "
};

module.groups = groupvitals.groups;
module.rank_permissions = groupvitals.rank_permissions;
module.chattags = groupvitals.chattags;

return module;
