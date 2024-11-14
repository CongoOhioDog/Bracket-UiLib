
	
local core_gui = game:GetService("CoreGui")
local players = game:GetService("Players")
local texts = game:GetService("TextService")
local lplr = players.LocalPlayer
local mouse = lplr:GetMouse()
local http = game:GetService("HttpService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local hs = game:GetService("HttpService")
local stats = game:GetService("Stats")
local camera = workspace.CurrentCamera

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end)
local ScreenGui = Instance.new('ScreenGui')
ProtectGui(ScreenGui)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = core_gui
ScreenGui.Name = "linebob"


local clamp = math.clamp
local floor = math.floor
local rad = math.rad
local sin = math.sin
local atan2 = math.atan2
local max = math.max
local min = math.min
local cos = math.cos
local abs = math.abs
local pi = math.pi
local gsub = string.gsub
local vect2 = Vector2.new
local vect3 = Vector3.new
local cfnew = CFrame.new
local angles = CFrame.Angles
local cflookat = CFrame.lookAt
local forcefield = Enum.Material.ForceField
local plastic = Enum.Material.Plastic
local neon = Enum.Material.Neon
local udimnew = UDim.new
local udim2new = UDim2.new
local lower = string.lower
local viewport_size = camera.ViewportSize
local mouse_pos = uis:GetMouseLocation()
local twinfo = TweenInfo.new
local colorfromrgb = Color3.fromRGB


local signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/Quenty/NevermoreEngine/version2/Modules/Shared/Events/Signal.lua"))()




local lib = {
    config_location = "judensense",
    accent_color = colorfromrgb(196, 166, 177),
    on_config_load = -- Converted: Generic Event/Signal Initialization("on_config_load"),
    on_accent_change = -- Converted: Generic Event/Signal Initialization("on_accent_change"),
    flags = {},
    copied_color = colorfromrgb(255,255,255),
    notifications = {
        cache = {}
    },
    Registry = {},
    RegistryMap = {},
    HudRegistry = {},
}

function -- Converted: Generic Config List Fetch
    local location = lib.config_location.."/configs/"
    local cfgs = listfiles(location)
    local returnTable = {}
    for _, file in pairs(cfgs) do
        local str = tostring(file)
        if string.sub(str, #str - 3, #str) == ".cfg" then
            table.insert(returnTable, string.sub(str, #location + 1, #str - 4))
        end        
    end
    return returnTable
end

function lib:get_script_list()
    local location = lib.config_location.."/scripts/"
    local cfgs = listfiles(location)
    local returnTable = {}
    for _, file in pairs(cfgs) do
        local str = tostring(file)
        if string.sub(str, #str-3, #str) == ".lua" then
            table.insert(returnTable, string.sub(str, #location+2, #str-4))
        end
    end
    return returnTable
end


local util = {
    connections = {}
}

do
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

    function util:to_hex(color)
        return string.format("#%02X%02X%02X", color.R * 0xFF,
                color.G * 0xFF, color.B * 0xFF)
    end

    function util:new_drawing(class, properties)
        local surge = new_drawing(class)
        surge.Visible = false
        for property, value in pairs(properties) do
            surge[property] = value
        end
        return surge
    end

    function util:encode64(data)
            local r,b='',x:byte()
            for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
            return r;
            if (#x < 6) then return '' end
            local c=0
            for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
            return b:sub(c+1,c+1)
        end))..({ '', '==', '=' })[#data%3+1])
    end

    function util:decode64(data)
        local data = string.gsub(data, '[^'..b..'=]', '')
            if (x == '=') then return '' end
            local r,f='',(b:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
            return r;
            if (#x ~= 8) then return '' end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
        end)))
    end

    function util:hex_to_color(hex)
        hex = hex:gsub("#","")
        local r, g, b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
        return Color3.new(r,g,b)
    end

    function util:round(num, decimals)
        local mult = 10^(decimals or 0)
        return floor(num * mult + 0.5) / mult
    end

    function util:copy(original)
        local copy = {}
        for _, v in pairs(original) do
            if type(v) == "table" then
                v = util:copy(v)
            end
            copy[_] = v
        end
        return copy
    end

    function util:find(surge, target)
        for i = 1, #surge do
            local potential = surge[i]
            if potential == target then
                return i
            end
        end
    end

    function util:tween(...) 
        ts:Create(...):Play()
    end

    function util:set_draggable(obj)
        local dragging
        local dragInput
        local dragStart
        local startPos

        local function update(input)
            local delta = input.Position - dragStart
            obj.Position = udim2new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch and not lib.busy then
                dragging = true
                dragStart = input.Position
                startPos = obj.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        obj.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch and not lib.busy then
                dragInput = input
            end
        end)

        uis.InputChanged:Connect(function(input)
            if input == dragInput and dragging and not lib.busy then
                update(input)
            end
        end)
    end

    function util:is_in_frame(object)
        local abs_pos = object.AbsolutePosition
        local abs_size = object.AbsoluteSize
        local x = abs_pos.Y <= mouse.Y and mouse.Y <= abs_pos.Y + abs_size.Y
        local y = abs_pos.X <= mouse.X and mouse.X <= abs_pos.X + abs_size.X

        return (x and y)
    end

        local success, _ = pcall(function() 
            object[propertyName] = object[propertyName]
        end)
        return success
    end)

        local object = Instance.new(classname)

        for prop, val in pairs(properties) do
            local prop, val = prop, val

            object[prop] = val
        end

        object.Name = hs:GenerateGUID(false)

        return object
    end)

    function util:create_connection(signal, callback)
        local connection = signal:Connect(callback)

        table.insert(util.connections, connection)

        return connection
    end

    function util:get_text_size(title)
        return texts:GetTextSize(title, 12, "RobotoMono", vect2(999,999)).X
    end

    function lib:save_config(cfgName)
        local values_copy = util:copy(lib.flags)
        for i,element in pairs(values_copy) do
            if typeof(element) == "table" and element["color"] then
                element["color"] = {R = element["color"].R, G = element["color"].G, B = element["color"].B}
            end
        end

        if true then
            task.spawn(function()
                task.wait()
            end)
            writefile(lib.config_location.."/configs/"..cfgName..".cfg", util:encode64(hs:JSONEncode(values_copy)))
        else
            return hs:JSONEncode(values_copy)
        end
    end

    function lib:load_config(cfgName)
        local new_values = hs:JSONDecode(util:decode64(readfile((lib.config_location.."/configs/"..cfgName..".cfg"))))

        for i, element in pairs(new_values) do
            if typeof(element) == "table" and element["color"] then
                element["color"] = Color3.new(element["color"].R, element["color"].G, element["color"].B)
            end
            lib.flags[i] = element
        end

        task.spawn(function()
            task.wait()
            lib.on_config_load:Fire()
        end)
    end

    global_sg = -- Converted: Use UI Library's Instance creation functions("ScreenGui", {
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        Name = "trannyhack.paste",
        Parent = gethui and gethui() or core_gui
    })
end


if not isfolder(lib.config_location) then
    makefolder(lib.config_location)
end

if not isfolder(lib.config_location.."/configs") then
    makefolder(lib.config_location.."/configs")
end

if not isfolder(lib.config_location.."/scripts") then
    makefolder(lib.config_location.."/scripts")
end


do

local window = {}; window.__index = window
local tab = {}; tab.__index = tab
local subtab = {}; subtab.__index = subtab
local section = {}; section.__index = section
local element = {}; element.__index = element

function window:set_title(text)
    self.name_label.Text = text
    self.name_label.RichText = true
    self.name_label.TextColor3 = Color3.fromRGB(74, 74, 74)
end

function window:set_build(text)
    local color = {R = util:round(lib.accent_color.R*255), G = util:round(lib.accent_color.G*255), B = util:round(lib.accent_color.B*255)}
    self.build_label.Text = string.format("build: <font color=\"rgb(%s, %s, %s)\">%s</font>", color.R, color.G, color.B, text)
end

function window:set_user(text)
    local color = {R = util:round(lib.accent_color.R*255), G = util:round(lib.accent_color.G*255), B = util:round(lib.accent_color.B*255)}
    self.user_label.Text = string.format("active user: <font color=\"rgb(%s, %s, %s)\">%s</font>", color.R, color.G, color.B, text)
end

function window:set_tab(name)
    self.active_tab = name
    for _, v in pairs(self.tabs) do
        if v.name == name then v:set_active() else v:set_not_active() end
    end 
end

function window:set_accent_color(color)
    lib.on_accent_change:Fire(color)
end

do
    local has_property = util.has_property

    function window:open()
        self.screen_gui.Enabled = true
        self.opened = true
        local descendants = self.screen_gui:GetDescendants()
        util:tween(self.line, twinfo(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(1, -298, 1, 1), Size = udim2new(0.5, 0, 0, 1)})
        util:tween(self.tab_holder, twinfo(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(0,0,0,0)})
        for i = 1, #descendants do
            local descendant = descendants[i]
            local parent = descendant.Parent
            local parent_parent = parent.Parent
            if (parent and has_property(parent, "Visible")) then if not parent.Visible then continue end end
            if (parent_parent and has_property(parent_parent, "Visible")) then if not parent_parent.Visible then continue end end
            if (parent_parent_parent and has_property(parent_parent_parent, "Visible")) then if not parent_parent_parent.Visible then continue end end
            if descendant.ClassName == "Frame" then
                if descendant.BackgroundColor3 == colorfromrgb(255,255,255) or (string.sub(descendant.Name, 1, 1) == "t" and not descendant.Name:find(self.active_tab)) then continue end
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = (descendant.BackgroundColor3 == colorfromrgb(1,1,1) and 0.5 or 0)})
            elseif descendant.ClassName == "TextLabel" then
                if descendant.BackgroundColor3 == colorfromrgb(254,254,254) then continue end
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
            elseif descendant.ClassName == "ImageLabel" then
                if descendant.BackgroundColor3 == colorfromrgb(254,254,254) then continue end
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
                if descendant.ZIndex == 16 then
                    util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
                end
            elseif descendant.ClassName == "TextBox" then
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
            elseif descendant.ClassName == "ScrollingFrame" then
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarImageTransparency = 0})
            end
        end
    end

    function window:close()
        local descendants = self.screen_gui:GetDescendants()
        util:tween(self.line, twinfo(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(1, 0, 1, 1), Size = udim2new(0, 0, 0, 1)})
        util:tween(self.tab_holder, twinfo(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(-1,0,0,0)})
        for i = 1, #descendants do
            local descendant = descendants[i]
            local parent = descendant.Parent
            local parent_parent = parent.Parent
            local parent_parent_parent = parent.Parent.Parent
            if (parent and has_property(parent, "Visible")) then if not parent.Visible then continue end end
            if (parent_parent and has_property(parent_parent, "Visible")) then if not parent_parent.Visible then continue end end
            if (parent_parent_parent and has_property(parent_parent_parent, "Visible")) then if not parent_parent_parent.Visible then continue end end
            if descendant.ClassName == "Frame" then
                if descendant.BackgroundColor3 == colorfromrgb(255,255,255) then continue end
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
            elseif descendant.ClassName == "TextLabel" then
                if descendant.BackgroundColor3 == colorfromrgb(254,254,254) then continue end
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
            elseif descendant.ClassName == "ImageLabel" then
                if descendant.BackgroundColor3 == colorfromrgb(254,254,254) then continue end
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
                if descendant.ZIndex == 16 then
                    util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                end
            elseif descendant.ClassName == "TextBox" then
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
            elseif descendant.ClassName == "ScrollingFrame" then
                util:tween(descendant, twinfo(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarImageTransparency = 1})
            end
        end
        task.delay(0.24, function()
            if self.screen_gui:FindFirstChildOfClass("Frame").BackgroundTransparency > 0.99 then
                self.on_close:Fire()
                self.screen_gui.Enabled = false
                self.opened = false
            end
        end)
    end
end

function window:new_tab(text)
    local TabButton = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        BackgroundTransparency = 1;
        Position = udim2new(0, 106, 0, 1);
        Size = udim2new(0, util:get_text_size(text) + 20, 0, 19);
        Parent = self.tab_holder
    }); TabName = "t-"..text
    local TabLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(11, 11, 11);
        BorderColor3 = colorfromrgb(32, 32, 32);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 1, -2);
        ZIndex = 2;
        Font = Enum.Font.RobotoMono;
        Text = text;
        TextColor3 = lib.accent_color;
        TextSize = 12.000;
        BackgroundTransparency = 1;
        Parent = TabButton
    })
    local UICorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 6);
        Parent = TabButton
    })
    local ButtonFix = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(11, 11, 11);
        BorderColor3 = colorfromrgb(32, 32, 32);
        Position = udim2new(0, 1, 0, 9);
        Size = udim2new(1, -2, 0, 10);
        Visible = false;
        Parent = TabButton
    })
    local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, lib.accent_color), ColorSequenceKeypoint.new(0.10, lib.accent_color), ColorSequenceKeypoint.new(0.20, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(1.00, colorfromrgb(32, 32, 32))};
        Rotation = 90;
        Offset = vect2(0,-0.19);
        Parent = TabButton
    })
    local UICorner_2 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 6);
        Parent = TabLabel
    })
    local ButtonFix2 = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(11, 11, 11);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 1, 0);
        Size = udim2new(1, -2, 0, 1);
        Visible = false;
        Parent = TabButton
    })
    local TabFrame = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 12, 0, 34);
        Size = udim2new(1, -24, 0, 360);
        Parent = self.main;
        Visible = false
    })
    local SubtabHolder = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(8, 8, 8);
        BorderColor3 = colorfromrgb(32, 32, 32);
        Size = udim2new(0, 116, 0, 360);
        Parent = TabFrame
    })
    local SubtabInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 6, 0, 6);
        Size = udim2new(1, -12, 1, -12);
        Parent = SubtabHolder
    })
    local UIListLayout = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = udimnew(0, 3);
        Parent = SubtabInside
    })

    local new_tab = {
        tab_button = TabButton,
        gradient = UIGradient,
        fix1 = ButtonFix,
        fix2 = ButtonFix2,
        label = TabLabel,
        name = text,
        frame = TabFrame,
        holder = SubtabInside,
        subtabs = {},
        active_subtab = nil,
        lib = self
    }

    local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
        if self.active_tab == text then
            TabLabel.TextColor3 = color
            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, color), ColorSequenceKeypoint.new(0.10, lib.accent_color), ColorSequenceKeypoint.new(0.20, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(1.00, colorfromrgb(32, 32, 32))};
        end
    end)

    local on_click = util:create_connection(TabButton.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Touch and self.active_tab ~= text then
            TabLabel.TextColor3 = colorfromrgb(74,74,74)
        end
    end)

    local on_click = util:create_connection(TabButton.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            self:set_tab(text)
        end
    end)

    local on_hover = util:create_connection(TabButton.MouseEnter, function(input)
        if self.active_tab ~= text then
            TabLabel.TextColor3 = colorfromrgb(126,126,126)
        end
    end)

    local on_hover = util:create_connection(TabButton.MouseLeave, function(input)
        if self.active_tab ~= text then
            TabLabel.TextColor3 = colorfromrgb(74,74,74)
        end
    end)

    setmetatable(new_tab, tab); table.insert(self.tabs, new_tab)

    if #self.tabs == 1 then new_tab:set_active(); self.active_tab = text else new_tab:set_not_active() end

    return new_tab
