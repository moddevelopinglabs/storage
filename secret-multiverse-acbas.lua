local version = "1.0"

local Players = game:GetService("Players")

loadstring(game:HttpGet("https://raw.githubusercontent.com/moddevelopinglabs/storage/refs/heads/main/x11-colorpicker.lua"))()
repeat task.wait() until UILib
local hasWTS = type(WorldToScreen) == "function"

print("Loading Secret Multiverse script for ACBAS!")
print("Make sure you have Allow Unsafe LuaU Execution in Options!")

local function getPing(raw)
	local pingAddress = game:FindFirstChild("Stats"):FindFirstChild("PerformanceStats"):FindFirstChild("Ping").Address
	local ping = memory_read("double", pingAddress + 0xC8)

	if raw then
		return ping
	end

	return ("Ping: %sms"):format(math.floor(ping))
end

local mainGui = UILib.new(`Secret Multiverse - ACBAS | Version {version}`, Vector2.new(320, 380), {getPing})

local player = Players.LocalPlayer

local visualsTab = mainGui:Tab("Visuals")
local automationTab = mainGui:Tab("Automation")
local otherTab = mainGui:Tab("Other")
local espSection = mainGui:Section(visualsTab, "General")
local farmSection = mainGui:Section(automationTab, "Auto Farm")
local otherSection = mainGui:Section(otherTab, "Other")
local unloadSection = mainGui:Section(otherTab, "Unload")
local debugSection = mainGui:Section(otherTab, "Debug")
local infoSection = mainGui:Section(otherTab, "Info")
mainGui:CreateSettingsTab()

local entityESPOn = false
local keyESPOn = false

local autoFarm = false

local running = true

mainGui:Checkbox(automationTab, farmSection, "Auto Get Coins", false, function(state)
	for _, coin in workspace.CurrentRealm.CoinChallenge.Coins:GetChildren() do
		task.wait(0.01)
		if coin.Name == "Coin" then
			player.Character.HumanoidRootPart.Position = coin.Position
		end
	end
end)

mainGui:Checkbox(otherTab, otherSection, "Force Reset", false, function(state)
	local OFFSET = 0x18C

	local humanoid = player.Character.Humanoid
	local addr = humanoid.Address


	local v = Vector3.new(0, 0, 0)

	memory_write("float", addr + OFFSET + 8, v.Z)
end)

mainGui:Checkbox(otherTab, unloadSection, "Unload", false, function(state)
	running = false
end)

mainGui:Checkbox(otherTab, debugSection, "Grab Player Position", false, function(state)
	local position = player.Character.HumanoidRootPart.Position
	notify("Player Position", `Current player position is {position.X} {position.Y} {position.Z}`, 10)
	print("Current player position is", player.Character.HumanoidRootPart.Position)
end)

mainGui:Checkbox(otherTab, infoSection, `Version {version}`, false, function(state)
end)

mainGui:Checkbox(otherTab, infoSection, "Some settings might get you on a leaderboard, be careful!", false, function(state)
end)

local activeSquares = {} -- [Drawing] = expireTime

mainGui:Checkbox(visualsTab, espSection, "Entity", false, function(state)
	entityESPOn = state
end)

mainGui:Checkbox(visualsTab, espSection, "Key", false, function(state)
	keyESPOn = state
end)

local function cacheInvalid()
	for coin in pairs(cachedCoins) do
		if not coin:IsDescendantOf(workspace) then
			return true
		end
		if not coin:FindFirstChild("SUCoin") then
			return true
		end
	end
	return false
end

local function deleteInactiveSquares(group)
	local now = os.clock()
	for square, theTable in pairs(activeSquares) do
		if theTable.Group == group then
			if now >= theTable.ExpireTime then
				square:Remove()
				activeSquares[square] = nil
			end
		end
	end
end

local function deleteSquares(group)
	for square, theTable in pairs(activeSquares) do
		if theTable.Group == group then
			square:Remove()
			activeSquares[square] = nil
		end
	end
end

local function drawPart(part, name, color, group)
	local drawingPosition, isShown = WorldToScreen(part.Position)
	if not drawingPosition or not isShown then
		return
	end

	local square = Drawing.new("Square")
	square.Filled = true
	square.Color = color
	square.Position = drawingPosition
	square.Size = Vector2.new(10, 10)
	square.Visible = true
	square.Corner = 20

	local text = Drawing.new("Text")
	text.Text = name
	text.Color = Color3.fromRGB(255, 255, 255)
	text.Outline = true
	text.Center = true
	text.Visible = true
	text.Position = Vector2.new(drawingPosition.X, drawingPosition.Y - 20)

	activeSquares[square] = {
		ExpireTime = os.clock() + 0.05,
		Part = part,
		Group = group
	}
	activeSquares[text] = {
		ExpireTime = os.clock() + 0.05,
		Part = part,
		Group = group
	}
end

print("Loaded!")

while running do
	task.wait(0.0015)
	mainGui:Step()
	if keyESPOn then
		local key = workspace.CurrentRealm.Maze:FindFirstChild("Key")
		
		if key then
			drawPart(key, key.Name, Color3.fromRGB(255, 255, 255), "Key")
		end

		-- cleanup expired squares
		deleteInactiveSquares("Key")
	else
		deleteSquares("Key")
	end
	if entityESPOn then
		local screamy = workspace.CurrentRealm.Maze:FindFirstChild("Screamy")

		if screamy and screamy:FindFirstChild("HumanoidRootPart") then
			drawPart(screamy.HumanoidRootPart, screamy.Name, Color3.fromRGB(255, 0, 0), "Entity")
		end

		-- cleanup expired squares
		deleteInactiveSquares("Entity")
	else
		deleteSquares("Entity")
	end
end
for square, _ in pairs(activeSquares) do
	square:Remove()
	activeSquares[square] = nil
end
mainGui:Destroy()