-- FABRICATED VALUES!!!
local SWGvars = {
    "swim",
    1,
    true,
    true,
    "v2",
    ' >.< ',
    "ph",
    "placeholder",
    false
}
local SWG_DiscordUser, SWG_DiscordID, SWG_Private, SWG_Dev, SWG_Version, SWG_Title, SWG_ShortName, SWG_FullName, SWG_FFA =
SWGvars[1], SWGvars[2], SWGvars[3], SWGvars[4], SWGvars[5], SWGvars[6], SWGvars[7], SWGvars[8], SWGvars[9]
local type_custom = typeof
if not LPH_OBFUSCATED then
	LPH_JIT = function(...)
		return ...;
	end;
	LPH_JIT_MAX = function(...)
		return ...;
	end;
	LPH_NO_VIRTUALIZE = function(...)
		return ...;
	end;
	LPH_NO_UPVALUES = function(f)
		return (function(...)
			return f(...);
		end);
	end;
	LPH_ENCSTR = function(...)
		return ...;
	end;
	LPH_ENCNUM = function(...)
		return ...;
	end;
	LPH_ENCFUNC = function(func, key1, key2)
		if key1 ~= key2 then return print("LPH_ENCFUNC mismatch") end
		return func
	end
	LPH_CRASH = function()
		return print(debug.traceback());
	end;
end;
--- FABRICATED VALUES END!!!

local workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Lighting = cloneref(game:GetService("Lighting"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local GuiInset = cloneref(game:GetService("GuiService")):GetGuiInset()
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local function getfile(name)
    local repo = "https://raw.githubusercontent.com/SWIMHUBISWIMMING/swimhub/main/"
    local success, content = pcall(game.HttpGet, game, repo..name)
    if success then return content else return print("getfile returned error \""..content.."\"") end
end
local function ispriv3file(file)
    return isfile("priv3/new/files/"..file)
end
local function readpriv3file(file)
    if not ispriv3file(file) then return false end
    local success, returns = pcall(readfile, "priv3/new/files/"..file)
    if success then return returns else return print(returns) end
end
local function loadpriv3file(file)
    if not ispriv3file(file) then return false end
    local success, returns = pcall(loadstring, readpriv3file(file))
    if success then return returns else return print(returns) end
end
local function getpriv3asset(file)
    if ispriv3file(file) then return false end
    local success, returns = pcall(getcustomasset, "priv3/new/files/"..file)
    if success then return returns else return print(returns) end
end
do
    if not isfolder("priv3") then makefolder("priv3") end
    if not isfolder("priv3/new") then makefolder("priv3/new") end
    if not isfolder("priv3/new/files") then makefolder("priv3/new/files") end
    local function getfiles(force, list)
        for _, file in list do
            if (force or not force and not ispriv3file(file)) then
                writefile("priv3/new/files/"..file, getfile(file))
            end
        end
    end
    local gotassets = getfile("assets.json")
    local assets = HttpService:JSONDecode(gotassets)
    local localassets = readpriv3file("assets.json")
    if localassets then
        localassets = HttpService:JSONDecode(localassets)
        if localassets.version ~= assets.version then
            getfiles(true, assets.list)
        end
    else
        writefile("priv3/new/files/assets.json", gotassets)
    end
    getfiles(false, assets.list)
end

-- priv3 main

local cheat = {
    Library = nil,
    Toggles = nil,
    Options = nil,
    ThemeManager = nil,
    SaveManager = nil,
    connections = {
        heartbeats = {},
        renderstepped = {}
    },
    drawings = {},
    hooks = {}
}
cheat.utility = {} do
    cheat.utility.new_heartbeat = function(func)
        local obj = {}
        cheat.connections.heartbeats[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.heartbeats[func] = nil
                func = nil
            end
        end
        return obj
    end
    cheat.utility.new_renderstepped = function(func)
        local obj = {}
        cheat.connections.renderstepped[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.renderstepped[func] = nil
                func = nil
            end
        end
        return obj
    end
    cheat.utility.new_drawing = function(drawobj, args)
        local obj = Drawing.new(drawobj)
        for i, v in pairs(args) do
            obj[i] = v
        end
        cheat.drawings[obj] = obj
        return obj
    end
    cheat.utility.new_hook = function(f, newf, usecclosure) LPH_NO_VIRTUALIZE(function()
        if usecclosure then
            local old; old = hookfunction(f, newcclosure(function(...)
                return newf(old, ...)
            end))
            cheat.hooks[f] = old
            return old
        else
            local old; old = hookfunction(f, function(...)
                return newf(old, ...)
            end)
            cheat.hooks[f] = old
            return old
        end
    end)() end
    local connection; connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.heartbeats) do
            func(delta)
        end
    end))
    local connection1; connection1 = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.renderstepped) do
            func(delta)
        end
    end))
    cheat.utility.unload = function()
        connection:Disconnect()
        connection1:Disconnect()
        for key, _ in pairs(cheat.connections.heartbeats) do
            cheat.connections.heartbeats[key] = nil
        end
        for key, _ in pairs(cheat.connections.renderstepped) do
            cheat.connections.heartbeats[key] = nil
        end
        for _, drawing in pairs(cheat.drawings) do
            drawing:Remove()
            cheat.drawings[_] = nil
        end
        for hooked, original in pairs(cheat.hooks) do
            if type(original) == "function" then
                hookfunction(hooked, clonefunction(original))
            else
                hookmetamethod(original["instance"], original["metamethod"], clonefunction(original["func"]))
            end
        end
    end
end
-- [version:tsext]
-- [translation:trident survival external]
-- [scriptid:tridentsurvivalext]
local _CFramenew = CFrame.new
local _Vector2new = Vector2.new
local _Vector3new = Vector3.new
local _IsDescendantOf = game.IsDescendantOf
local _FindFirstChild = game.FindFirstChild
local _FindFirstChildOfClass = game.FindFirstChildOfClass
local _Raycast = workspace.Raycast
local _IsKeyDown = UserInputService.IsKeyDown
local _WorldToViewportPoint = Camera.WorldToViewportPoint
local _Vector3zeromin = Vector3.zero.Min
local _Vector2zeromin = Vector2.zero.Min
local _Vector3zeromax = Vector3.zero.Max
local _Vector2zeromax = Vector2.zero.Max
local _IsA = game.IsA
local tablecreate = table.create
local mathfloor = math.floor
local mathround = math.round
local mathclamp = math.clamp
local tostring = tostring
local unpack = unpack
local getupvalues = debug.getupvalues
local getupvalue = debug.getupvalue
local setupvalue = debug.setupvalue
local getconstants = debug.getconstants
local getconstant = debug.getconstant
local setconstant = debug.setconstant
local getstack = debug.getstack
local setstack = debug.setstack
local getinfo = debug.getinfo
local rawget = rawget

local trident = {
    loaded = false,
    gc = {
        createProjectile = {},
        classes = nil,
        entitylist = nil,
        recoil = nil,
        sendtcp = nil,
        isgrounded = nil,
        character = nil,
        equippeditem = nil,
        camera = nil
    },
    lastpos = nil,
    middlepart = nil,
    tcp = nil,
    original_model = nil
}
local runonactorused = false
if not (hookfunction and hookmetamethod and getgc and set_thread_identity and getupvalues and getupvalue) then return print('wtf dude...') end
LPH_JIT_MAX(function()
    for i,v in pairs(getgc(true)) do
        if type(v) == "table" then
            if type(rawget(v, "Camera")) == "table" and rawget(v.Camera, "type") == "Camera" then
                trident.gc.classes = v
            end
            if type(rawget(v, "updateCharacter")) == "function" then
                trident.gc.character = v
            end
            if type(v) == 'table' and rawget(v, "SetMaxRelativeLookExtentsY") then
                trident.gc.camera = v
            end
        end
        if type(v) == "function" then
            local name = getinfo(v).name
            if name == "GetEntityFromPart" then
                trident.gc.entitylist = v
            end
            if name == "createProjectile" then
                table.insert(trident.gc.createProjectile, v)
            end
            if name == "Recoil" and not rawget(getfenv(v), "script") then
                trident.gc.recoil = v
            end
            if name == "IsGrounded" then
                trident.gc.isgrounded = v
            end
            if name == "GetEquippedItem" then
                trident.gc.equippeditem = v
            end
            if name == "GetCFrame" and getinfo(v).short_src:lower():find("camera") then
                trident.gc.getcamcframe = v
            end
        end
        --if trident.gc.entitylist and trident.gc.classes then break end
    end
end)()

if not trident.gc.classes then return print("USE AN ACTOR BYPASS...") end

repeat pcall(function()
    if workspace:FindFirstChild("Ignore") and workspace.Ignore:FindFirstChild("LocalCharacter") and workspace.Ignore.LocalCharacter:FindFirstChild("Middle") then
        trident.middlepart = workspace.Ignore.LocalCharacter.Middle
    end
    trident.original_model = game:GetService("ReplicatedStorage").Shared.entities.Player.Model
    trident.tcp = LocalPlayer.TCP
    if not (trident.middlepart and trident.original_model) then task.wait(0.1) end
end) until trident.middlepart ~= nil and trident.original_model

cheat.Library, cheat.Toggles, cheat.Options = loadpriv3file("library_main.lua")()
cheat.ThemeManager = loadpriv3file("library_theme.lua")()
cheat.SaveManager = loadpriv3file("library_save.lua")()
local ui = {
    window = cheat.Library:CreateWindow({
        Title=string.format(
            SWG_Title,
            SWG_Version,
            SWG_FullName
        ),
    Center=true,AutoShow=true,TabPadding=8})
}

ui.tabs = {
    combat = ui.window:AddTab('combat'),
    visuals = ui.window:AddTab('visuals'),
    misc = ui.window:AddTab('misc'),
    config = ui.window:AddTab('config'),
}
ui.box = {
    aimbot = ui.tabs.combat:AddLeftTabbox(),
    mods = ui.tabs.combat:AddRightTabbox(),
    esp = ui.tabs.visuals:AddLeftTabbox(),
    cheatvis = ui.tabs.visuals:AddRightTabbox(),
    world = ui.tabs.visuals:AddRightTabbox(),
    move = ui.tabs.misc:AddLeftTabbox(),
    atvfly = ui.tabs.misc:AddLeftTabbox(),
    misc = ui.tabs.misc:AddRightTabbox(),
    themeconfig = ui.tabs.config:AddLeftGroupbox('theme config'),
}

local vectors = {
    Vector3.zero, -- none
    _Vector3new(1, 0, 0), -- big right
    _Vector3new(-1, 0, 0), -- big left
    _Vector3new(0, 0, 1), -- big forward
    _Vector3new(0, 0, -1), -- big backward
    _Vector3new(0, 1, 0), -- big up
    _Vector3new(0, -1, 0), -- big down
    
    _Vector3new(1 / 2, 0, 0), -- small right
    _Vector3new(-1 / 2, 0, 0), -- small left
    _Vector3new(0, 0, 1 / 2), -- small forward
    _Vector3new(0, 0, -1 / 2), -- small backward
    _Vector3new(0, 1 / 2, 0), -- small up
    _Vector3new(0, -1 / 2, 0), -- small down

    _Vector3new(1 / 2, 1 / 2, 0), -- small right up
    _Vector3new(1 / 2, -1 / 2, 0), -- small right down
    _Vector3new(-1 / 2, 1 / 2, 0), -- small left up
    _Vector3new(-1 / 2, -1 / 2, 0), -- small left down
    _Vector3new(0, 1 / 2, 1 / 2), -- small forward up
    _Vector3new(0, -1 / 2, 1 / 2), -- small forward down
    _Vector3new(0, 1 / 2, -1 / 2), -- small backward up
    _Vector3new(0, -1 / 2, -1 / 2), -- small backward down
}
local multipoints = {
    {1, 1, -1},
    {1, -1, -1},
    {-1, -1, -1},
    {-1, 1, -1},
    {1, 1, 1},
    {1, -1, 1},
    {-1, -1, 1},
    {-1, 1, 1},
    {0, 0, 0}
}

local function GetCorners(cframe, size, idx)
    return cframe * _CFramenew(size.X/2 * (multipoints[idx][1]*0.7), size.Y/2 * (multipoints[idx][2]*0.7), size.Z/2 * (multipoints[idx][3]*0.7))