end

function tab:set_active()
    local button = self.tab_button
    local fix1 = self.fix1
    local fix2 = self.fix2
    local gradient = self.gradient
    local label = self.label
    local frame = self.frame

    button.BackgroundTransparency = 0
    label.BackgroundTransparency = 0
    label.TextColor3 = lib.accent_color
    fix1.Visible = true
    fix2.Visible = true
    frame.Visible = true
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, lib.accent_color), ColorSequenceKeypoint.new(0.10, lib.accent_color), ColorSequenceKeypoint.new(0.20, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(1.00, colorfromrgb(32, 32, 32))};
    util:tween(gradient, twinfo(0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Offset = vect2(0,0)})
end

function tab:set_not_active()
    local button = self.tab_button
    local fix1 = self.fix1
    local fix2 = self.fix2
    local gradient = self.gradient
    local label = self.label
    local frame = self.frame

    button.BackgroundTransparency = 1
    label.BackgroundTransparency = 1
    label.TextColor3 = colorfromrgb(74,74,74)
    fix1.Visible = false
    fix2.Visible = false
    frame.Visible = false
    util:tween(gradient, twinfo(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Offset = vect2(0,-0.19)})
end

function tab:set_subtab(name)
    self.active_subtab = name
    for _, v in pairs(self.subtabs) do
        if v.name == name then v:set_active() else v:set_not_active() end
    end 
end

function tab:new_subtab(text)
    local SubtabButton = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(254, 254, 254);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Size = udim2new(1, 0, 0, 18);
        Parent = self.holder
    })
    local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(17, 17, 17)), ColorSequenceKeypoint.new(1.00, colorfromrgb(9, 9, 9))};
        Parent = SubtabButton
    })
    local ButtonLine = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = lib.accent_color;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Size = udim2new(0, 1, 1, 0);
        Parent = SubtabButton
    })
    local ButtonLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 8, 0, 0);
        Size = udim2new(1, -8, 1, 0);
        Font = Enum.Font.RobotoMono;
        Text = text;
        TextColor3 = lib.accent_color;
        TextSize = 12.000;
        TextXAlignment = Enum.TextXAlignment.Left;
        Parent = SubtabButton
    })
    local Left = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(32, 32, 32);
        BorderSizePixel = 0;
        Position = udim2new(0, 127, 0, 0);
        Size = udim2new(0, 217, 0, 360);
        Visible = false;
        Parent = self.frame;
    })
    local UIListLayout = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = udimnew(0, 10);
        Parent = Left
    })
    local Right = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(32, 32, 32);
        BorderSizePixel = 0;
        Position = udim2new(1, -217, 0, 0);
        Size = udim2new(0, 217, 0, 360);
        Visible = false;
        Parent = self.frame
    })
    local UIListLayout_4 = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = udimnew(0, 10);
        Parent = Right
    })

    local on_click = util:create_connection(SubtabButton.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            self:set_subtab(text)
        end
    end)

    local on_hover = util:create_connection(SubtabButton.MouseEnter, function(input)
        if self.active_subtab ~= text then
            ButtonLabel.TextColor3 = colorfromrgb(126,126,126)
        end
    end)

    local on_hover = util:create_connection(SubtabButton.MouseLeave, function(input)
        if self.active_subtab ~= text then
            ButtonLabel.TextColor3 = colorfromrgb(74,74,74)
        end
    end)

    local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
        if self.active_subtab == text then
            ButtonLabel.TextColor3 = color
            ButtonLine.BackgroundColor3 = color
        else
            local h,s,v = color:ToHSV()
            ButtonLine.BackgroundColor3 = Color3.fromHSV(h,s,v*.5)
        end
    end)

    local new_subtab = {
        line = ButtonLine,
        label = ButtonLabel,
        name = text,
        whole = SubtabButton,
        left = Left,
        right = Right,
        lib = self.lib
    }

    setmetatable(new_subtab, subtab); table.insert(self.subtabs, new_subtab)

    if #self.subtabs == 1 then new_subtab:set_active(); self.active_subtab = text else new_subtab:set_not_active() end

    return new_subtab
end

function subtab:set_not_active()
    local h,s,v = lib.accent_color:ToHSV()
    local line, label = self.line, self.label
    line.BackgroundColor3 = Color3.fromHSV(h,s,v*.5)
    label.TextColor3 = colorfromrgb(74,74,74)
    self.right.Visible = false
    self.left.Visible = false
end

function subtab:set_active()
    local line, label = self.line, self.label
    line.BackgroundColor3 = lib.accent_color
    label.TextColor3 = lib.accent_color
    self.right.Visible = true
    self.left.Visible = true
end

function subtab:new_section(info)
    local name, side, size = info.name, info.side, info.size

    local SectionFrame = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(8, 8, 8);
        BorderColor3 = colorfromrgb(32, 32, 32);
        Size = udim2new(0, 217, 0, 38);
        Parent = info.side:lower() == "left" and self.left or self.right
    })
    local SectionTop = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(254, 254, 254);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Size = udim2new(1, 0, 0, 21);
        Parent = SectionFrame
    })
    local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(16, 16, 16)), ColorSequenceKeypoint.new(1.00, colorfromrgb(8, 8, 8))};
        Rotation = 90;
        Parent = SectionTop
    })
    local SectionLine = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(254, 254, 254);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 1, 0);
        Size = udim2new(1, -2, 0, 1);
        Parent = SectionTop
    })
    local UIGradient_2 = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(0.15, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(0.35, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(0.50, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(0.65, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(0.85, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(1.00, colorfromrgb(32, 32, 32))};
        Parent = SectionLine
    })
    local SectionLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 5, 0, 0);
        Size = udim2new(1, -5, 1, 0);
        Font = Enum.Font.RobotoMono;
        Text = name;
        TextColor3 = colorfromrgb(74, 74, 74);
        TextSize = 12.000;
        TextXAlignment = Enum.TextXAlignment.Left;
        Parent = SectionTop
    })
    local SectionHolder = -- Converted: Use UI Library's Instance creation functions("ScrollingFrame", {
        Active = false;
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 22);
        Size = udim2new(1, -2, 1, -22);
        BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
        ScrollBarImageColor3 = colorfromrgb(56,56,56);
        CanvasSize = udim2new(0, 0, 1, -22);
        ScrollBarThickness = 0;
        ScrollingEnabled = false;
        TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
        Parent = SectionFrame
    })
    local SectionList = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 14, 0, 8);
        Size = udim2new(1, -28, 1, -16);
        Parent = SectionHolder
    })
    local UIListLayout = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = udimnew(0, 9);
        Parent = SectionList
    })

    local new_section = {
        scroller = SectionHolder,
        frame = SectionFrame,
        elements = 0,
        max_size = size,
        holder = SectionList,
        element_holder = {},
        lib = self.lib
    }

    local on_hover = util:create_connection(SectionFrame.MouseEnter, function() 
        if SectionHolder.ScrollingEnabled == true then
            util:tween(SectionHolder, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarThickness = 4})
        end
    end)

    local on_leave = util:create_connection(SectionFrame.MouseLeave, function() 
        if SectionHolder.ScrollingEnabled == true then
            util:tween(SectionHolder, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarThickness = 0})
        end
    end)

    setmetatable(new_section, section)

    return new_section
end

function section:update_size(size2, scroll)
    local frame = (self.frame.Size.Y.Offset >= self.max_size) and self.scroller or self.frame
    if frame.ClassName == "ScrollingFrame" then
        local size = frame.CanvasSize
        frame.ScrollingEnabled = true
        frame.CanvasSize = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + size2)
    elseif frame.ClassName == "Frame" then
        self.scroller.ScrollingEnabled = false
        local size = frame.Size
        if frame.Size.Y.Offset + size2 >= self.max_size then
            local leftover = frame.Size.Y.Offset + size2 - self.max_size
            frame.Size = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, self.max_size)

            local frame = self.scroller
            local size = frame.CanvasSize
            frame.ScrollingEnabled = true
            frame.CanvasSize = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + leftover)
        else
            frame.Size = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + size2)
        end
    end 
end

function section:remove(size, scroll)
    for _, element in pairs(self.element_holder) do
        element:remove()
    end
    self.frame:Destroy()
end

