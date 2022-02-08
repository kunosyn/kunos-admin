local http = game:GetService("HttpService");
local format_webhook = require(script.Parent.GroupVitals).webhook_format;
local webhook = require(script.Parent.GroupVitals).webhook_link;

local module = {};

module.log = function(executor, target, cmd)
	http:PostAsync(webhook, http:JSONEncode(format_webhook(executor, target, cmd)));
end

return module;