end

local vischeck_params = RaycastParams.new()
vischeck_params.FilterDescendantsInstances = { workspace.Ignore }
vischeck_params.FilterType = Enum.RaycastFilterType.Exclude
vischeck_params.CollisionGroup = "WeaponRaycast"
vischeck_params.IgnoreWater = true

local function is_visible(position, target, target_part)
    if not (target and target_part and position) then return false end
    local castresults = _Raycast(workspace, position, target_part.CFrame.p - position, vischeck_params)
    return castresults and castresults.Instance and castresults.Instance.Parent == target
end

local function is_position_visible(pos_from, pos_to)
    if not (pos_to and pos_from) then return false end
    local castresults = _Raycast(workspace, pos_from, pos_to - pos_from, vischeck_params)
    return not castresults
end

local function get_manipulation_pos(origin_pos, target, target_part, range, enabled)
    if not origin_pos then origin_pos = Camera.CFrame.p end
    if not enabled then
        local visible = is_visible(origin_pos, target, target_part)
        if visible then
            return origin_pos
        end
    end
    local final, maxmag = nil, math.huge;
    for _, vector in vectors do
        local curvector = (vector * range)
        local modified = origin_pos + curvector
        local posvisible, visible = is_position_visible(origin_pos, modified), is_visible(modified, target, target_part)
        if curvector.Magnitude <= maxmag and posvisible and visible then
            final = modified
        end
    end
    return final
end

local function get_closest_target(usefov, fov_size, aimpart, sleep, team)
    local part, entity = nil, nil
    local maximum_distance = usefov and fov_size or math.huge
    local mousepos = _Vector2new(Mouse.X, Mouse.Y)
    LPH_JIT_MAX(function()
        for _, tbl in getupvalue(trident.gc.entitylist, 1) do
            if ((tbl.type == "Player" or tbl.type == "Soldier" or tbl.type == "Officer") and not tbl.ghost and tbl.model and _FindFirstChild(tbl.model, aimpart)) and (sleep and not tbl.sleeping or not sleep) then
                local hitpart = _FindFirstChild(tbl.model, aimpart)
                local position, onscreen = _WorldToViewportPoint(Camera, hitpart.Position)
                local distance = (_Vector2new(position.X, position.Y - GuiInset.Y) - mousepos).Magnitude
                if (usefov and onscreen or not usefov) and distance < maximum_distance then
                    part = hitpart
                    entity = tbl
                    maximum_distance = distance
                end
            end
        end
    end)()
    return part, entity
end

