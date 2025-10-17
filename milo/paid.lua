visuals = {
    ore_esp_enabled = false,
    show_name = false,
    show_distance = false,
    ore_max_distance = 1000,
    colors = {
        ore_name_color = Color3.fromRGB(255, 0, 0)
    }
}

local SoundService = game:GetService("SoundService")

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://131644923"
sound.Parent = SoundService
sound.Volume = 1
sound.Looped = false
sound:Play()

local StarterGui = game:GetService("StarterGui")

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "🔑 Whitelisted.",
        Text = "Hello Friend. You have been whitelisted.",
        Duration = 7
    })
end)
local repo = 'https://raw.githubusercontent.com/milo22-ux/Linoria-modded-/main/'
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/milo22-ux/Linoria-modded-/refs/heads/main/LinoriaModded.lua", true))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/milo22-ux/Linoria-modded-/refs/heads/main/ThemeManger.txt.lua",true))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Vercore.xyz paid',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Combat = Window:AddTab('⚔️ Combat'),
    Visuals = Window:AddTab('👀 Visuals'),
    World = Window:AddTab('🌍 World'),
    Random = Window:AddTab('❓ Random'),
    Settings = Window:AddTab('⚙️ settings'),
}

local hitbox = Tabs.Combat:AddLeftGroupbox("hitbox")
local silent = Tabs.Combat:AddLeftGroupbox("Silent aim")
local mods = Tabs.Combat:AddRightGroupbox("Mods")
local esp = Tabs.Visuals:AddLeftGroupbox("Esp")
local random = Tabs.Visuals:AddLeftGroupbox("Random esps")
local ore = Tabs.Visuals:AddRightGroupbox("ore esp")
local world = Tabs.World:AddLeftGroupbox("World")
local extra = Tabs.Random:AddRightGroupbox("Extra")
local arms = Tabs.World:AddRightGroupbox("arms")
local guns = Tabs.World:AddRightGroupbox("guns")
local config = Tabs.Settings:AddLeftGroupbox("Menu")


hitbox:AddButton("Hitbox", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/milo22-ux/Trident-survival-stuff/refs/heads/main/V5%20hitbox", true))()
end)

mods:AddToggle("NoSpread", {
    Text = "No Spread",
    Default = false,
    Callback = function(state)
        if state then
            no_spread = hookmetamethod(Random.new(), "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method=="NextInteger" and debug.info(3,"l")==283 and debug.info(3,"s"):find("RangedWeaponClient") or
                   method=="NextInteger" and debug.info(3,"l")==152 and debug.info(3,"s"):find("BowClient") then
                    if getstack(3,12)==-100 and getstack(3,13)==100 then
                        setstack(3,12,0)
                        setstack(3,13,0)
                    end
                end
                return no_spread(self,...)
            end))
        else
            no_spread = nil
        end
    end
})

mods:AddToggle("NoRecoil", {
    Text = "No Recoil",
    Default = false,
    Callback = function(state)
        if state then
            no_recoil = hookfunction(CFrame.new, newcclosure(function(...)
                if debug.info(3,"l")==389 and debug.info(3,"s"):find("Camera") then
                    setstack(3,1,{cameraXShake=0,rotSpeed=0,rotMag=0,returnTime=0,push=0,returnLerp=0,cameraY=0,cameraX=0,lerp=0})
                end
                return no_recoil(...)
            end))
        else
            no_recoil = nil
        end
    end
})

mods:AddButton("No Cooldown", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/milo22-ux/Trident-survival-stuff/refs/heads/main/Mine%20speed%20v5", true))()
end)

