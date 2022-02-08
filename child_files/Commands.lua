local ts = game:GetService("TextService");
local ds = game:GetService("DataStoreService");
local bans = ds:GetDataStore("bans");

local server_bans = require(script.Parent.ServerBans);

local admin_events = game.ReplicatedStorage.admin_events;

local utils = script.Parent.Utils;
local methods = require(utils.Methods);
local globals = require(utils.Globals);

local module = {};

module.respawn = function(player, str, command)
	local username = methods.split_str(str)[2];
	if username == player.Name or not username then return end;

	local mentioned = game.Players:FindFirstChild(username);
	if not mentioned then return end;

	if mentioned:GetRankInGroup(globals.rank_permissions["main group"]) > player:GetRankInGroup(globals.rank_permissions["main group"]) then return end;

	mentioned:LoadCharacter();
	methods.system_private_message(globals.system, "Respawn executed.", player);
end

module.spectate = function(player, str, command)
	local mentioned_name = methods.split_str(str)[2];

	local mentioned = game.Players:FindFirstChild(mentioned_name);

	if mentioned and mentioned_name then
		methods.system_private_message(globals.system, "You are now spectating "..mentioned.Name..".", player);
		admin_events.spectate:FireClient(player, true, mentioned);
	end
end

module.unspectate = function(player, str, command)
	methods.system_private_message(globals.system, "You are no longer spectating.", player);
	admin_events.spectate:FireClient(player, false, nil);
end

module.kick = function(player, str, command)
	local username = methods.split_str(str)[2];

	if username == player.Name then return end;

	local mentioned = game.Players:FindFirstChild(username);
	if not mentioned then return end;

	if mentioned:GetRankInGroup(globals.rank_permissions["main group"]) > player:GetRankInGroup(globals.rank_permissions["main group"]) then return end;

	mentioned:Kick("You've been kicked from the server.");
	methods.system_message(username.." has been kicked.");
end

module.sban = function(player, str, command)
	local username = methods.split_str(str)[2];
	if username == player.Name or not username then return end;

	local mentioned = game.Players:FindFirstChild(username);
	if not mentioned then return end;

	if mentioned:GetRankInGroup(globals.rank_permissions["main group"]) > player:GetRankInGroup(globals.rank_permissions["main group"]) then return end;

	server_bans[mentioned.UserId] = true;

	mentioned:Kick("You are banned from this server. If you believe this is a mistake, contact us on our communications server.");
	methods.system_message(username.." has been s-banned.");
end

module.pban = function(player, str, command)
	local username = methods.split_str(str)[2];
	if username == player.Name or not username then return end;

	local mentioned = game.Players:FindFirstChild(username);
	if not mentioned then return end;

	if mentioned:GetRankInGroup(globals.rank_permissions["main group"]) > player:GetRankInGroup(globals.rank_permissions["main group"]) then return end;

	mentioned:Kick("You are permanently banned from The Oasis. If you believe this is a mistake, contact us on our communications server.");

	bans:SetAsync(mentioned.UserId, true);
	methods.system_message(username.." has been p-banned.");
end

module.unsban = function(player, str, command)
	local id = methods.split_str(str)[2];

	if methods.isSBanned(id) then
		server_bans[id] = false;
		methods.system_message(id.." has been un sbanned.");
	end
end


module.unpban = function(player, str, command)
	local id = methods.split_str(str)[2];

	if methods.isPBanned(id) then
		bans:RemoveAsync(id);
		methods.system_message(id.." has been un pbanned.");
	end
end

module.m = function(player, str, command)
	local message = str:gsub(command, "");
	
	local filtered;
	
	local success, err = pcall(function()
		filtered = ts:FilterStringAsync(message, player.UserId);
	end);
	
	if success then 
		methods.annouce(filtered:GetNonChatStringForBroadcastAsync(), player.Name, false, nil);
	end
end

module.pm = function(player, str, command)
	if not methods.player_permissions(player, "pm") then return end;
	
	local mentioned = methods.split_str(str)[2];
	local message = str:gsub(command.." "..mentioned, "");
	local mentioned_player = game.Players:FindFirstChild(mentioned);
	
	local filtered;

	local success, err = pcall(function()
		filtered = ts:FilterStringAsync(message, player.UserId);
	end);
	
	if success then
		methods.annouce(filtered:GetNonChatStringForBroadcastAsync(), player.Name, true, mentioned_player);
		methods.system_private_message(globals.system, "PM executed.", player);
	end