cheat.EspLibrary = {}; LPH_NO_VIRTUALIZE(function()
    local esp_table = {}
    local workspace = cloneref(game:GetService("Workspace"))
    local rservice = cloneref(game:GetService("RunService"))
    local plrs = cloneref(game:GetService("Players"))
    local lplr = plrs.LocalPlayer
    local container = Instance.new("Folder", game:GetService("CoreGui").RobloxGui)
    esp_table = {
        __loaded = false,
        main_settings = {
            textSize = 15,
            textFont = Drawing.Fonts.Monospace,
            distancelimit = false,
            maxdistance = 200,
            useteamcolor = false,
            teamcheck = false,
            sleepcheck = false
        },
        main_object_settings = {
            textSize = 15,
            textFont = Drawing.Fonts.Monospace,
            distancelimit = false,
            maxdistance = 200,
            useteamcolor = false,
            teamcheck = false,
            sleepcheck = false,
            allowed = {}
        },
        settings = {
            enemy = {
                enabled = false,
    
                box = false,
                box_fill = false,
                realname = false,
                dist = false,
                weapon = false,
                skeleton = false,
    
                box_outline = false,
                realname_outline = false,
                dist_outline = false,
                weapon_outline = false,
    
                box_color = { Color3.new(1, 1, 1), 1 },
                box_fill_color = { Color3.new(1, 0, 0), 0.3 },
                realname_color = { Color3.new(1, 1, 1), 1 },
                dist_color = { Color3.new(1, 1, 1), 1 },
                weapon_color = { Color3.new(1, 1, 1), 1 },
                skeleton_color = { Color3.new(1, 1, 1), 1 },
    
                box_outline_color = { Color3.new(), 1 },
                realname_outline_color = Color3.new(),
                dist_outline_color = Color3.new(),
                weapon_outline_color = Color3.new(),
    
                chams = false,
                chams_visible_only = false,
                chams_fill_color = { Color3.new(1, 1, 1), 0.5 },
                chamsoutline_color = { Color3.new(1, 1, 1), 0 }
            },
            object = {
                enabled = false,

                realname = false,
                realname_outline = false,

                realname_color = { Color3.new(1, 1, 1), 1 },
                realname_outline_color = Color3.new(),

                chams = false,
                chams_visible_only = false,
                chams_fill_color = { Color3.new(1, 1, 1), 0.5 },
                chamsoutline_color = { Color3.new(1, 1, 1), 0 }
            }
        }
    }
    local loaded_plrs = {}
    -- (please update me) vars
    local camera = workspace.CurrentCamera
    local viewportsize = camera.ViewportSize
    
    -- constants
    local VERTICES = {
        _Vector3new(-1, -1, -1),
        _Vector3new(-1, 1, -1),
        _Vector3new(-1, 1, 1),
        _Vector3new(-1, -1, 1),
        _Vector3new(1, -1, -1),
        _Vector3new(1, 1, -1),
        _Vector3new(1, 1, 1),
        _Vector3new(1, -1, 1)
    }
    local skeleton_order = {
        ["LeftFoot"] = "LeftLowerLeg",
        ["LeftLowerLeg"] = "LeftUpperLeg",
        ["LeftUpperLeg"] = "LowerTorso",
    
        ["RightFoot"] = "RightLowerLeg",
        ["RightLowerLeg"] = "RightUpperLeg",
        ["RightUpperLeg"] = "LowerTorso",
    
        ["LeftHand"] = "LeftLowerArm",
        ["LeftLowerArm"] = "LeftUpperArm",
        ["LeftUpperArm"] = "Torso",
    
        ["RightHand"] = "RightLowerArm",
        ["RightLowerArm"] = "RightUpperArm",
        ["RightUpperArm"] = "Torso",
    
        ["LowerTorso"] = "Torso",
        ["Torso"] = "Head"
    }
    -- game specific function
    local function getcurrentweapon(entity)
        --return "None"
        local gun = "None"
        if type(entity) == "table" and type(entity.equippedItem) == "table" then
            return entity.equippedItem.type
        end
        return gun
    end
    -- functions
    local esp = {}
    esp.create_obj = function(type, args)
        local obj = Drawing.new(type)
        for i, v in args do
            obj[i] = v
        end
        return obj
    end
    local function isBodyPart(name)
        return name == "Head" or name:find("Torso") or name:find("Leg") or name:find("Arm")
    end
    local function getBoundingBox(parts)
        local min, max
        for i = 1, #parts do
            local part = parts[i]
            local cframe, size = part.CFrame, part.Size
    
            min = _Vector3zeromin(min or cframe.Position, (cframe - size * 0.5).Position)
            max = _Vector3zeromax(max or cframe.Position, (cframe + size * 0.5).Position)
        end
    
        local center = (min + max) * 0.5
        local front = _Vector3new(center.X, center.Y, max.Z)
        return _CFramenew(center, front), max - min
    end
    local function worldToScreen(world)
        local screen, inBounds = _WorldToViewportPoint(camera, world)
        return _Vector2new(screen.X, screen.Y), inBounds, screen.Z
    end
    
    local function calculateCorners(cframe, size)
        local corners = tablecreate(#VERTICES)
        for i = 1, #VERTICES do
            corners[i] = worldToScreen((cframe + size * 0.5 * VERTICES[i]).Position)
        end
    
        local min = _Vector2zeromin(camera.ViewportSize, unpack(corners))
        local max = _Vector2zeromax(Vector2.zero, unpack(corners))
        return {
            corners = corners,
            topLeft = _Vector2new(mathfloor(min.X), mathfloor(min.Y)),
            topRight = _Vector2new(mathfloor(max.X), mathfloor(min.Y)),
            bottomLeft = _Vector2new(mathfloor(min.X), mathfloor(max.Y)),
            bottomRight = _Vector2new(mathfloor(max.X), mathfloor(max.Y))
        }
    end
    
    local function identify_model(model)
        if _FindFirstChildOfClass(model, "MeshPart") and _FindFirstChildOfClass(model, "MeshPart").MeshId == "rbxassetid://12939036056" then
            if #model:GetChildren() == 1 then
                return "Stone", model:GetChildren()[1]
            else
                for _, part in model:GetChildren() do
                    if part.Color == Color3.fromRGB(248, 248, 248) then
                        return "Nitrate", part
                    elseif part.Color == Color3.fromRGB(199, 172, 120) then
                        return "Iron", part
                    end
                end
            end
        end
        if _FindFirstChildOfClass(model, "MeshPart") and (_FindFirstChildOfClass(model, "MeshPart").Name:find("_Leaves") or _FindFirstChildOfClass(model, "MeshPart").Name:find("_Trunk")) then
            return "Tree", _FindFirstChildOfClass(model, "MeshPart")
        end
        if _FindFirstChildOfClass(model, "UnionOperation") and _FindFirstChildOfClass(model, "UnionOperation").Color == Color3.new(211, 190, 150) then
            return "Loot Box", _FindFirstChildOfClass(model, "UnionOperation")
        end
        if _FindFirstChildOfClass(model, "UnionOperation") and 
        _FindFirstChildOfClass(model, "UnionOperation").Color == Color3.new(205, 205, 205) 
        and _FindFirstChildOfClass(model, "UnionOperation").Material == Enum.Material.Fabric then
            return "Bag", _FindFirstChildOfClass(model, "UnionOperation")
        end
        if _FindFirstChild(model, "Frame") and _FindFirstChild(model, "Seat") then
            return "ATV", _FindFirstChild(model, "Frame")
        end
        return false, false
    end

    -- MAINN
    
    local function create_esp(model)
        if model and _FindFirstChild(model, "Head") and _FindFirstChild(model, "LowerTorso") then
            local entity;
            repeat
                for _, ent in getupvalue(trident.gc.entitylist, 1) do
                    if (ent.type == "Player" or ent.type == "Soldier" or ent.type == "Officer") and ent.model == model then
                        entity = ent
                        break
                    end
                end
                if not entity then task.wait(.1) end
            until entity
            local settings = esp_table.settings.enemy
            loaded_plrs[model] = {
                obj = {
                    box_fill = esp.create_obj("Square", { Filled = true, Visible = false }),
                    box_outline = esp.create_obj("Square", { Filled = false, Thickness = 3, Visible = false, ZIndex = -1}),
                    box = esp.create_obj("Square", { Filled = false, Thickness = 1, Visible = false }),
                    realname = esp.create_obj("Text", { Center = true, Visible = false }),
                    dist = esp.create_obj("Text", { Center = false, Visible = false }),
                    weapon = esp.create_obj("Text", { Center = true, Visible = false }),
                },
                esp = {
                    current_gun = "",
                    corners = nil,
                    head = nil,
                    character = nil
                },
                chams_object = Instance.new("Highlight", container),
            }
            for required, _ in next, skeleton_order do
                loaded_plrs[model].obj["skeleton_" .. required] = esp.create_obj("Line", { Visible = false })
            end
            local plr = loaded_plrs[model]
            local obj = plr.obj
            local esp = plr.esp
            local main_settings = esp_table.main_settings
            local settings = esp_table.settings
            local settings_cache, main_settings_cache = settings.enemy, main_settings
            local setvis_cache = false

            local character = model
            local head = _FindFirstChild(character, "Head")

            local cham = plr.chams_object
            local box = obj.box
            local box_outline = obj.box_outline
            local box_fill = obj.box_fill
            local realname = obj.realname
            local dist = obj.dist
            local weapon = obj.weapon

            plr.connection = cheat.utility.new_renderstepped(function(delta)
                camera = workspace.CurrentCamera
                if not camera then return end
                if
                    settings_cache.enabled and head and character and
                    (main_settings_cache.sleepcheck and not entity.sleeping or not main_settings_cache.sleepcheck)
                then
                    local _, onScreen = worldToScreen(head.Position)
                    if onScreen then
                        local distance = (camera.CFrame.p - head.Position).Magnitude
                        local corners do
                            local cache = {}
                            local children = character:GetChildren()
                            for i = 1, #children do
                                local part = children[i]
                                if _IsA(part, "BasePart") and isBodyPart(part.Name) then
                                    cache[#cache + 1] = part
                                end
                            end
                            corners = calculateCorners(getBoundingBox(cache))
                        end
                        
                        if corners then
                            if main_settings_cache ~= esp_table.main_object_settings or settings_cache ~= settings.object then
                                settings_cache = settings.enemy
                                main_settings_cache = esp_table.main_settings

                                realname.Size = main_settings_cache.textSize
                                realname.Font = main_settings_cache.textFont
                                realname.Color = settings_cache.realname_color[1]
                                realname.Outline = settings_cache.realname_outline
                                realname.OutlineColor = settings_cache.realname_outline_color
                                realname.Transparency = settings_cache.realname_color[2]

                                cham.DepthMode = settings_cache.chams_visible_only and Enum.HighlightDepthMode.Occluded or not settings_cache.chams_visible_only and Enum.HighlightDepthMode.AlwaysOnTop 
                                cham.FillColor = settings_cache.chams_fill_color[1]
                                cham.FillTransparency = settings_cache.chams_fill_color[2]
                                cham.OutlineColor = settings_cache.chamsoutline_color[1]
                                cham.OutlineTransparency = settings_cache.chamsoutline_color[2]

                                box.Transparency = settings_cache.box_color[2]
                                box.Color = settings_cache.box_color[1]
                                box_outline.Transparency = settings_cache.box_outline_color[2]
                                box_outline.Color = settings_cache.box_outline_color[1]
                                box_fill.Color = settings_cache.box_fill_color[1]
                                box_fill.Transparency = settings_cache.box_fill_color[2]

                                realname.Size = main_settings_cache.textSize
                                realname.Font = main_settings_cache.textFont
                                realname.Color = settings_cache.realname_color[1]
                                realname.Outline = settings_cache.realname_outline
                                realname.OutlineColor = settings_cache.realname_outline_color
                                realname.Transparency = settings_cache.realname_color[2]

                                dist.Size = main_settings_cache.textSize
                                dist.Font = main_settings_cache.textFont
                                dist.Color = settings_cache.dist_color[1]
                                dist.Outline = settings_cache.dist_outline
                                dist.OutlineColor = settings_cache.dist_outline_color
                                dist.Transparency = settings_cache.dist_color[2]

                                weapon.Size = main_settings_cache.textSize
                                weapon.Font = main_settings_cache.textFont
                                weapon.Color = settings_cache.weapon_color[1]
                                weapon.Outline = settings_cache.weapon_outline
                                weapon.OutlineColor = settings_cache.weapon_outline_color
                                weapon.Transparency = settings_cache.weapon_color[2]

                                --[[
                                cham.Enabled = settings_cache.chams
                                box.Visible = settings_cache.box
                                box_outline.Visible = box.Visible and settings_cache.box_outline
                                box_fill.Visible = box.Visible and settings_cache.box_fill
                                realname.Visible = settings_cache.realname
                                dist.Visible = settings_cache.dist
                                weapon.Visible = settings_cache.weapon

                                for required, _ in next, skeleton_order do
                                    local skeletonobj = obj["skeleton_" .. required]
                                    if (skeletonobj) then
                                        skeletonobj.Visible = settings_cache.skeleton
                                        skeletonobj.Color = settings_cache.skeleton_color[1]
                                        skeletonobj.Transparency = settings_cache.skeleton_color[2]
                                    end
                                end
                                --]]
                            end

                            if not setvis_cache then
                                setvis_cache = true
                                cham.Enabled = settings_cache.chams
                                box.Visible = settings_cache.box
                                box_outline.Visible = box.Visible and settings_cache.box_outline
                                box_fill.Visible = box.Visible and settings_cache.box_fill
                                realname.Visible = settings_cache.realname
                                dist.Visible = settings_cache.dist
                                weapon.Visible = settings_cache.weapon
                                for required, _ in next, skeleton_order do
                                    local skeletonobj = obj["skeleton_" .. required]
                                    if (skeletonobj) then
                                        skeletonobj.Visible = settings_cache.skeleton
                                    end
                                end
                            end

                            cham.Adornee = character

                            box.Position = corners.topLeft
                            box.Size = corners.bottomRight - corners.topLeft
                            box_outline.Position = box.Position + _Vector2new(1, 1)
                            box_outline.Size = box.Size - _Vector2new(1, 1)
                            box_fill.Position = box.Position
                            box_fill.Size = box.Size

                            realname.Text = (entity.type == "Soldier" or entity.type == "Officer") and entity.type or entity.name or "Player"
                            realname.Position = (corners.topLeft + corners.topRight) * 0.5 -
                                Vector2.yAxis * realname.TextBounds.Y - _Vector2new(0, 2)

                            dist.Text = tostring(mathround(distance)) .. "s"
                            dist.Position = corners.topRight + _Vector2new(2, 0) -
                                Vector2.yAxis * (dist.TextBounds.Y * 0.25)

                            weapon.Text = getcurrentweapon(entity)
                            weapon.Position = (corners.bottomLeft + corners.bottomRight) * 0.5

                            if settings_cache.skeleton then
                                for _, part in next, character:GetChildren() do
                                    local skeletonobj = obj["skeleton_" .. part.Name]
                                    local parent_part = skeleton_order[part.Name] and _FindFirstChild(character, skeleton_order[part.Name])
                                    if skeletonobj and parent_part then
                                        local part_position, _ = _WorldToViewportPoint(camera, part.Position)
                                        local parent_part_position, _ = _WorldToViewportPoint(
                                            camera, parent_part.CFrame.p
                                        )
                                        skeletonobj.From = _Vector2new(part_position.X, part_position.Y)
                                        skeletonobj.To = _Vector2new(parent_part_position.X, parent_part_position.Y)
                                    end
                                end
                            end
                        else -- disabled, no corners
                            if setvis_cache then for _, v in obj do v.Visible = false end plr.chams_object.Enabled = false setvis_cache = false end
                        end
                    else -- not on screen
                        if setvis_cache then for _, v in obj do v.Visible = false end plr.chams_object.Enabled = false setvis_cache = false end
                    end
                else -- not here
                    if setvis_cache then for _, v in obj do v.Visible = false end plr.chams_object.Enabled = false setvis_cache = false end
                end
            end)
        else
            local espname, mainpart = identify_model(model)
            if not espname then return end
            loaded_plrs[model] = {
                obj = {
                    name = esp.create_obj("Text", { Center = true, Visible = false, Text = espname }),
                }
            }
            local plr = loaded_plrs[model]
            local obj = plr.obj
            local realname = obj.name
            local main_settings = esp_table.main_object_settings
            local settings = esp_table.settings
            local settings_cache, main_settings_cache
            local setvis_cache = false
            plr.connection = cheat.utility.new_heartbeat(function(delta)
                local plr = loaded_plrs[model]
                camera = workspace.CurrentCamera
                if not camera then return end
                if settings.enabled and mainpart and main_settings.allowed[espname] then
                    local position, onScreen = worldToScreen(mainpart.Position)
                    if onScreen then
                        if main_settings_cache ~= esp_table.main_object_settings or settings_cache ~= settings.object then
                            settings_cache = settings.object
                            main_settings_cache = esp_table.main_object_settings
                            realname.Size = main_settings_cache.textSize
                            realname.Font = main_settings_cache.textFont
                            realname.Color = settings_cache.realname_color[1]
                            realname.Outline = settings_cache.realname_outline
                            realname.OutlineColor = settings_cache.realname_outline_color
                            realname.Transparency = settings_cache.realname_color[2]
                        end
                        if not setvis_cache then
                            realname.Visible = settings.realname
                        end
                        realname.Position = _Vector2new(position.X, position.Y)
                    else
                        if setvis_cache then for _, v in obj do v.Visible = false end setvis_cache = false end
                    end
                else
                    if setvis_cache then for _, v in obj do v.Visible = false end setvis_cache = false end
                end
            end)
        end
    end
    local function destroy_esp(model)
        local plr_object = loaded_plrs[model]
        if not plr_object then return end
        plr_object.connection:Disconnect()
        for i, v in plr_object.obj do
            v:Remove()
        end
        if plr_object.chams_object then
            plr_object.chams_object:Destroy()
        end
        loaded_plrs[model] = nil
    end
    
    function esp_table.load()
        assert(not esp_table.__loaded, "[ESP] already loaded");
    
        for i, v in next, workspace:GetChildren() do
           create_esp(v)
        end
    
        esp_table.playerAdded = workspace.ChildAdded:Connect(create_esp);
        esp_table.playerRemoving = workspace.ChildRemoved:Connect(destroy_esp);
        esp_table.__loaded = true;
    end
    
    function esp_table.unload()
        assert(esp_table.__loaded, "[ESP] not loaded yet");
    
        for i, v in next, workspace:GetChildren() do
            destroy_esp(v)
        end
    
        esp_table.playerAdded:Disconnect();
        esp_table.playerRemoving:Disconnect();
        esp_table.__loaded = false;
    end
    
    cheat.EspLibrary = esp_table
end)();
local function predict_time(part, entity, projectile_speed)
    local part_cframe = part.CFrame
    local velocity = --[[entity.velocityVector or ]](entity.goalPosition - entity.startPosition) / 0.15
    local distance = (trident.middlepart.Position - part_cframe.Position).Magnitude
    local time_to_hit = (distance / projectile_speed)
    local predicted_position = part_cframe.Position + (velocity * time_to_hit)
    local delta = (predicted_position - part_cframe.Position).Magnitude
    local final_projectile_speed = projectile_speed * (time_to_hit) * projectile_speed ^ 2
    return time_to_hit + (delta / final_projectile_speed)
end
local function predict_velocity(part, entity, projectile_speed)
    local velocity = (entity.goalPosition - entity.startPosition) / 0.15
    return part.CFrame.p + (velocity * predict_time(part, entity, projectile_speed))
end
local function predict_drop(part, entity, projectile_speed, projectile_drop)
    local drop_timing = projectile_drop ^ (predict_time(part, entity, projectile_speed) * projectile_drop) - 1
    if not (drop_timing ~= drop_timing) then
        return drop_timing
    end
    return 0
end
local function make_beam(Origin, Position, Color)
    local part1, part2 = Instance.new("Part", workspace.Ignore), Instance.new("Part", workspace.Ignore)
    part1.Position = Origin; part2.Position = Position;
    part1.Transparency = 1; part2.Transparency = 1;
    part1.CanCollide = false; part2.CanCollide = false;
    part1.Size = Vector3.zero; part2.Size = Vector3.zero;
    part1.Anchored = true; part2.Anchored = true;
    local OriginAttachment = Instance.new("Attachment", part1)
    local PositionAttachment = Instance.new("Attachment", part2)
    local Beam = Instance.new("Beam", workspace.Ignore)
    Beam.Name = "Beam"
    Beam.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color),
        ColorSequenceKeypoint.new(1,Color)
    };
    Beam.LightEmission = 1
    Beam.LightInfluence = 1
    Beam.TextureMode = Enum.TextureMode.Static
    Beam.TextureSpeed = 0
    Beam.Transparency = NumberSequence.new(0)
    Beam.Attachment0 = OriginAttachment
    Beam.Attachment1 = PositionAttachment
    Beam.FaceCamera = true
    Beam.Segments = 1
    Beam.Width0 = 0.1
    Beam.Width1 = 0.1
    return Beam, part1, part2
