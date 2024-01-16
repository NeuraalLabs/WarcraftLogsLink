local function copyWarcraftLogsButton(self)
    if self.value == "copyWarcraftLogsButton" then
        local dropdownMenu = _G["UIDROPDOWNMENU_INIT_MENU"]
        local unitName = dropdownMenu.name

        if unitName then
            local serverName = GetRealmName():gsub(" ", "-")
            local region = "us"
            local warcraftLogsURL = "https://vanilla.warcraftlogs.com/character/" .. region .. "/" .. serverName .. "/" .. unitName
            local isMac = IsMacClient() 
            StaticPopupDialogs["COPY_WARCRAFT_LOGS_URL"] = {
                text = string.format("Copy Warcraft Logs URL - Press %s+C to Copy", isMac and "Cmd" or "Ctrl"),
 
                button2 = CLOSE,
                hasEditBox = true,
                editBoxWidth = 350,
                EditBoxOnEnterPressed = function(self)
                    self:GetParent():Hide()
                end,
                EditBoxOnEscapePressed = function(self)
                    self:GetParent():Hide()
                end,
                OnShow = function(self)
                    self.editBox:SetText(warcraftLogsURL)
                    self.editBox:SetFocus()
                    self.editBox:HighlightText()

                    self.editBox:SetScript("OnKeyDown", function(_, key)
                        if key == "C" and IsControlKeyDown() then
                            C_Timer.After(0.1, function()
                                self.editBox:GetParent():Hide()
                                ActionStatus_DisplayMessage("Copied WarcraftLogs URL to clipboard", true)
                            end)
                        end
                    end)
                end
            }

            StaticPopup_Show("COPY_WARCRAFT_LOGS_URL")
        end
    end
end

hooksecurefunc("UnitPopup_ShowMenu", function()
    if (UIDROPDOWNMENU_MENU_LEVEL > 1) then
        return
    end

    local info = UIDropDownMenu_CreateInfo()
    info.text = "Copy WarcraftLogs Link"
    info.notCheckable = 1
    info.func = copyWarcraftLogsButton
    info.colorCode = "|cFFFFD700"
    info.value = "copyWarcraftLogsButton"

    UIDropDownMenu_AddButton(info)
end)

