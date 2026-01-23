local Players = game:GetService("Players")

loadstring(game:HttpGet("https://raw.githubusercontent.com/moddevelopinglabs/storage/refs/heads/main/x11-colorpicker.lua"))()
repeat task.wait() until UILib
local hasWTS = type(WorldToScreen) == "function"

print("Loading Secret Universe script!")
print("Make sure you have Allow Unsafe LuaU Execution in Options!")

local function getPing(raw)
	local pingAddress = game:FindFirstChild("Stats"):FindFirstChild("PerformanceStats"):FindFirstChild("Ping").Address
	local ping = memory_read("double", pingAddress + 0xC8)

	if raw then
		return ping
	end

	return ("Ping: %sms"):format(math.floor(ping))
end

local mainGui = UILib.new("Secret Universe", Vector2.new(320, 380), {getPing})

local player = Players.LocalPlayer

local visualsTab = mainGui:Tab("Visuals")
local automationTab = mainGui:Tab("Automation")
local otherTab = mainGui:Tab("Other")
local espSection = mainGui:Section(visualsTab, "General")
local farmSection = mainGui:Section(automationTab, "Auto Farm")
local teleportSection = mainGui:Section(automationTab, "Teleports")
local secretSection = mainGui:Section(automationTab, "Secrets")
local infiniSection = mainGui:Section(automationTab, "Infinitower")
local puthingSection = mainGui:Section(automationTab, "Puthing Around")
local unloadSection = mainGui:Section(otherTab, "Unload")
local debugSection = mainGui:Section(otherTab, "Debug")
mainGui:CreateSettingsTab()

local coinsESPOn = false
local structuresESPOn = false

local autoFarm = false
local bruteForcerPuth = false
local autoinfini = false
local obbyTeleportSpeed = 2
local bruteForceTeleportSpeed = 0.35

local running = true

local obbyStage = 0
local currentPathNumber = 0
local autoFarmMethod = "Endless Obby"

local lastTeleport = os.clock()

local usedLetters = {}

local pathLetters = {
	[1] = "S",
	[2] = "O",
	[3] = "P",
	[4] = "Y",
	[5] = "K",
	[6] = "X",
	[7] = "D",
	[8] = "Q",
	[9] = "H",
	[10] = "A",
	[11] = "R",
	[12] = "W",
	[13] = "Z",
	[14] = "C",
	[15] = "U",
	[16] = "T"
}

mainGui:Checkbox(automationTab, farmSection, "Auto Farm", false, function(state)
	if state and autoFarmMethod == "Zombie" then
		player.Character.HumanoidRootPart.Position = Vector3.new(-267, 3, -127)
		task.wait(0.1)
	end
	autoFarm = state
end)

mainGui:Choice(automationTab, farmSection, "Method", {"Endless Obby"}, function(values)
	autoFarmMethod = table.concat(values, ', ')
end, {"Endless Obby", "Random Money Maker", "Zombie"}, false)

mainGui:Slider(automationTab, farmSection, 'Teleport Speed', 2, function(value)
	obbyTeleportSpeed = value
end, 0.1, 5, 0.1, ' seconds')

mainGui:Choice(automationTab, teleportSection, "Teleport", {}, function(values)
	local teleportValue = table.concat(values, ', ')

	if teleportValue == "Evil Arena" then
		player.Character.HumanoidRootPart.Position = Vector3.new(-267, 3, -127)
	elseif teleportValue == "Endless Obby" then
		player.Character.HumanoidRootPart.Position = Vector3.new(270, 3, 0)
	elseif teleportValue == "Rebirth Door" then
		player.Character.HumanoidRootPart.Position = Vector3.new(15, 4, -14.5)
	elseif teleportValue == "Secret Meetup Outer" then
		player.Character.HumanoidRootPart.Position = Vector3.new(12.5, 505, 0)
	elseif teleportValue == "Secret Meetup Inner" then
		player.Character.HumanoidRootPart.Position = Vector3.new(235, 235, 43)
	end
end, {"Evil Arena", "Endless Obby", "Secret Meetup Outer", "Secret Meetup Inner", "Rebirth Door"}, false)