end
local function visualize_bullet_path(cframedir, part, entity, projectile_speed, projectile_drop, color)
    local distance = (trident.middlepart.Position - part.Position).Magnitude
    local velocity = (entity.goalPosition - entity.startPosition) / 0.25
    local time_to_hit = (distance / projectile_speed)  
    local predicted_position = part.Position + (velocity * time_to_hit)
    local delta = (predicted_position - part.CFrame.p).Magnitude
    local final_projectile_speed = projectile_speed * (time_to_hit) * projectile_speed ^ 2
    time_to_hit = time_to_hit + (delta / final_projectile_speed)
    LPH_JIT_MAX(function()
        local newpos = cframedir.p
        local predictions = math.ceil(distance/10)
        if predictions == 0 then return end
        for i=1,predictions do
            local new_time = (i/predictions)*time_to_hit
            local oldpos = newpos
            local newpos1 = (cframedir * _CFramenew(0, -projectile_drop ^ (new_time * projectile_drop) + 1, -new_time * projectile_speed)).Position
            newpos = newpos1
            --print(oldpos, newpos1)
            local drawing, deleteme, deleteme1;
            local real_sigma, fakeerror = pcall(function()
                drawing, deleteme, deleteme1 = make_beam(oldpos, newpos1, color)
            end)
            if not real_sigma then
                return print(fakeerror)
            end
            local wtf = -1
            local conn; conn = cheat.utility.new_renderstepped(function(delta)
                wtf = wtf + delta
                drawing.Transparency = NumberSequence.new(math.clamp(wtf, 0, 1))
                if wtf >= 1 then
                    drawing:Destroy()
                    deleteme:Destroy()
                    deleteme1:Destroy()
                    conn:Disconnect()
                end
            end)
        end
    end)()
end

--[[

--]]
local aimbot = {
    enabled = false,
    camera = false,
    silent = false, -- camera, silent
    sleep_check = false,
    team_check = false,
    part = "Head",
    manipulation = false,
    manipulation_range = 5,
    fov = false,
    fov_show = false,
    fov_color = Color3.new(1, 1, 1),
    fov_outline = false,
    fov_outline_color = Color3.new(0, 0, 0),
    fov_size = 100,
    indicator = false,
    indicator_text = "",
    jumpshoot = false,
    noslowdown = false,
    nospread = false,
    forcehead = false,
    invis = false,
    mathhuge = false,
    hitboxes = false,
    hbbypass = false,
    instant = false,
    fly = false,
    silentwalk = false,
    downhill = false
}
do
    local norecoil = false
    local target_part, target_entity, manipulation_pos;
    local salobox = ui.box.aimbot:AddTab('aimbotzz')
    local gunmodbox = ui.box.mods:AddTab('gun mods')
    gunmodbox:AddToggle('gunmods_norecoil', {Text = 'no recoil',Default = false,Callback = function(first)
        setconstant(debug.getproto(trident.gc.recoil, 1), 2, first and trident.gc.classes.InputManager.InputDevice or "Mobile")
    end})
    gunmodbox:AddToggle('gunmods_jumpshoot', {Text = 'jump shoot',Default = false,Callback = function(first)
        aimbot.jumpshoot = first
    end})
    gunmodbox:AddToggle('gunmods_nospread', {Text = 'no spread',Default = false,Callback = function(first)
        aimbot.nospread = first
    end})
    gunmodbox:AddToggle('gunmods_noslowdown', {Text = 'no slowdown',Default = false,Callback = function(first)
        aimbot.noslowdown = first
    end})
    gunmodbox:AddToggle('gunmods_forcehead', {Text = 'force head',Default = false,Callback = function(first)
        aimbot.forcehead = first
    end})

    salobox:AddToggle('aimbot_enabled', {Text = 'aimbot',Default = false,Callback = function(first)
        aimbot.enabled = first
    end})

    --[[salobox:AddToggle('aimbot_instant', {Text = 'instant hit (TEST)',Default = false,Callback = function(first)
        aimbot.instant = first
    end})]]

    salobox:AddToggle('aimbot_camera', {Text = 'camera (mb2)',Default = false,Callback = function(first)
        aimbot.camera = first
    end})
    salobox:AddToggle('aimbot_silent', {Text = 'silent',Default = false,Callback = function(first)
        aimbot.silent = first
    end})

    salobox:AddToggle('aimbot_sleep_check', {Text = 'sleeper check',Default = false,Callback = function(first)
        aimbot.sleep_check = first
    end})

    salobox:AddToggle('aimbot_team_check', {Text = 'team check',Default = false,Callback = function(first)
        aimbot.team_check = first
    end})

    salobox:AddToggle('aimbot_fov', {Text = 'use fov',Default = false,Callback = function(Value)
        aimbot.fov = Value
    end})

    local Depbox1 = salobox:AddDependencyBox();

    Depbox1:AddToggle('aimbot_fov_show', {Text = 'show fov',Default = false,Callback = function(Value)
        aimbot.fov_show = Value
    end}):AddColorPicker('aimbot_fov_color',{Default = Color3.new(1, 1, 1),Title = 'fov color',Transparency = 0,Callback = function(Value)
        aimbot.fov_color = Value
    end})

    Depbox1:AddToggle('aimbot_fov_outline', {Text = 'fov outline',Default = false,Callback = function(Value)
        aimbot.fov_outline = Value
    end})

    Depbox1:AddSlider('aimbot_fov_size',{Text = 'target fov',Default = 100,Min = 10,Max = 1000,Rounding = 0,Compact = true,Callback = function(State)
        aimbot.fov_size = State
    end})

    Depbox1:SetupDependencies({
        { Toggles.aimbot_fov, true }
    });
    salobox:AddToggle('silentaim_manipulation', {Text = 'silent manipulation',Default = false,Callback = function(Value)
        aimbot.manipulation = Value
    end})

    local Depbox2 = salobox:AddDependencyBox();
    
    Depbox2:AddSlider('silentaim_manipulation_range',{Text = 'manipulation range',Default = 5,Min = 1,Max = 5,Rounding = 1,Compact = true,Callback = function(State)
        aimbot.manipulation_range = State
    end})

    Depbox2:SetupDependencies({
        { Toggles.silentaim_manipulation, true }
    });

    local CircleOutline = Drawing.new("Circle")
    local CircleInline = Drawing.new("Circle")
    CircleInline.Transparency = 1
    CircleInline.Thickness = 1
    CircleInline.ZIndex = 2
    CircleOutline.Thickness = 3
    CircleOutline.Color = Color3.new()
    CircleOutline.ZIndex = 1
    local classes = trident.gc.classes

    cheat.utility.new_renderstepped(LPH_JIT_MAX(function()
        CircleOutline.Position = (_Vector2new(Mouse.X, Mouse.Y + GuiInset.Y))
        CircleInline.Position = (_Vector2new(Mouse.X, Mouse.Y + GuiInset.Y))
        CircleInline.Radius = aimbot.fov_size
        CircleInline.Color = aimbot.fov_color
        CircleInline.Visible = aimbot.fov and aimbot.fov_show
        CircleOutline.Radius = aimbot.fov_size
        CircleOutline.Visible = (aimbot.fov and aimbot.fov_show and aimbot.fov_outline)

        local equippeditem = getupvalue(trident.gc.equippeditem, 1)
        trident.guninfo = classes and equippeditem and classes[equippeditem.type]

        if aimbot.noslowdown then
            trident.gc.character.sprintBlocked = false
        end
        if aimbot.enabled and aimbot.camera and target_part and target_entity and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local guninfo = trident.guninfo
            if not (guninfo and guninfo.ProjectileSpeed and guninfo.ProjectileDrop) then
                local pitch,yaw = CFrame.lookAt(Camera.CFrame.p, target_part.CFrame.p):ToOrientation()
                setupvalue(trident.gc.recoil, 13, _Vector3new(pitch, yaw, 0))
            else
                local pitch,yaw = CFrame.lookAt(Camera.CFrame.p, predict_velocity(target_part, target_entity, guninfo.ProjectileSpeed) + _Vector3new(0, predict_drop(target_part, target_entity, guninfo.ProjectileSpeed, guninfo.ProjectileDrop), 0)):ToOrientation()
                setupvalue(trident.gc.recoil, 13, _Vector3new(pitch, yaw, 0))
            end
        end
    end))
    cheat.utility.new_heartbeat(LPH_JIT_MAX(function()
        local indtxt = ""
        target_part, target_entity = get_closest_target(aimbot.fov, aimbot.fov_size, aimbot.part, aimbot.sleep_check, aimbot.team_check);
        manipulation_pos = target_part and target_entity and get_manipulation_pos(aimbot.extended_manipulation and trident.lastpos or Camera.CFrame.p, target_part.Parent, target_part, aimbot.manipulation_range + (aimbot.extended_manipulation and 5 or 0), aimbot.manipulation) or nil;
        if target_part and target_entity then
            indtxt = indtxt..(target_entity.name or target_entity.type)
            if aimbot.manipulation and manipulation_pos then
                indtxt = indtxt.." (visible)"
            end
        else
            indtxt = ""
        end
        aimbot.indicator_text = indtxt
    end))
    --[[
    for _, v in getgc(true) do
        if type(v) == "table" and rawget(v, "type") == "MiningDrill" then
            v.AttackCooldown = 0
        end
    end
    ]]
    RunService:BindToRenderStep(tostring(math.random()), Enum.RenderPriority.Character.Value + 1, LPH_NO_VIRTUALIZE(function()
        if aimbot.jumpshoot then
            setupvalue(trident.gc.isgrounded, 1, true)
            setupvalue(trident.gc.isgrounded, 4, true)
        end
    end))
    local __randomnamecall; __randomnamecall = hookmetamethod(Random.new(), "__namecall", newcclosure(LPH_JIT_MAX(function(self, ...)
        local args = {...}
            if typeof(getstack(3, 4)) ~= "CFrame" then
                print("pasting has failed...", typeof(getstack(3, 4)))
                return __randomnamecall(self, ...)
            end
            if aimbot.enabled and aimbot.silent and target_part and target_entity then
                local guninfo = trident.guninfo
                if guninfo and guninfo.ProjectileSpeed and guninfo.ProjectileDrop then
                    setstack(3, 4, CFrame.lookAt(manipulation_pos and manipulation_pos or Camera.CFrame.p,
                        (aimbot.instant and target_part.CFrame.p or predict_velocity(target_part, target_entity, guninfo.ProjectileSpeed)) +
                        _Vector3new(0, predict_drop(target_part, target_entity, guninfo.ProjectileSpeed, guninfo.ProjectileDrop), 0))
                    )
                end
            end
            if aimbot.nospread then
                local guninfo = trident.guninfo
                if guninfo and guninfo.Pellets then
                    return __randomnamecall(self, -guninfo.Pellets / 5, guninfo.Pellets / 5)
                end
                return 0
            end
        return __randomnamecall(self, ...)
    end)))
    --[[local game_RunService = game:GetService("RunService");
    local __runserviceindex; __runserviceindex = hookmetamethod(game_RunService, "__index", newcclosure(function(self, key)
        if key == "RenderStepped" and aimbot.instant and (debug.isvalidlevel(7) and debug.getinfo(7).name == "createProjectile") then
            return {
                Connect = function(selfconnect, funcconnect)
                    local guninfo, instant_time = trident.guninfo, nil
                    if target_part and target_entity and guninfo and guninfo.ProjectileSpeed then
                        instant_time = predict_time(target_part, target_entity, guninfo.ProjectileSpeed)
                        print('wow', instant_time)
                    else
                        print('fail...', not not (target_part and target_entity and guninfo and guninfo.ProjectileSpeed))
                    end
                    
                    local connection; connection = game_RunService.RenderStepped:Connect(function(delta)
                        funcconnect(instant_time or delta)
                    end)
                    return {Disconnect = function()if connection then connection:Disconnect() end end}
                end
            }
        end
        return __runserviceindex(self, key)
    end))]]
end