end

module.enabletags = function(player, str, command) 
	local cs = methods.getChatService();

	local speaker = cs:GetSpeaker(player.Name);
	
	local tags = methods.getUserTags(player);
	speaker:SetExtraData("Tags", tags);
end

module.disabletags = function(player, str, command)
	local cs = methods.getChatService();
	
	local speaker = cs:GetSpeaker(player.Name);
	speaker:SetExtraData("Tags");
end

module.enabletag = function(player, str, command)
	local cs = methods.getChatService();
	
	local args = methods.split_str(str);
	
	local speaker = cs:GetSpeaker(player.Name);
	local current_tags = speaker:GetExtraData("Tags");
	local tags = methods.getUserTags(player);
	
	if args[2] == "rank" then
		for i,v in pairs(globals.chattags[globals.rank_permissions["main group"]]) do
			if table.find(current_tags, v) then continue end;
			
			if table.find(tags, v) then
				table.insert(current_tags, v);
			end
		end 
		
		speaker:SetExtraData("Tags", current_tags);
	elseif args[2] == "division" then
		for i,v in pairs(globals.chattags) do
			if i == "player_tags" or i == globals.rank_permissions["main group"] then continue end;
				
			for si,sv in pairs(v) do
				if table.find(current_tags, sv) then continue end;
				
				if table.find(tags, sv) then
					table.insert(current_tags, sv);
				end
			end
		end
		
		speaker:SetExtraData("Tags", current_tags);
	elseif args[2] == "custom" then
		for i,v in pairs(globals.chattags["player_tags"][player.UserId]) do
			if table.find(current_tags, v) then continue end;
			table.insert(current_tags, v);
		end
		
		speaker:SetExtraData("Tags", current_tags);
	else
		for i,v in pairs(tags) do
			if v.TagText == args[2] then
				local current_tags = speaker:GetExtraData("Tags");
				table.insert(current_tags, v);
				speaker:SetExtraData("Tags", current_tags);
				
				break;
			end
		end
	end
end

module.disabletag = function(player, str, command)
	local cs = methods.getChatService();
	local speaker = cs:GetSpeaker(player.Name);
	local current_tags = speaker:GetExtraData("Tags");
	local tags = methods.getUserTags(player);
	local args = methods.split_str(str);
	
	if args[2] == "rank" then
		for i,v in pairs(globals.chattags[globals.rank_permissions["main group"]]) do
			if table.find(current_tags, v) then
				table.remove(current_tags, table.find(current_tags, v));
			end
		end
	elseif args[2] == "division" then
		for i,v in pairs(globals.chattags) do
			if i == globals.rank_permissions["main group"] or i == "player_tags" then continue end;
			
			for si,sv in pairs(v) do
				if table.find(tags, sv) and table.find(current_tags, sv) then
					table.remove(current_tags, table.find(current_tags, sv));
				end
			end
		end
	elseif args[2] == "custom" then
		for i,v in pairs(globals.chattags.player_tags[player.UserId]) do
			if table.find(current_tags, v) then
				table.remove(current_tags, table.find(current_tags, v));
			end
		end
		
		speaker:SetExtraData("Tags", current_tags);
	else
		for i,v in pairs(current_tags) do
			if v.TagText == args[2] then 
				table.remove(current_tags, table.find(current_tags, v));
			end
		end
		
		speaker:SetExtraData("Tags", current_tags);
	end
end

module.mute = function(player, str, command)
	local mentioned = methods.split_str(str)[2];
	
	if mentioned == player.Name then return end;
	
	local mentioned_player = game.Players:FindFirstChild(mentioned);
	if not mentioned_player then return end;
	
	admin_events.mute:FireClient(mentioned_player, true);
	methods.system_message(globals.system, mentioned.." was muted.");
end

module.unmute = function(player, str, command)
	local mentioned = methods.split_str(str)[2];

	local mentioned_player = game.Players:FindFirstChild(mentioned);
	if not mentioned_player then return end;

	admin_events.mute:FireClient(mentioned_player, false);
end

return module;
