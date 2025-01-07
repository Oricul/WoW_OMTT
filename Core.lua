-- Shared namespace
OriMouseToolTip = OriMouseToolTip or {}

-- Load localization
local L = OriMouseToolTip.Localization

-- Load Ace3
OriMouseToolTip.OMTT = LibStub("AceAddon-3.0"):NewAddon(L["Name"], "AceConsole-3.0", "AceEvent-3.0")
local OMTT = OriMouseToolTip.OMTT

-- Default settings
local defaults = {
    profile = {
        xOffset = 20,
        yOffset = -20,
        anchor = "TOPLEFT",
        debug = false,
        classColors = true,
    },
}

-- Reset button static window
StaticPopupDialogs["OMTT_RESET_CONFIRM"] = {
    text = L["ResetDialog_Text"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        -- Reset settings to defaults
        OMTT.db:ResetProfile()
        LibStub("AceConfigRegistry-3.0"):NotifyChange(L["Name"])
        OriMouseToolTip:OMTTPrint(L["ResetDialog_Confirmed"])
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

-- Formatted message
function OriMouseToolTip:OMTTPrint(msg,msgType)
    -- Ensure capitalization normalization or set default value
    msgType = msgType or "normal"
    msgType = string.lower(msgType)
    -- Set message types and it's colors/format
    local validTypes = {
        normal = "|cFF00FFFF[" .. L["Name"] .. "]|r ", -- Cyan, "[Name] "
        debug = "|cFF00FF00[" .. L["Name"] .. " " .. L["Debug"] .. "]|r ", -- Green, "[Name Debug]"
        warning = "|cFFFFFF00[" .. L["Name"] .. " " .. L["Warning"] .. "]|r ", -- Yellow, "[Name Warning]"
        error = "|cFFFF0000[" .. L["Name"] .. " " .. L["Error"] .. "]|r ", -- Red, "[Name Error]"
    }
    -- Select the appropriate message prefix
    local prefix = validTypes[msgType]
    -- If prefix wasn't set, invalid msgType was defined
    if not prefix then
        error("Invalid OMTTPrint msgType: " .. tostring(msgType))
        return
    end
    -- Ignore debug messages if debug isn't set
    if msgType == "debug" and not self.OMTT.db.profile.debug then
        return
    end
    -- Print formatted message
    print(prefix .. msg)
end

-- DB validator
function OMTT:ValidateDB()
    local profile = self.db.profile
    if type(profile.xOffset) ~= "number" then profile.xOffset = defaults.profile.xOffset end
    if type(profile.yOffset) ~= "number" then profile.yOffset = defaults.profile.yOffset end
    if type(profile.anchor) ~= "string" then profile.anchor = defaults.profile.anchor end
    if type(profile.debug) ~= "boolean" then profile.debug = defaults.profile.debug end
end

-- Init
function OMTT:OnInitialize()
    -- DB
    self.db = LibStub("AceDB-3.0"):New("OMTT_DB", defaults)
    self:ValidateDB()
    OriMouseToolTip:OMTTPrint(L["OnInitialize_Debug_Enabled"], "debug")

    -- Init Options
    self:SetupOptions()

    -- Slash command
    self:RegisterChatCommand("OMTT", "CommandParser")
    OriMouseToolTip:OMTTPrint(L["OnInitialize_Debug_SlashCmds"], "debug")
end

-- Enabled
function OMTT:OnEnable()
    OriMouseToolTip:OMTTPrint(string.format(L["OnEnable_Debug_Enabled"],
        self.db.profile.anchor,
        self.db.profile.xOffset,
        self.db.profile.yOffset
    ), "debug")
end

-- Disabled
function OMTT:OnDisable()
    OriMouseToolTip:OMTTPrint(L["OnDisable_Disabled"], "debug")
end

-- Debug toggle
function OMTT:ToggleDebug()
    self.db.profile.debug = not self.db.profile.debug
    OriMouseToolTip:OMTTPrint(L["ToggleDebug_DebugChange"] .. (self.db.profile.debug and L["Toggle_Enabled"] or L["Toggle_Disabled"]))
end

-- Class color toggle
function OMTT:ToggleClassColors()
    self.db.profile.classColors = not self.db.profile.classColors
    OriMouseToolTip:OMTTPrint(L["Cmd_Colorize_Toggled"] .. (self.db.profile.classColors and L["Toggle_Enabled"] or L["Toggle_Disabled"]))
end

function OMTT:PrintHelp()
    OriMouseToolTip:OMTTPrint(L["PrintHelp_Usage"])
    OriMouseToolTip:OMTTPrint(L["PrintHelp_Commands"])
    OriMouseToolTip:OMTTPrint("  help - " .. L["PrintHelp_Command_Help"])
    OriMouseToolTip:OMTTPrint("  debug - " .. L["PrintHelp_Command_Debug"])
    OriMouseToolTip:OMTTPrint("  offset <x|y> <number> - " .. L["PrintHelp_Command_Offset"])
    OriMouseToolTip:OMTTPrint("  anchor <anchor_point> - " .. L["PrintHelp_Command_Anchor"])
    OriMouseToolTip:OMTTPrint("  colorize - " .. L["PrintHelp_Command_Colorize"])
end

-- Subcommand parser
function OMTT:CommandParser(input)
    if not input or input:trim() == "" then
        OriMouseToolTip:OMTTPrint(L["Cmd_OpenSettings"])
        LibStub("AceConfigDialog-3.0"):Open(L["Name"])
        return
    end

    -- Split input into arguments
    local args = {strsplit(" ", input)}
    local command = args[1]:lower()

    if command == "help" then
        self:PrintHelp()
    elseif command == "debug" then
        self:ToggleDebug()
    elseif command == "offset" then
        local axis = string.lower(args[2] or "")
        local value = tonumber(args[3])
        if axis == "x" and value then
            self.db.profile.xOffset = value
            OriMouseToolTip:OMTTPrint(L["Cmd_Offset_X"] .. value)
        elseif axis == "y" and value then
            self.db.profile.yOffset = value
            OriMouseToolTip:OMTTPrint(L["Cmd_Offset_Y"] .. value)
        else
            OriMouseToolTip:OMTTPrint(L["Cmd_Offset_Invalid"], "error")
        end
    elseif command == "anchor" then
        local anchor = string.upper(args[2] or "")
        local validAnchors = {
            TOPLEFT = true, TOP = true, TOPRIGHT = true,
            LEFT = true, CENTER = true, RIGHT = true,
            BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
            ANCHOR_CURSOR = true,
        }
        if validAnchors[anchor] then
            self.db.profile.anchor = anchor
            OriMouseToolTip:OMTTPrint(L["Cmd_Anchor_Set"] .. anchor)
        else
            OriMouseToolTip:OMTTPrint(L["Cmd_Anchor_Invalid"], "error")
        end
    elseif command == "colorize" then
        OMTT:ToggleClassColors()
    else
        OriMouseToolTip:OMTTPrint(L["PrintHelp_UnknownCommand"] .. command, "warning")
        self:PrintHelp()
        return
    end
    LibStub("AceConfigRegistry-3.0"):NotifyChange(L["Name"])
end

-- **************************************
-- ** Actual functionality starts here **
-- **************************************

-- For coloring tooltips
function RGBToHex(r, g, b)
    -- Ensure the RGB values are within the range [0, 1]
    r = math.max(0, math.min(1, r))
    g = math.max(0, math.min(1, g))
    b = math.max(0, math.min(1, b))

    -- Convert to hexadecimal
    return string.format("%02X%02X%02X", r * 255, g * 255, b * 255)
end

-- Hook into GameTooltip anchor
-- hooksecurefunc is a built-in WoW function
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    local anchor = OMTT.db.profile.anchor or "ANCHOR_CURSOR"
    tooltip:SetOwner(parent, anchor)
end)

-- Adjust tooltip position dynamically
function OMTT:PositionTooltip(tooltip)
    -- Grab set options
    local anchor = OMTT.db.profile.anchor or "ANCHOR_CURSOR"
    local xOffset = OMTT.db.profile.xOffset or defaults.profile.xOffset
    local yOffset = OMTT.db.profile.yOffset or defaults.profile.yOffset

    -- Get some UI info
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()

    -- Clear any other set location
    tooltip:ClearAllPoints()

    -- Apply offsets
    if anchor == "ANCHOR_CURSOR" then anchor = "BOTTOMLEFT" end
    tooltip:SetPoint(anchor, UIParent, "BOTTOMLEFT", (x / scale) + xOffset, (y / scale) + yOffset)
end
GameTooltip:HookScript("OnUpdate", function(self)
    OMTT:PositionTooltip(self)
end)
GameTooltip:HookScript("OnShow", function(self)
    OMTT:PositionTooltip(self)
end)

-- Define a backdrop template for the tooltip
local BACKDROP_TEMPLATE = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

-- Enhance tooltip content
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local _, unit = self:GetUnit()
    if unit and UnitIsPlayer(unit) then
        if OMTT.db.profile.classColors then
            local classColor = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
            local class = select(2, UnitClass(unit))
            local color = classColor[class] or { r = 1, g = 1, b = 1 }

            -- Create a background texture if it doesn't already exist
            if not self.bg then
                self.bg = self:CreateTexture(nil, "BACKGROUND")
                self.bg:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
                self.bg:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
                self.bg:SetColorTexture(0, 0, 0, 0.8)
            end

            -- Set the background to the player's class color
            self.bg:SetColorTexture(color.r, color.g, color.b, 0.5)
        end

        -- Add guild information
        local guildName = GetGuildInfo(unit)
        if guildName then
            self:AddLine("<" .. guildName .. ">", 0, 1, 0)
        end
    end
end)

-- Reset background color when tooltip is cleared
GameTooltip:HookScript("OnTooltipCleared", function(self)
    if self.bg then
        -- Reset to default color (black with slight transparency)
        self.bg:SetColorTexture(0, 0, 0, 0.8)
    end
end)