mainGui:Choice(automationTab, secretSection, "Collect Secret", {}, function(values)
	local secretValue = table.concat(values, ', ')
	local ogPosition = player.Character.HumanoidRootPart.Position

	if secretValue == "Lorem Ipsum" then
		if not workspace.Structures:FindFirstChild("easiest obby on roblox!") then
			notify("Error", "You need the Foundation secret to use this!", 10)
			notify("Error", "Click on the baseplate!", 10)
			return
		end
		player.Character.HumanoidRootPart.Position = Vector3.new(12.7, 3, -266)
		task.wait(0.1)
		player.Character.HumanoidRootPart.Position = Vector3.new(-39.5, 3, -365)
		task.wait(0.1)
		player.Character.HumanoidRootPart.Position = Vector3.new(12.7, 3, -414)
		task.wait(0.1)
		player.Character.HumanoidRootPart.Position = Vector3.new(12.8, 3, -322)
		task.wait(0.1)
		player.Character.HumanoidRootPart.Position = Vector3.new(-39.5, 3, -414)
		task.wait(0.1)
		player.Character.HumanoidRootPart.Position = Vector3.new(12.8, 3, -322)
	elseif secretValue == "Post-mortem" then
		if not workspace.Structures:FindFirstChild("easiest obby on roblox!") then
			notify("Error", "You need the Foundation secret to use this!", 10)
			notify("Error", "Click on the baseplate!", 10)
			return
		end
		player.Character.HumanoidRootPart.Position = Vector3.new(12.7, 3, -266)
		task.wait(0.1)
		player.Character.HumanoidRootPart.Position = Vector3.new(-1.3, 3.5, -413)
		task.wait(0.1)
		player.Character.HumanoidRootPart.Position = Vector3.new(12.8, 3, -322)
	elseif secretValue == "Random Number Generation" then
		local rainberge = workspace.Terrain:FindFirstChild("Rainberge")
		if rainberge then
			player.Character.HumanoidRootPart.Position = rainberge.Position
		else
			notify("Error", "No rainberge has spawned yet.", 10)
		end
	elseif secretValue == "Oracle Attack" then
		if not workspace.Structures:FindFirstChild("Paths") then
			notify("Error", "You need the Transliteration secret to use this!", 10)
			return
		end
		local pathsInput = workspace.Structures.Paths.InputBricks
		player.Character.HumanoidRootPart.Position = pathsInput.C.Position
		task.wait(0.35)
		player.Character.HumanoidRootPart.Position = pathsInput.A.Position
		task.wait(0.35)
		player.Character.HumanoidRootPart.Position = pathsInput.R.Position
		task.wait(0.35)
		player.Character.HumanoidRootPart.Position = pathsInput.P.Position
		task.wait(0.35)
		player.Character.HumanoidRootPart.Position = pathsInput.O.Position
		task.wait(0.35)
		player.Character.HumanoidRootPart.Position = pathsInput.X.Position
		task.wait(0.35)
		player.Character.HumanoidRootPart.Position = pathsInput.Y.Position
		task.wait(0.35)
		player.Character.HumanoidRootPart.Position = pathsInput.D.Position
		task.wait(0.35)
		player.Character.HumanoidRootPart.Position = pathsInput.Z.Position
	end
	task.wait(0.1)
	player.Character.HumanoidRootPart.Position = ogPosition
end, {"Lorem Ipsum", "Post-mortem", "Random Number Generation", "Oracle Attack"}, false)

mainGui:Checkbox(automationTab, infiniSection, "Auto TP Buttons", false, function(state)
	autoinfini = state
end)

mainGui:Checkbox(automationTab, puthingSection, "Brute Forcer", false, function(state)
	bruteForcerPuth = state
end)

mainGui:Slider(automationTab, puthingSection, 'Teleport Speed', 0.35, function(value)
	bruteForceTeleportSpeed = value
end, 0.05, 5, 0.05, ' seconds')

mainGui:Checkbox(otherTab, unloadSection, "Unload", false, function(state)
	running = false
end)

mainGui:Checkbox(otherTab, debugSection, "Grab Player Position", false, function(state)
	local position = player.Character.HumanoidRootPart.Position
	notify("Player Position", `Current player position is {position.X} {position.Y} {position.Z}`, 10)
	print("Current player position is", player.Character.HumanoidRootPart.Position)
end)

local function resetValues()
	obbyStage = 0
end

local function indexCoins()
	local coins = {}
	for _, part in workspace:GetDescendants() do
		if not part:IsA("BasePart") then
			continue
		end
		local name = part.Name
		local springSplit = string.split(name, "FloatingCoin")

		if springSplit[1] ~= "" then
			continue
		end

		local SUCoin = part:FindFirstChild("SUCoin")

		if SUCoin then
			coins[part] = part
		end
	end
	return coins
end

local function indexStructures()
	local structures = {}
	for _, folder in workspace.Structures:GetChildren() do
		for _, part in folder:GetChildren() do
			if not part:IsA("BasePart") then
				continue
			end

			if part.Name == "CameraPos" then
				structures[part] = part
			end
		end
	end
	return structures
end

local activeSquares = {} -- [Drawing] = expireTime
local cachedCoins = indexCoins()
local cachedStructures = indexStructures()

mainGui:Checkbox(visualsTab, espSection, "Coins", false, function(state)
	cachedCoins = indexCoins()
	coinsESPOn = state
end)