function section:new_element(info)
    local name, flag, types, tooltip = info.name, info.flag or "", info.types or {}, info.tip

    local ElementFrame = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Size = udim2new(1, 0, 0, 8);
        Parent = self.holder
    })
    local ElementLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 12, 0, 0);
        Size = udim2new(0, util:get_text_size(name) + 4, 0, 7);
        Font = Enum.Font.RobotoMono;
        Text = name;
        TextColor3 = colorfromrgb(74, 74, 74);
        TextSize = 12.000;
        TextWrapped = true;
        TextXAlignment = Enum.TextXAlignment.Left;
        Parent = ElementFrame
    })
    local AddonHolder = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(1, -30, 0, 0);
        Size = udim2new(0, 30, 0, 8);
        Parent = ElementFrame
    })
    local UIListLayout = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal;
        HorizontalAlignment = Enum.HorizontalAlignment.Right;
        SortOrder = Enum.SortOrder.LayoutOrder;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        Padding = udimnew(0, 5);
        Parent = AddonHolder
    })

    local new_element = {
        frame = ElementFrame,
        total_size = self.elements == 0 and 8 or 17,
        section = self,
        flag = flag,
        keybinds = 0,
        colorpickers = 0
    }

    if tooltip then
        local on_hover = util:create_connection(ElementLabel.MouseEnter, function()
            if lib.busy then return end
            local image, tip_label, label = self.lib.tip, self.lib.tip:GetChildren()[1], self.lib.build_label
            util:tween(image, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
            util:tween(tip_label, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
            util:tween(label, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
            tip_label.Text = info.tip
        end)

        local on_leave = util:create_connection(ElementLabel.MouseLeave, function()
            if lib.busy then return end
            local image, tip_label, label = self.lib.tip, self.lib.tip:GetChildren()[1], self.lib.build_label
            util:tween(image, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
            util:tween(tip_label, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
            util:tween(label, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
        end)
    end

    lib.flags[flag] = {}

    for element, info in pairs(types) do
        if element == "toggle" then 
            local no_load = info.no_load or false
            local on_toggle = info.on_toggle or function() end
            local default = info.default and info.default or false
            local no_touch = info.no_touch or false

            local ToggleBox = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(32, 32, 32);
                BorderColor3 = colorfromrgb(0, 0, 0);
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(0, 6, 0, 6);
                Parent = ElementFrame
            })
            local ToggleInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = lib.accent_color;
                BackgroundTransparency = 1;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Visible = false;
                Size = udim2new(0, 6, 0, 6);
                Parent = ToggleBox
            })
            local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(195, 195, 195))};
                Rotation = 90;
                Parent = ToggleInside
            })

            new_element.on_toggle = -- Converted: Generic Event/Signal Initialization("on_toggle")

            local on_hover = util:create_connection(ToggleBox.MouseEnter, function()
                if lib.busy then return end
                if lib.flags[flag]["toggle"] then return end
                ElementLabel.TextColor3 = colorfromrgb(126, 126, 126)
                ToggleInside.BackgroundTransparency = 0.5
                ToggleInside.Visible = true
            end)

            local on_hover = util:create_connection(ElementLabel.MouseEnter, function()
                if lib.busy then return end
                if lib.flags[flag]["toggle"] then return end
                ElementLabel.TextColor3 = colorfromrgb(126, 126, 126)
                ToggleInside.BackgroundTransparency = 0.5
                ToggleInside.Visible = true
            end)

            local on_leave = util:create_connection(ToggleBox.MouseLeave, function()
                if lib.busy then return end
                if lib.flags[flag]["toggle"] then return end
                ElementLabel.TextColor3 = colorfromrgb(74, 74, 74)
                ToggleInside.BackgroundTransparency = 1
                ToggleInside.Visible = false
            end)

            local on_leave = util:create_connection(ElementLabel.MouseLeave, function()
                if lib.busy then return end
                if lib.flags[flag]["toggle"] then return end
                ElementLabel.TextColor3 = colorfromrgb(74, 74, 74)
                ToggleInside.BackgroundTransparency = 1
                ToggleInside.Visible = false
            end)

            function new_element:set_toggle(toggle, callback)
                local is_in_toggle = util:is_in_frame(ElementLabel) or util:is_in_frame(ToggleBox)
                ElementLabel.TextColor3 = not toggle and (not is_in_toggle and colorfromrgb(74, 74, 74) or colorfromrgb(126, 126, 126)) or colorfromrgb(221,221,221)
                ToggleInside.BackgroundTransparency = not toggle and (not is_in_toggle and 1 or 0.5) or 0
                ToggleInside.Visible = not toggle and (not is_in_toggle and false or true) or true

                lib.flags[flag]["toggle"] = toggle

                if not callback then
                    new_element.on_toggle:Fire(toggle)
                end
            end

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                ToggleInside.BackgroundColor3 = color
            end)

            local on_click = util:create_connection(ToggleBox.InputEnded, function(input)
                if lib.busy then return end
                if input.UserInputType == Enum.UserInputType.Touch and not no_touch then
                    local toggle = not lib.flags[flag]["toggle"]; lib.flags[flag]["toggle"] = toggle
                    new_element:set_toggle(toggle)
                end
            end)

            local on_click = util:create_connection(ElementLabel.InputEnded, function(input)
                if lib.busy then return end
                if input.UserInputType == Enum.UserInputType.Touch and not no_touch then
                    local toggle = not lib.flags[flag]["toggle"]; lib.flags[flag]["toggle"] = toggle
                    new_element:set_toggle(toggle)
                end
            end)

            local on_window_close = util:create_connection(self.lib.on_close, function()
                if lib.flags[flag]["toggle"] then return end
                ElementLabel.TextColor3 = colorfromrgb(74, 74, 74)
                ToggleInside.BackgroundTransparency = 1
                ToggleInside.Visible = false
            end)

            lib.flags[flag]["toggle"] = false

            if default and not info.no_load then new_element:set_toggle(default) end

            util:create_connection(lib.on_config_load, function()
                if not info.no_load then
                    new_element:set_toggle(lib.flags[flag]["toggle"])
                end
            end)
        elseif element == "keybind" then
            new_element.keybinds+=1

            local AddonImage = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = udim2new(0, 9, 0, 9);
                Image = "rbxassetid://14138205253";
                ImageColor3 = colorfromrgb(74, 74, 74);
                ZIndex = 100;
                Parent = AddonHolder
            })
            local KeybindOpen = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 0, 0, 0);
                Size = udim2new(0, 163, 0, 19);
                Parent = self.lib.screen_gui;
                ZIndex = 15;
                Visible = false
            })
            local UICorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = KeybindOpen
            })
            local OpenInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(32, 32, 32);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                ZIndex = 15;
                Parent = KeybindOpen
            })
            local UICorner_2 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = OpenInside
            })
            local OpenLabel = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                ZIndex = 15;
                Parent = OpenInside
            })
            local UICorner_3 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = OpenLabel
            })
            local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(16, 16, 16)), ColorSequenceKeypoint.new(1.00, colorfromrgb(8, 8, 8))};
                Rotation = 90;
                Parent = OpenLabel
            })
            local OpenText = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Font = Enum.Font.RobotoMono;
                Text = "keybind: unbound";
                TextColor3 = colorfromrgb(74, 74, 74);
                TextSize = 12.000;
                TextXAlignment = Enum.TextXAlignment.Right;
                ZIndex = 15;
                RichText = true;
                Parent = OpenLabel
            }); local on_size_change = util:create_connection(OpenText:GetPropertyChangedSignal("Size"), function()
                local size = OpenText.Size.X.Offset
                OpenText.Position = udim2new(1, -size, 0, 0)
            end); OpenText.Size = udim2new(0, util:get_text_size("keybind: unbound"), 1, 0);
            local OpenMethod = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0.065750733, 0, 0.0604938269, 0);
                Size = udim2new(0, 65, 0, 60);
                ZIndex = 16;
                Visible = false;
                Parent = self.lib.screen_gui
            })
            local UICorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = OpenMethod
            })
            local MethodInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(16, 16, 16);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                ZIndex = 16;
                Parent = OpenMethod
            })
            local UICorner_2 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = MethodInside
            })
            local UIListLayout = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = MethodInside
            })
            local HoldLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                BackgroundColor3 = colorfromrgb(27, 27, 27);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = udim2new(1, 0, 0, 19);
                Font = Enum.Font.RobotoMono;
                Text = " hold";
                TextColor3 = lib.accent_color;
                TextSize = 12.000;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 16;
                Parent = MethodInside
            })
            local ToggleLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                BackgroundColor3 = colorfromrgb(27, 27, 27);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = udim2new(1, 0, 0, 20);
                Font = Enum.Font.RobotoMono;
                Text = " toggle";
                TextColor3 = colorfromrgb(126, 126, 126);
                TextSize = 12.000;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 16;
                Parent = MethodInside
            })
            local AlwaysLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                BackgroundColor3 = colorfromrgb(27, 27, 27);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = udim2new(1, 0, 0, 19);
                Font = Enum.Font.RobotoMono;
                Text = " always";
                TextColor3 = colorfromrgb(126, 126, 126);
                TextSize = 12.000;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 16;
                Parent = MethodInside
            })

            local is_open, binding, is_choosing_method = false, false, false
            local addon_cover = self.lib.addon_cover

            local on_enter_alt = util:create_connection(OpenText.MouseEnter, function()
                OpenText.TextColor3 = colorfromrgb(126,126,126)
            end)

            local on_leave_alt = util:create_connection(OpenText.MouseLeave, function()
                if binding then return end
                OpenText.TextColor3 = colorfromrgb(74,74,74)
            end)

            lib.flags[flag]["bind"] = {
                ["key"] = "unbound",
                ["method"] = "hold",
                ["active"] = false
            }

            local method = info.method and info.method or "hold"
            local key = info.key and info.key or "unbound"

            local function start_binding()
                binding = true
                OpenText.Text = "keybind: <font color=\"rgb(189, 172, 255)\">"..string.sub(OpenText.Text, 10, #OpenText.Text).."</font>";
            end

            new_element.on_key_change = -- Converted: Generic Event/Signal Initialization("on_key_change")
            new_element.on_method_change = -- Converted: Generic Event/Signal Initialization("on_method_change")
            new_element.callback = -- Converted: Generic Event/Signal Initialization("on_key_press");

            local function stop_binding()
                binding = false
                if not util:is_in_frame(OpenText) then
                    OpenText.TextColor3 = colorfromrgb(74,74,74)
                end
            end

            local function set_key(key2)
                lib.flags[flag]["bind"]["key"] = key2
                key = key2
                OpenText.Text = "keybind: "..lib.flags[flag]["bind"]["key"]
                OpenText.Size = udim2new(0, util:get_text_size(OpenText.Text), 1, 0);
                new_element.on_key_change:Fire(key2)
            end

            local function open_method()
                if info.method_lock then return end
                is_choosing_method = true
                OpenMethod.Visible = true
                OpenMethod.Position = udim2new(0, mouse.X, 0, mouse.Y)
            end

            local function close_method()
                is_choosing_method = false
                OpenMethod.Visible = false
            end

            local function set_method(method2) 
                local label = (method2 == "always" and AlwaysLabel) or (method2 == "toggle" and ToggleLabel) or (method2 == "hold" and HoldLabel)
                local children = MethodInside:GetChildren()
                for i = 1, #children do
                    local child = children[i]
                    if child.ClassName == "TextLabel" then
                        child.TextColor3 = colorfromrgb(126,126,126)
                    end
                end
                label.TextColor3 = lib.accent_color
                lib.flags[flag]["bind"]["method"] = method2
                new_element.on_method_change:Fire(method2)
                method = method2
                if method2 == "always" then
                    if lib.flags[flag]["toggle"] ~= nil then
                        if not lib.flags[flag]["toggle"] then return end
                    end
                    new_element.on_activate:Fire()
                end
            end

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                local method2 = lib.flags[flag]["bind"]["method"]
                local label = (method2 == "always" and AlwaysLabel) or (method2 == "toggle" and ToggleLabel) or (method2 == "hold" and HoldLabel)
                label.TextColor3 = color
            end)

            local children = MethodInside:GetChildren()

            for i = 1, #children do
                local child = children[i]
                if child.ClassName == "TextLabel" then
                    local on_enter = util:create_connection(child.MouseEnter, function()
                        child.BackgroundTransparency = 0
                    end)

                    local on_leave = util:create_connection(child.MouseLeave, function()
                        child.BackgroundTransparency = 1
                    end)

                    local on_click = util:create_connection(child.InputBegan, function(input, gpe)
                        if gpe then return end
                        if input.UserInputType == Enum.UserInputType.Touch then
                            set_method(string.sub(child.Text, 2, #child.text))
                        end 
                    end)
                end
            end

            util:create_connection(self.lib.on_close, function()
                if is_open then
                    close_keybind()
                    addon_cover.Visible = false
                end
            end)

            local function close_keybind()
                is_open = false
                KeybindOpen.Visible = false
                OpenText.TextColor3 = colorfromrgb(74,74,74)
                util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                task.delay(0.3, function()
                    if addon_cover.BackgroundTransparency > 0.99 then
                        addon_cover.Visible = false
                    end
                end)
                AddonImage.ImageColor3 = colorfromrgb(74,74,74)
                if binding then stop_binding() end
                if is_choosing_method then close_method() end
                task.delay(0.03, function()
                    lib.busy = false; 
                end)
            end

            local function open_keybind()
                lib.busy = true; is_open = true
                KeybindOpen.Visible = true
                AddonImage.ImageColor3 = colorfromrgb(255,255,255)
                addon_cover.Visible = true
                addon_cover.BackgroundTransparency = 1
                util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})

                local absPos = AddonImage.AbsolutePosition
                KeybindOpen.Position = udim2new(0, absPos.X - 5, 0, absPos.Y - 5)
            end

            local on_hover = util:create_connection(AddonImage.MouseEnter, function()
                if is_open or lib.busy then return end
                AddonImage.ImageColor3 = colorfromrgb(126,126,126)
            end)

            local on_leave = util:create_connection(AddonImage.MouseLeave, function()
                if is_open or lib.busy then return end
                AddonImage.ImageColor3 = colorfromrgb(74,74,74)
            end)

            local on_mouse1alt = util:create_connection(OpenText.InputEnded, function(input, gpe)
                if binding then return end
                if input.UserInputType == Enum.UserInputType.Touch then
                    task.delay(0.01, start_binding)
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    if not is_choosing_method then
                        open_method()
                    end
                end
            end)

            local on_mouse1 = util:create_connection(AddonImage.InputBegan, function(input, gpe)
                if lib.busy or gpe then return end
                if input.UserInputType == Enum.UserInputType.Touch then
                    if not lib.busy then AddonImage.ImageColor3 = colorfromrgb(255,255,255) end
                end
            end)

            local on_mouse1end = util:create_connection(AddonImage.InputEnded, function(input, gpe)
                if lib.busy or gpe then return end
                if input.UserInputType == Enum.UserInputType.Touch then
                    if not lib.busy then open_keybind() end
                end
            end)

            local on_window_close = util:create_connection(self.lib.on_close, function()
                addon_cover.Visible = false
                if is_open then close_keybind() end
            end)

            local on_input = util:create_connection(uis.InputEnded, function(input, gpe)
                if input.UserInputType == Enum.UserInputType.Touch and is_choosing_method then
                    task.delay(0.01, close_method)
                end
                if input.UserInputType == Enum.UserInputType.Touch and is_open and not util:is_in_frame(AddonImage) and not util:is_in_frame(KeybindOpen) then
                    if is_choosing_method and util:is_in_frame(OpenMethod) then
                    else
                        close_keybind()
                    end
                elseif binding then
                    local inputType = input.UserInputType
                    local key = (inputType == Enum.UserInputType.MouseButton2 and "mouse 2") or (inputType == Enum.UserInputType.Touch and "mouse 1") or (inputType == Enum.UserInputType.MouseButton3 and "mouse 3") or (input.KeyCode.Name == "Unknown" and "unbound") or (input.KeyCode.Name == "Escape" and "unbound")
                    set_key(key and key or lower(input.KeyCode.Name))
                    stop_binding()
                end
            end)

            new_element.on_deactivate = -- Converted: Generic Event/Signal Initialization("on_deactivate")
            new_element.on_activate = -- Converted: Generic Event/Signal Initialization("on_activate")

            local active = false

            function new_element:is_active()
                return method == "always" and true or active
            end

            local on_key_press = util:create_connection(uis.InputBegan, function(input, gpe)
                if gpe or method == "always" then return end
                if lower(input.KeyCode.Name) == key then
                    new_element.callback:Fire();                    
                    if lib.flags[flag]["toggle"] ~= nil then
                        if not lib.flags[flag]["toggle"] then return end
                    end
                    active = method == "hold" and true or method == "toggle" and not active
                    if active then 
                        lib.flags[flag]["bind"]["active"] = true;
                        new_element.on_activate:Fire()
                    else 
                        new_element.on_deactivate:Fire()
                        lib.flags[flag]["bind"]["active"] = false
                    end
                elseif string.find(key, "mouse") then
                    if lib.flags[flag]["toggle"] ~= nil then
                        if not lib.flags[flag]["toggle"] then return end
                    end
                    if input.UserInputType == Enum.UserInputType.MouseButton2 and key == "mouse 2" then
                        active = method == "hold" and true or method == "toggle" and not active
                        if active then 
                            lib.flags[flag]["bind"]["active"] = true;
                            new_element.on_activate:Fire() 
                        else 
                            new_element.on_deactivate:Fire()
                            lib.flags[flag]["bind"]["active"] = false
                        end                        
                    elseif input.UserInputType == Enum.UserInputType.MouseButton3 and key == "mouse 3" then
                        active = method == "hold" and true or method == "toggle" and not active
                        if active then 
                            lib.flags[flag]["bind"]["active"] = true;
                            new_element.on_activate:Fire() 
                        else 
                            new_element.on_deactivate:Fire()
                            lib.flags[flag]["bind"]["active"] = false
                        end                    elseif input.UserInputType == Enum.UserInputType.Touch and key == "mouse 1" then
                        active = method == "hold" and true or method == "toggle" and not active
                        if active then 
                            lib.flags[flag]["bind"]["active"] = true;
                            new_element.on_activate:Fire() 
                        else 
                            new_element.on_deactivate:Fire()
                            lib.flags[flag]["bind"]["active"] = false
                        end                    
                    end
                end
            end)

            local on_key_stopped = util:create_connection(uis.InputEnded, function(input, gpe)
                if gpe or method == "always" then return end
                if lower(input.KeyCode.Name) == key and method == "hold" then
                    if lib.flags[flag]["toggle"] ~= nil then
                        if not lib.flags[flag]["toggle"] then return end
                    end
                    active = false
                    new_element.on_deactivate:Fire()
                elseif string.find(key, "mouse") then
                    if lib.flags[flag]["toggle"] ~= nil then
                        if not lib.flags[flag]["toggle"] then return end
                    end
                    if input.UserInputType == Enum.UserInputType.MouseButton2 and key == "mouse 2" then
                        active = false
                        new_element.on_deactivate:Fire()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton3 and key == "mouse 3" then
                        active = false
                        new_element.on_deactivate:Fire()
                    elseif input.UserInputType == Enum.UserInputType.Touch and key == "mouse 1" then
                        active = false
                        new_element.on_deactivate:Fire()
                    end
                end
            end)

            set_key(info.key and info.key or "unbound")
            set_method(info.method and info.method or "hold")

            util:create_connection(lib.on_config_load, function()
                set_key(lib.flags[flag]["bind"]["key"])
                set_method(lib.flags[flag]["bind"]["method"])
            end)
        elseif element == "slider" then
            new_element.total_size+=13
            local SliderBackground = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(32, 32, 32);
                BorderColor3 = colorfromrgb(0, 0, 0);
                Position = udim2new(0, 12, 0, 15);
                Size = udim2new(1, -24, 0, 6);
                Parent = ElementFrame
            })
            local SliderFill = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = lib.accent_color;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = udim2new(1, 0, 1, 0);
                Parent = SliderBackground
            })
            local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(195, 195, 195))};
                Rotation = 90;
                Parent = SliderFill
            })
            local SliderText = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(1, -12, 0, 0);
                Size = udim2new(0, 0, 0, 7);
                Font = Enum.Font.RobotoMono;
                Text = "100%";
                TextColor3 = colorfromrgb(74, 74, 74);
                TextSize = 12.000;
                TextXAlignment = Enum.TextXAlignment.Right;
                Parent = ElementFrame
            })

            local min, max, default, decimal, on_value_change, suffix, prefix = info.min, info.max, info.default, info.decimal or info.decimals, info.on_value_change or function() end, info.suffix or "", info.prefix or ""
            local dragging = false

            new_element.on_value_change = -- Converted: Generic Event/Signal Initialization("on_value_change")

            lib.flags[flag]["value"] = min

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                SliderFill.BackgroundColor3 = color
            end)

            function new_element:set_value(value, do_callback)
                local value = clamp(value, min, max)
                SliderFill.Size = udim2new((value - min)/(max-min), 0, 1, 0)
                SliderText.Text = prefix..value..suffix
                lib.flags[flag]["value"] = value
                if value > min and (lib.flags[flag]["toggle"] ~= nil and lib.flags[flag]["toggle"] or true) then
                    ElementLabel.TextColor3 = colorfromrgb(221,221,221)
                else
                    ElementLabel.TextColor3 = util:is_in_frame(SliderBackground) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
                end
                new_element.on_value_change:Fire(value)
            end

            local on_input_began = util:create_connection(SliderBackground.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Touch and not lib.busy then
                    lib.busy = true
                    local distance = clamp((mouse.X - SliderBackground.AbsolutePosition.X)/SliderBackground.AbsoluteSize.X, 0, 1)
                    local value = util:round(min + (max - min) * distance, decimal and decimal or 0)
                    new_element:set_value(value, true)

                    dragging = true
                end
            end)

            local on_input_end = util:create_connection(SliderBackground.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.Touch and dragging then
                    lib.busy = false
                    dragging = false
                end
            end)

                dragging = false
            end)--]]

            local on_mouse_move = util:create_connection(mouse.Move, function()
                if dragging then
                    local distance = clamp((mouse.X - SliderBackground.AbsolutePosition.X)/SliderBackground.AbsoluteSize.X, 0, 1)
                    local value = util:round(min + (max-min) * distance, decimal and decimal or 0)
                    new_element:set_value(value, true)
                end
            end)

            local on_enter = util:create_connection(SliderBackground.MouseEnter, function()
                if lib.busy then return end
                if lib.flags[flag]["value"] == min and (lib.flags[flag]["toggle"] ~= nil and lib.flags[flag]["toggle"] or true) then
                    ElementLabel.TextColor3 = colorfromrgb(126,126,126)
                end
            end)

            local on_leave = util:create_connection(SliderBackground.MouseLeave, function()
                if lib.busy then return end
                if lib.flags[flag]["value"] == min and (lib.flags[flag]["toggle"] ~= nil and lib.flags[flag]["toggle"] or true) then
                    ElementLabel.TextColor3 = colorfromrgb(74,74,74)
                end
            end)

            new_element:set_value(default and default or min)

            util:create_connection(lib.on_config_load, function()
                new_element:set_value(lib.flags[flag]["value"])
            end)
        elseif element == "dropdown" then
            new_element.total_size+=24

            local DropdownBorder = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 12, 0, 12);
                Size = udim2new(1, -24, 0, 20);
                Parent = ElementFrame
            })
            local DropdownBackground = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                Parent = DropdownBorder
            })
            local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(23, 23, 23)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
                Rotation = 90;
                Parent = DropdownBackground
            })
            local DropdownImage = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(1, -13, 0.5, -4);
                Size = udim2new(0, 8, 0, 8);
                Image = "http://www.roblox.com/asset/?id=14138109916";
                ImageColor3 = colorfromrgb(74, 74, 74);
                Parent = DropdownBackground
            })
            local DropdownText = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 5, 0, 0);
                Size = udim2new(1, -23, 1, 0);
                Font = Enum.Font.RobotoMono;
                Text = "-";
                TextColor3 = colorfromrgb(74, 74, 74);
                TextSize = 12.000;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextWrapped = true;
                ClipsDescendants = true;
                Parent = DropdownBackground
            })
            local OpenDropdown = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 440, 0, 54);
                Size = udim2new(0, 163, 0, 60);
                Parent = self.lib.screen_gui
            }); OpenDropdown.Visible = false
            local OpenInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(16, 16, 16);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                ClipsDescendants = true;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                Parent = OpenDropdown
            })
            local UIListLayout = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = OpenInside
            })

            local is_open = false

            lib.flags[flag]["selected"] = {}

            local options = info.options and info.options or {}
            local default = info.default and info.default or {}
            local multi = info.multi and info.multi or false
            local no_none = info.no_none and info.no_none or false

            new_element.on_option_change = -- Converted: Generic Event/Signal Initialization("on_option_change")

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                local options = lib.flags[flag]["selected"]
                for i,v in pairs(OpenInside:GetChildren()) do
                    if v.ClassName == "TextLabel" then
                        if util:find(options, v.Name) then 
                            v.TextColor3 = color
                        end
                    end
                end
            end)

            local function set_options(options)
                lib.flags[flag]["selected"] = options
                for i,v in pairs(OpenInside:GetChildren()) do
                    if v.ClassName == "TextLabel" then
                        if util:find(options, v.Name) then 
                            v.TextColor3 = lib.accent_color
                            v.BackgroundTransparency = util:is_in_frame(v) and 0 or 1
                        else
                            v.TextColor3 = util:is_in_frame(v) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
                            v.BackgroundTransparency = util:is_in_frame(v) and 0 or 1
                        end
                    end
                end
                local text = ""
                for i = 1, #options do
                    local option = options[i]
                    if text == "" then 
                        text = option
                    else
                        text = text..", "..option
                    end
                end
                DropdownText.Text = text ~= "" and text or "-"
                lib.flags[flag]["selected"] = options
                new_element.on_option_change:Fire(options)
            end

            OpenDropdown.Size = udim2new(0, 163, 0, #options*20)

            local function open_dropdown()
                local abspos = DropdownBorder.AbsolutePosition
                OpenDropdown.Position = udim2new(0, abspos.X + 1, 0, abspos.Y + 22)
                OpenDropdown.Visible = true
                ElementLabel.TextColor3 = colorfromrgb(221,221,221)
                DropdownText.TextColor3 = colorfromrgb(221,221,221)
                DropdownImage.ImageColor3 = colorfromrgb(221,221,221)
                is_open = true; lib.busy = true;
            end

            local function close_dropdown()
                OpenDropdown.Visible = false
                is_open = false; task.delay(0, function()
                    lib.busy = false; 
                end)
                ElementLabel.TextColor3 = (#lib.flags[flag]["selected"] == 0 and (util:is_in_frame(DropdownBorder) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)) or colorfromrgb(221,221,221))
                DropdownText.TextColor3 = util:is_in_frame(DropdownBorder) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
                DropdownImage.ImageColor3 = util:is_in_frame(DropdownBorder) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
                Color = util:is_in_frame(DropdownBorder) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(33, 33, 33)), ColorSequenceKeypoint.new(1.00, colorfromrgb(23, 23, 23))} or ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(23, 23, 23)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
            end

            local on_close = util:create_connection(self.lib.on_close, function()
                if is_open then
                    close_dropdown()
                end
            end)

            for i = 1, #options do
                local option = options[i]
                local DropdownOption = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                    BackgroundColor3 = colorfromrgb(24, 24, 24);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = colorfromrgb(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = udim2new(1, 0, 0, 20);
                    Font = Enum.Font.RobotoMono;
                    Text = " "..option;
                    TextColor3 = colorfromrgb(74, 74, 74);
                    TextSize = 12.000;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    Parent = OpenInside
                }); DropdownOption.Name = option

                local on_hover = util:create_connection(DropdownOption.MouseEnter, function()
                    if not util:find(lib.flags[flag]["selected"], option) then
                        DropdownOption.TextColor3 = colorfromrgb(126,126,126)
                    end
                    DropdownOption.BackgroundTransparency = 0
                end)

                local on_leave = util:create_connection(DropdownOption.MouseLeave, function()
                    if not util:find(lib.flags[flag]["selected"], option) then
                        DropdownOption.TextColor3 = colorfromrgb(74,74,74)
                    end
                    DropdownOption.BackgroundTransparency = 1
                end)

                local on_click = util:create_connection(DropdownOption.InputEnded, function(input, gpe)
                    if gpe then return end
                    if input.UserInputType == Enum.UserInputType.Touch then
                        local new_selected = util:copy(lib.flags[flag]["selected"])
                        local is_found = util:find(lib.flags[flag]["selected"], option)
                        if is_found then
                            table.remove(new_selected, is_found)
                        else
                            if (#new_selected > 0 and multi) or #new_selected == 0 then
                                table.insert(new_selected, option)
                            elseif not multi then
                                new_selected = {option}
                            end
                        end
                        if #new_selected == 0 and no_none then 
                            return 
                        else
                            set_options(new_selected)
                            if not multi then
                                close_dropdown()
                            end
                        end
                    end
                end)
            end

            local on_click = util:create_connection(DropdownBorder.InputBegan, function(input, gpe)
                if gpe then return end
                if lib.busy and not is_open then return end
                if input.UserInputType == Enum.UserInputType.Touch then
                    if not lib.busy then
                        open_dropdown()
                    elseif is_open then
                        close_dropdown()
                    end
                end				
            end)

            local on_window_close = util:create_connection(self.lib.on_close, function()
                if is_open then close_dropdown() end
            end)
            ]]

            local on_enter = util:create_connection(DropdownBorder.MouseEnter, function()
                if is_open or lib.busy then return end
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(33, 33, 33)), ColorSequenceKeypoint.new(1.00, colorfromrgb(23, 23, 23))};
                DropdownText.TextColor3 = colorfromrgb(126,126,126)
                DropdownImage.ImageColor3 = colorfromrgb(126,126,126)
                if #lib.flags[flag]["selected"] == 0 then
                    ElementLabel.TextColor3 = colorfromrgb(126,126,126)
                end
            end)

            local on_enter = util:create_connection(DropdownBorder.MouseLeave, function()
                if is_open or lib.busy then return end
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(23, 23, 23)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
                DropdownText.TextColor3 = colorfromrgb(74,74,74)
                DropdownImage.ImageColor3 = colorfromrgb(74,74,74)
                if #lib.flags[flag]["selected"] == 0 then
                    ElementLabel.TextColor3 = colorfromrgb(74,74,74)
                end
            end)

            local on_click = util:create_connection(uis.InputEnded, function(input, gpe)
                if gpe then return end
                if lib.busy and not is_open then return end
                if input.UserInputType == Enum.UserInputType.Touch and is_open and not util:is_in_frame(DropdownBorder) and not util:is_in_frame(OpenDropdown) then 
                    close_dropdown()
                end
            end)

            if default then
                set_options(default)
            end

            util:create_connection(lib.on_config_load, function()
                set_options(lib.flags[flag]["selected"])
            end)	
        elseif element == "button" then
            new_element.total_size+=16

            local confirmation = info.confirmation and info.confirmation or false

            local Button = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 12, 0, 0);
                Size = udim2new(1, -24, 0, 24);
                Parent = ElementFrame
            })
            local UICorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 3);
                Parent = Button
            })
            local ButtonInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                Parent = Button
            })
            local UICorner_2 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 3);
                Parent = ButtonInside
            })
            local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
                Rotation = 90;
                Parent = ButtonInside
            })
            local ButtonLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = udim2new(1, 0, 1, 0);
                Font = Enum.Font.RobotoMono;
                Text = ElementLabel.Text;
                TextColor3 = colorfromrgb(74, 74, 74);
                TextSize = 12.000;
                Parent = ButtonInside
            }); ElementLabel:Destroy()

            local is_holding = false

            new_element.on_clicked = -- Converted: Generic Event/Signal Initialization("on_clicked")

            local on_hover = util:create_connection(Button.MouseEnter, function()
                if is_holding or lib.busy then return end
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}
                ButtonLabel.TextColor3 = colorfromrgb(221,221,221)
            end)

            local on_leave = util:create_connection(Button.MouseLeave, function()
                if is_holding or lib.busy then return end
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
                ButtonLabel.TextColor3 = colorfromrgb(74,74,74)
            end)

            local on_click = util:create_connection(Button.InputBegan, function(input, gpe)
                if gpe or lib.busy then return end
                if input.UserInputType == Enum.UserInputType.Touch then
                    is_holding = true
                    ButtonLabel.TextColor3 = lib.accent_color
                    Button.BackgroundColor3 = lib.accent_color
                end
            end)

            local confirmation_cover = self.lib.confirmation_cover
            local confirmation_frame = self.lib.confirmation

            local is_in_confirmation = false

            local on_stopclick = util:create_connection(Button.InputEnded, function(input, gpe)
                if gpe or lib.busy then return end
                if input.UserInputType == Enum.UserInputType.Touch and is_holding then
                    is_holding = false
                    ButtonLabel.TextColor3 = util:is_in_frame(Button) and colorfromrgb(221,221,221) or colorfromrgb(74,74,74)
                    Color = util:is_in_frame(Button) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
                    Button.BackgroundColor3 = colorfromrgb(0, 0, 0)
                    if confirmation then
                        confirmation_cover.Visible = true
                        self.lib.cflabel.Text = confirmation.text
                        self.lib.cftoplabel.Text = confirmation.top
                        util:tween(confirmation_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
                        confirmation_frame.Visible = true
                        lib.busy = true
                        is_in_confirmation = true
                    else
                        new_element.on_clicked:Fire()
                    end
                end
            end)

            local on_close = util:create_connection(self.lib.on_close, function()
                confirmation_cover.BackgroundTransparency = 1
                confirmation_cover.Visible = false
                confirmation_frame.Visible = false
                lib.busy = false
                is_in_confirmation = false
            end)

            local on_confirmed = util:create_connection(self.lib.confirmationsignal, function(t)
                if is_in_confirmation then
                    if t then
                        new_element.on_clicked:Fire()
                    end
                    task.delay(0.3, function() 
                        if confirmation_cover.BackgroundTransparency > .99 then
                            confirmation_cover.Visible = false
                        end
                    end)
                    util:tween(confirmation_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                    confirmation_frame.Visible = false
                    task.delay(0.03, function()
                        lib.busy = false
                    end)
                    is_in_confirmation = false
                end
            end)
        elseif element == "multibox" then
            new_element.total_size+=(21+(info.maxsize*17))
            ElementLabel:Destroy()
            local MultiboxTextbox = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 12, 0, 0);
                Size = udim2new(1, -24, 0, 19);
                Parent = ElementFrame
            })
            local DropdownBackground = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(24, 24, 24);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                Parent = MultiboxTextbox
            })
            local TextBox = -- Converted: Use UI Library's Instance creation functions("TextBox", {
                Parent = DropdownBackground;
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 5, 0, 0);
                Size = udim2new(1, -5, 1, 0);
                Font = Enum.Font.RobotoMono;
                Text = "";
                TextColor3 = colorfromrgb(74, 74, 74);
                TextSize = 12.000;
                ClearTextOnFocus = false;
                TextXAlignment = Enum.TextXAlignment.Left
            }); local on_focus = util:create_connection(TextBox.Focused, function()
                if lib.busy then TextBox:ReleaseFocus(); return end
            end)
            local MultiboxOpen = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 12, 0, 19);
                Size = udim2new(1, -24, 0, 2 + info.maxsize*17);
                Parent = ElementFrame
            })
            local MultiboxScroll = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                Parent = MultiboxOpen
            })
            local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 23, 22)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
                Rotation = 90;
                Parent = MultiboxScroll
            })
            local MultiboxInside = -- Converted: Use UI Library's Instance creation functions("ScrollingFrame", {
                Active = true;
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = udim2new(1, 0, 1, 0);
                BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
                CanvasSize = udim2new(0, 0, 1, 0);
                ScrollBarImageColor3 = colorfromrgb(56,56,56);
                ScrollBarThickness = 4;
                TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
                ScrollingEnabled = false;
                Parent = MultiboxScroll
            }); local on_text_change = util:create_connection(TextBox:GetPropertyChangedSignal("Text"), function()
                local text = lower(TextBox.Text)
                local all_labels = MultiboxInside:GetChildren()
                for i = 1, #all_labels do
                    local label = all_labels[i]
                    if label.ClassName == "TextLabel" then
                        if lower(label.Name):find(text) or text == " " or text == "" then
                            label.Visible = true
                        else
                            label.Visible = false
                        end
                    end
                end
            end)
            local UIListLayout = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.Name;
                VerticalAlignment = Enum.VerticalAlignment.Top;
                Padding = udimnew(0,0);
                Parent = MultiboxInside
            })

            new_element.on_option_change = -- Converted: Generic Event/Signal Initialization("on_option_change")

            local options = 0

            local selected = nil


            local function set_option(option)
                local all_labels = MultiboxInside:GetChildren()
                for i = 1, #all_labels do
                    local label = all_labels[i]
                    if label.ClassName == "TextLabel" then
                        label.Line.Visible = false
                        label.Line.Fade.Visible = false
                        label.TextColor3 = util:is_in_frame(label) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
                    end
                end
                local label = MultiboxInside:FindFirstChild(option)
                label.Line.Visible = true
                label.Line.Fade.Visible = true
                label.TextColor3 = colorfromrgb(221,221,221)
                selected = option
                new_element.on_option_change:Fire(selected)
            end

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                local options = lib.flags[flag]["selected"]
                for i,v in pairs(MultiboxInside:GetChildren()) do
                    if v.ClassName == "TextLabel" then
                        v.Line.BackgroundColor3 = color
                    end
                end
            end)

            function new_element:add_option(option)
                options+=1
                local MultiboxLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                    BackgroundColor3 = colorfromrgb(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = colorfromrgb(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = udim2new(1, 0, 0, 17);
                    ZIndex = 2;
                    Font = Enum.Font.RobotoMono;
                    Text = " "..option;
                    TextColor3 = colorfromrgb(74, 74, 74);
                    TextSize = 12.000;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    Parent = MultiboxInside
                }); MultiboxLabel.Name = option
                local MultiLine = -- Converted: Use UI Library's Instance creation functions("Frame", {
                    BackgroundColor3 = lib.accent_color;
                    BorderColor3 = colorfromrgb(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = udim2new(0, 1, 1, 0);
                    Visible = false;
                    ZIndex = 2;
                    Parent = MultiboxLabel
                }); MultiLine.Name = "Line"
                local LabelFade = -- Converted: Use UI Library's Instance creation functions("Frame", {
                    BackgroundColor3 = colorfromrgb(254, 254, 254);
                    BorderColor3 = colorfromrgb(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = udim2new(0, 40, 1, 0);
                    Visible = false;
                    Parent = MultiLine
                }); LabelFade.Name = "Fade"
                local UIGradient_2 = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                    Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(34, 34, 34)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))};
                    Parent = LabelFade
                })

                local on_enter = util:create_connection(MultiboxLabel.MouseEnter, function()
                    if selected == option or lib.busy then return end
                    MultiboxLabel.TextColor3 = colorfromrgb(126,126,126)
                end)

                local on_leave = util:create_connection(MultiboxLabel.MouseLeave, function()
                    if selected == option or lib.busy then return end
                    MultiboxLabel.TextColor3 = colorfromrgb(74,74,74)
                end)

                local on_leave = util:create_connection(MultiboxLabel.InputBegan, function(input, gpe)
                    if gpe or lib.busy then return end
                    if input.UserInputType == Enum.UserInputType.Touch then
                        if selected == option then return end
                        set_option(option)
                    end
                end)
                if options > info.maxsize then
                    local size = MultiboxInside.CanvasSize
                    MultiboxInside.CanvasSize = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + 17)
                    MultiboxInside.ScrollingEnabled = true
                else
                    MultiboxInside.ScrollingEnabled = false
                end
            end

            function new_element:remove_option(option)
                if options > info.maxsize then
                    local size = MultiboxInside.CanvasSize
                    MultiboxInside.CanvasSize = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset - 17)
                    MultiboxInside.ScrollingEnabled = true
                else
                    MultiboxInside.ScrollingEnabled = false
                end
                options-=1
                local label = MultiboxInside:FindFirstChild(option)
                if label then
                label:Destroy()
                end
                if selected == nil then
                local all_labels = MultiboxInside:GetChildren()
                    for i = 1, #all_labels do
                        local label = all_labels[i]
                        if label.ClassName == "TextLabel" then
                            set_option(label.Name)
                            return
                        end
                    end
                end
                if selected == option then selected = nil end
            end
        elseif element:find("colorpicker") then
            new_element.colorpickers+=1
            local AddonImage = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = udim2new(0, 9, 0, 9);
                Image = "rbxassetid://14138205253";
                ImageColor3 = colorfromrgb(74, 74, 74);
                ZIndex = 14;
                Parent = AddonHolder
            })
            local ColorpickerOpen = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0.329400182, 0, 0.683950603, 0);
                Size = udim2new(0, 163, 0, 181);
                ZIndex = 15;
                Visible = false;
                Parent = self.lib.screen_gui
            })
            local UICorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = ColorpickerOpen
            })
            local ColorpickerBorder = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(32, 32, 32);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                ZIndex = 15;
                Parent = ColorpickerOpen
            })
            local UICorner_2 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = ColorpickerBorder
            })
            local ColorpickerInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                ZIndex = 15;
                Parent = ColorpickerBorder
            })
            local UICorner_3 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = ColorpickerInside
            })
            local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(16, 16, 16)), ColorSequenceKeypoint.new(0.35, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(1.00, colorfromrgb(8, 8, 8))};
                Rotation = 90;
                Parent = ColorpickerInside
            })
            local SaturationImage = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
                BackgroundColor3 = colorfromrgb(170, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                Position = udim2new(0, 3, 0, 17);
                Size = udim2new(0, 141, 0, 145);
                ZIndex = 16;
                Image = "rbxassetid://13966897785";
                Parent = ColorpickerInside
            })
            local SaturationMover = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                BackgroundTransparency = 1;
                ZIndex = 17;
                Size = udim2new(0, 4, 0, 4);
                Image = "http://www.roblox.com/asset/?id=14138315296";
                Parent = SaturationImage
            })
            local HueFrame = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                Position = udim2new(1, -11, 0, 17);
                Size = udim2new(0, 8, 0, 145);
                ZIndex = 15;
                Parent = ColorpickerInside
            })
            local UIGradient_2 = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(170, 0, 0)), ColorSequenceKeypoint.new(0.15, colorfromrgb(255, 255, 0)), ColorSequenceKeypoint.new(0.30, colorfromrgb(0, 255, 0)), ColorSequenceKeypoint.new(0.45, colorfromrgb(0, 255, 255)), ColorSequenceKeypoint.new(0.60, colorfromrgb(0, 0, 255)), ColorSequenceKeypoint.new(0.75, colorfromrgb(175, 0, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(170, 0, 0))};
                Rotation = 90;
                Parent = HueFrame
            })
            local HueMover = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, -1, 0, 0);
                Size = udim2new(0, 10, 0, 3);
                ZIndex = 15;
                Image = "http://www.roblox.com/asset/?id=14138375431";
                Parent = HueFrame
            })
            local TransparencyFrame = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                Position = udim2new(0, 3, 1, -11);
                Size = udim2new(0, 141, 0, 8);
                ZIndex = 15;
                Parent = ColorpickerInside
            })
            local TransparencyMover = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(1, -3, 0, -1);
                Size = udim2new(0, 3, 0, 10);
                ZIndex = 15;
                Image = "http://www.roblox.com/asset/?id=14138391128";
                Parent = TransparencyFrame
            })
            local ColorpickerOpen2 = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
                Parent = self.lib.screen_gui;
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 0, 0, 0);
                Size = udim2new(0, 100, 0, 60);
                ZIndex = 15;
                Visible = false;
                Parent = self.lib.screen_gui
            })
            local UICorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = ColorpickerOpen2
            })
            local ColorpickerBorder2 = -- Converted: Use UI Library's Instance creation functions("Frame", {
                Parent = ColorpickerOpen2;
                BackgroundColor3 = colorfromrgb(32, 32, 32);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                ZIndex = 15
            })
            local UICorner_2 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = ColorpickerBorder2
            })
            local ColorpickerInside2 = -- Converted: Use UI Library's Instance creation functions("Frame", {
                Parent = ColorpickerBorder2;
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                ZIndex = 15	
            })
            local UICorner_3 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
                CornerRadius = udimnew(0, 4);
                Parent = ColorpickerInside2
            })
            local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(16, 16, 16)), ColorSequenceKeypoint.new(0.35, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(1.00, colorfromrgb(8, 8, 8))};
                Rotation = 90;
                Parent = ColorpickerInside2
            })
            local ColorBox2 = -- Converted: Use UI Library's Instance creation functions("Frame", {
                Parent = ColorpickerInside2;
                BackgroundColor3 = colorfromrgb(254, 254, 254);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(1, -12, 0, 2);
                Size = udim2new(0, 10, 0, 10);
                ZIndex = 66
            })
            local HexLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                Parent = ColorpickerInside2;
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 80, 0, 1);
                Size = udim2new(0, 0, 0, 12);
                ZIndex = 66;
                Font = Enum.Font.RobotoMono;
                Text = "#ffffff";
                TextColor3 = colorfromrgb(126, 126, 126);
                TextSize = 12.000;
                TextXAlignment = Enum.TextXAlignment.Right;
                Parent = ColorpickerInside2
            })
            local PasteLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 0, 1, -16);
                Size = udim2new(1, 0, 0, 12);
                ZIndex = 66;
                Font = Enum.Font.RobotoMono;
                Text = "paste color";
                TextColor3 = colorfromrgb(126, 126, 126);
                TextSize = 12.000;
                Parent = ColorpickerInside2
            })
            local CopyLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 0, 1, -34);
                Size = udim2new(1, 0, 0, 12);
                ZIndex = 66;
                Font = Enum.Font.RobotoMono;
                Text = "copy color";
                TextColor3 = colorfromrgb(126, 126, 126);
                TextSize = 12.000;
                Parent = ColorpickerInside2
            })

            lib.flags[flag]["color"] = info.color and info.color or colorfromrgb(255,255,255)
            lib.flags[flag]["transparency"] = info.transparency and info.transparency or 0

            local is_open = false
            local is_open2 = false
            local addon_cover = self.lib.addon_cover

            new_element.on_color_change = -- Converted: Generic Event/Signal Initialization("on_color_change")
            new_element.on_transparency_change = -- Converted: Generic Event/Signal Initialization("on_transparency_change")

            local function open_colorpicker()
                lib.busy = true; is_open = true
                ColorpickerOpen.Visible = true
                AddonImage.ImageColor3 = colorfromrgb(255,255,255)
                addon_cover.Visible = true
                addon_cover.BackgroundTransparency = 1
                AddonImage.ZIndex = 16
                util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})

                local absPos = AddonImage.AbsolutePosition
                ColorpickerOpen.Position = udim2new(0, absPos.X - 5, 0, absPos.Y - 5)
            end

            local function open_colorpicker_alt()
                lib.busy = true; is_open2 = true
                ColorpickerOpen2.Visible = true
                AddonImage.ImageColor3 = colorfromrgb(255,255,255)
                addon_cover.Visible = true
                addon_cover.BackgroundTransparency = 1
                AddonImage.ZIndex = 67
                util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})

                local absPos = AddonImage.AbsolutePosition
                ColorpickerOpen2.Position = udim2new(0, absPos.X - 5, 0, absPos.Y - 5)
            end

            local function close_colorpicker_alt()
                task.delay(0.03, function()
                    lib.busy = false
                end)
                is_open2 = false
                ColorpickerOpen2.Visible = false
                AddonImage.ZIndex = 14
                util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                task.delay(0.3, function()
                    if addon_cover.BackgroundTransparency > 0.99 then
                        addon_cover.Visible = false
                    end
                end)
                AddonImage.ImageColor3 = colorfromrgb(74,74,74)
            end

            local function close_colorpicker()
                task.delay(0.03, function()
                    lib.busy = false
                end)
                is_open = false
                ColorpickerOpen.Visible = false
                AddonImage.ZIndex = 14
                util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                task.delay(0.3, function()
                    if addon_cover.BackgroundTransparency > 0.99 then
                        addon_cover.Visible = false
                    end
                end)
                AddonImage.ImageColor3 = colorfromrgb(74,74,74)
            end

            local on_close = util:create_connection(self.lib.on_close, function()
                if is_open then
                    close_colorpicker()
                    addon_cover.Visible = false
                end
                if is_open2 then
                    close_colorpicker_alt()
                    addon_cover.Visible = false
                end
            end)

            local on_hover = util:create_connection(AddonImage.MouseEnter, function()
                if is_open or lib.busy then return end
                AddonImage.ImageColor3 = colorfromrgb(126,126,126)
            end)

            local on_leave = util:create_connection(AddonImage.MouseLeave, function()
                if is_open or lib.busy then return end
                AddonImage.ImageColor3 = colorfromrgb(74,74,74)
            end)

            local on_hover = util:create_connection(CopyLabel.MouseEnter, function()
                CopyLabel.TextColor3 = colorfromrgb(221,221,221)
            end)

            local on_leave = util:create_connection(CopyLabel.MouseLeave, function()
                CopyLabel.TextColor3 = colorfromrgb(126,126,126)
            end)

            local on_hover = util:create_connection(PasteLabel.MouseEnter, function()
                PasteLabel.TextColor3 = colorfromrgb(221,221,221)
            end)

            local on_leave = util:create_connection(PasteLabel.MouseLeave, function()
                PasteLabel.TextColor3 = colorfromrgb(126,126,126)
            end)

            local on_mouse1 = util:create_connection(CopyLabel.InputBegan, function(input, gpe)
                if input.UserInputType == Enum.UserInputType.Touch then
                    CopyLabel.TextColor3 = lib.accent_color
                    if is_open2 then lib.copied_color = lib.flags[flag]["color"] end
                end
            end)
        
            local on_mouse1_end = util:create_connection(CopyLabel.InputEnded, function(input, gpe)
                if input.UserInputType == Enum.UserInputType.Touch then
                    CopyLabel.TextColor3 = util:is_in_frame(CopyLabel) and colorfromrgb(221,221,221) or colorfromrgb(126,126,126)
                end
            end)

            local on_mouse1 = util:create_connection(AddonImage.InputBegan, function(input, gpe)
                if lib.busy or gpe then return end
                if input.UserInputType == Enum.UserInputType.Touch then
                    if not lib.busy then AddonImage.ImageColor3 = colorfromrgb(255,255,255) end
                end
            end)

            local on_mouse1end = util:create_connection(AddonImage.InputEnded, function(input, gpe)
                if lib.busy or gpe then return end
                if input.UserInputType == Enum.UserInputType.Touch then
                    if not lib.busy then open_colorpicker() elseif is_open then close_colorpicker() end
                    if is_open2 then close_colorpicker_alt() end
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    if not lib.busy then open_colorpicker_alt() elseif is_open2 then close_colorpicker_alt() end
                end
            end)

            local on_mouse1end = util:create_connection(uis.InputBegan, function(input, gpe)
                if input.UserInputType == Enum.UserInputType.Touch then
                    if is_open and not util:is_in_frame(AddonImage) and not util:is_in_frame(ColorpickerOpen) then
                        close_colorpicker()
                    elseif is_open2 and not util:is_in_frame(AddonImage) and not util:is_in_frame(ColorpickerOpen2) then
                        close_colorpicker_alt()
                    end
                end
            end)

            local hue, saturation, value = 0, 0, 255

            local color = info.color and info.color or colorfromrgb(255,255,255)
            local transparency =  info.transparency and info.transparency or 0

            local dragging_sat, dragging_hue, dragging_trans = false, false, false
            local on_transparency_change = info.on_transparency_change and info.on_transparency_change or function() end
            local on_color_change = info.on_color_change and info.on_color_change or function() end

            local function update_sv(val, sat, nocallback)
                saturation = sat
                value = val 
                color = Color3.fromHSV(hue/360, saturation/255, value/255)
                SaturationMover.Position = udim2new(clamp(sat/255, 0, 0.98), 0, 1 - clamp(val/255, 0.02, 1), 0)
                lib.flags[flag]["color"] = color
                ColorBox2.BackgroundColor3 = color
                HexLabel.Text = util:to_hex(color)
                new_element.on_color_change:Fire(color)
            end

            local function update_hue(hue2)
                SaturationImage.BackgroundColor3 = Color3.fromHSV(hue2/360, 1, 1)
                HueMover.Position = udim2new(0, -1, clamp(hue2/360, 0, 0.99), -1)
                color = Color3.fromHSV(hue2/360, saturation/255, value/255)
                hue = hue2
                lib.flags[flag]["color"] = color
                HexLabel.Text = util:to_hex(color)
                ColorBox2.BackgroundColor3 = color
                new_element.on_color_change:Fire(color)
            end

            local function update_transparency(o, nocallback)
                TransparencyMover.Position = udim2new(clamp(1 - o, 0, 0.98), 0, 0, -1)
                lib.flags[flag]["transparency"] = o
                transparency = o
                new_element.on_transparency_change:Fire(transparency)
                TransparencyFrame.BackgroundColor3 = Color3.new(0.75 - o*.5, 0.75 - o*.5, 0.75 - o*.5)
            end

            util:create_connection(SaturationImage.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local xdistance = clamp((mouse.X - SaturationImage.AbsolutePosition.X)/SaturationImage.AbsoluteSize.X, 0, 1)
                    local ydistance = 1 - clamp((mouse.Y - SaturationImage.AbsolutePosition.Y)/SaturationImage.AbsoluteSize.Y, 0, 1)
                    local sat = 255 * xdistance
                    local val = 255 * ydistance
                    update_sv(val, sat)
                    dragging_sat = true
                end
            end)

            util:create_connection(SaturationImage.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.Touch and dragging_sat then
                    dragging_sat = false
                end
            end)

            util:create_connection(mouse.Move, function()
                if dragging_sat then
                    local xdistance = clamp((mouse.X - SaturationImage.AbsolutePosition.X)/SaturationImage.AbsoluteSize.X, 0, 1)
                    local ydistance = 1 - clamp((mouse.Y - SaturationImage.AbsolutePosition.Y)/SaturationImage.AbsoluteSize.Y, 0, 1)
                    local sat = 255 * xdistance
                    local val = 255 * ydistance
                    update_sv(val, sat)
                elseif dragging_hue then
                    local xdistance = clamp((mouse.Y - HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y, 0, 1)
                    local hue = 360 * xdistance
                    update_hue(hue)
                elseif dragging_trans then
                    local xdistance = clamp((mouse.X - TransparencyFrame.AbsolutePosition.X)/TransparencyFrame.AbsoluteSize.X, 0, 1)
                    update_transparency(1 - 1 * xdistance)
                end
            end)

            util:create_connection(HueFrame.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local xdistance = clamp((mouse.Y - HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y, 0, 1)
                    local hue = 360 * xdistance
                    update_hue(hue)
                    dragging_hue = true
                end
            end)

            util:create_connection(HueFrame.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.Touch and dragging_hue then
                    dragging_hue = false
                end
            end)

            util:create_connection(TransparencyFrame.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local xdistance = clamp((mouse.X - TransparencyFrame.AbsolutePosition.X)/TransparencyFrame.AbsoluteSize.X, 0, 1)
                    update_transparency(1 - 1 * xdistance)
                    dragging_trans = true
                end
            end)

            util:create_connection(TransparencyFrame.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.Touch and dragging_trans then
                    dragging_trans = false
                end
            end)

            do
                local h,s,v = lib.flags[flag]["color"]:ToHSV()
                update_sv(v*255, s*255, true)
                update_hue(h*360)
                update_transparency(lib.flags[flag]["transparency"])
            end

            local on_mouse1 = util:create_connection(PasteLabel.InputBegan, function(input, gpe)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local color = lib.copied_color
                    local h,s,v = color:ToHSV()
                    update_sv(v*255, s*255, true)
                    update_hue(h*360)
                    update_transparency(lib.flags[flag]["transparency"])
                    PasteLabel.TextColor3 = lib.accent_color
                end
            end)
        
            local on_mouse1_end = util:create_connection(PasteLabel.InputEnded, function(input, gpe)
                if input.UserInputType == Enum.UserInputType.Touch then
                    PasteLabel.TextColor3 = util:is_in_frame(PasteLabel) and colorfromrgb(221,221,221) or colorfromrgb(126,126,126)
                end
            end)

            util:create_connection(lib.on_config_load, function()
                local h,s,v = lib.flags[flag]["color"]:ToHSV()
                update_sv(v*255, s*255, true)
                update_hue(h*360)
                update_transparency(lib.flags[flag]["transparency"])
            end)	
        elseif element == "textbox" then
            new_element.total_size+=(23)
            local MultiboxTextbox = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(0, 0, 0);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 12, 0, 11);
                Size = udim2new(1, -24, 0, 19);
                Parent = ElementFrame
            })
            local DropdownBackground = -- Converted: Use UI Library's Instance creation functions("Frame", {
                BackgroundColor3 = colorfromrgb(24, 24, 24);
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 1, 0, 1);
                Size = udim2new(1, -2, 1, -2);
                Parent = MultiboxTextbox
            })
            local TextBox = -- Converted: Use UI Library's Instance creation functions("TextBox", {
                Parent = DropdownBackground;
                BackgroundColor3 = colorfromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = colorfromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = udim2new(0, 5, 0, 0);
                Size = udim2new(1, -5, 1, 0);
                Font = Enum.Font.RobotoMono;
                Text = "";
                TextColor3 = colorfromrgb(74, 74, 74);
                TextSize = 12.000;
                TextWrapped = true;
                ClearTextOnFocus = false;
                TextXAlignment = Enum.TextXAlignment.Left
            }); local on_focus = util:create_connection(TextBox.Focused, function()
                if lib.busy then TextBox:ReleaseFocus(); return end
            end)

            new_element.on_text_change = -- Converted: Generic Event/Signal Initialization("on_text_change")

            local on_text_change = util:create_connection(TextBox:GetPropertyChangedSignal("Text"), function()
                lib.flags[flag]["text"] = TextBox.Text
                new_element.on_text_change:Fire(TextBox.Text)
            end)

            if info.text then TextBox.Text = info.text end

            util:create_connection(lib.on_config_load, function()
                TextBox.Text = lib.flags[flag]["text"] or ""
            end)
        end
    end

    ElementFrame.Size = udim2new(1, 0, 0, self.elements ~= 0 and new_element.total_size-9 or new_element.total_size)

    setmetatable(new_element, element); self.elements+=1

    self:update_size(new_element.total_size)

    table.insert(self.element_holder, new_element)

    return new_element
