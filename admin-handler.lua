-- Kunos Admin V3.
-- Written By kunostaken.
-- 1/30/2022

local commands = require(script.Commands);
local log_exceptions = require(script.GroupVitals).webhook_log;
local globals = require(script.Utils.Globals);
local methods = require(script.Utils.Methods);

local function check_banned(player)
	if methods.isPBanned(player.UserId) then
		player:Kick("You are permanently banned from The Oasis. If you believe this is a mistake, contact us on our communications server.");
	elseif methods.isSBanned(player.UserId) then
		player:Kick("You are banned from this server. If you believe this is a mistake, contact us on our communications server.");
	end
end

game.Players.PlayerAdded:Connect(function(player)
	check_banned(player);

	player.Chatted:Connect(function(message)
		local args = methods.split_str(message);
		local command = args[1]:gsub("%"..globals.system.CommandPrefix, "");
		
		if not commands[command] then return end;
		if not methods.player_permissions(player, command) then return end;
		
		if table.find(log_exceptions, command) then
			require(script.WebhookLogging).log(player, args[2], command);
		end
		
		commands[command](player, message, command);
	end);
end);