silent:AddButton("Magic Bullet Redirection", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/milo22-ux/V5-paid/refs/heads/main/Magic%20bullet%20redirection", true))()
end)
silent:AddButton("Silent aim", function()
local baseRadius = 200

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = true
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Radius = baseRadius
fovCircle.Filled = false

local snapLine = Drawing.new("Line")
snapLine.Visible = false
snapLine.Color = Color3.fromRGB(255, 255, 255)
snapLine.Thickness = 1

local targetCircle = Drawing.new("Circle")
targetCircle.Visible = false
targetCircle.Thickness = 1
targetCircle.Color = Color3.fromRGB(255, 255, 255)
targetCircle.Radius = 2
targetCircle.Filled = false

local CoreGui = game:GetService("CoreGui")
local HL = Instance.new("Highlight")
HL.Name = "Highlight"
HL.Parent = CoreGui
HL.FillTransparency = 1
HL.OutlineColor = Color3.fromRGB(255, 255, 255)

local RunService = game:GetService("RunService")
local Classes = getrenv()._G.classes
local CameraClient = Classes.Camera
local FPSClient = Classes.FPS
local Camera = cloneref(game:GetService("Workspace").CurrentCamera)

local GetFunction = function(Script, Line)
    for _, v in pairs(getgc()) do
        if typeof(v) == "function" and debug.info(v, "sl") then
            local src, lineNum = debug.info(v, "s"), debug.info(v, "l")
            if src:find(Script) and lineNum == Line then
                return v
            end
        end
    end
end

local SetInfraredEnabled = GetFunction("PlayerClient", 588)
local PlayerReg = debug.getupvalue(SetInfraredEnabled, 2)

local validGuns = {
    "AR15", "C9", "Crossbow", "Bow", "EnergyRifle", "GaussRifle",
    "HMAR", "KABAR", "LeverActionRifle", "M4A1", "PipePistol",
    "PipeSMG", "PumpShotgun", "SCAR", "SVD", "USP9", "UZI", "Blunderbuss"
}

function IsValidGun(gun)
    return table.find(validGuns, tostring(gun)) ~= nil
end

function GetClosestTarget(maxDistance)
    local closestTarget, targetVelocity, closestDistance = nil, nil, math.huge
    for i, v in next, PlayerReg do
        if v.type == "Player" and not v.sleeping and v.model:FindFirstChild("HumanoidRootPart") then
            local distanceToPlayer = (v.model.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
            local screenPoint = Camera:WorldToViewportPoint(v.model.Head.Position)
            local distanceFromCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - fovCircle.Position).Magnitude
            if distanceToPlayer <= maxDistance and distanceFromCenter <= fovCircle.Radius and distanceToPlayer < closestDistance then
                closestTarget = v.model
                targetVelocity = v.velocityVector
                closestDistance = distanceToPlayer
            end
        end
    end
    return closestTarget, targetVelocity
end

function CalculateBulletDrop(tPos, tVel, cPos, pSpeed, pDrop)
    local dTT = (tPos - cPos).Magnitude
    local tTT = dTT / pSpeed

    local sVE = 8.8 - (pSpeed / (400 + pSpeed / 30))

    local horizontalVel = Vector3.new(tVel.X, 0, tVel.Z) * 7
    local verticalVel = Vector3.new(0, tVel.Y, 0) * 2

    local adjustedVel = horizontalVel + verticalVel

    local pTP = tPos + (adjustedVel * tTT)

    local dP = -pDrop ^ (tTT * pDrop) + 1
    local pPWD = pTP - Vector3.new(0, dP, 0)

    return pPWD
end

local oldGetCFrame = CameraClient.GetCFrame
CameraClient.GetCFrame = function()
    local closest, velocityVector = GetClosestTarget(1000)
    local equippedData = FPSClient.GetEquippedItem()
    if equippedData and closest and closest:FindFirstChild("HumanoidRootPart") and IsValidGun(equippedData.type) then
        local itemClass = Classes[equippedData.type]
        if itemClass then
            local projectileSpeed = itemClass.ProjectileSpeed
            local projectileDrop = itemClass.ProjectileDrop
            
            local predictedPosition , tTT = CalculateBulletDrop(closest.Head.Position, velocityVector, Camera.CFrame.Position, projectileSpeed, projectileDrop)
            return CFrame.new(Camera.CFrame.Position, predictedPosition)
        end
    end
    return oldGetCFrame()
end

RunService.RenderStepped:Connect(function()
    fovCircle.Radius = baseRadius * (math.tan(math.rad(50)) / math.tan(math.rad(Camera.FieldOfView))) ^ 0.35
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closest, _ = GetClosestTarget(1000)
    if closest and closest:FindFirstChild("Head") then
        local headPosition = Camera:WorldToViewportPoint(closest.Head.Position)
        snapLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        snapLine.To = Vector2.new(headPosition.X, headPosition.Y)
        snapLine.Visible = true
        targetCircle.Position = Vector2.new(headPosition.X, headPosition.Y)
        targetCircle.Visible = true
        HL.Adornee = closest
    else
        HL.Adornee = nil
        snapLine.Visible = false
        targetCircle.Visible = false
    end
end)
end)