end

function element:remove()
    self.frame:Destroy()
    self.section:update_size(-self.total_size)
    lib.flags[self.flag] = nil
    self = nil
end

function element:set_visible(visible)
    if self.frame.Visible == visible then return end

    self.frame.Visible = visible
    self.section:update_size(visible and self.total_size or -self.total_size)
end

    local ScreenGui = -- Converted: Use UI Library's Instance creation functions("ScreenGui", {
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        Parent = gethui and gethui() or cg,
        Enabled = false,
        Name = "nigger"
    })
    local MainBackground = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0.132718891, 0, 0.122222222, 0);
        Size = udim2new(0, 600, 0, 430);
        Parent = ScreenGui
    })
    local AddonCover = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(1, 1, 1);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        BackgroundTransparency = 1;
        Position = udim2new(0, 0, 0, 25);
        Size = udim2new(1, 0, 0, 381);
        Visible = false;
        ZIndex = 14;
        Parent = MainBackground
    })
    local ConfirmCover = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(1, 1, 1);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        BackgroundTransparency = 1;
        Position = udim2new(0, 0, 0, 25);
        Size = udim2new(1, 0, 0, 381);
        Visible = false;
        ZIndex = 14;
        Parent = MainBackground
    })
    local UICorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = MainBackground
    })
    local MainBorder = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(32, 32, 32);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 1, -2);
        Parent = MainBackground
    })
    local UICorner_2 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = MainBorder
    })
    local MainInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(11, 11, 11);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 1, -2);
        Parent = MainBorder    
    })
    local UICorner_3 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = MainInside
    })
    local MainTop = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 0, 20);
        Parent = MainBorder  
    })
    local UICorner_4 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = MainTop
    })
    local TopInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(8, 8, 8);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 1, -2);
        Parent = MainTop
    })
    local UICorner_5 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = TopInside
    })
    local TopFix = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(8, 8, 8);
        BorderColor3 = colorfromrgb(0, 0, 0);
        Position = udim2new(0, 0, 0, 9);
        Size = udim2new(1, 0, 0, 9);
        Parent = TopInside
    })
    local TopFix2 = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(8, 8, 8);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 0, 0, -1);
        Size = udim2new(1, 0, 0, 1);
        Parent = TopFix
    })
    local NameLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 5, 0, 0);
        Size = udim2new(0, 95, 1, 0);
        Font = Enum.Font.RobotoMono;
        Text = "ratio.lol";
        TextColor3 = lib.accent_color;
        TextSize = 12.000;
        TextWrapped = true;
        TextXAlignment = Enum.TextXAlignment.Left;
        RichText = true;
        Parent = TopInside
    })
    local TopCover = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(32, 32, 32);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 0, 1, 0);
        Size = udim2new(1, 0, 0, 1);
        Parent = MainTop
    })
    local MainBottom = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 1, -21);
        Size = udim2new(1, -2, 0, 20);
        Parent = MainBorder
    })
    local UICorner_8 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = MainBottom
    })
    local BottomInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(8, 8, 8);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 1, -2);
        Parent = MainBottom
    })
    local TipImage = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
        BackgroundColor3 = colorfromrgb(254, 254, 254);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 5, 0, 3);
        Size = udim2new(0, 12, 0, 12);
        ImageTransparency = 1;
        Visible = true;
        ZIndex = 3;
        Image = "http://www.roblox.com/asset/?id=14151711445";
        Parent = BottomInside
    })
    local TipLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(254, 254, 254);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 21, 0, 0);
        Size = udim2new(0, 350, 1, 0);
        Font = Enum.Font.RobotoMono;
        Text = "This is an example tip.";
        TextColor3 = colorfromrgb(74, 74, 74);
        TextSize = 12.000;
        TextWrapped = true;
        TextTransparency = 1;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 3;
        Parent = TipImage
    })
    local UICorner_9 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = BottomInside
    })
    local BottomFix = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(8, 8, 8);
        BorderColor3 = colorfromrgb(0, 0, 0);
        Size = udim2new(1, 0, 0, 9);
        Parent = BottomInside
    })
    local BottomFix2 = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(8, 8, 8);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 0, 0, 9);
        Size = udim2new(1, 0, 0, 1);
        Parent = BottomFix
    })
    local BuildLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 5, 0, 0);
        Size = udim2new(0, 95, 1, 0);
        Font = Enum.Font.RobotoMono;
        Text = "build: <font color=\"rgb(189, 172, 255)\">live</font>";
        TextColor3 = colorfromrgb(74, 74, 74);
        TextSize = 12.000;
        TextWrapped = true;
        RichText = true;
        TextXAlignment = Enum.TextXAlignment.Left;
        Parent = BottomInside
    })
    local UserLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(1, -305, 0, 0);
        Size = udim2new(0, 300, 1, 0);
        Font = Enum.Font.RobotoMono;
        Text = "active user: <font color=\"rgb(189, 172, 255)\">xander</font>";
        TextColor3 = colorfromrgb(74, 74, 74);
        TextSize = 12.000;
        RichText = true;
        TextWrapped = true;
        TextXAlignment = Enum.TextXAlignment.Right;
        Parent = BottomInside
    })
    local BottomCover = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(32, 32, 32);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 0, 0, -1);
        Size = udim2new(1, 0, 0, 1);
        Parent = MainBottom
    })
    local TabSlider = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        ClipsDescendants = true;
        Position = udim2new(0, 106, 0, 1);
        Size = udim2new(1, -212, 1, 0);
        Parent = MainTop
    })
    local TabHolder = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(-1, 0, 0, 0);
        Size = udim2new(1, 0, 1, 0);
        Parent = TabSlider
    })
    local UIListLayout = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        VerticalAlignment = Enum.VerticalAlignment.Top;
        Padding = udimnew(0, 5);
        Parent = TabHolder
    })
    local FadeLine = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = lib.accent_color;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(1, -298, 1, 1);
        Size = udim2new(0.5, 0, 0, 1);
        Parent = MainTop
    })
    local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(11, 11, 11)), ColorSequenceKeypoint.new(1.00, colorfromrgb(255, 255, 255))};
        Parent = FadeLine
    })
    local ConfirmationFrame = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0.5, -121, 0.5, -48);
        Size = udim2new(0, 242, 0, 96);
        ZIndex = 101;
        Visible = false;
        Parent = MainBackground
    })
    local UICorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = ConfirmationFrame
    })
    local CF2 = -- Converted: Use UI Library's Instance creation functions("Frame", {
        Parent = ConfirmationFrame;
        BackgroundColor3 = colorfromrgb(32, 32, 32);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 1, -2);
        ZIndex = 101;
        Parent = ConfirmationFrame
    })
    local UICorner_2 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = CF2
    })
    local CF3 = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(11, 11, 11);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 1, -2);
        ZIndex = 101;
        Parent = CF2
    })
    local UICorner_3 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = CF3
    })
    local CFTOP = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Size = udim2new(1, 0, 0, 20);
        ZIndex = 101;
        Parent = CF3
    })
    local UICorner_4 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = CFTOP
    })
    local CFFIX = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 0, 1, -4);
        Size = udim2new(1, 0, 0, 4);
        ZIndex = 101;
        Parent = CFTOP
    })
    local UICorner_5 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 4);
        Parent = CFFIX
    })
    local CFLINE = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(32, 32, 32);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 0, 1, 0);
        Size = udim2new(1, 0, 0, 1);
        ZIndex = 101;
        Parent = CFTOP
    })
    local CFLABEL = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Size = udim2new(1, 0, 1, 0);
        ZIndex = 101;
        Font = Enum.Font.RobotoMono;
        Text = "Load config";
        TextColor3 = lib.accent_color;
        TextSize = 12.000;
        Parent = CFTOP
    })
    local CFTEXTLABEL = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Size = udim2new(1, 0, 1, -10);
        ZIndex = 101;
        Font = Enum.Font.RobotoMono;
        Text = "Are you sure you want to load your config?";
        TextColor3 = colorfromrgb(221, 221, 221);
        TextSize = 12.000;
        TextWrapped = true;
        Parent = CF3
    })
    local CancelButton = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 34, 1, -33);
        Size = udim2new(0, 80, 0, 20);
        ZIndex = 101;
        Parent = CF3
    })
    local UICorner_7 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 3);
        Parent = CancelButton
    })
    local CancelInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(254, 254, 254);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 1, -2);
        ZIndex = 101;
        Parent = CancelButton	
    })
    local UICorner_8 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 3);
        Parent = CancelInside
    })
    local UIGradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
        Rotation = 90;
        Parent = CancelInside
    })
    local CancelLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Size = udim2new(0, 80, 0, 20);
        ZIndex = 101;
        Font = Enum.Font.RobotoMono;
        Text = "Cancel";
        TextColor3 = colorfromrgb(74, 74, 74);
        TextSize = 12.000;
        Parent = CancelInside
    })
    local ConfirmButton = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(1, -114, 1, -33);
        Size = udim2new(0, 80, 0, 20);
        ZIndex = 101;
        Parent = CF3
    })
    local UICorner_9 = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 3);
        Parent = ConfirmButton
    })
    local ConfirmInside = -- Converted: Use UI Library's Instance creation functions("Frame", {
        BackgroundColor3 = colorfromrgb(254, 254,254);
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = udim2new(0, 1, 0, 1);
        Size = udim2new(1, -2, 1, -2);
        ZIndex = 101;
        Parent = ConfirmButton
    })
    local UICorner_10  = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = udimnew(0, 3);
        Parent = ConfirmInside
    })
    local UIGradient_2 = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
        Rotation = 90;
        Parent = ConfirmInside
    })
    local ConfirmLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Size = udim2new(0, 80, 0, 20);
        ZIndex = 101;
        Font = Enum.Font.RobotoMono;
        Text = "Confirm";
        TextColor3 = colorfromrgb(74, 74, 74);
        TextSize = 12.000;
        Parent = ConfirmInside
    })


    util:set_draggable(MainBackground)

    local new_window = {
        screen_gui = ScreenGui,
        name_label = NameLabel,
        build_label = BuildLabel,
        user_label = UserLabel,
        tab_holder = TabHolder,
        active_tab = nil,
        main = MainBackground,
        line = FadeLine,
        opened = false,
        hotkey = "insert",
        tip = TipImage,
        addon_cover = AddonCover,
        confirmation_cover = ConfirmCover,
        confirmation = ConfirmationFrame,
        on_close = -- Converted: Generic Event/Signal Initialization("on_close"),
        confirmationsignal = -- Converted: Generic Event/Signal Initialization("confirmation"),
        cflabel = CFTEXTLABEL,
        cftoplabel = CFLABEL,
        tabs = {}
    }

    local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
        lib.accent_color = color
        CFLABEL.TextColor3 = color
        FadeLine.BackgroundColor3 = color
        new_window:set_user(lplr.DisplayName)
        new_window:set_build("$$$")
        new_window:set_title("TRANNYHACK")
    end)

    local is_holding = false

    local on_hover = util:create_connection(CancelButton.MouseEnter, function()
        if is_holding then return end
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}
        CancelLabel.TextColor3 = colorfromrgb(221,221,221)
    end)

    local on_leave = util:create_connection(CancelButton.MouseLeave, function()
        if is_holding then return end
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
        CancelLabel.TextColor3 = colorfromrgb(74,74,74)
    end)

    local on_click = util:create_connection(CancelButton.InputBegan, function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            is_holding = true
            CancelLabel.TextColor3 = lib.accent_color
            CancelButton.BackgroundColor3 = lib.accent_color
        end
    end)

    local on_stopclick = util:create_connection(CancelButton.InputEnded, function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            is_holding = false
            CancelLabel.TextColor3 = util:is_in_frame(CancelButton) and colorfromrgb(221,221,221) or colorfromrgb(74,74,74)
            Color = util:is_in_frame(CancelButton) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
            CancelButton.BackgroundColor3 = colorfromrgb(0, 0, 0)
            new_window.confirmationsignal:Fire(false)
        end
    end)

    local on_hover = util:create_connection(ConfirmButton.MouseEnter, function()
        if is_holding then return end
        UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}
        ConfirmLabel.TextColor3 = colorfromrgb(221,221,221)
    end)

    local on_leave = util:create_connection(ConfirmButton.MouseLeave, function()
        if is_holding then return end
        UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
        ConfirmLabel.TextColor3 = colorfromrgb(74,74,74)
    end)

    local on_click = util:create_connection(ConfirmButton.InputBegan, function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            is_holding = true
            ConfirmLabel.TextColor3 = lib.accent_color
            ConfirmButton.BackgroundColor3 = lib.accent_color
        end
    end)

    local on_stopclick = util:create_connection(ConfirmButton.InputEnded, function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            is_holding = false
            ConfirmLabel.TextColor3 = util:is_in_frame(ConfirmButton) and colorfromrgb(221,221,221) or colorfromrgb(74,74,74)
            UIGradient_2.Color = util:is_in_frame(ConfirmButton) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
            ConfirmButton.BackgroundColor3 = colorfromrgb(0, 0, 0)
            new_window.confirmationsignal:Fire(true)
        end
    end)

    local on_input = util:create_connection(uis.InputBegan, function(input, gpe)
        if gpe then return end

        if input.KeyCode.Name:lower() == new_window.hotkey then
            if new_window.opened then new_window:close() else new_window:open() end
        end
    end)

    setmetatable(new_window, window)

    new_window:close()

    return new_window
