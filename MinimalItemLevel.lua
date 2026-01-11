local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if addon == "MinimalItemLevel" then
        local function UpdateSlot(button)
            local slotID = button:GetID()
            -- Exclui Shirt (4) e Tabard (19)
            if not slotID or slotID < INVSLOT_FIRST_EQUIPPED or slotID > INVSLOT_LAST_EQUIPPED or slotID == 4 or slotID == 19 then
                if button.ilvlText then button.ilvlText:Hide() end
                return
            end

            local unit = (InspectFrame and InspectFrame:IsShown() and InspectFrame.unit) or "player"
            local link = GetInventoryItemLink(unit, slotID)
            if not link then
                if button.ilvlText then button.ilvlText:Hide() end
                return
            end

            local _, _, quality, ilvl = GetItemInfo(link)
            if not ilvl or ilvl <= 0 then
                if button.ilvlText then button.ilvlText:Hide() end
                return
            end

            local r, g, b = GetItemQualityColor(quality or 1)

            local fs = button.ilvlText
            if not fs then
                fs = button:CreateFontString(nil, "OVERLAY")
                fs:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2)
                fs:SetJustifyH("RIGHT")
                -- FONTE CUSTOM: Expressway.ttf
                fs:SetFont("Interface\\AddOns\\MinimalItemLevel\\Fonts\\Expressway.ttf", 12, "OUTLINE")
                fs:SetShadowOffset(1, -1)
                fs:SetShadowColor(0, 0, 0, 1)
                button.ilvlText = fs
            end

            fs:SetTextColor(r, g, b)
            fs:SetText(ilvl)
            fs:Show()
        end

        hooksecurefunc("PaperDollItemSlotButton_Update", UpdateSlot)  -- Seu char (C)
        hooksecurefunc("InspectPaperDollItemSlotButton_Update", UpdateSlot)  -- Inspect alvo

        f:RegisterEvent("INSPECT_READY")
        f:SetScript("OnEvent", function(self, event)
            if event == "INSPECT_READY" and InspectFrame:IsShown() then
                InspectPaperDollFrame_UpdateButtons()  -- Refresh slots
            end
        end)
    end
end)