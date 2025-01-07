-- Load localization
local L = OriMouseToolTip.Localization

-- Load OMTT
local OMTT = OriMouseToolTip.OMTT

local AceConfig = LibStub("AceConfig-3.0")
local options = {
    name = L["Name"],
    type = "group",
    args = {
        general = {
            type = "group",
            name = L["Options_UI_GeneralSettings"],
            inline = true,
            args = {
                debug = {
                    type = "toggle",
                    name = L["Debug"],
                    desc = L["PrintHelp_Command_Debug"],
                    get = function(info) return OMTT.db.profile.debug end,
                    set = function(info, value) OMTT:ToggleDebug() end,
                    order = 1,
                },
                resetToDefaults = {
                    type = "execute",
                    name = L["Options_UI_General_Reset"],
                    desc = L["Options_UI_General_ResetDesc"],
                    func = function()
                        StaticPopup_Show("OMTT_RESET_CONFIRM")
                    end,
                    order = 2,
                },
            },
        },
        tooltip = {
            type = "group",
            name = L["Options_UI_TooltipSettings"],
            inline = true,
            args = {
                anchor = {
                    type = "select",
                    name = L["Options_UI_TooltipSettings_Anchor"],
                    desc = L["Options_UI_TooltipSettings_AnchorDesc"],
                    values = {
                        TOPLEFT = L["Options_UI_TooltipSettings_Anchor_TopLeft"],
                        TOP = L["Options_UI_TooltipSettings_Anchor_Top"],
                        TOPRIGHT = L["Options_UI_TooltipSettings_Anchor_TopRight"],
                        LEFT = L["Options_UI_TooltipSettings_Anchor_Left"],
                        CENTER = L["Options_UI_TooltipSettings_Anchor_Center"],
                        RIGHT = L["Options_UI_TooltipSettings_Anchor_Right"],
                        BOTTOMLEFT = L["Options_UI_TooltipSettings_Anchor_BottomLeft"],
                        BOTTOM = L["Options_UI_TooltipSettings_Anchor_Bottom"],
                        BOTTOMRIGHT = L["Options_UI_TooltipSettings_Anchor_BottomRight"],
                        ANCHOR_CURSOR = L["Options_UI_TooltipSettings_Anchor_Cursor"],
                    },
                    get = function(info) return OMTT.db.profile.anchor end,
                    set = function(info, value)
                        OMTT.db.profile.anchor = value
                        OriMouseToolTip:OMTTPrint(L["Options_UI_TooltipSettings_Anchor_SetDebug"] .. value, "debug")
                    end,
                    order = 1, -- Anchor dropdown on its own row
                },
                offsets = {
                    type = "group",
                    name = L["Options_UI_TooltipSettings_Offsets"],
                    inline = true, -- Inline to share the same row
                    args = {
                        xOffset = {
                            type = "input",
                            name = L["Options_UI_TooltipSettings_Offsets_X"],
                            desc = L["Options_UI_TooltipSettings_Offsets_XDesc"],
                            get = function(info) return tostring(OMTT.db.profile.xOffset) end,
                            set = function(info, value)
                                local num = tonumber(value)
                                if num then
                                    OMTT.db.profile.xOffset = num
                                    OriMouseToolTip:OMTTPrint(L["Options_UI_TooltipSettings_Offsets_XSetDebug"] .. num, "debug")
                                end
                            end,
                            order = 1,
                        },
                        yOffset = {
                            type = "input",
                            name = L["Options_UI_TooltipSettings_Offsets_Y"],
                            desc = L["Options_UI_TooltipSettings_Offsets_YDesc"],
                            get = function(info) return tostring(OMTT.db.profile.yOffset) end,
                            set = function(info, value)
                                local num = tonumber(value)
                                if num then
                                    OMTT.db.profile.yOffset = num
                                    OriMouseToolTip:OMTTPrint(L["Options_UI_TooltipSettings_Offsets_YSetDebug"] .. num, "debug")
                                end
                            end,
                            order = 2,
                        },
                    },
                    order = 2, -- Group appears below Anchor
                },
                classColors = {
                    type = "toggle",
                    name = L["Options_UI_TooltipSettings_ClassColors"],
                    desc = L["Options_UI_TooltipSettings_ClassColorsDesc"],
                    get = function(info) return OMTT.db.profile.classColors end,
                    set = function(info, value) OMTT:ToggleClassColors() end,
                    order = 3,
                }
            },
        },
    },
}

function OMTT:SetupOptions()
    -- Register options table
    LibStub("AceConfig-3.0"):RegisterOptionsTable(L["Name"], options)

    -- Add to Blizzard's Interface Options
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L["Name"], L["Name"])
end