end)

function lib:set_dependent(dependency, dependent_on)
    dependency:set_visible(false)
    util:create_connection(dependent_on.on_toggle, function(toggle)
        dependency:set_visible(toggle)
    end)
end

function lib:set_dropdown_dependent(dependency, dependent_on, value)
    dependency:set_visible(false)
    util:create_connection(dependent_on.on_option_change, function(option)
        dependency:set_visible(option[1] == value)
    end)
end

end


function do_load_animation(signal, text, image)
    local box = util:new_drawing("Square", {
        Thickness = 1;
        Filled = true;
        Color = colorfromrgb(0,0,0);
        Transparency = 0;
        Visible = true;
        Size = vect2(9000,9000);
        ZIndex = 1
    })
    local logo = util:new_drawing("Image", {
        Size = vect2(64, 64);
        Position = vect2(viewport_size.X/2-32, viewport_size.Y/2-32);
        Data = game:HttpGet(image or "https://raw.githubusercontent.com/refinanced/robloxscripts/main/logo.png");
        Color = accent_color;
        Visible = true;
        Transparency = 0
    })
    local text = util:new_drawing("Text", {
        Outline = true;
        Size = 16;
        ZIndex = 100;
        Center = true;
        Text = text or "ratio is initializing";
        Color = colorfromrgb(226,226,226);
        Visible = true;
        Transparency = 0
    })

    local delta = 0
    local delta2 = 0
    local delta3 = 0
        local viewport_size = viewport_size/2
        delta+=dt
        delta3+=dt
        if delta3 < 1 then
            local tween_value = ts:GetValue((delta3 / 1), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            box.Transparency = 0 + (0.4*tween_value)
        end
        if delta < 1 then
            local tween_value = ts:GetValue((delta / 1), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            logo.Transparency = 0 + (1*tween_value)
        elseif delta2 < 1 then
            delta2+=dt
            local tween_value = ts:GetValue((delta2 / 1), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            text.Transparency = 0 + (1*tween_value)
        end
        logo.Position = viewport_size - vect2(32,32)
        text.Position = viewport_size + vect2(0,28)
    end))

    signal:Wait()

    delta,delta2,delta3 = 0,0,0

    load_connection:Disconnect()

        local viewport_size = viewport_size/2
        delta+=dt
        delta2+=dt
        delta3+=dt
        if delta < 1 then
            local tween_value = ts:GetValue((delta / 0.8), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            logo.Transparency = 1 - (1*tween_value)
        end
        if delta2 < 1 then
            local tween_value = ts:GetValue((delta2 / 0.8), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            text.Transparency = 1 - (1*tween_value)
        end
        if delta3 < 1 then
            local tween_value = ts:GetValue((delta3 / 0.81), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            box.Transparency = 0.4 - (1*tween_value)
        end
        logo.Position = viewport_size - vect2(32,32)
        text.Position = viewport_size + vect2(0,28)
    end))

    task.wait(0.81)

    unload_connection:Disconnect()
    text:Remove()
    logo:Remove()
    box:Remove()
end

local keybind = {}
keybind.__index = keybind

local KeybindsHolder = -- Converted: Use UI Library's Instance creation functions("Frame", {
    BackgroundColor3 = colorfromrgb(255, 255, 255);
    BackgroundTransparency = 1.000;
    BorderColor3 = colorfromrgb(0, 0, 0);
    BorderSizePixel = 0;
    Position = UDim2.new(0, 2, 1, 4);
    Size = UDim2.new(1, -4, 0, 500);
})