esp:AddButton("ESP", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/milo22-ux/Trident-survival-stuff/refs/heads/main/V5%20esp", true))()
end)

random:AddButton("CrossHair", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/milo22-ux/Trident-survival-stuff/refs/heads/main/Cross%20hair", true))()
end)
    
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local DesiredColor = Color3.fromRGB(255,255,255)
local custom_ambient,FovEnabled = false,false
local no_fog,no_shadows,no_colorshift = false,false,false
local SpoofedFov = 120
local ambientFunc = {TimeOfDay=Lighting.TimeOfDay,Ambient=Lighting.Ambient,GlobalShadows=Lighting.GlobalShadows,ColorShift_Top=Lighting.ColorShift_Top,ColorShift_Bottom=Lighting.ColorShift_Bottom,FogEnd=Lighting.FogEnd,FogStart=Lighting.FogStart,FogColor=Lighting.FogColor}
local fovFunc = {FieldOfView=Camera.FieldOfView}

local spoofed_ambient2
spoofed_ambient2 = hookmetamethod(game,"__index",newcclosure(function(self,key)
    if checkcaller() then return spoofed_ambient2(self,key) end
    if self==Lighting and ambientFunc[key]~=nil then return ambientFunc[key] end
    if self==Camera and fovFunc[key] then return fovFunc[key] end
    return spoofed_ambient2(self,key)
end))

local spoofed_ambient1
spoofed_ambient1 = hookmetamethod(game,"__newindex",newcclosure(function(self,key,value)
    if checkcaller() then return spoofed_ambient1(self,key,value) end
    if self==Lighting and ambientFunc[key]~=nil then
        ambientFunc[key]=value
        if key=="Ambient" then return spoofed_ambient1(self,key,custom_ambient and DesiredColor or value)
        elseif key=="GlobalShadows" then return spoofed_ambient1(self,key,no_shadows and false or value)
        elseif key=="ColorShift_Top" or key=="ColorShift_Bottom" then return spoofed_ambient1(self,key,no_colorshift and Color3.new(0,0,0) or value)
        elseif key=="FogStart" or key=="FogEnd" then return spoofed_ambient1(self,key,no_fog and 1e6 or value) end
    end
    if self==Camera and key=="FieldOfView" then
        fovFunc[key]=value
        if FovEnabled then return spoofed_ambient1(self,key,SpoofedFov) end
    end
    return spoofed_ambient1(self,key,value)
end))

world:AddToggle("Ambient", {Text="Ambient", Default=false, Callback=function(state) custom_ambient = state end})
world:AddToggle("FOV", {Text="FOV", Default=false, Callback=function(state) FovEnabled = state end})

local Chatspam = false
extra:AddToggle("Chat Spammer", {Text="Chat Spammer", Default=false, Callback=function(state) Chatspam = state end})

task.spawn(function()
    while true do
        task.wait(12)
        if Chatspam then
            game.TextChatService.TextChannels.RBXGeneral:SendAsync(".gg Q8a9yQb7NY")
        end
    end
end)
local constIgnore = workspace:WaitForChild("Const"):WaitForChild("Ignore")
local fpsArms = constIgnore:WaitForChild("FPSArms")
local gunModel = fpsArms:FindFirstChild("HandModel")

local gunColorEnabled = false
local armsColorEnabled = false
local gunColor = Color3.fromRGB(255, 0, 0)
local armsColor = Color3.fromRGB(255, 0, 0)

local function safeMerge(tblA, tblB)
	local merged = {}
	if typeof(tblA) == "table" then
		for _, v in ipairs(tblA) do table.insert(merged, v) end
	end
	if typeof(tblB) == "table" then
		for _, v in ipairs(tblB) do table.insert(merged, v) end
	end
	return merged
end

