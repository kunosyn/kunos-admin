local server_bans = require(script.Parent.Parent.ServerBans);

local ds = game:GetService("DataStoreService");
local bans = ds:GetDataStore("bans");

local globals = require(script.Parent.Globals);

local admin_events = game.ReplicatedStorage.admin_events;

local module = {};

module.player_permissions = function(player, action)
	local sanctioned = false;

	for i,v in pairs(globals.groups) do
		local rank = player:GetRankInGroup(v);
		
		if rank < globals.rank_permissions[globals.groups[i]]["highest written"] then
			if not rank or not globals.rank_permissions[globals.groups[i]][rank] then continue end;
		end

		if rank > globals.rank_permissions[globals.groups[i]]["highest written"] then
			sanctioned = true;
			break;
		elseif globals.rank_permissions[globals.groups[i]][rank][action] then 
			sanctioned = true;
			break;
		end
	end

	return sanctioned;
end

module.split_str = function(str)
	local args = {};
	for token in string.gmatch(str, "[^%s]+") do
		table.insert(args, token);
	end
	return args;
end

module.system_message = function(system, msg)
	admin_events.system_message:FireAllClients(system, msg);
end

module.system_private_message = function(system, message, target)
	admin_events.system_message:FireClient(target, system, message);
end

module.annouce = function(msg, announcer, pm, target)
	if pm then
		if not game.Players:FindFirstChild(target.Name) then return end;
		
		
		admin_events.announce:FireClient(target, msg, announcer);
	else
		admin_events.announce:FireAllClients(msg, announcer);
	end
end

module.isPBanned = function(id)
	local banned = bans:GetAsync(id);
	
	if banned then return true end;
	return false;
end

module.isSBanned = function(id)
	if server_bans[id] then return true end;
	return false;
end

module.getChatService = function()
	return require(game.ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"));
end

module.getUserTags = function(player)
	local tags = {};
	
	if globals.chattags["player_tags"][player.UserId] then
		for i,v in pairs(globals.chattags["player_tags"][player.UserId]) do
			table.insert(tags, v);
		end
	end
	for _,v in pairs(globals.groups) do
		local rank = player:GetRankInGroup(v);

		if globals.chattags[v][rank] then
			table.insert(tags, globals.chattags[v][rank]);
		end
	end
	
	return tags;
end

return module;