local new_keybind = nil

do
    local flags = lib.flags

    new_keybind = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BackgroundTransparency = 0.500;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 555, 0, 550);
        Size = UDim2.new(0, 165, 0, 20);
        ZIndex = 2;
        Font = Enum.Font.Ubuntu;
        Text = "keybinds";
        TextColor3 = colorfromrgb(255, 255, 255);
        TextSize = 12.000;
        Visible = false;
        Parent = global_sg
    }); KeybindsHolder.Parent = new_keybind; util:set_draggable(new_keybind); util:create_connection(new_keybind:GetPropertyChangedSignal("Position"), function()
        lib.flags["keybinds_position"] = {new_keybind.Position.X.Offset, new_keybind.Position.Y.Offset}
    end)
    local UICorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
        CornerRadius = UDim.new(0, 6);
        Parent = new_keybind
    })
    local Shadow = -- Converted: Use UI Library's Instance creation functions("ImageLabel", {
        BackgroundTransparency = 1.000;
        Position = UDim2.new(0, -7, 0, -7);
        Size = UDim2.new(1, 14, 1, 14);
        ZIndex = 0;
        Image = "rbxassetid://1316045217";
        ImageTransparency = 0.880;
        ScaleType = Enum.ScaleType.Slice;
        SliceCenter = Rect.new(10, 10, 118, 118);
        Parent = new_keybind
    })
    local UIListLayout = -- Converted: Use UI Library's Instance creation functions("UIListLayout", {
        Parent = KeybindsHolder;
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local TextLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
        BackgroundColor3 = colorfromrgb(0, 0, 0);
        BackgroundTransparency = 11.000;
        BorderColor3 = colorfromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, 0, 1, 0);
        Font = Enum.Font.Ubuntu;
        Text = "keybinds";
        TextColor3 = colorfromrgb(0, 0, 0);
        TextSize = 12.000;
        Parent = new_keybind
    })

    function keybind.new(text, element, flag)
        local NameLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
            BackgroundColor3 = colorfromrgb(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = colorfromrgb(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 16);
            ZIndex = 2;
            Font = Enum.Font.Ubuntu;
            Text = text;
            TextColor3 = colorfromrgb(255, 255, 255);
            TextSize = 12.000;
            TextStrokeColor3 = colorfromrgb(165, 165, 165);
            TextXAlignment = Enum.TextXAlignment.Left;
            Visible = false;
            Parent = KeybindsHolder
        })
        local NameOffset = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
            BackgroundColor3 = colorfromrgb(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = colorfromrgb(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, 0, 1, 0);
            Font = Enum.Font.Ubuntu;
            Text = text;
            TextColor3 = colorfromrgb(0, 0, 0);
            TextSize = 12.000;
            TextStrokeColor3 = colorfromrgb(165, 165, 165);
            TextTransparency = 0.700;
            TextXAlignment = Enum.TextXAlignment.Left;
            Parent = NameLabel
        })
        local MethodLabel = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
            BackgroundColor3 = colorfromrgb(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = colorfromrgb(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 2;
            Font = Enum.Font.Ubuntu;
            Text = "[unbound]";
            TextColor3 = colorfromrgb(255, 255, 255);
            TextSize = 12.000;
            TextStrokeColor3 = colorfromrgb(165, 165, 165);
            TextXAlignment = Enum.TextXAlignment.Right;
            Parent = NameLabel	
        })
        local MethodOffset = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
            BackgroundColor3 = colorfromrgb(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = colorfromrgb(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, 0, 1, 0);
            Font = Enum.Font.Ubuntu;
            Text = "[unbound]";
            TextColor3 = colorfromrgb(0, 0, 0);
            TextSize = 12.000;
            TextStrokeColor3 = colorfromrgb(165, 165, 165);
            TextTransparency = 0.700;
            TextXAlignment = Enum.TextXAlignment.Right;
            Parent = MethodLabel
        })

        local kb = {}
        kb.text = NameLabel
        kb.key_label = MethodLabel

        local flag = flags[flag]

        setmetatable(kb, keybind)

        if element.on_toggle then
            util:create_connection(element.on_toggle, function(t)
                kb:set_visible((t and element:is_active()) and true or false)
            end)
        end

        util:create_connection(element.on_key_change, function(key)
            kb:set_key(key)
        end)

        util:create_connection(element.on_activate, function()
            kb:set_visible(true)
        end)

        util:create_connection(element.on_deactivate, function()
            kb:set_visible(false)
        end)
    end

    function keybind:set_visible(visible)
        local transparency = visible and 0 or 1
        if visible then
            self.text.Visible = true
        end
        util:tween(self.text, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = transparency})
        for _, text in pairs(self.text:GetDescendants()) do
            util:tween(text, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = transparency})		
        end
        if not visible then
            task.delay(0.3, function()
                if self.text.TextTransparency > 0.99 then
                    self.text.Visible = false
                end
            end)
        end
    end

    function keybind:set_key(key)
        local string2 = string.format("[%s]", key)
        self.key_label.Text = string2
        self.key_label:FindFirstChildOfClass("TextLabel").Text = string2
    end

    function keybind:set_color(color)
        Shadow.ImageColor3 = color
    end

    function keybind:set_transparency(transparency)
        Shadow.ImageTransparency = transparency
    end

    function keybind:set_list_visible(visible)
        new_keybind.Visible = visible
    end