local function updateModel()
	if gunModel and gunColorEnabled then
		for _, v in ipairs(gunModel:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("MeshPart") then
				v.Material = Enum.Material.ForceField
				v.Color = gunColor
				v.Transparency = 0
			end
		end
	end

	if fpsArms and armsColorEnabled then
		local fakeArms = fpsArms:FindFirstChild("Fake")
		local merged = safeMerge(fpsArms:GetChildren(), fakeArms and fakeArms:GetChildren() or {})
		for _, v in ipairs(merged) do
			if v:IsA("MeshPart") then
				v.Material = Enum.Material.ForceField
				v.Color = armsColor
				v.Transparency = 0
			end
		end
	end
end

fpsArms.ChildAdded:Connect(function(child)
	task.wait()
	if child.Name == "HandModel" then
		gunModel = child
		updateModel()
	end
end)

updateModel()

guns:AddToggle('GunColorToggle', {
	Text = 'Enable Gun Color',
	Default = false,
	Tooltip = 'Toggle gun color on/off',
	Callback = function(Value)
		gunColorEnabled = Value
		updateModel()
	end
})
Toggles.GunColorToggle:SetValue(false)

guns:AddLabel('Gun Color'):AddColorPicker('GunColorPicker', {
	Default = gunColor,
	Title = 'Gun Color',
	Transparency = 0,
	Callback = function(Value)
		gunColor = Value
		if gunColorEnabled then
			updateModel()
		end
	end
})

arms:AddToggle('ArmsColorToggle', {
	Text = 'Enable Arms Color',
	Default = false,
	Tooltip = 'Toggle arms color on/off',
	Callback = function(Value)
		armsColorEnabled = Value
		updateModel()
	end
})
Toggles.ArmsColorToggle:SetValue(false)

arms:AddLabel('Arms Color'):AddColorPicker('ArmsColorPicker', {
	Default = armsColor,
	Title = 'Arms Color',
	Transparency = 0,
	Callback = function(Value)
		armsColor = Value
		if armsColorEnabled then
			updateModel()
		end
	end
})
    
local vercore = {}

function vercore:Create(className, properties)
    local success, object = pcall(Drawing.new, className)
    if not success or not object then 
        return nil 
    end
    for prop, value in next, properties or {} do
        local ok = pcall(function() 
            object[prop] = value 
        end)
        if not ok then 
            warn("Invalid property:", prop) 
        end
    end
    return object
end

local ESPObjects = {}

local function createESP(part, oreName)
    local drawing = vercore:Create("Text", {
        Text = oreName,
        Size = 14,
        Center = true,
        Outline = true,
        Color = visuals.colors.ore_name_color,
        Visible = false
    })
    ESPObjects[part] = {drawing = drawing, oreName = oreName}
end

local function updateESP()
    for part, data in pairs(ESPObjects) do
        local drawing = data.drawing
        if not visuals.ore_esp_enabled or not part or not part.Parent then
            drawing.Visible = false
        else
            local partPos = part.Position
            local vector, onScreen = Camera:WorldToViewportPoint(partPos)
            local distance = (Camera.CFrame.Position - partPos).Magnitude
            if onScreen and distance <= visuals.ore_max_distance then
                local text = ""
                if visuals.show_name then
                    text = "[" .. data.oreName .. "]"
                end
                if visuals.show_distance then
                    text = text .. string.format(" %.0f studs", distance)
                end
                drawing.Text = text
                drawing.Position = Vector2.new(vector.X, vector.Y - 10)
                drawing.Color = visuals.colors.ore_name_color
                drawing.Visible = true
            else
                drawing.Visible = false
            end
        end
    end
end

local function classifyAndAdd(part)
    if part:IsA("MeshPart") then
        local name
        if part.BrickColor == BrickColor.new("Flint") and part.Material == Enum.Material.Limestone then
            name = "Stone"
        elseif part.BrickColor == BrickColor.new("Burlap") and part.Material == Enum.Material.Slate then
            name = "Iron"
        elseif part.BrickColor == BrickColor.new("Institutional white") and part.Material == Enum.Material.Slate then
            name = "Nitrate"
        end
        if name then
            createESP(part, name)
        end
    end
end

for _, part in ipairs(workspace:GetDescendants()) do
    classifyAndAdd(part)
end

workspace.DescendantAdded:Connect(classifyAndAdd)
game:GetService("RunService").RenderStepped:Connect(updateESP)

ore:AddToggle('OreESPEnabled', {
    Text = 'Enable Ore ESP',
    Default = visuals.ore_esp_enabled,
    Callback = function(Value)
        visuals.ore_esp_enabled = Value
    end
})

ore:AddToggle('ShowName', {
    Text = 'Show Ore Name',
    Default = visuals.show_name,
    Callback = function(Value)
        visuals.show_name = Value
    end
})

ore:AddToggle('ShowDistance', {
    Text = 'Show Distance',
    Default = visuals.show_distance,
    Callback = function(Value)
        visuals.show_distance = Value
    end
})

ore:AddSlider('OreMaxDistance', {
    Text = 'Max Distance',
    Default = visuals.ore_max_distance,
    Min = 50,
    Max = 1500,
    Rounding = 0,
    Callback = function(Value)
        visuals.ore_max_distance = Value
    end
})

ore:AddLabel('Ore Name Color'):AddColorPicker('OreNameColor', {
    Default = visuals.colors.ore_name_color,
    Title = 'Ore Name Color',
    Callback = function(Value)
        visuals.colors.ore_name_color = Value
        for _, data in pairs(ESPObjects) do
            data.drawing.Color = Value
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local top = workspace.Const.Ignore.LocalCharacter.Top
local speed = 50
local enabled = false
local freecamoffset = Vector3.zero
local tppos = top.CFrame

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FreecamUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "Freecam OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Parent = screenGui

local wasdFrame = Instance.new("Frame")
wasdFrame.Size = UDim2.new(0, 160, 0, 160)
wasdFrame.Position = UDim2.new(1, -180, 1, -180)
wasdFrame.BackgroundTransparency = 1
wasdFrame.Visible = false
wasdFrame.Parent = screenGui

local function makeKey(label, pos)
	local key = Instance.new("TextButton")
	key.Size = UDim2.new(0, 50, 0, 50)
	key.Position = pos
	key.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	key.TextColor3 = Color3.new(1, 1, 1)
	key.Text = label
	key.Font = Enum.Font.SourceSansBold
	key.TextSize = 24
	key.Parent = wasdFrame
	return key
end

local w = makeKey("W", UDim2.new(0.5, -25, 0, 0))
local a = makeKey("A", UDim2.new(0, 0, 0.5, -25))
local s = makeKey("S", UDim2.new(0.5, -25, 0.5, -25))
local d = makeKey("D", UDim2.new(1, -50, 0.5, -25))

local activeKeys = {W = false, A = false, S = false, D = false}

w.MouseButton1Down:Connect(function() activeKeys.W = true end)
w.MouseButton1Up:Connect(function() activeKeys.W = false end)
a.MouseButton1Down:Connect(function() activeKeys.A = true end)
a.MouseButton1Up:Connect(function() activeKeys.A = false end)
s.MouseButton1Down:Connect(function() activeKeys.S = true end)
s.MouseButton1Up:Connect(function() activeKeys.S = false end)
d.MouseButton1Down:Connect(function() activeKeys.D = true end)
d.MouseButton1Up:Connect(function() activeKeys.D = false end)

local function updateKeyHighlights()
	local active = Color3.fromRGB(0, 170, 255)
	local inactive = Color3.fromRGB(70, 70, 70)
	local isW = UserInputService:IsKeyDown(Enum.KeyCode.W) or activeKeys.W
	local isA = UserInputService:IsKeyDown(Enum.KeyCode.A) or activeKeys.A
	local isS = UserInputService:IsKeyDown(Enum.KeyCode.S) or activeKeys.S
	local isD = UserInputService:IsKeyDown(Enum.KeyCode.D) or activeKeys.D
	w.BackgroundColor3 = isW and active or inactive
	a.BackgroundColor3 = isA and active or inactive
	s.BackgroundColor3 = isS and active or inactive
	d.BackgroundColor3 = isD and active or inactive
end

toggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleButton.Text = enabled and "Freecam ON" or "Freecam OFF"
	wasdFrame.Visible = enabled
end)

RunService.Heartbeat:Connect(function(delta)
	updateKeyHighlights()
	if enabled and top then  
		local cameralook = Camera.CFrame.LookVector  
		cameralook = Vector3.new(cameralook.X, 0, cameralook.Z)  
		local direction = Vector3.zero  
		if UserInputService:IsKeyDown(Enum.KeyCode.W) or activeKeys.W then direction += cameralook end  
		if UserInputService:IsKeyDown(Enum.KeyCode.S) or activeKeys.S then direction -= cameralook end  
		if UserInputService:IsKeyDown(Enum.KeyCode.D) or activeKeys.D then direction += Vector3.new(-cameralook.Z, 0, cameralook.X) end  
		if UserInputService:IsKeyDown(Enum.KeyCode.A) or activeKeys.A then direction += Vector3.new(cameralook.Z, 0, -cameralook.X) end  
		if direction.Magnitude > 0 then  
			direction = direction.Unit  
		end  
		freecamoffset += direction * delta * speed  
		top.CFrame = tppos + freecamoffset  
		top.AssemblyLinearVelocity = Vector3.zero  
	else  
		freecamoffset = Vector3.zero  
		tppos = top.CFrame  
	end
end)

extra:AddToggle('FreecamToggle', {
    Text = 'freecam',
    Default = true,
    Tooltip = '',
    Callback = function(Value)
        screenGui.Enabled = Value
    end
})

local LogService = game:GetService("LogService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HitIndicatorUI"
screenGui.Parent = Player:WaitForChild("PlayerGui")

local activeIndicators = {}
local hitIndicatorEnabled = false

LogService.MessageOut:Connect(function(message)
    if not hitIndicatorEnabled then return end

    local target = message:match("->(%w+)%s")
    local distance = message:match("(%d+%.?%d*)s")
    if distance then distance = tonumber(distance) end
    local weapon = message:match("s%s*(%w+)%s*%d+%.?%d*%->")

    if target and weapon and distance then
        local hitLabel = Instance.new("TextLabel")
        hitLabel.Size = UDim2.new(0, 450, 0, 17)
        hitLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        hitLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        hitLabel.BackgroundTransparency = 0
        hitLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
        hitLabel.TextStrokeTransparency = 0.5
        hitLabel.TextStrokeColor3 = Color3.fromRGB(50, 50, 50)
        hitLabel.TextScaled = true
        hitLabel.Font = Enum.Font.Antique
        hitLabel.RichText = true
        hitLabel.Text = "Hit " .. target .. " with " .. weapon .. " from " .. distance .. "s"

        local boxStroke = Instance.new("UIStroke")
        boxStroke.Color = Color3.fromRGB(50, 50, 50)
        boxStroke.Thickness = 2
        boxStroke.Parent = hitLabel

        table.insert(activeIndicators, hitLabel)

        local baseY = 0.85
        local offset = (#activeIndicators - 1) * 0.02
        hitLabel.Position = UDim2.new(0.5, 0, baseY - offset, 0)
        hitLabel.Parent = screenGui

        task.delay(4, function()
            hitLabel:Destroy()
            table.remove(activeIndicators, 1)
            for i, lbl in ipairs(activeIndicators) do
                local newOffset = (i - 1) * 0.02
                lbl.Position = UDim2.new(0.5, 0, baseY - newOffset, 0)
            end
        end)
    end
end)

extra:AddToggle('HitIndicatorToggle', {
    Text = 'Hit Indicator',
    Default = true,
    Tooltip = 'Shows hit messages on screen',
    Callback = function(Value)
        hitIndicatorEnabled = Value
        screenGui.Enabled = Value
    end
})

Toggles.HitIndicatorToggle:SetValue(true)

loadstring(game:HttpGet("https://raw.githubusercontent.com/milo22-ux/V5-paid/refs/heads/main/Name", true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/milo22-ux/Trident-survival-stuff/refs/heads/main/New%20paid", true))()
    
    config:AddToggle('show_keybind_ui', {
    Text = 'Show Keybind UI',
    Default = false,
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end
})

Library.KeybindFrame.Visible = true
    
Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    Library.Unloaded = true
end)
    
Library.ToggleKeybind = Options.MenuKeybind
config:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' })
config:AddButton('Unhook', function() Library:Unload() end)
    
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Vercore')
SaveManager:SetFolder('Vercore/Trident')
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadconfig()