do
    local validcharacters = {}
    local hbc, original_size, hbsize = nil, trident.original_model.Torso.Size, _Vector3new(0.5, 1, 0.5)
    local dynamic, alwayshead = false, false
    local hitboxheadsizex, hitboxheadsizey, hitboxheadtransparency, cancollide = 10, 10, 0.5, false
    local function addtovc(obj)
        if not obj then return end
        if not obj:FindFirstChild("Head") and not obj:FindFirstChild("LowerTorso") then return end
        validcharacters[obj] = obj
    end

    local function removefromvc(obj)
        if not validcharacters[obj] then return end
        validcharacters[obj] = nil
    end

    for i, v in next, workspace:GetChildren() do addtovc(v) end
    workspace.ChildAdded:Connect(addtovc);
    workspace.ChildRemoved:Connect(removefromvc);

    local hbb = ui.box.aimbot:AddTab("hitbox")
    hbb:AddToggle('hitbox_enabled', {
        Text = 'hitbox expander',
        Default = false,
        Callback = function(value)
            aimbot.hitboxes = value
            if hbc then hbc:Disconnect() end
            if value then
                hbc = cheat.utility.new_heartbeat(function()
                    local trans = hitboxheadtransparency
                    for i, v in validcharacters do
                        local primpart = v and _FindFirstChild(v, 'Torso')
                        if primpart then
                            primpart.Size = hbsize
                            primpart.Transparency = trans
                            primpart.CanCollide = cancollide
                        end
                    end
                end)
            else
                if hbc then hbc:Disconnect() end
                for i, v in validcharacters do
                    local primpart = v and _FindFirstChild(v, 'Torso')
                    if primpart then
                        primpart.Size = original_size
                        primpart.Transparency = 0
                        primpart.CanCollide = true
                    end
                end
            end
        end
    })
    hbb:AddToggle('hitbox_cancollide',{Text = 'can collide',Default = false,Callback = function(v)
        cancollide = v
    end})
    hbb:AddToggle('hitbox_bypass',{Text = 'advanced bypass (TEST)',Default = false,Callback = function(v)
        aimbot.hbbypass = v
    end})
    hbb:AddSlider('hitbox_head_transparency', { Text = 'transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(State)
        hitboxheadtransparency = State
    end)
    hbb:AddSlider('hitbox_head_size_x', { Text = 'size x', Default = 10, Min = 1, Max = 25, Rounding = 1, Compact = false }):OnChanged(function(State)
        hitboxheadsizex = State
        hbsize = _Vector3new(hitboxheadsizex, hitboxheadsizey, hitboxheadsizex)
    end)
    hbb:AddSlider('hitbox_head_size_y', { Text = 'size y', Default = 10, Min = 1, Max = 25, Rounding = 1, Compact = false }):OnChanged(function(State)
        hitboxheadsizey = State
        hbsize = _Vector3new(hitboxheadsizex, hitboxheadsizey, hitboxheadsizex)
    end)
    local __headindex; __headindex = hookmetamethod(game, "__index", newcclosure(LPH_NO_VIRTUALIZE(function(self, idx)
        if not checkcaller() and (idx == "CanCollide" or idx == "Size" or idx == "Transparency") and self.Name == "Torso" then
            return trident.original_model[self.Name][idx]
        end
        return __headindex(self, idx)
    end)))
end
do
    local espb = ui.box.esp:AddTab("player esp")
    local es = cheat.EspLibrary.settings.enemy
    espb:AddDropdown('espfont', {Values = { 'UI', 'System', 'Plex', 'Monospace' },Default = 1,Multi = false,Text = 'esp font',Tooltip = 'select font',Callback = function(Value)
        cheat.EspLibrary.main_settings.textFont = Drawing.Fonts[Value]
    end})
    espb:AddSlider('espfontsize', { Text = 'esp font size', Default = 13, Min = 1, Max = 30, Rounding = 0, Compact = true }):OnChanged(function(State)
        cheat.EspLibrary.main_settings.textSize = State
    end)
    espb:AddToggle('espswitch', {
        Text = 'enable esp',
        Default = false,
        Callback = function(first)
            es.enabled = first
        end
    })
    espb:AddToggle('espteamswitch', {
        Text = 'team/ai check',
        Default = false,
        Callback = function(first)
            cheat.EspLibrary.main_settings.teamcheck = first
        end
    })
    espb:AddToggle('espsleeperswitch', {
        Text = 'sleeper check',
        Default = false,
        Callback = function(first)
            cheat.EspLibrary.main_settings.sleepcheck = first
        end
    })
    ----------------------------------------------------------
    espb:AddToggle('espbox', {
        Text = 'box esp',
        Default = false,
        Callback = function(first)
            es.box = first
        end
    }):AddColorPicker('espboxcolor', {
        Default = Color3.new(1, 1, 1),
        Title = 'box color',
        Transparency = 0,
        Callback = function(Value)
            es.box_color[1] = Value
        end
    })
    ---
    espb:AddToggle('espboxfill', {
        Text = 'box fill',
        Default = false,
        Callback = function(first)
            es.box_fill = first
        end
    }):AddColorPicker('espboxfillcolor',
        {
            Default = Color3.new(1, 1, 1),
            Title = 'box fill color',
            Transparency = 0,
            Callback = function(Value)
                es.box_fill_color[1] = Value
            end
        })
    ---
    espb:AddToggle('espoutlinebox', {
        Text = 'box outline',
        Default = false,
        Callback = function(first)
            es.box_outline = first
        end
    }):AddColorPicker('espboxoutlinecolor',
        {
            Default = Color3.new(),
            Title = 'box outline color',
            Transparency = 0,
            Callback = function(Value)
                es.box_outline_color[1] = Value
            end
        })
    ---
    espb:AddSlider('espboxtransparency',
        { Text = 'box transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(
        State)
        es.box_color[2] = 1-State
    end)
    espb:AddSlider('espoutlineboxtransparency',
        { Text = 'box outline transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(
        State)
        es.box_outline_color[2] = State
    end)
    espb:AddSlider('espboxfilltransparency',
        { Text = 'box fill transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(
        State)
        es.box_fill_color[2] = 1-State
    end)
    ----------------------------------------------------------
    espb:AddToggle('esprealname', {
        Text = 'name esp',
        Default = false,
        Callback = function(first)
            es.realname = first
        end
    }):AddColorPicker('esprealnamecolor',
        {
            Default = Color3.new(1, 1, 1),
            Title = 'name color',
            Transparency = 0,
            Callback = function(Value)
                es.realname_color[1] = Value
            end
        })
    espb:AddSlider('esprealnametransparency',
        { Text = 'name transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(
        State)
        es.realname_color[2] = 1-State
    end)
    ---
    espb:AddToggle('esprealnameoutline', {
        Text = 'name outline',
        Default = false,
        Callback = function(first)
            es.realname_outline = first
        end
    }):AddColorPicker('esprealnameoutlinecolor',
        {
            Default = Color3.new(),
            Title = 'name outline color',
            Transparency = 0,
            Callback = function(Value)
                es.realname_outline_color = Value
            end
        })

    ----------------------------------------------------------
    espb:AddToggle('espdistance', {
        Text = 'distance esp',
        Default = false,
        Callback = function(first)
            es.dist = first
        end
    }):AddColorPicker('espdistancecolor',
        {
            Default = Color3.new(1, 1, 1),
            Title = 'distance color',
            Transparency = 0,
            Callback = function(Value)
                es.dist_color[1] = Value
            end
        })
    espb:AddSlider('espdistancetransparency',
        { Text = 'distance transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(
        State)
        es.dist_color[2] = 1-State
    end)
    ---
    espb:AddToggle('espdistanceoutline', {
        Text = 'distance outline',
        Default = false,
        Callback = function(first)
            es.dist_outline = first
        end
    }):AddColorPicker('espdistanceoutlinecolor',
        {
            Default = Color3.new(),
            Title = 'distance outline color',
            Transparency = 0,
            Callback = function(Value)
                es.dist_outline_color = Value
            end
        })
    ----------------------------------------------------------
    espb:AddToggle('espweapon', {
        Text = 'weapon esp',
        Default = false,
        Callback = function(first)
            es.weapon = first
        end
    }):AddColorPicker('espweaponcolor',
        {
            Default = Color3.new(1, 1, 1),
            Title = 'weapon color',
            Transparency = 0,
            Callback = function(Value)
                es.weapon_color[1] = Value
            end
        })
    espb:AddSlider('espweapontransparency',
        { Text = 'weapon transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(
        State)
        es.weapon_color[2] = 1-State
    end)
    ---
    espb:AddToggle('espweaponoutline', {
        Text = 'weapon outline',
        Default = false,
        Callback = function(first)
            es.weapon_outline = first
        end
    }):AddColorPicker('espweaponoutlinecolor',
        {
            Default = Color3.new(),
            Title = 'weapon outline color',
            Transparency = 0,
            Callback = function(Value)
                es.weapon_outline_color = Value
            end
        })
    ----------------------------------------------------------
    espb:AddToggle('espskeleton', {Text = 'skeleton esp',Default = false,Callback = function(first)
        es.skeleton = first
    end}):AddColorPicker('espskeletoncolor', {Default = Color3.new(1, 1, 1),Title = 'skeleton color',Transparency = 0,Callback = function(Value)
        es.skeleton_color[1] = Value
    end})
    espb:AddSlider('espskeletontransparency', { Text = 'skeleton transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(State)
        es.skeleton_color[2] = 1-State
    end)
    ----------------------------------------------------------
    espb:AddToggle('espchams', {
        Text = 'chams',
        Default = false,
        Callback = function(first)
            es.chams = first
        end
    })
    espb:AddToggle('espchamsvisibleonly', {
        Text = 'chams visible only',
        Default = false,
        Callback = function(first)
            es.chams_visible_only = first
        end
    })
    ---
    espb:AddLabel("chams fill color"):AddColorPicker('espchamsfillcolor',
        {
            Default = Color3.new(),
            Title = 'chams fill color',
            Transparency = 0,
            Callback = function(Value)
                es.chams_fill_color[1] = Value
            end
        })
    espb:AddLabel("chams outline color"):AddColorPicker('espchamsoutlinecolor',
        {
            Default = Color3.new(),
            Title = 'chams outline color',
            Transparency = 0,
            Callback = function(Value)
                es.chamsoutline_color[1] = Value
            end
        })
    ---
    espb:AddSlider('espchamsfilltransparency',
        { Text = 'fill transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(
        State)
        es.chams_fill_color[2] = State
    end)
    espb:AddSlider('espchamsoutlinetransparency',
        { Text = 'outline transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(
        State)
        es.chamsoutline_color[2] = State
    end)
    ----------------------------------------------------------
end
do
    local espb = ui.box.esp:AddTab("object esp")
    local es = cheat.EspLibrary.settings.object
    espb:AddDropdown('objectespfont', {Values = { 'UI', 'System', 'Plex', 'Monospace' },Default = 1,Multi = false,Text = 'esp font',Tooltip = 'select font',Callback = function(Value)
        cheat.EspLibrary.main_object_settings.textFont = Drawing.Fonts[Value]
    end})
    espb:AddSlider('objectespfontsize', { Text = 'esp font size', Default = 13, Min = 1, Max = 30, Rounding = 0, Compact = true }):OnChanged(function(State)
        cheat.EspLibrary.main_object_settings.textSize = State
    end)
    espb:AddDropdown('objectespallowed', {Values = { 'ATV', 'Stone', 'Nitrate', 'Iron', 'Bag', 'Tree' },Default = 0,Multi = true,Text = 'objects',Tooltip = 'select objects thats gonna show up',Callback = function(Value)
        cheat.EspLibrary.main_object_settings.allowed = Value
    end})
    espb:AddToggle('objectespswitch', {
        Text = 'enable esp',
        Default = false,
        Callback = function(first)
            es.enabled = first
        end
    })
    espb:AddToggle('objectesprealname', {
        Text = 'name esp',
        Default = false,
        Callback = function(first)
            es.realname = first
        end
    }):AddColorPicker('objectesprealnamecolor',
        {
            Default = Color3.new(1, 1, 1),
            Title = 'name color',
            Transparency = 0,
            Callback = function(Value)
                es.realname_color[1] = Value
            end
        })
    espb:AddSlider('objectesprealnametransparency',
        { Text = 'name transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(
        State)
        es.realname_color[2] = 1-State
    end)
    espb:AddToggle('objectesprealnameoutline', {
        Text = 'name outline',
        Default = false,
        Callback = function(first)
            es.realname_outline = first
        end
    }):AddColorPicker('objectesprealnameoutlinecolor',
        {
            Default = Color3.new(),
            Title = 'name outline color',
            Transparency = 0,
            Callback = function(Value)
                es.realname_outline_color = Value
            end
        })
end
local canuseimages = pcall(function()
    cheat.utility.new_drawing("Image", {}):Remove()
end) and pcall(function()
    local a = cheat.utility.new_drawing("Image", {})
    rawget(a, "_frame").Image = ""
    a:Remove()
end)
do
    local enabled, dynamic = false, false;
    local color1, color2 = Color3.new(1,1,1), Color3.new();
    local watermarktab = ui.box.cheatvis:AddTab("watermark")
    local watermarktoggle = watermarktab:AddToggle('watermark_enabled', {Text = 'enabled',Default = false,Callback = function(first)
        enabled = first
    end})
    watermarktoggle:AddColorPicker('watermark_color1',{Default = Color3.new(),Title = canuseimages and 'color left' or 'color',Transparency = 0,Callback = function(Value)
        color1 = Value
        if not canuseimages then color2 = Value end
    end})
    if canuseimages then watermarktoggle:AddColorPicker('watermark_color2',{Default = Color3.new(),Title = 'color right',Transparency = 0,Callback = function(Value)
        color2 = Value
    end}); end
    watermarktab:AddToggle('watermark_rainbowcolor', {Text = 'rainbow',Default = false,Callback = function(first)
        dynamic = first
    end})
    local leftcolor, rightcolor, watertext = 
    Color3.new(0.000000, 0.666667, 0.333333), 
    Color3.new(0.349020, 0.000000, 1.000000),
    "priv3 canary | Jul 28 2024 | fps: 63 ";
    local waterpos = Vector2.new(10, 10);
    local text = cheat.utility.new_drawing("Text", {
        ZIndex = 4,
        Visible = true,
        Transparency = 1,
        Position = waterpos + Vector2.new(6, 5),
        Color = Color3.new(1, 1, 1),
        Outline = true,
        OutlineColor = Color3.new(),
        Font = 0,
        Size = 14,
        Text = watertext
    });
    local gradr, gradl = cheat.utility.new_drawing(canuseimages and "Image" or "Square", {
        ZIndex = 2,
        Visible = true,
        Transparency = 1,
        Position = waterpos,
        Size = Vector2.new(text.TextBounds.X + 10, text.TextBounds.Y + 10),
        Color = rightcolor
    }), cheat.utility.new_drawing(canuseimages and "Image" or "Square", {
        ZIndex = 2,
        Visible = true,
        Transparency = 1,
        Position = waterpos,
        Size = Vector2.new(text.TextBounds.X + 10, text.TextBounds.Y + 10),
        Color = leftcolor
    });
    local gradbackground = cheat.utility.new_drawing("Square", {
        ZIndex = 1,
        Visible = true,
        Transparency = 1,
        Position = waterpos,
        Size = Vector2.new(text.TextBounds.X + 10, text.TextBounds.Y + 10),
        Color = leftcolor:Lerp(rightcolor, 0.5),
        Filled = true
    });
    local textbackground = cheat.utility.new_drawing("Square", {
        ZIndex = 3,
        Visible = true,
        Transparency = 0.337,
        Position = waterpos + Vector2.new(2, 2),
        Size = Vector2.new(text.TextBounds.X + 6, text.TextBounds.Y + 6),
        Color = Color3.new(0,0,0),
        Filled = true,
        Thickness = 0,
    });
    if canuseimages then rawget(gradr, "_frame").Image = getcustomasset(""); end
    if canuseimages then rawget(gradl, "_frame").Image = getcustomasset(""); end
    local hue1, hue2, fpstimer, fps, finalfps = 0, 0.15, tick(), 0, 60;
    cheat.utility.new_renderstepped(LPH_JIT_MAX(function(delta)
        fps = fps + 1;
        if fpstimer + 1 <= tick() then
            fpstimer = tick();
            finalfps = fps;
            fps = 0;
        end;
        hue1, hue2 = tick() % 1, tick() % 1 + 0.15;
        if hue1 >= 1 then hue1 = 0 end if hue2 >= 1 then hue2 = 0 end
        rightcolor = dynamic and Color3.fromHSV(hue1, 1, 1) or color2;
        leftcolor = dynamic and Color3.fromHSV(hue2, 1, 1) or color1;
        watertext = ("priv3 %s | %s | %s | %s fps"):format(SWG_Version, SWG_ShortName, os.date("%b %d %Y"), tostring(finalfps));
        gradr.Color = rightcolor;
        gradl.Color = leftcolor;
        gradbackground.Color = gradr.Color:Lerp(gradl.Color, 0.5);
        textbackground.Size = Vector2.new(text.TextBounds.X + 7, text.TextBounds.Y + 6);
        textbackground.Position = waterpos + Vector2.new(2, 2);
        gradbackground.Size = Vector2.new(text.TextBounds.X + 11, text.TextBounds.Y + 10);
        gradbackground.Position = waterpos;
        gradl.Position = waterpos;
        gradl.Size = Vector2.new(text.TextBounds.X + 11, text.TextBounds.Y + 10);
        gradr.Position = waterpos;
        gradr.Size = Vector2.new(text.TextBounds.X + 11, text.TextBounds.Y + 10);
        text.Position = waterpos + Vector2.new(6, 5);
        text.Text = watertext;

        text.Visible = enabled;
        gradl.Visible = enabled;
        gradr.Visible = enabled;
        gradbackground.Visible = enabled;
        textbackground.Visible = enabled;
    end))
end
do
    local oldvalues = {
        ["Ambient"] = Lighting.Ambient,
        ["OutdoorAmbient"] = Lighting.OutdoorAmbient,
        ["FogStart"] = Lighting.FogStart,
        ["FogEnd"] = Lighting.FogEnd,
        ["GlobalShadows"] = Lighting.GlobalShadows,
        ["ClockTime"] = Lighting.ClockTime,
        ["TimeOfDay"] = Lighting.TimeOfDay
    }
    local __index; __index = hookmetamethod(Lighting, "__index", newcclosure(LPH_NO_VIRTUALIZE(function(self, idx)
        if not checkcaller() then
            return oldvalues[idx] or __index(self, idx)
        end
        return __index(self, idx)
    end)))
    local __newindex; __newindex = hookmetamethod(Lighting, "__newindex", newcclosure(LPH_NO_VIRTUALIZE(function(self, idx, new)
        if not checkcaller() and oldvalues[idx] then
            oldvalues[idx] = new
        end
        return __newindex(self, idx, new)
    end)))
    local WorldTab = ui.box.world:AddTab("world visuals")
    local gradientenabled = false
    local gradientcolor1 = Color3.fromRGB(90, 90, 90)
    local gradientcolor2 = Color3.fromRGB(150, 150, 150)
    local time = 12
    local timechanger = false
    local nofog = false
    local noshadows = false
    WorldTab:AddToggle('enabletimechanger', {Text = 'enable time changer',Default = false,Callback = function(first)
        timechanger = first
    end})
    WorldTab:AddSlider('timechanger',{ Text = 'time changer', Default = mathround(Lighting.ClockTime), Min = 0, Max = 24, Rounding = 1, Compact = false }):OnChanged(function(State)
        time = State
    end)
    WorldTab:AddToggle('ambientswitch', {Text = 'enable ambient',Default = false,Callback = function(first)
        gradientenabled = first
    end}):AddColorPicker('ambientcolor', {Default = Color3.new(1, 1, 1),Title = 'ambient color1',Transparency = 0,Callback = function(Value)
        gradientcolor1 = Value
    end}):AddColorPicker('ambientcolor1',{Default = Color3.new(1, 1, 1),Title = 'ambient color2',Transparency = 0,Callback = function(Value)
        gradientcolor2 = Value
    end})
    WorldTab:AddToggle('grassswitch', {
        Text = 'no grass',
        Default = false,
        Callback = function(first)
            sethiddenproperty(_FindFirstChildOfClass(workspace, "Terrain"), "Decoration", not first)
        end
    })
    WorldTab:AddToggle('fogswitch', {
        Text = 'no fog',
        Default = false,
        Callback = function(first)
            nofog = first
        end
    })
    WorldTab:AddToggle('shadowswitch', {
        Text = 'no shadows',
        Default = false,
        Callback = function(first)
            noshadows = first
        end
    })
    cheat.utility.new_heartbeat(function()
        Lighting.GlobalShadows = not noshadows
        if gradientenabled then
            Lighting.Ambient = gradientcolor1
            Lighting.OutdoorAmbient = gradientcolor2
        end
        if timechanger then
            Lighting.ClockTime = time
        end
        Lighting.FogEnd = nofog and math.huge or 900
        Lighting.FogStart = nofog and math.huge or 0
    end)
end

do
    local cursor = {
        Enabled = false,
        CustomPos = false,
        Position = _Vector2new(0, 0),
        Speed = 5,
        Radius = 25,
        Color = Color3.fromRGB(180, 50, 255),
        Thickness = 1.7,
        Outline = false,
        Resize = false,
        Dot = false,
        Gap = 10,
        TheGap = false,
        Font = Drawing.Fonts.Monospace,
        Text = {
            Logo = false,
            LogoColor = Color3.new(1, 1, 1),
            Name = false,
            NameColor = Color3.new(1, 1, 1),
            LogoFadingOffset = 0,
        }
    }
    local CrosshairTab = ui.box.world:AddTab("crosshair")
    cursor.rainbow = false
    cursor.sussy = false
    CrosshairTab:AddDropdown('espfont', {Values = { 'UI', 'System', 'Plex', 'Monospace' },Default = 1,Multi = false,Text = 'esp font',Tooltip = 'select font',Callback = function(Value)
        cursor.Font = Drawing.Fonts[Value]
    end})
    CrosshairTab:AddToggle('crosshairenable', {Text = 'enable crosshair',Default = false,Callback = function(first)
        cursor.Enabled = first
    end}):AddColorPicker('crosshaircolor', {Default = Color3.new(1, 1, 1),Title = 'crosshair color',Transparency = 0,Callback = function(Value)
        cursor.Color = Value
    end})
    CrosshairTab:AddSlider('crosshairspeed', {Text = 'speed',Default = 3,Min = 0.1,Max = 15,Rounding = 1,Compact = true}):OnChanged(function(State)
        cursor.Speed = State / 10
    end)
    CrosshairTab:AddSlider('crosshairradius', {Text = 'radius',Default = 25,Min = 0.1,Max = 100,Rounding = 1,Compact = true,}):OnChanged(function(State)
        cursor.Radius = State
    end)
    CrosshairTab:AddSlider('crosshairthickness', {Text = 'thickness',Default = 1.5,Min = 0.1,Max = 10,Rounding = 1,Compact = true,}):OnChanged(function(State)
        cursor.Thickness = State
    end)
    CrosshairTab:AddSlider('crosshairgapsize', {Text = 'gap',Default = 5,Min = 0,Max = 50,Rounding = 1,Compact = true,}):OnChanged(function(State)
        cursor.Gap = State
    end)
    CrosshairTab:AddToggle('crosshairenablegap', {Text = 'math divide gap',Default = false,Callback = function(first)
        cursor.TheGap = first
    end})
    CrosshairTab:AddToggle('crosshairenableoutline', {Text = 'outline',Default = false,Callback = function(first)
        cursor.Outline = first
    end})
    CrosshairTab:AddToggle('crosshairenableresize', {Text = 'resize animation',Default = false,Callback = function(first)
        cursor.Resize = first
    end})
    CrosshairTab:AddToggle('crosshairenabledot', {Text = 'dot',Default = false,Callback = function(first)
        cursor.Dot = first
    end})
    CrosshairTab:AddToggle('crosshairenablenazi', {Text = 'sussy',Default = false,Callback = function(first)
        cursor.sussy = first
        end})
        CrosshairTab:AddToggle('crosshairenablefaggot', {Text = 'rainbow',Default = false,Callback = function(first)
        cursor.rainbow = first
    end})

    -- // Initilisation
    local lines = {}
    -- // Drawings
    local outline = cheat.utility.new_drawing("Square", {
        Visible = true,
        Size = _Vector2new(4, 4),
        Color = Color3.fromRGB(0, 0, 0),
        Filled = true,
        ZIndex = 1,
        Transparency = 1
    })
    --
    local dot = cheat.utility.new_drawing("Square", {
        Visible = true,
        Size = _Vector2new(2, 2),
        Color = cursor.Color,
        Filled = true,
        ZIndex = 2,
        Transparency = 1
    })
    --
    local logotext = cheat.utility.new_drawing("Text", {
        Visible = false,
        Font = cursor.Font,
        Size = 13,
        Color = Color3.fromRGB(138, 128, 255),
        ZIndex = 3,
        Transparency = 1,
        Text = "priv3",
        Center = true,
        Outline = true,
    })
    local indicatortext = cheat.utility.new_drawing("Text", {
        Visible = false,
        Font = cursor.Font,
        Size = 13,
        Color = Color3.new(1, 1, 1),
        ZIndex = 3,
        Transparency = 1,
        Text = "",
        Center = true,
        Outline = true,
    })
    --
    for i = 1, 4 do
        local line_outline = cheat.utility.new_drawing("Line", {
            Visible = true,
            From = _Vector2new(200, 500),
            To = _Vector2new(200, 500),
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = cursor.Thickness + 2.5,
            ZIndex = 1,
            Transparency = 1
        })
        local line = cheat.utility.new_drawing("Line", {
            Visible = true,
            From = _Vector2new(200, 500),
            To = _Vector2new(200, 500),
            Color = cursor.Color,
            Thickness = cursor.Thickness,
            ZIndex = 2,
            Transparency = 1
        })
        local naziline = cheat.utility.new_drawing("Line", {
            Visible = true,
            From = _Vector2new(200, 500),
            To = _Vector2new(200, 500),
            Color = cursor.Color,
            Thickness = cursor.Thickness,
            ZIndex = 2,
            Transparency = 1
        })
        lines[i] = { line, line_outline, naziline }
    end
    local angle = 0
    local transp = 0
    local reverse = false
    local function setreverse(value)
        if reverse ~= value then
            reverse = value
        end
    end
    --
    local pos, rainbow, rotationdegree, color = Vector2.zero, 0, 0, Color3.new()
    local math_cos, math_atan, math_pi, math_sin = math.cos, math.atan, math.pi, math.sin
    local function DEG2RAD(x) return x * math_pi / 180 end
    local function RAD2DEG(x) return x * 180 / math_pi end
    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
        if cursor.Enabled then
            rainbow = rainbow + (delta * 0.5)
            if rainbow > 1.0 then rainbow = 0.0 end
            color = Color3.fromHSV(rainbow, 1, 1)
            if cursor.CustomPos then pos = cursor.Position else pos = _Vector2new(
                Mouse.X,
                Mouse.Y + GuiInset.Y) end
            if cursor.rainbow then color = Color3.fromHSV(rainbow, 1, 1) else color = cursor.Color end
            if transp <= 1.5 + cursor.Text.LogoFadingOffset and not reverse then
                transp = transp + (((cursor.Speed == 0 and 1 or cursor.Speed) * 10) * delta)
                if transp >= 1.5 + cursor.Text.LogoFadingOffset then setreverse(true) end
            elseif reverse then
                transp = transp - (((cursor.Speed == 0 and 1 or cursor.Speed) * 10) * delta)
                if transp <= 0 - cursor.Text.LogoFadingOffset then setreverse(false) end
            end
            logotext.Position = _Vector2new(pos.X, (pos + _Vector2new(0, cursor.Radius + 5)).Y)
            logotext.Transparency = transp
            logotext.Visible = cursor.Text.Logo
            logotext.Color = cursor.Text.LogoColor
            logotext.Font = cursor.Font
            --
            indicatortext.Position = _Vector2new(pos.X, (pos + _Vector2new(0, cursor.Radius + (cursor.Text.Logo and 19 or 5))).Y)
            indicatortext.Visible = aimbot.indicator
            indicatortext.Color = cursor.Text.NameColor
            indicatortext.Font = cursor.Font
            indicatortext.Text = aimbot.indicator_text

            if cursor.sussy then
                local frametime = delta
                local a = cursor.Radius - 10
                local gamma = math_atan(a / a)

                if rotationdegree >= 90 then rotationdegree = 0 end

                for i = 1, 4 do
                    local p_0 = (a * math_sin(DEG2RAD(rotationdegree + (i * 90))))
                    local p_1 = (a * math_cos(DEG2RAD(rotationdegree + (i * 90))))
                    local p_2 = ((a / math_cos(gamma)) * math_sin(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))
                    local p_3 = ((a / math_cos(gamma)) * math_cos(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))


                    lines[i][1].From = _Vector2new(pos.X, pos.Y)
                    lines[i][1].To = _Vector2new(pos.X + p_0, pos.Y - p_1)
                    lines[i][1].Color = color
                    lines[i][1].Thickness = cursor.Thickness
                    lines[i][1].Visible = true
                    lines[i][3].From = _Vector2new(pos.X + p_0, pos.Y - p_1)
                    lines[i][3].To = _Vector2new(pos.X + p_2, pos.Y - p_3)
                    lines[i][3].Color = color
                    lines[i][3].Thickness = cursor.Thickness
                    lines[i][3].Visible = true
                end
                rotationdegree = rotationdegree + ((cursor.Speed * frametime) * 1000)
            else
                angle = (cursor.Speed == 0 and 0 or angle + ((cursor.Speed * 10) * delta))

                if angle >= 90 then
                    angle = 0
                end

                --
                dot.Visible = cursor.Dot
                dot.Color = color
                dot.Position = _Vector2new(pos.X - 1, pos.Y - 1)
                --
                outline.Visible = cursor.Outline and cursor.Dot
                outline.Position = _Vector2new(pos.X - 2, pos.Y - 2)
                --

                --
                for index, line in pairs(lines) do
                    index = index
                    local x, y = {}, {}
                    local x1, y1 = {}, {}
                    if cursor.Resize then
                        x = { pos.X +
                        (math.cos(angle + (index * (math.pi / 2))) * (cursor.Radius + ((cursor.Radius * math.sin(angle)) / 9))),
                            pos.X +
                            (math.cos(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20) - (cursor.TheGap and (((cursor.Radius - 20) * math.cos(angle)) / 4) or (((cursor.Radius - 20) * math.cos(angle)) - 4)))) }
                        y = { pos.Y +
                        (math.sin(angle + (index * (math.pi / 2))) * (cursor.Radius + ((cursor.Radius * math.sin(angle)) / 9))),
                            pos.Y +
                            (math.sin(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20) - (cursor.TheGap and (((cursor.Radius - 20) * math.cos(angle)) / 4) or (((cursor.Radius - 20) * math.cos(angle)) - 4)))) }
                        x1 = { pos.X + (math.cos(angle + (index * (math.pi / 2))) * (cursor.Radius + 1)), pos
                        .X +
                        (math.cos(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20 + 1) - (cursor.TheGap and ((cursor.Radius - 20 + 1) / cursor.Gap) or ((cursor.Radius - 20 + 1) - cursor.Gap)))) }
                        y1 = { pos.Y + (math.sin(angle + (index * (math.pi / 2))) * (cursor.Radius + 1)), pos
                        .Y +
                        (math.sin(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20 + 1) - (cursor.TheGap and ((cursor.Radius - 20 + 1) / cursor.Gap) or ((cursor.Radius - 20 + 1) - cursor.Gap)))) }
                    else
                        x = { pos.X + (math.cos(angle + (index * (math.pi / 2))) * (cursor.Radius)), pos.X +
                        (math.cos(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20) - (cursor.TheGap and ((cursor.Radius - 20) / cursor.Gap) or ((cursor.Radius - 20) - cursor.Gap)))) }
                        y = { pos.Y + (math.sin(angle + (index * (math.pi / 2))) * (cursor.Radius)), pos.Y +
                        (math.sin(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20) - (cursor.TheGap and ((cursor.Radius - 20) / cursor.Gap) or ((cursor.Radius - 20) - cursor.Gap)))) }
                        x1 = { pos.X + (math.cos(angle + (index * (math.pi / 2))) * (cursor.Radius + 1)), pos
                        .X +
                        (math.cos(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20 + 1) - (cursor.TheGap and ((cursor.Radius - 20 + 1) / cursor.Gap) or ((cursor.Radius - 20 + 1) - cursor.Gap)))) }
                        y1 = { pos.Y + (math.sin(angle + (index * (math.pi / 2))) * (cursor.Radius + 1)), pos
                        .Y +
                        (math.sin(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20 + 1) - (cursor.TheGap and ((cursor.Radius - 20 + 1) / cursor.Gap) or ((cursor.Radius - 20 + 1) - cursor.Gap)))) }
                    end
                    --
                    line[1].Visible = true
                    line[1].Color = color
                    line[1].From = _Vector2new(x[2], y[2])
                    line[1].To = _Vector2new(x[1], y[1])
                    line[1].Thickness = cursor.Thickness
                    --
                    line[2].Visible = cursor.Outline
                    line[2].From = _Vector2new(x1[2], y1[2])
                    line[2].To = _Vector2new(x1[1], y1[1])
                    line[2].Thickness = cursor.Thickness + 2.5

                    line[3].Visible = false
                end
            end
        else
            dot.Visible = false
            outline.Visible = false
            logotext.Visible = false
            indicatortext.Visible = false
            --
            for index, line in pairs(lines) do
                line[1].Visible = false
                line[2].Visible = false
                line[3].Visible = false
            end
        end
    end))