end

do -- notifications
    function lib:AddToRegistry(Instance, Properties, IsHud)
        local Idx = #lib.Registry + 3
        local Data = {Instance = Instance, Properties = Properties, Idx = Idx}
        
        table.insert(lib.Registry, Data);
        lib.RegistryMap[Instance] = Data;
        
        if IsHud then 
            table.insert(lib.HudRegistry, Data) 
        end;
    end;

    function lib:CreateLabel(Properties, IsHud)
        local _Instance = lib:Create('TextLabel', {
            BackgroundTransparency = 1;
            Font = Enum.Font.Code;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextSize = 16;
            TextStrokeTransparency = 0; 
            RichText = true;
        });
        
        lib:AddToRegistry(_Instance, {TextColor3 =  Color3.fromRGB(255, 255, 255)}, IsHud);
        return lib:Create(_Instance, Properties);
    end;
    
    function lib:GetTextBounds(Text, Font, Size, Resolution)
        local Bounds = game:GetService('TextService'):GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
        return Bounds.X, Bounds.Y
    end;

    function lib:Create(Class, Properties)
        local _Instance = Class;
        if type(Class) == 'string' then 
            _Instance = Instance.new(Class);
        end;
        
        for Property, Value in next, Properties do 
            _Instance[Property] = Value; 
        end;
        
        return _Instance;
    end;
    
    lib.NotificationArea = lib:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0.003, 0, 0, 40);
        Size = UDim2.new(0, 300, 0, 200);
        ZIndex = 100;
        Parent = ScreenGui
    });

    lib:Create('UIListLayout', {
        Padding = UDim.new(0, 4);
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = lib.NotificationArea
    });

    lib.NotificationArea2 = lib:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0.42, 0, 0, 700);
        Size = UDim2.new(0, 300, 0, 200);
        ZIndex = 100;
        Parent = ScreenGui
    });
    
    lib:Create('UIListLayout', {
        Padding = UDim.new(0, 4);
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = 
        lib.NotificationArea2
    });

    function lib:Notify(Text, Time)
        local XSize, YSize = lib:GetTextBounds(Text, Enum.Font.Code, 14);YSize = YSize + 7
        local NotifyOuter = lib:Create('Frame', {
            BorderColor3 = Color3.new(189, 172, 255);
            Position = UDim2.new(0, 100, 0, 10);
            Size = UDim2.new(0, 0, 0, YSize);
            ClipsDescendants = true;
            Transparency = 0,
            ZIndex = 100;
            Parent = lib.NotificationArea
        });
        lib:Create('UIGradient', {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)), 
                ColorSequenceKeypoint.new(0.1, Color3.fromRGB(14, 14, 14)), 
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(14, 14, 14)), 
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
            },
            Rotation = -120;
            Parent = NotifyOuter
        });
        local NotifyInner = lib:Create('Frame', {
            BackgroundColor3 = Color3.fromRGB(14, 14, 14);
            BorderColor3 = Color3.fromRGB(15, 15, 15);
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 101;
            Parent = NotifyOuter
        });
        
        local InnerFrame = lib:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, -2, 1, -2);
            ZIndex = 102;
            Parent = NotifyInner;
        });

        local Line = lib:Create('Frame', {
            BackgroundColor3 = lib.accent_color;
            BorderSizePixel = 0;
            Position = UDim2.new(1, 0, 0.97, 0);
            Size = UDim2.new(-0.999, -0.5, 0, 1.9);
            ZIndex = 102;
            Parent = NotifyInner;
        });

        local LeftColor = lib:Create('Frame', {
            BackgroundColor3 = lib.accent_color;
            BorderSizePixel = 0;
            Position = UDim2.new(0, -1, 0, 22);
            Size = UDim2.new(0, 2, -1.2, 0);
            ZIndex = 104;
            Parent = NotifyOuter;
        });

        local Gradient = lib:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
            });
            Rotation = -90;
            Parent = InnerFrame
        });
    
        lib:AddToRegistry(NotifyInner, {
            BackgroundColor3 = Color3.fromRGB(14, 14, 14);
            BorderColor3 = Color3.fromRGB(15, 15, 15);
        }, true);

        lib:AddToRegistry(Gradient, {
            Color = function() 
                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
                }); 
            end
        });

        lib:CreateLabel({
            Position = UDim2.new(0, 6, 0, 0);
            Size = UDim2.new(1, -4, 1, 0);
            Text = Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextSize = 14;
            ZIndex = 103;
            Parent = InnerFrame
        });

        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), 'Out', 'Quad', 0.6, true);
        pcall(LeftColor.TweenSize, LeftColor, UDim2.new(0, 2, 0, 0), 'Out', 'Linear', 1, true);
        wait(0.9)
        pcall(Line.TweenSize, Line, UDim2.new(0, 0, 0, 2), 'Out', 'Linear', Time, true);
        task.spawn(function()
            wait(Time or 5);
            pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);
            wait(0.4);
            NotifyOuter:Destroy();
        end);
    end;

    function lib:Notify2(Text, Time)
        local XSize, YSize = lib:GetTextBounds(Text, Enum.Font.Code, 14);YSize = YSize + 7
        local NotifyOuter = lib:Create('Frame', {
            BorderColor3 = Color3.new(189, 172, 255);
            Position = UDim2.new(0, 100, 0, 10);
            Size = UDim2.new(0, 0, 0, YSize);
            ClipsDescendants = true;
            BackgroundTransparency = 1,
            ZIndex = 100;
            Parent = lib.NotificationArea
        });
        lib:Create('UIGradient', {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)), 
                ColorSequenceKeypoint.new(0.1, Color3.fromRGB(14, 14, 14)), 
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(14, 14, 14)), 
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
            },
            Rotation = -120;
            Parent = NotifyOuter
        });
        local NotifyInner = lib:Create('Frame', {
            BackgroundColor3 = Color3.fromRGB(14, 14, 14);
            BorderColor3 = Color3.fromRGB(15, 15, 15);
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 101;
            BackgroundTransparency = 1,
            Parent = NotifyOuter
        });
        
        local InnerFrame = lib:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, -2, 1, -2);
            ZIndex = 102;
            BackgroundTransparency = 1,
            Parent = NotifyInner;
        });

        local LeftColor = lib:Create('Frame', {
            BackgroundColor3 = lib.accent_color;
            BorderSizePixel = 0;
            Position = UDim2.new(0, -1, 0, 22);
            Size = UDim2.new(0, 2, -1.2, 0);
            ZIndex = 104;
            BackgroundTransparency = 1,
            Parent = NotifyOuter;
        });

        local Gradient = lib:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
            });
            Rotation = -90;
            Parent = InnerFrame
        });
    
        lib:AddToRegistry(NotifyInner, {
            BackgroundColor3 = Color3.fromRGB(14, 14, 14);
            BorderColor3 = Color3.fromRGB(15, 15, 15);
        }, true);

        lib:AddToRegistry(Gradient, {
            Color = function() 
                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
                }); 
            end
        });

        lib:CreateLabel({
            Position = UDim2.new(0, 6, 0, 0);
            Size = UDim2.new(1, -4, 1, 0);
            Text = Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextSize = 14;
            ZIndex = 103;
            Parent = InnerFrame
        });

        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), 'Out', 'Quad', 0.6, true);
        task.spawn(function()
            wait(Time or 5);
            pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);
            wait(0.4);
            NotifyOuter:Destroy();
        end);
    end;

    function lib:Notify3(Text, Time)
        local XSize, YSize = lib:GetTextBounds(Text, Enum.Font.Code, 14);YSize = YSize + 7
        local NotifyOuter = lib:Create('Frame', {
            BorderColor3 = Color3.new(189, 172, 255);
            Position = UDim2.new(0, 100, 0, 10);
            Size = UDim2.new(0, 0, 0, YSize);
            ClipsDescendants = true;
            BackgroundTransparency = 1,
            ZIndex = 100;
            Parent = lib.NotificationArea2
        });
        lib:Create('UIGradient', {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)), 
                ColorSequenceKeypoint.new(0.1, Color3.fromRGB(14, 14, 14)), 
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(14, 14, 14)), 
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
            },
            Rotation = -120;
            Parent = NotifyOuter
        });
        local NotifyInner = lib:Create('Frame', {
            BackgroundColor3 = Color3.fromRGB(14, 14, 14);
            BorderColor3 = Color3.fromRGB(15, 15, 15);
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 101;
            BackgroundTransparency = 1,
            Parent = NotifyOuter
        });
        
        local InnerFrame = lib:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, -2, 1, -2);
            ZIndex = 102;
            BackgroundTransparency = 1,
            Parent = NotifyInner;
        });

        local LeftColor = lib:Create('Frame', {
            BackgroundColor3 = lib.accent_color;
            BorderSizePixel = 0;
            Position = UDim2.new(0, -1, 0, 22);
            Size = UDim2.new(0, 2, -1.2, 0);
            ZIndex = 104;
            BackgroundTransparency = 1,
            Parent = NotifyOuter;
        });

        local Gradient = lib:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
            });
            Rotation = -90;
            Parent = InnerFrame
        });
    
        lib:AddToRegistry(NotifyInner, {
            BackgroundColor3 = Color3.fromRGB(14, 14, 14);
            BorderColor3 = Color3.fromRGB(15, 15, 15);
        }, true);

        lib:AddToRegistry(Gradient, {
            Color = function() 
                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 14))
                }); 
            end
        });

        lib:CreateLabel({
            Position = UDim2.new(0, 6, 0, 0);
            Size = UDim2.new(1, -4, 1, 0);
            Text = Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextSize = 14;
            ZIndex = 103;
            Parent = InnerFrame
        });

        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), 'Out', 'Quad', 0.6, true);
        task.spawn(function()
            wait(Time or 5);
            pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);
            wait(0.4);
            NotifyOuter:Destroy();
        end);
    end;