mainGui:Checkbox(visualsTab, espSection, "Structures", false, function(state)
	cachedStructures = indexStructures()
	structuresESPOn = state
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
	if autoFarm then
		if autoFarmMethod == "Zombie" then
			player.Character.HumanoidRootPart.Position = Vector3.new(-315, 50, -127)
		elseif autoFarmMethod == "Random Money Maker" then
			player.Character.HumanoidRootPart.Position = Vector3.new(-154, 4, -233)
		elseif autoFarmMethod == "Endless Obby" then
			local currentTime = os.clock()

			if currentTime - lastTeleport >= obbyTeleportSpeed then
				local endlessObby = workspace.Structures:FindFirstChild("Endless Obby")

				if endlessObby then
					local stage = endlessObby.Stages[obbyStage]

					if stage then
						local position = stage.Finish.Position
						player.Character.HumanoidRootPart.Position = Vector3.new(position.X, position.Y + 2, position.Z)
						obbyStage += 1
					else
						if obbyStage ~= 0 then
							obbyStage -= 1
						else
							player.Character.HumanoidRootPart.Position = Vector3.new(270, 3, 0)
						end
					end
				else
					notify("Error", "You need the Lorem Ipsum secret to use this!", 10)
					notify("Error", "Use collect secret!", 10)
				end
				lastTeleport = currentTime
			end
		end
	end
	if autoinfini then
		local currentTime = os.clock()

		if currentTime - lastTeleport >= 2 then
			for _, child in workspace.Structures.Infinitower.Floors:GetDescendants() do
				if child.Parent.Name == "Buttons" then
					for _, button in child.Parent:GetChildren() do
						if button.Transparency == 0 then
							local position = button.Position
							if position then
								player.Character.HumanoidRootPart.Position = Vector3.new(position.X, position.Y + 2, position.Z)
							end
						else
							continue
						end
					end
				else
					continue
				end
			end
			lastTeleport = currentTime
		end
	end
	if bruteForcerPuth then
		local currentTime = os.clock()

		if currentTime - lastTeleport >= bruteForceTeleportSpeed then
			if currentPathNumber >= 16 then
				player.Character.HumanoidRootPart.Position = Vector3.new(171, 112, -115)
				currentPathNumber = 0
				usedLetters = {}
				lastTeleport = currentTime
			else
				local randomValue = math.random(1, 16)
				local pathsInput = workspace.Structures.Paths.InputBricks
				local part = pathsInput[pathLetters[randomValue]]
				local position = part.Position
				if not usedLetters[part.Name] then
					player.Character.HumanoidRootPart.Position = Vector3.new(position.X, position.Y + 3, position.Z)
					usedLetters[part.Name] = true
					currentPathNumber += 1
					lastTeleport = currentTime
				end
			end
		end
	end
	if coinsESPOn then
		if cacheInvalid() then
			cachedCoins = indexCoins()
		end
		-- draw coins
		for _, coin in cachedCoins do
			local coinValue = string.split(coin.Name, "FloatingCoin_")[2]
			local drawingColor = Color3.fromRGB(255, 0, 0)

			if coinValue == "10000" then
				drawingColor = Color3.fromRGB(0, 255, 0)
			elseif coinValue == "25000" then
				drawingColor = Color3.fromRGB(0, 0, 255)
			elseif coinValue == "50000" then
				drawingColor = Color3.fromRGB(255, 215, 0)
			elseif coinValue == "100000" then
				drawingColor = Color3.fromRGB(160, 32, 240)
			elseif coinValue == "1000000" then
				drawingColor = Color3.fromRGB(255, 255, 0)
			end
			drawPart(coin, coin.Name, drawingColor, "Coins")
		end

		-- cleanup expired squares
		local now = os.clock()
		for square, theTable in pairs(activeSquares) do
			if theTable.Group == "Coins" then
				if now >= theTable.ExpireTime then
					square:Remove()
					activeSquares[square] = nil
				end
			end
		end
	else
		for square, theTable in pairs(activeSquares) do
			if theTable.Group == "Coins" then
				square:Remove()
				activeSquares[square] = nil
			end
		end
	end
	if structuresESPOn then
		-- draw structures
		for _, structure in cachedStructures do
			drawPart(structure, structure.Parent.Name, Color3.fromRGB(255, 255, 255), "Structures")
		end

		-- cleanup expired squares
		local now = os.clock()
		for square, theTable in pairs(activeSquares) do
			if theTable.Group == "Structures" then
				if now >= theTable.ExpireTime then
					square:Remove()
					activeSquares[square] = nil
				end
			end
		end
	else
		for square, theTable in pairs(activeSquares) do
			if theTable.Group == "Structures" then
				square:Remove()
				activeSquares[square] = nil
			end
		end
	end
	if player.Character then
		local character = player.Character

		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid and humanoid.Health <= 0 then
			resetValues()
		end
	end
end
for square, _ in pairs(activeSquares) do
	square:Remove()
	activeSquares[square] = nil
end
mainGui:Destroy()
