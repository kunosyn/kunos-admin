local module = {};

module.webhook_link = ""; -- Link removed for security reasons
module.webhook_log = {
	"respawn",
	"kick",
	"sban",
	"pban",
	"mute"
};

module.webhook_format = function(executor, target, cmd)
		local em = {
			["content"] = "",
			["embeds"] = {
				{
					["type"] = "rich",
					["title"] = "***"..string.upper(cmd)..":***",
					["description"] = "*ADMIN: "..executor.Name.."*\n*TARGET: "..target.."*",
					["color"] = tonumber(0xffffff)
				}
			}
		}
		
		return em;
end;

module.groups = {
	8257824
};

module.rank_permissions = {
	["main group"] = 8257824,

	[8257824] = {
		[146] = {
			["respawn"] = true,
			["spectate"] = true,
			["unspectate"] = true,
			["pm"] = true, 
			["m"] = true
		},

		[147] = {
			["spectate"] = true,
			["unspectate"] = true,
			["respawn"] = true,
			["kick"] = true,
			["sban"] = true,
			["unsban"] = true,
			["mute"] = true,
			["unmute"] = true,
			["pm"] = true,
			["m"] = true

		},

		[148] = {
			["spectate"] = true,
			["unspectate"] = true,
			["respawn"] = true,
			["kick"] = true,
			["sban"] = true,
			["unsban"] = true,
			["pban"] = true,
			["unpban"] = true,
			["mute"] = true,
			["unmute"] = true,
			["pm"] = true,
			["m"] = true

		},


		["highest written"] = 148
	}
};

module.chattags = {
	[8257824] = {
		[255] = {TagText = "X", TagColor = Color3.new(0, 0.0666667, 1)},
		[254] = {TagText = "X", TagColor = Color3.new(0, 0, 0.658824)},
		[253] = {TagText = "HC", TagColor = Color3.new(0, 0.392157, 0.87451)},
		[252] = {TagText = "HC", TagColor = Color3.new(0, 0.129412, 0.87451)},
		[251] = {TagText = "DEV", TagColor = Color3.new(0.341176, 0.945098, 1)},
		[150] = {TagText = "O", TagColor = Color3.new(0, 0.207843, 0.6)},
		[149] = {TagText = "O", TagColor = Color3.new(0, 0.247059, 0.831373)},
		[148] = {TagText = "O", TagColor = Color3.new(0, 0.321569, 0.92549)},
		[147] = {TagText = "SO", TagColor = Color3.new(0, 0.694118, 0.729412)},
		[146] = {TagText = "SO", TagColor = Color3.new(0, 0.490196, 0.505882)}
		
	},
	
	["player_tags"] = {
		-- Keys inside here are user id's you wanna give tags too.
		[256584577] = {
			{TagText = "CDEV", TagColor = Color3.new(0.0352941, 0.164706, 0)}
		}
	}
}

return module;