end;

local watermark = {}

watermark.__index = watermark

    local wm = {
        label = nil,
        user = user,
        game = game,
        main = nil,
    }

    do
        local Watermark = -- Converted: Use UI Library's Instance creation functions("Frame", {
            BackgroundColor3 = colorfromrgb(35, 35, 35);
            BorderColor3 = colorfromrgb(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(0, 0, 0, 30);
            Position = UDim2.new(0,0,0,0);
            Visible = false;
            Parent = global_sg
        }); wm.main = Watermark
        local BackCorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
            CornerRadius = UDim.new(0, 3);
            Parent = Watermark
        })
        local Border = -- Converted: Use UI Library's Instance creation functions("Frame", {
            BackgroundColor3 = colorfromrgb(255, 255, 255);
            BorderColor3 = colorfromrgb(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, -2, 1, -2);
            Parent = Watermark
        })
        local InsideCorner = -- Converted: Use UI Library's Instance creation functions("UICorner", {
            CornerRadius = UDim.new(0, 3);
            Parent = Border
        })
        local Gradient = -- Converted: Use UI Library's Instance creation functions("UIGradient", {
            Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(29, 29, 29)), ColorSequenceKeypoint.new(1.00, colorfromrgb(20, 20, 20))};
            Rotation = 90;
            Parent = Border
        })
        local Text = -- Converted: Use UI Library's Instance creation functions("TextLabel", {
            BackgroundColor3 = colorfromrgb(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = colorfromrgb(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 28, 0, 0);
            Size = UDim2.new(1, -33, 1, 0);
            Font = Enum.Font.ArialBold;
            TextColor3 = colorfromrgb(170, 170, 170);
            TextSize = 11.000;
            TextWrapped = true;
            TextXAlignment = Enum.TextXAlignment.Left;
            RichText = true;
            Parent = Border
        })

        wm.label = Text
        wm.main = Watermark

        util:set_draggable(Watermark)
    end

    setmetatable(wm, watermark)

    return wm
end)

function watermark:update_text()
    local user, game_name = self.user, self.game
    local accent_color = lib.accent_color

    local label = self.label
    local time_text = os.date("%I:%M")
    local time_suffix = lower(os.date("%p"))
    local color = tostring(util:round(accent_color.R*255))..", "..tostring(util:round(accent_color.G*255))..", "..tostring(util:round(accent_color.B*255))

    self.main.Size = UDim2.new(0, texts:GetTextSize((string.format("%s | %s | %s %s", user, game_name, time_text, time_suffix)), 11, "ArialBold", vect2(999,999)).X + 36, 0, 30)
    self.label.Text = string.format("%s <font color=\"rgb(35, 35, 35)\">|</font> %s <font color=\"rgb(35, 35, 35)\">|</font> <font color=\"rgb("..color..")\">%s</font> %s", user, game_name, time_text, time_suffix)
end

local flags = lib.flags;

local workspace = game:GetService("Workspace");
local user_input_service = game:GetService("UserInputService");
local lighting = game:GetService("Lighting");
local players = game:GetService("Players");
local run_service = game:GetService("RunService");
local replicated_storage = game:GetService("ReplicatedStorage");
local http_service = game:GetService("HttpService");
local stats = game:GetService("Stats");
local tween_service = game:GetService("TweenService");