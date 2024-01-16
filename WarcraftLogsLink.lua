-- Function to handle the Copy WarcraftLogs button functionality
local function copyWarcraftLogsButton(self)
    -- Check if the clicked button is the Copy WarcraftLogs button
    if self.value == "copyWarcraftLogsButton" then
        -- Get the unit name from the dropdown menu
        local dropdownMenu = _G["UIDROPDOWNMENU_INIT_MENU"]
        local unitName = dropdownMenu.name

        -- Check if a valid unit name is available
        if unitName then
            -- Get the server name and replace spaces with dashes
            local serverName = GetRealmName():gsub(" ", "-")
            -- Set the default region to "us"
            local region = "us" 
            -- Construct the WarcraftLogs URL using the region, server, and unit name
            local warcraftLogsURL = "https://vanilla.warcraftlogs.com/character/" .. region .. "/" .. serverName .. "/" .. unitName
            -- Check if the client is running on macOS
            local isMac = IsMacClient() 

            -- Define the StaticPopupDialog for displaying the URL
            StaticPopupDialogs["COPY_WARCRAFT_LOGS_URL"] = {
                text = string.format("Copy Warcraft Logs URL - Press %s+C to Copy", isMac and "Cmd" or "Ctrl"),
                button2 = CLOSE,
                hasEditBox = true,
                editBoxWidth = 350,
                -- Function called when Enter is pressed in the edit box
                EditBoxOnEnterPressed = function(self)
                    self:GetParent():Hide()
                end,
                -- Function called when Escape is pressed in the edit box
                EditBoxOnEscapePressed = function(self)
                    self:GetParent():Hide()
                end,
                -- Function called when the dialog is shown
                OnShow = function(self)
                    -- Set the edit box text to the WarcraftLogs URL
                    self.editBox:SetText(warcraftLogsURL)
                    self.editBox:SetFocus()
                    self.editBox:HighlightText()

                    -- Function called when a key is pressed in the edit box
                    self.editBox:SetScript("OnKeyDown", function(_, key)
                        -- Check if the pressed key is 'C' and the Control key is down
                        if key == "C" and IsControlKeyDown() then
                            -- After a delay, hide the dialog, copy to clipboard, and display a message
                            C_Timer.After(0.1, function()
                                self.editBox:GetParent():Hide()
                                ActionStatus_DisplayMessage("Copied WarcraftLogs URL to clipboard", true)
                            end)
                        end
                    end)
                end
            }

            -- Show the StaticPopupDialog for displaying the URL
            StaticPopup_Show("COPY_WARCRAFT_LOGS_URL")
        end
    end
end

-- Hook into the UnitPopup_ShowMenu function to add the Copy WarcraftLogs button
hooksecurefunc("UnitPopup_ShowMenu", function()
    -- Check if the dropdown menu level is greater than 1
    if (UIDROPDOWNMENU_MENU_LEVEL > 1) then
        return
    end

    -- Create the dropdown menu information for the Copy WarcraftLogs button
    local info = UIDropDownMenu_CreateInfo()
    info.text = "Copy WarcraftLogs Link"
    info.notCheckable = 1
    info.func = copyWarcraftLogsButton
    info.colorCode = "|cFFFFD700"
    info.value = "copyWarcraftLogsButton"

    -- Add the Copy WarcraftLogs button to the dropdown menu
    UIDropDownMenu_AddButton(info)
end)