end

do
    local mvb = ui.box.move:AddTab('speedhack')
    local bhop_enabled, speed = false, 55
    local downcliff_mode, downcliff_start, downcliff_speed, downcliff_accel, downcliff_fall = false, 50, 150, 50, 50
    local forcesprint = false
    mvb:AddToggle('speedhack_forcesprint', {Text = 'forcesprint',Default = false,Callback = function(first)
        forcesprint = first
    end})
    mvb:AddToggle('speedhack_enabled', {Text = 'speedhack enabled',Default = false,Callback = function(first)
        bhop_enabled = first
    end})
    mvb:AddSlider('speedhack_speed',{ Text = 'speed', Default = 55, Min = 55, Max = 70, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        speed = State
    end)
    mvb:AddToggle('downcliff_mode',{ Text = 'downcliff mode',Default = false,Callback = function(first)
        downcliff_mode = first
    end})
    mvb:AddSlider('downcliff_start',{ Text = 'start speed', Default = 55, Min = 10, Max = 250, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        downcliff_start = State
    end)
    mvb:AddSlider('downcliff_speed',{ Text = 'max speed', Default = 55, Min = 10, Max = 250, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        downcliff_speed = State
    end)
    mvb:AddSlider('downcliff_accel',{ Text = 'acceleration', Default = 55, Min = 1, Max = 250, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        downcliff_accel = State
    end)
    mvb:AddSlider('downcliff_fall',{ Text = 'fall speed', Default = 55, Min = 10, Max = 200, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        downcliff_fall = State
    end)
    local niga, wtf = speed, 0
    local dc_buildup = downcliff_speed
    local middle = trident.middlepart
    cheat.utility.new_renderstepped(LPH_JIT_MAX(function(delta)
        local shiftpressed = _IsKeyDown(UserInputService, Enum.KeyCode.LeftShift)
        local cpressed = _IsKeyDown(UserInputService, Enum.KeyCode.C)
        local spacedown = _IsKeyDown(UserInputService, Enum.KeyCode.Space)
        if bhop_enabled and not downcliff_mode and middle and cpressed and shiftpressed then
            local cameralook = Camera.CFrame.LookVector
            cameralook = _Vector3new(cameralook.X, 0, cameralook.Z)
            local direction = Vector3.zero
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.W) and direction + cameralook or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.S) and direction - cameralook or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.D) and direction + _Vector3new(- cameralook.Z, 0, cameralook.X) or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.A) and direction + _Vector3new(cameralook.Z, 0, - cameralook.X) or direction;
            if not (direction == Vector3.zero) then
                direction = direction.Unit
            end
            niga = math.clamp(niga-delta*20, 17, speed)
            if wtf == 0 then
                middle.CFrame = middle.CFrame + _Vector3new(0, 6.5, 0)
            end
            middle.AssemblyLinearVelocity = _Vector3new(
                direction.X * niga,
                wtf < 0.85 and 0 or -7,
                direction.Z * niga
            )
            wtf = wtf + delta
        elseif bhop_enabled and downcliff_mode and middle and cpressed and shiftpressed then
            local cameralook = Camera.CFrame.LookVector
            cameralook = _Vector3new(cameralook.X, 0, cameralook.Z)
            local direction = Vector3.zero
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.W) and direction + cameralook or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.S) and direction - cameralook or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.D) and direction + _Vector3new(- cameralook.Z, 0, cameralook.X) or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.A) and direction + _Vector3new(cameralook.Z, 0, - cameralook.X) or direction;
            if not (direction == Vector3.zero) then
                direction = direction.Unit
            end
            dc_buildup = math.clamp(spacedown and dc_buildup-delta*20 or dc_buildup+delta*downcliff_accel, 17, downcliff_speed)
            middle.AssemblyLinearVelocity = _Vector3new(
                direction.X * dc_buildup,
                spacedown and -7 or -downcliff_fall,
                direction.Z * dc_buildup
            )
            wtf = wtf + delta
        else
            if forcesprint and middle then
                local cameralook = Camera.CFrame.LookVector
                cameralook = _Vector3new(cameralook.X, 0, cameralook.Z)
                local direction = Vector3.zero
                direction = _IsKeyDown(UserInputService, Enum.KeyCode.W) and direction + cameralook or direction;
                direction = _IsKeyDown(UserInputService, Enum.KeyCode.S) and direction - cameralook or direction;
                direction = _IsKeyDown(UserInputService, Enum.KeyCode.D) and direction + _Vector3new(- cameralook.Z, 0, cameralook.X) or direction;
                direction = _IsKeyDown(UserInputService, Enum.KeyCode.A) and direction + _Vector3new(cameralook.Z, 0, - cameralook.X) or direction;
                if not (direction == Vector3.zero) then
                    direction = direction.Unit
                end
                middle.AssemblyLinearVelocity = _Vector3new(
                    direction.X * 18,
                    middle.AssemblyLinearVelocity.Y,
                    direction.Z * 18
                )
            end
            niga = speed
            dc_buildup = downcliff_start
            wtf = 0
        end
    end))
end

do
    local mvb = ui.box.move:AddTab('exploits')
    local enabled, speed = false, 55
    mvb:AddToggle('desync_enabled', {Text = 'desync enabled',Default = false,Callback = function(first)
        aimbot.invis = first
    end}):AddKeyPicker('desyncbind', {Default = 'None',SyncToggleState = true,Mode = 'Toggle',Text = 'desync',NoUI = false})
    mvb:AddToggle('silentwalk_enabled', {Text = 'silent walking',Default = false,Callback = function(first)
        aimbot.silentwalk = first
        if first then trident.tcp:FireServer(2, true) end
    end}):AddKeyPicker('silentwalk_bind', {Default = 'None',SyncToggleState = true,Mode = 'Toggle',Text = 'silent walk',NoUI = false})
    local freecamoffset = Vector3.zero
    local middle = workspace.Ignore.LocalCharacter.Middle
    local bottom = workspace.Ignore.LocalCharacter.Bottom
    local top = workspace.Ignore.LocalCharacter.Top
    local pos = middle.CFrame
    mvb:AddToggle('freecam_enabled', {Text = 'freecam enabled',Default = false,Callback = function(first)
        enabled = first
        middle.CanCollide = not first
        bottom.CanCollide = not first
        top.CanCollide = not first
    end}):AddKeyPicker('freecam_bind', {Default = 'None',SyncToggleState = true,Mode = 'Toggle',Text = 'freecam',NoUI = false})
    mvb:AddSlider('freecam_speed',{ Text = 'speed', Default = 10, Min = 1, Max = 150, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        speed = State
    end)
    mvb:AddToggle('silentaim_extended', {Text = 'fakelag',Default = false,Callback = function(Value)
        aimbot.extended_manipulation = Value
    end}):AddKeyPicker('fakelag_bind', {Default = 'None',SyncToggleState = true,Mode = 'Toggle',Text = 'fakelag',NoUI = false})
    cheat.utility.new_heartbeat(LPH_JIT_MAX(function(delta)
        if enabled and middle then
            middle.CFrame = pos
            RunService.RenderStepped:Wait()
            if middle then
                local cameralook = Camera.CFrame.LookVector
                local direction = Vector3.zero
                direction = _IsKeyDown(UserInputService, Enum.KeyCode.W) and direction + cameralook or direction;
                direction = _IsKeyDown(UserInputService, Enum.KeyCode.S) and direction - cameralook or direction;
                direction = _IsKeyDown(UserInputService, Enum.KeyCode.D) and direction + _Vector3new(- cameralook.Z, 0, cameralook.X) or direction;
                direction = _IsKeyDown(UserInputService, Enum.KeyCode.A) and direction + _Vector3new(cameralook.Z, 0, - cameralook.X) or direction;
                if not direction == Vector3.zero then
                    direction = direction.Unit
                end
                freecamoffset = freecamoffset + (direction * delta * speed)
                middle.CFrame = pos + freecamoffset
                middle.AssemblyLinearVelocity = Vector3.zero
            end
        elseif middle then
            freecamoffset = Vector3.zero
            pos = middle.CFrame
        end
    end))
end

do
    local mvb = ui.box.atvfly:AddTab('vehicle fly')
    local carfly_enabled, speed, accel, upspeed = false, 55, 100, 15
    mvb:AddToggle('carfly_enabled', {Text = 'vehicle fly enabled',Default = false,Callback = function(first)
        carfly_enabled = first
    end}):AddKeyPicker('carfly_bind', {Default = 'None',SyncToggleState = true,Mode = 'Toggle',Text = 'vehicle fly',NoUI = false})
    mvb:AddSlider('carfly_speed',{ Text = 'speed', Default = 150, Min = 50, Max = 300, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        speed = State
    end)
    mvb:AddSlider('carfly_upspeed',{ Text = 'up speed', Default = 15, Min = 5, Max = 100, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        upspeed = State
    end)
    mvb:AddSlider('carfly_accel',{ Text = 'acceleration', Default = 100, Min = 10, Max = 300, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        accel = State
    end)
    mvb:AddLabel("hold V to go up")
    mvb:AddLabel("hold B to go down")
    local car, carpart, dist = nil, nil, 50
    local findcar = function()
        car, dist = nil, 50
        for i,v in pairs(workspace:GetChildren()) do
            local temp_part = (_FindFirstChild(v, "Seat") and _FindFirstChild(v, "Frame")) or (_FindFirstChild(v, "Seats") and _FindFirstChild(v, "Hull"))
            if temp_part and (temp_part.Position - trident.middlepart.Position).Magnitude < dist then
                car = v
                carpart = temp_part
                dist = (carpart.Position - trident.middlepart.Position).Magnitude
            end
        end
    end
    findcar()
    local buildup = 0
    local lastdir = _Vector3new(1,0,0)
    cheat.utility.new_renderstepped(LPH_JIT_MAX(function(delta)
        if carfly_enabled and car and carpart and (carpart.CFrame.p - Camera.CFrame.p).Magnitude <= 50 then
            local cameralook = Camera.CFrame.LookVector
            cameralook = _Vector3new(cameralook.X, 0, cameralook.Z)
            local direction = Vector3.zero
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.W) and direction + cameralook or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.S) and direction - cameralook or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.D) and direction + _Vector3new(- cameralook.Z, 0, cameralook.X) or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.A) and direction + _Vector3new(cameralook.Z, 0, - cameralook.X) or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.V) and direction + Vector3.yAxis or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.B) and direction - Vector3.yAxis or direction;
            if direction ~= Vector3.zero then
                direction = direction.Unit
                if direction ~= Vector3.yAxis and -direction ~= Vector3.yAxis then
                    buildup = math.clamp(buildup + delta * accel, 0, speed)
                    lastdir = direction
                end
            else
                direction = lastdir
                buildup = math.clamp(buildup - delta * 150, 0, speed)
            end
            carpart.AssemblyLinearVelocity = _Vector3new(direction.X * buildup, direction.Y * upspeed, direction.Z * buildup)
            --v.AssemblyLinearVelocity = direction * SPEED + _Vector3new(0, 0.05, 0)
            --v.CFrame = _CFramenew(v.CFrame.Position) * CFrame.Angles(0, y+(math.pi/2), 0)
        elseif not carpart or car and carpart and (carpart.CFrame.p - Camera.CFrame.p).Magnitude > 50 then
            findcar()
            buildup = 0
        else
            buildup = 0
        end
    end))
end
loadpriv3file("chat_spam.lua")(cheat.Library, ui.box.misc:AddTab("chat spam"), function(word)
    trident.tcp:FireServer(23, word, "Global")
end, 25, 100)
do
    local noatvrestriction = false
    local charactermod = ui.box.misc:AddTab("char mod")
    charactermod:AddToggle('noatvrestriction', {Text = 'no atv restriction',Default = false,Callback = function(first)
        noatvrestriction = first
    end})
    task.spawn(function()
        local thing = trident.gc.camera.SetMaxRelativeLookExtentsY
        while wait() do
            if noatvrestriction then thing(10000) end
        end
    end)
end
--[[
1 = SendCodes_class.INV_USE_ITEM,
2 = "Hit",
3 = currentbulletcount,
4 = totaltraveltime,
5 = EntityFromPart.id,
6 = raycastresult.Instance.Name,
7 = raycastresult.Position - EntityFromPart.model.PrimaryPart.Position,
8 = raycastresult.Position
]]
do
    local real_extended = 0
    local oldfireserver; oldfireserver = hookmetamethod(Instance.new("RemoteEvent"), "__namecall", newcclosure(LPH_NO_VIRTUALIZE(function(self, ...)
        if checkcaller() then return oldfireserver(self, ...) end
        if getnamecallmethod() == "FireServer" and self == trident.tcp then
            local args = {...}
            if args[1] == 1 then

                real_extended = real_extended + 1

                if real_extended % 2 >= 1 and aimbot.extended_manipulation then
                    args[5] = nil
                    return oldfireserver(self, unpack(args))
                end

                if aimbot.jumpshoot or aimbot.downhill then
                    args[5] = 1
                end

                if aimbot.invis then
                    args[3] = nil
                    args[5] = nil
                    return oldfireserver(self, unpack(args))
                end

                trident.lastpos = args[2] + _Vector3new(0, 3, 0)

                --[[if args[3] then
                    args[3] = _Vector3new(-1.5, args[3].Y, args[3].Z)
                end]]
            end
            if args[1] == 2 and aimbot.silentwalk then
                return-- oldfireserver(self, 2, true)
            end
            if args[1] == 10 and args[2] == "Hit" and type(args[5]) == "number" and type(args[6]) == "string" then
                local entity = getupvalue(trident.gc.entitylist, 1)[args[5]]
                if entity and entity.model and _FindFirstChild(entity.model, "Head") then
                    if aimbot.forcehead then args[6] = "Head" print('set head') end
                    local part = _FindFirstChild(entity.model, args[6])
                    local originalpart = _FindFirstChild(trident.original_model, args[6])
                    if aimbot.hitboxes and part and originalpart then
                        if aimbot.hbbypass then
                            local primarypart = entity.model.PrimaryPart
                            local partoffset = part.Position - primarypart.Position
                            print('sigma1')
                            args[7] = _Vector3new(
                                math.random(-originalpart.Size.X, originalpart.Size.X),
                                math.random(-originalpart.Size.Y, originalpart.Size.Y),
                                math.random(-originalpart.Size.Z, originalpart.Size.Z)
                            ) + partoffset
                            print('sigma2')
                            --args[8] = args[7] + primarypart.Position
                        else
                            args[7] = _Vector3new(1.615182638168335, args[7].Y, 0.13987892866134644)
                        end
                    end
                end
            end
            return oldfireserver(self, unpack(args))
        end
        return oldfireserver(self, ...)
    end)))
end

ui.box.themeconfig:AddToggle('keybindshoww', {Text = 'show keybinds',Default = false,Callback = function(first)cheat.Library.KeybindFrame.Visible = first end})
cheat.ThemeManager:SetOptionsTEMP(cheat.Options, cheat.Toggles)
cheat.SaveManager:SetOptionsTEMP(cheat.Options, cheat.Toggles)
cheat.ThemeManager:SetLibrary(cheat.Library)
cheat.SaveManager:SetLibrary(cheat.Library)
cheat.SaveManager:IgnoreThemeSettings()
cheat.ThemeManager:SetFolder('priv3')
cheat.SaveManager:SetFolder('priv3')
cheat.SaveManager:BuildConfigSection(ui.tabs.config)
cheat.ThemeManager:ApplyToGroupbox(ui.box.themeconfig)

cheat.EspLibrary.load()
