-- Heirloom Deliver Addon
HeirloomDeliver = HeirloomDeliver or {}
local AddonName, private = ...

-- Configuration variables
HeirloomDeliver.Config = {
    MAX_RETRY_ATTEMPTS = 6,           -- Max number of times to retry failed deliveries
    DELIVERY_DELAY = 2,               -- Delay between delivering each item (seconds)
    RETRY_DELAY = 2,                  -- Delay between retry attempts (seconds)
    VERIFICATION_DELAY = 2            -- Delay before verifying delivery (seconds)
}

-- Create main frame with better background
HeirloomDeliver.Frame = CreateFrame("Frame", "HeirloomDeliverFrame", UIParent, "BasicFrameTemplate")
local Frame = HeirloomDeliver.Frame

Frame:SetSize(480, 600)  -- Taller for better layout
Frame:SetPoint("CENTER")
Frame:SetMovable(true)
Frame:EnableMouse(true)
Frame:RegisterForDrag("LeftButton")
Frame.TitleText:SetText("Heirloom Set Delivery")
Frame:Hide()

-- Add solid black background
Frame.Background = Frame:CreateTexture(nil, "BACKGROUND")
Frame.Background:SetAllPoints()
Frame.Background:SetColorTexture(0, 0, 0, 1)  -- Solid black

-- Set data with full descriptions for tooltips
HeirloomDeliver.Sets = {
    {
        id = 1,
        name = "Burnished Armor of Might",
        armor = "MAIL",
        stat = "STRENGTH",
        role = "TANK",
        description = "Mail tanking set with Block, Defense, Dodge",
        tooltip = "As you level up, this MAIL set will provide you with the following stats:\n\n- Block Value\n- Defense Rating\n- Dodge Rating\n- Hit Rating\n- Stamina\n- Strength\n- +70% EXP from Quests & Monsters (Additive)",
        items = {
            "Burnished Observer's Shield",
            "Pendant of the Bulwark",
            "Ring of the Bulwark",
            "Ring of the Bulwark", -- 2x
            "Strengthened Cloak of Might",
            "Burnished Belt of Might",
            "Burnished Boots of Might",
            "Burnished Bracers of Might",
            "Burnished Platelegs of Might",
            "Burnished Helmet of Might",
            "Burnished Gauntlets of Might",
            "Swift Hand of Justice",
            "Swift Hand of Justice", -- 2x
            "Burnished Spaulders of Might",
            "Burnished Breastplate of Might"
        }
    },
    {
        id = 2,
        name = "Preened Ironfeather Armor",
        armor = "LEATHER",
        stat = "INTELLECT",
        role = "HEALER/CASTER",
        description = "Leather intellect set for spellcasters",
        tooltip = "As you level up, this LEATHER set will provide you with the following stats:\n\n- Critical Strike Rating\n- Intellect\n- Stamina\n- Spirit\n- Spell Power\n- +70% EXP from Quests & Monsters (Additive)",
        items = {
            "Pendant of the Sorcerer",
            "Ring of the Sorcerer",
            "Ring of the Seer",
            "Preened Ironfeather Cloak",
            "Preened Ironfeather Belt",
            "Preened Ironfeather Boots",
            "Preened Ironfeather Bracers",
            "Preened Ironfeather Legguards",
            "Preened Ironfeather Headguard",
            "Preened Ironfeather Gloves",
            "Preened Ironfeather Shoulders",
            "Discerning Eye of the Beast",
            "Discerning Eye of the Beast", -- 2x
            "Preened Ironfeather Breastplate"
        }
    },
    {
        id = 3,
        name = "Champion's Battlegear",
        armor = "MAIL",
        stat = "AGILITY/INTELLECT",
        role = "HYBRID DPS",
        description = "Mail hybrid set for agility/int users",
        tooltip = "As you level up, this MAIL set will provide you with the following stats:\n\n- Agility\n- Attack Power\n- Haste Rating\n- Hit Rating\n- Intellect\n- Stamina\n- +70% EXP from Quests & Monsters (Additive)",
        items = {
            "Pendant of the Warrior",
            "Ring of the Vanguard",
            "Ring of the Lionhearted",
            "Champion's Deathdealer Cloak",
            "Champion Herod's Belt",
            "Champion Herod's Boots",
            "Champion Herod's Bracers",
            "Champion Herod's Legguards",
            "Champion Herod's Helmet",
            "Champion Herod's Gloves",
            "Champion Herod's Shoulder",
            "Swift Hand of Justice",
            "Swift Hand of Justice", -- 2x
            "Champion's Deathdealer Breastplate"
        }
    },
    {
        id = 4,
        name = "Stained Shadowcraft Armor",
        armor = "LEATHER",
        stat = "AGILITY",
        role = "MELEE/RANGED DPS",
        description = "Leather agility set for physical DPS",
        tooltip = "As you level up, this LEATHER set will provide you with the following stats:\n\n- Agility\n- Attack Power\n- Critical Strike Rating\n- Haste Rating\n- Hit Rating\n- Stamina\n- +70% EXP from Quests & Monsters (Additive)",
        items = {
            "Pendant of the Warrior",
            "Ring of the Vanguard",
            "Ring of the Lionhearted",
            "Stained Shadowcraft Cloak",
            "Stained Shadowcraft Belt",
            "Stained Shadowcraft Boots",
            "Stained Shadowcraft Bracers",
            "Stained Shadowcraft Pants",
            "Stained Shadowcraft Hood",
            "Stained Shadowcraft Gloves",
            "Stained Shadowcraft Spaulders",
            "Swift Hand of Justice",
            "Swift Hand of Justice", -- 2x
            "Stained Shadowcraft Tunic"
        }
    },
    {
        id = 5,
        name = "The Mystical Elements Set",
        armor = "MAIL",
        stat = "INTELLECT",
        role = "HEALER/CASTER",
        description = "Mail intellect set with Mp5 for casters",
        tooltip = "As you level up, this MAIL set will provide with the following stats:\n\n- Haste Rating\n- Intellect\n- Mp5\n- Stamina\n- Spell Power\n- +70% EXP from Quests & Monsters (Additive)",
        items = {
            "Pendant of the Sorcerer",
            "Ring of the Sorcerer",
            "Ring of the Seer",
            "Mystical Cloak of Elements",
            "Mystical Belt of Elements",
            "Mystical Boots of Elements",
            "Mystical Bracers of Elements",
            "Mystical Kilt of Elements",
            "Mystical Helm of Elements",
            "Mystical Gloves of Elements",
            "Mystical Pauldrons of Elements",
            "Discerning Eye of the Beast",
            "Discerning Eye of the Beast", -- 2x
            "Mystical Vest of Elements"
        }
    },
    {
        id = 6,
        name = "Battlegear of Valor",
        armor = "MAIL",
        stat = "STRENGTH",
        role = "PHYSICAL DPS",
        description = "Mail strength DPS set with crit/haste",
        tooltip = "As you level up, this MAIL set will provide you with the following stats:\n\n- Critical Strike Rating\n- Haste Rating\n- Hit Rating\n- Stamina\n- Strength\n- +70% EXP from Quests & Monsters (Additive)",
        items = {
            "Pendant of the Warrior",
            "Ring of the Vanguard",
            "Ring of the Lionhearted",
            "Polished Cloak of Valor",
            "Polished Belt of Valor",
            "Polished Boots of Valor",
            "Polished Bracers of Valor",
            "Polished Platelegs of Valor",
            "Polished Helmet of Valor",
            "Polished Gauntlets of Valor",
            "Polished Spaulders of Valor",
            "Swift Hand of Justice",
            "Swift Hand of Justice", -- 2x
            "Polished Breastplate of Valor"
        }
    },
    {
        id = 7,
        name = "Tattered Dreadmist Raiment",
        armor = "CLOTH",
        stat = "INTELLECT",
        role = "HEALER/CASTER",
        description = "Cloth intellect set for all cloth casters",
        tooltip = "As you level up, this CLOTH set will provide you with the following stats:\n\n- Haste\n- Hit Rating\n- Intellect\n- Stamina\n- Spirit\n- Spell Power\n- +70% EXP from Quests & Monsters (Additive)",
        items = {
            "Pendant of the Sorcerer",
            "Ring of the Sorcerer",
            "Ring of the Seer",
            "Tattered Dreadmist Cloak",
            "Tattered Dreadmist Belt",
            "Tattered Dreadmist Boots",
            "Tattered Dreadmist Bracers",
            "Tattered Dreadmist Leggings",
            "Tattered Dreadmist Hood",
            "Tattered Dreadmist Gloves",
            "Tattered Dreadmist Mantle",
            "Discerning Eye of the Beast",
            "Discerning Eye of the Beast", -- 2x
            "Tattered Dreadmist Robe"
        }
    }
}

-- Helper function to count how many times an item appears in inventory
function HeirloomDeliver:CountItemInInventory(itemName)
    local count = 0
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink then
                local foundItemName = GetItemInfo(itemLink)
                if foundItemName and foundItemName == itemName then
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- Helper function to check if all items from a set are in inventory (accounting for duplicates)
function HeirloomDeliver:AreAllSetItemsInInventory(set)
    if not set or not set.items then return false end
    
    -- Count occurrences of each item in the set
    local itemRequirements = {}
    for _, itemName in ipairs(set.items) do
        itemRequirements[itemName] = (itemRequirements[itemName] or 0) + 1
    end
    
    -- Check if we have enough of each item
    for itemName, requiredCount in pairs(itemRequirements) do
        local actualCount = HeirloomDeliver:CountItemInInventory(itemName)
        if actualCount < requiredCount then
            return false
        end
    end
    
    return true
end

-- Helper function to extract item ID from item link
function HeirloomDeliver:ExtractItemIDFromLink(itemLink)
    if not itemLink then return nil end
    
    local itemID = string.match(itemLink, "item:(%d+):")
    if itemID then
        return tonumber(itemID)
    end
    
    return nil
end

-- Function to find item ID by name
function HeirloomDeliver:FindItemID(itemName)
    if not VANITY_ITEMS then 
        return nil
    end
    
    -- First try exact match
    for itemID, itemData in pairs(VANITY_ITEMS) do
        if itemData.name == itemName then
            return itemID
        end
    end
    
    -- Try case-insensitive search
    local lowerName = itemName:lower()
    for itemID, itemData in pairs(VANITY_ITEMS) do
        if itemData.name:lower() == lowerName then
            return itemID
        end
    end
    
    return nil
end

-- Function to find and delete a specific item from inventory
function HeirloomDeliver:DeleteItemFromInventory(itemName)
    -- First, try to find the item ID
    local itemID = HeirloomDeliver:FindItemID(itemName)
    if not itemID then
        print("HeirloomDeliver: Could not find item ID for: " .. itemName)
        return false
    end
    
    -- Search all bags for the item
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink then
                -- Extract item ID from the link
                local foundItemID = HeirloomDeliver:ExtractItemIDFromLink(itemLink)
                if foundItemID == itemID then
                    -- Found it! Delete it
                    PickupContainerItem(bag, slot)
                    DeleteCursorItem()
                    
                    -- Brief pause to let the deletion process
                    C_Timer.After(0.1, function() end)
                    
                    return true
                end
            end
        end
    end
    
    -- Item not found in inventory
    return false
end

-- Function to check if we own ALL items in a set (accounting for duplicates)
function HeirloomDeliver:CheckSetOwnership(set)
    if not set or not set.items then return {} end
    
    local missingItems = {}
    
    -- Count occurrences of each item in the set
    local itemRequirements = {}
    for _, itemName in ipairs(set.items) do
        itemRequirements[itemName] = (itemRequirements[itemName] or 0) + 1
    end
    
    -- Check ownership for each item
    for itemName, requiredCount in pairs(itemRequirements) do
        local itemID = HeirloomDeliver:FindItemID(itemName)
        if not itemID then
            for i = 1, requiredCount do
                table.insert(missingItems, itemName .. " (not found)")
            end
        else
            -- Check how many we own
            local ownedCount = 0
            if C_VanityCollection and C_VanityCollection.IsCollectionItemOwned then
                -- Try to check ownership - we need to call this for each instance
                for i = 1, requiredCount do
                    if not C_VanityCollection.IsCollectionItemOwned(itemID) then
                        table.insert(missingItems, itemName)
                    else
                        ownedCount = ownedCount + 1
                    end
                end
            else
                -- API not available, assume we don't own it
                for i = 1, requiredCount do
                    table.insert(missingItems, itemName)
                end
            end
        end
    end
    
    return missingItems
end

-- Function to get missing items from a set (accounting for duplicates)
function HeirloomDeliver:GetMissingItems(setIndex)
    local set = HeirloomDeliver.Sets[setIndex]
    if not set then return {} end
    
    local missingItems = {}
    
    -- Count occurrences of each item in the set
    local itemRequirements = {}
    for _, itemName in ipairs(set.items) do
        itemRequirements[itemName] = (itemRequirements[itemName] or 0) + 1
    end
    
    -- Check what we're missing
    for itemName, requiredCount in pairs(itemRequirements) do
        local actualCount = HeirloomDeliver:CountItemInInventory(itemName)
        if actualCount < requiredCount then
            local needed = requiredCount - actualCount
            for i = 1, needed do
                table.insert(missingItems, {name = itemName, id = HeirloomDeliver:FindItemID(itemName)})
            end
        end
    end
    
    return missingItems
end

-- Function to verify ALL items were delivered (accounting for duplicates)
function HeirloomDeliver:VerifySetDelivery(setIndex)
    local set = HeirloomDeliver.Sets[setIndex]
    if not set then return false end
    
    -- Count occurrences of each item in the set
    local itemRequirements = {}
    for _, itemName in ipairs(set.items) do
        itemRequirements[itemName] = (itemRequirements[itemName] or 0) + 1
    end
    
    -- Check if we have all items in inventory
    local allPresent = true
    for itemName, requiredCount in pairs(itemRequirements) do
        local actualCount = HeirloomDeliver:CountItemInInventory(itemName)
        if actualCount < requiredCount then
            print("HeirloomDeliver: Missing " .. (requiredCount - actualCount) .. " of " .. itemName)
            allPresent = false
        end
    end
    
    return allPresent
end

-- Function to deliver specific missing items with retry logic
function HeirloomDeliver:DeliverMissingItems(setIndex, missingItems, attempt)
    attempt = attempt or 1
    
    if #missingItems == 0 then
        Frame.ProgressText:SetText("✓ All items delivered")
        print("HeirloomDeliver: All items successfully delivered")
        
        C_Timer.After(2, function()
            Frame.ProgressText:Hide()
            Frame.StatusText:Show()
            HeirloomDeliver:RefreshSets()
        end)
        return
    end
    
    if attempt > HeirloomDeliver.Config.MAX_RETRY_ATTEMPTS then
        Frame.ProgressText:SetText("Failed after " .. HeirloomDeliver.Config.MAX_RETRY_ATTEMPTS .. " attempts")
        print("HeirloomDeliver: Failed to deliver all items after " .. HeirloomDeliver.Config.MAX_RETRY_ATTEMPTS .. " attempts")
        
        C_Timer.After(3, function()
            Frame.ProgressText:Hide()
            Frame.StatusText:Show()
            HeirloomDeliver:RefreshSets()
        end)
        return
    end
    
    Frame.ProgressText:SetText("Retrying missing items (Attempt " .. attempt .. "/" .. HeirloomDeliver.Config.MAX_RETRY_ATTEMPTS .. ")")
    
    local deliveredThisAttempt = 0
    local failedThisAttempt = 0
    local totalToDeliver = #missingItems
    
    -- Function to deliver the next missing item
    local function DeliverNextMissingItem(index)
        if index > totalToDeliver then
            -- All items attempted for this retry
            Frame.ProgressText:SetText("Verifying delivery...")
            
            -- Wait, then verify and retry if needed
            C_Timer.After(HeirloomDeliver.Config.VERIFICATION_DELAY, function()
                local stillMissing = HeirloomDeliver:GetMissingItems(setIndex)
                
                if #stillMissing == 0 then
                    Frame.ProgressText:SetText(string.format("✓ Delivered all items (Attempt %d)", attempt))
                    print("HeirloomDeliver: Successfully delivered all items on attempt " .. attempt)
                    
                    C_Timer.After(2, function()
                        Frame.ProgressText:Hide()
                        Frame.StatusText:Show()
                        HeirloomDeliver:RefreshSets()
                    end)
                else
                    print("HeirloomDeliver: Still missing " .. #stillMissing .. " items after attempt " .. attempt)
                    
                    -- Try again with remaining missing items
                    C_Timer.After(HeirloomDeliver.Config.RETRY_DELAY, function()
                        HeirloomDeliver:DeliverMissingItems(setIndex, stillMissing, attempt + 1)
                    end)
                end
            end)
            return
        end
        
        local itemData = missingItems[index]
        
        -- Update progress text
        Frame.ProgressText:SetText(string.format("Retrying... (%d/%d) - Attempt %d/%d", 
            index, totalToDeliver, attempt, HeirloomDeliver.Config.MAX_RETRY_ATTEMPTS))
        
        if itemData.id then
            -- Try to deliver the item
            local success, errorMsg = pcall(function()
                return RequestDeliverVanityCollectionItem(itemData.id)
            end)
            
            if success then
                deliveredThisAttempt = deliveredThisAttempt + 1
            else
                failedThisAttempt = failedThisAttempt + 1
                print("HeirloomDeliver: ERROR delivering " .. itemData.name .. ": " .. tostring(errorMsg))
            end
        else
            failedThisAttempt = failedThisAttempt + 1
            print("HeirloomDeliver: Could not find item ID for: " .. itemData.name)
        end
        
        -- Schedule next item delivery with configurable delay
        C_Timer.After(HeirloomDeliver.Config.DELIVERY_DELAY, function()
            DeliverNextMissingItem(index + 1)
        end)
    end
    
    -- Start delivering missing items
    DeliverNextMissingItem(1)
end

-- Function to show detailed delete confirmation with all items listed
function HeirloomDeliver:DeleteSetFromInventory(setIndex)
    local set = HeirloomDeliver.Sets[setIndex]
    if not set then return end
    
    -- Count how many items are actually in inventory (accounting for duplicates)
    local itemsFound = {}
    local itemCounts = {}
    
    for _, itemName in ipairs(set.items) do
        local count = HeirloomDeliver:CountItemInInventory(itemName)
        if count > 0 then
            for i = 1, count do
                table.insert(itemsFound, itemName)
            end
        end
    end
    
    if #itemsFound == 0 then
        print("HeirloomDeliver: No items from " .. set.name .. " found in inventory.")
        return
    end
    
    -- Create detailed confirmation text with all items listed
    local confirmationText = "Delete |cffff0000" .. #itemsFound .. "|r items from:\n\n|cffffd700" .. set.name .. "|r\n\n|cffffffffItems to delete:|r\n"
    
    -- Group duplicate items
    local groupedItems = {}
    for _, itemName in ipairs(itemsFound) do
        groupedItems[itemName] = (groupedItems[itemName] or 0) + 1
    end
    
    -- Add each item to the list
    local maxItemsToShow = 20
    local itemCount = 0
    for itemName, count in pairs(groupedItems) do
        if itemCount < maxItemsToShow then
            if count > 1 then
                confirmationText = confirmationText .. "• " .. itemName .. " (x" .. count .. ")\n"
            else
                confirmationText = confirmationText .. "• " .. itemName .. "\n"
            end
            itemCount = itemCount + 1
        else
            break
        end
    end
    
    if #itemsFound > maxItemsToShow then
        confirmationText = confirmationText .. "... and " .. (#itemsFound - maxItemsToShow) .. " more items\n"
    end
    
    confirmationText = confirmationText .. "\n|cffff0000This will permanently delete these items from your inventory!|r"
    
    -- Show confirmation dialog
    StaticPopupDialogs["HEIRLOOMDELIVER_DELETE_CONFIRM"] = {
        text = confirmationText,
        button1 = "Delete All Items",
        button2 = "Cancel",
        OnAccept = function()
            HeirloomDeliver:PerformDeleteSetFromInventory(setIndex)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
        showAlert = true,
        hasEditBox = false,
        enterClicksFirstButton = false
    }
    
    StaticPopup_Show("HEIRLOOMDELIVER_DELETE_CONFIRM")
end

function HeirloomDeliver:PerformDeleteSetFromInventory(setIndex)
    local set = HeirloomDeliver.Sets[setIndex]
    if not set then return end
    
    Frame.ProgressText:SetText("Deleting items from " .. set.name .. "...")
    Frame.ProgressText:Show()
    Frame.StatusText:Hide()
    
    local deleted = 0
    local notFound = 0
    local total = #set.items
    
    -- Function to delete the next item
    local function DeleteNextItem(index)
        if index > total then
            -- All items attempted
            Frame.ProgressText:SetText(string.format("Deleted %d/%d items", deleted, total))
            
            if notFound > 0 then
                print("HeirloomDeliver: " .. notFound .. " items not found in inventory")
            end
            
            print("HeirloomDeliver: Deleted " .. deleted .. " items from " .. set.name)
            
            -- Refresh display after delay
            C_Timer.After(2, function()
                Frame.ProgressText:Hide()
                Frame.StatusText:Show()
                HeirloomDeliver:RefreshSets()
            end)
            return
        end
        
        local itemName = set.items[index]
        
        -- Update progress text
        Frame.ProgressText:SetText(string.format("Deleting... (%d/%d)", index, total))
        
        -- Try to find and delete the item from inventory
        local foundAndDeleted = HeirloomDeliver:DeleteItemFromInventory(itemName)
        
        if foundAndDeleted then
            deleted = deleted + 1
        else
            notFound = notFound + 1
        end
        
        -- Schedule next item deletion with a small delay
        C_Timer.After(0.5, function()
            DeleteNextItem(index + 1)
        end)
    end
    
    -- Start deleting items
    DeleteNextItem(1)
end

-- Function to deliver a set with verification and retry logic
function HeirloomDeliver:DeliverSet(setIndex)
    local set = HeirloomDeliver.Sets[setIndex]
    if not set then return end
    
    -- First check if all items are already in inventory
    if HeirloomDeliver:AreAllSetItemsInInventory(set) then
        print("HeirloomDeliver: All items from " .. set.name .. " are already in your inventory.")
        Frame.ProgressText:SetText("Items already in inventory")
        Frame.ProgressText:Show()
        Frame.StatusText:Hide()
        
        C_Timer.After(2, function()
            Frame.ProgressText:Hide()
            Frame.StatusText:Show()
            HeirloomDeliver:RefreshSets()
        end)
        return
    end
    
    Frame.ProgressText:SetText("Delivering " .. set.name .. "...")
    Frame.ProgressText:Show()
    Frame.StatusText:Hide()
    
    -- Check ownership first
    local missingItems = HeirloomDeliver:CheckSetOwnership(set)
    if #missingItems > 0 then
        Frame.ProgressText:SetText("Missing " .. #missingItems .. " items")
        print("HeirloomDeliver: Cannot deliver " .. set.name)
        print("Missing items:")
        for _, itemName in ipairs(missingItems) do
            print("  - " .. itemName)
        end
        C_Timer.After(3, function()
            Frame.ProgressText:Hide()
            Frame.StatusText:Show()
            HeirloomDeliver:RefreshSets()
        end)
        return
    end
    
    -- Deliver items with delays between each
    local delivered = 0
    local failed = 0
    local total = #set.items
    
    -- Function to deliver the next item
    local function DeliverNextItem(index)
        if index > total then
            -- All items attempted, now verify delivery with retry logic
            Frame.ProgressText:SetText("Verifying delivery...")
            
            -- Wait a moment for items to appear in inventory, then verify
            C_Timer.After(HeirloomDeliver.Config.VERIFICATION_DELAY, function()
                local allDelivered = HeirloomDeliver:VerifySetDelivery(setIndex)
                
                if allDelivered then
                    Frame.ProgressText:SetText(string.format("✓ Delivered %d/%d items", delivered, total))
                    print("HeirloomDeliver: Successfully delivered and verified " .. set.name)
                    
                    C_Timer.After(2, function()
                        Frame.ProgressText:Hide()
                        Frame.StatusText:Show()
                        HeirloomDeliver:RefreshSets()
                    end)
                else
                    -- Some items are missing, get the list and retry
                    local missingItems = HeirloomDeliver:GetMissingItems(setIndex)
                    Frame.ProgressText:SetText(string.format("Missing %d items, retrying...", #missingItems))
                    print("HeirloomDeliver: " .. #missingItems .. " items missing, starting retry process")
                    
                    C_Timer.After(HeirloomDeliver.Config.RETRY_DELAY, function()
                        HeirloomDeliver:DeliverMissingItems(setIndex, missingItems, 1)
                    end)
                end
            end)
            return
        end
        
        local itemName = set.items[index]
        local itemID = HeirloomDeliver:FindItemID(itemName)
        
        if itemID then
            -- Update progress text
            Frame.ProgressText:SetText(string.format("Delivering... (%d/%d)", index, total))
            
            -- Try to deliver the item - use pcall to catch any errors
            local success, errorMsg = pcall(function()
                return RequestDeliverVanityCollectionItem(itemID)
            end)
            
            if success then
                -- Function didn't error
                delivered = delivered + 1
            else
                -- Function errored
                failed = failed + 1
                print("HeirloomDeliver: ERROR delivering " .. itemName .. ": " .. tostring(errorMsg))
            end
        else
            failed = failed + 1
            print("HeirloomDeliver: Could not find item ID for: " .. itemName)
        end
        
        -- Schedule next item delivery with configurable delay
        C_Timer.After(HeirloomDeliver.Config.DELIVERY_DELAY, function()
            DeliverNextItem(index + 1)
        end)
    end
    
    -- Start delivering items
    DeliverNextItem(1)
end

-- Create scroll frame for sets - CENTERED
Frame.ScrollFrame = CreateFrame("ScrollFrame", nil, Frame, "UIPanelScrollFrameTemplate")
Frame.ScrollFrame:SetPoint("TOP", 0, -100)
Frame.ScrollFrame:SetWidth(400)  -- Fixed width for centering
Frame.ScrollFrame:SetPoint("BOTTOM", 0, 40)

-- Hide the scroll bar elements (they have different names in the template)
Frame.ScrollFrame.ScrollBar:Hide()
Frame.ScrollFrame.ScrollBar.ScrollUpButton:Hide()
Frame.ScrollFrame.ScrollBar.ScrollDownButton:Hide()
Frame.ScrollFrame.ScrollBar.ThumbTexture:Hide()
Frame.ScrollFrame.ScrollBar:SetAlpha(0)

Frame.ScrollChild = CreateFrame("Frame")
Frame.ScrollChild:SetSize(400, 1)
Frame.ScrollFrame:SetScrollChild(Frame.ScrollChild)

-- Enable mouse wheel scrolling
Frame.ScrollFrame:EnableMouseWheel(true)
Frame.ScrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local scrollBar = self.ScrollBar
    local currentScroll = scrollBar:GetValue()
    local minScroll, maxScroll = scrollBar:GetMinMaxValues()
    
    if delta > 0 then
        scrollBar:SetValue(currentScroll - 50)  -- Scroll up
    else
        scrollBar:SetValue(currentScroll + 50)  -- Scroll down
    end
end)

-- Filter container frame - CENTERED
Frame.FilterContainer = CreateFrame("Frame", nil, Frame)
Frame.FilterContainer:SetSize(430, 60)
Frame.FilterContainer:SetPoint("TOP", 0, -30)

-- Filter title - CENTERED
Frame.FilterTitle = Frame.FilterContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
Frame.FilterTitle:SetPoint("TOP", 0, 0)
Frame.FilterTitle:SetText("Filter by:")

-- Filter buttons - Centered layout
local filterTypes = {
    {name = "All", key = "ALL"},
    {name = "Cloth", key = "CLOTH"},
    {name = "Leather", key = "LEATHER"},
    {name = "Mail", key = "MAIL"},
    {name = "Tank", key = "TANK"},
    {name = "Healer", key = "HEALER"},
    {name = "DPS", key = "DPS"},
    {name = "Hybrid", key = "HYBRID"}
}

HeirloomDeliver.FilterButtons = {}

local buttonWidth = 70
local buttonHeight = 22
local buttonSpacing = 5
local buttonsPerRow = 4

-- Calculate total width for centering
local totalRowWidth = (buttonWidth * buttonsPerRow) + (buttonSpacing * (buttonsPerRow - 1))

for i, filter in ipairs(filterTypes) do
    local row = math.floor((i-1)/buttonsPerRow)
    local col = (i-1) % buttonsPerRow
    
    local btn = CreateFrame("Button", nil, Frame.FilterContainer, "UIPanelButtonTemplate")
    btn:SetSize(buttonWidth, buttonHeight)
    btn:SetText(filter.name)
    
    -- Calculate centered position for each button
    local xOffset = -totalRowWidth/2 + (col * (buttonWidth + buttonSpacing)) + buttonWidth/2
    local yOffset = -20 - (row * (buttonHeight + 5))
    
    btn:SetPoint("TOP", Frame.FilterContainer, "TOP", xOffset, yOffset)
    
    btn.filterKey = filter.key
    btn:SetScript("OnClick", function(self)
        HeirloomDeliver:ApplyFilter(self.filterKey)
    end)
    
    HeirloomDeliver.FilterButtons[i] = btn
end

-- Status text - CENTERED
Frame.StatusText = Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
Frame.StatusText:SetPoint("BOTTOM", 0, 10)
Frame.StatusText:SetText("Ready")

-- Progress text (for delivery) - CENTERED
Frame.ProgressText = Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
Frame.ProgressText:SetPoint("BOTTOM", 0, 10)
Frame.ProgressText:SetText("")
Frame.ProgressText:Hide()

-- Function to create set display with tooltip
function HeirloomDeliver:CreateSetDisplay(set, index, parent)
    local display = CreateFrame("Frame", nil, parent)
    display:SetSize(350, 85)
    
    -- Center the display within the scroll child
    display:SetPoint("TOP", parent, "TOP", 0, -(index-1)*90)
    
    -- Make the entire frame respond to mouse for tooltip
    display:EnableMouse(true)
    display:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(set.armor .. " - " .. set.name, 1, 1, 1)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(set.tooltip, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    
    display:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    -- Background with border
    display.Background = display:CreateTexture(nil, "BACKGROUND")
    display.Background:SetAllPoints()
    display.Background:SetColorTexture(0.15, 0.15, 0.15, 0.8)
    
    display.Border = display:CreateTexture(nil, "BORDER")
    display.Border:SetAllPoints()
    display.Border:SetColorTexture(0.3, 0.3, 0.3, 1)
    
    -- Set name
    display.Name = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    display.Name:SetPoint("TOPLEFT", 10, -5)
    display.Name:SetText(set.armor .. " - " .. set.name)
    display.Name:SetJustifyH("LEFT")
    
    -- Stats/Role
    display.Stats = display:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    display.Stats:SetPoint("TOPLEFT", display.Name, "BOTTOMLEFT", 0, -5)
    display.Stats:SetText(set.stat .. " | " .. set.role)
    display.Stats:SetJustifyH("LEFT")
    
    -- Description
    display.Desc = display:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    display.Desc:SetPoint("TOPLEFT", display.Stats, "BOTTOMLEFT", 0, -5)
    display.Desc:SetText(set.description)
    display.Desc:SetJustifyH("LEFT")
    display.Desc:SetWidth(200)
    
    -- Button container
    display.ButtonContainer = CreateFrame("Frame", nil, display)
    display.ButtonContainer:SetSize(150, 25)
    display.ButtonContainer:SetPoint("RIGHT", 0, 0)
    
    -- Deliver button
    display.DeliverButton = CreateFrame("Button", nil, display.ButtonContainer, "UIPanelButtonTemplate")
    display.DeliverButton:SetSize(75, 22)
    display.DeliverButton:SetPoint("LEFT", 0, 0)
    display.DeliverButton:SetText("Deliver")
    
    -- Check ownership
    local missingItems = HeirloomDeliver:CheckSetOwnership(set)
    local ownedCount = #set.items - #missingItems
    
    -- Check if all items are in bag (accounting for duplicates)
    local allItemsInBag = HeirloomDeliver:AreAllSetItemsInInventory(set)
    
    -- Delete button (only show if all items are in bag)
    display.DeleteButton = CreateFrame("Button", nil, display.ButtonContainer, "UIPanelButtonTemplate")
    display.DeleteButton:SetSize(60, 22)
    display.DeleteButton:SetPoint("RIGHT", -5, 0)
    display.DeleteButton:SetText("Delete")
	
	-- Get the font string and adjust its position
	local deleteButtonText = display.DeleteButton:GetFontString()
	if deleteButtonText then
		deleteButtonText:ClearAllPoints()
		deleteButtonText:SetPoint("CENTER", 0, -2)  -- Move down 2 pixels
	end
    
    -- Style delete button differently (red)
    if deleteButtonText then
        deleteButtonText:SetTextColor(1, 0.2, 0.2)
    end
    
    -- Only show delete button if all items are in bag
    if allItemsInBag then
        display.DeleteButton:Show()
        display.DeliverButton:Disable()
        display.DeliverButton:SetText("Delivered")
        
        -- Style the disabled deliver button
        local deliverButtonText = display.DeliverButton:GetFontString()
        if deliverButtonText then
            deliverButtonText:SetTextColor(0.5, 0.5, 0.5)
        end
    else
        display.DeleteButton:Hide()
        -- Adjust deliver button position if delete button is hidden
        display.DeliverButton:SetPoint("CENTER", display.ButtonContainer, "CENTER", 0, 0)
    end
    
    -- Button tooltip handling
    display.DeliverButton:SetScript("OnEnter", function(self)
        if allItemsInBag then
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText("Already Delivered", 0.5, 0.5, 0.5)
            GameTooltip:AddLine("All items from this set are already in your inventory.", 1, 1, 1, true)
            GameTooltip:Show()
        else
            GameTooltip:Hide()
        end
    end)
    
    display.DeliverButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    display.DeleteButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Delete Items", 1, 0.2, 0.2)
        GameTooltip:AddLine("Deletes all items from this set", 1, 1, 1, true)
        GameTooltip:AddLine("that are currently in your inventory.", 1, 1, 1, true)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("(Only shows when all set items are in your bags)", 0.5, 0.5, 0.5)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Warning: This action cannot be undone!", 1, 0.5, 0)
        GameTooltip:Show()
    end)
    
    display.DeleteButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    -- Store set index for callbacks
    display.DeliverButton.setIndex = index
    display.DeleteButton.setIndex = index
    
    -- Set button scripts
    display.DeliverButton:SetScript("OnClick", function(self)
        if not allItemsInBag then
            HeirloomDeliver:DeliverSet(self.setIndex)
        end
    end)
    
    display.DeleteButton:SetScript("OnClick", function(self)
        HeirloomDeliver:DeleteSetFromInventory(self.setIndex)
    end)
    
    -- Ownership text
    display.Owned = display:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    display.Owned:SetPoint("BOTTOMLEFT", 10, 5)
    
    if #missingItems == 0 then
        if allItemsInBag then
            display.Owned:SetText(string.format("✓ In Inventory (%d items)", #set.items))
            display.Owned:SetTextColor(0, 1, 0)  -- Green
        else
            display.Owned:SetText(string.format("✓ Ready (%d items)", #set.items))
            display.Owned:SetTextColor(0, 1, 0)  -- Green
        end
    else
        display.Owned:SetText(string.format("Owned: %d/%d", ownedCount, #set.items))
        display.Owned:SetTextColor(1, 0.5, 0)  -- Orange
        display.DeliverButton:Disable()
        display.DeliverButton:SetText("Missing Items")
		
        
        -- Also style the disabled button text
        local deliverButtonText = display.DeliverButton:GetFontString()
        if deliverButtonText then
            deliverButtonText:SetTextColor(0.5, 0.5, 0.5)
        end
    end
	
	if deliverButtonText then
        deliverButtonText:SetPoint("CENTER", 0, -2)  -- Move down 2 pixels
    end
	
    
	
    display.setIndex = index
    return display
end

-- Function to check if set matches filter
function HeirloomDeliver:SetMatchesFilter(set, filter)
    if not set then return false end
    
    if filter == "ALL" or not filter then
        return true
    end
    
    local filterUpper = filter:upper()
    
    -- Armor type filters
    if filterUpper == "CLOTH" or filterUpper == "LEATHER" or filterUpper == "MAIL" then
        return set.armor:upper() == filterUpper
    end
    
    -- Role filters
    if filterUpper == "TANK" then
        return set.role:upper() == "TANK"
    end
    
    if filterUpper == "HEALER" then
        return set.role:upper():find("HEALER") or set.role:upper():find("CASTER")
    end
    
    if filterUpper == "DPS" then
        return set.role:upper():find("DPS") or 
               set.role:upper():find("MELEE") or 
               set.role:upper():find("RANGED") or
               set.role:upper():find("HEALER") or
               set.role:upper():find("CASTER")
    end
    
    if filterUpper == "HYBRID" then
        return set.role:upper():find("HYBRID")
    end
    
    return false
end

-- Function to refresh set displays
function HeirloomDeliver:RefreshSets()
    -- Clear existing displays
    for _, child in ipairs({Frame.ScrollChild:GetChildren()}) do
        child:Hide()
    end
    
    local currentFilter = HeirloomDeliver.currentFilter or "ALL"
    
    local visibleSets = {}
    for i, set in ipairs(HeirloomDeliver.Sets) do
        if HeirloomDeliver:SetMatchesFilter(set, currentFilter) then
            table.insert(visibleSets, {index = i, set = set})
        end
    end
    
    -- Update status
    Frame.StatusText:SetText(string.format("Showing %d of %d sets", #visibleSets, #HeirloomDeliver.Sets))
    
    -- Create displays for visible sets
    local totalHeight = 0
    for i, data in ipairs(visibleSets) do
        local display = HeirloomDeliver:CreateSetDisplay(data.set, data.index, Frame.ScrollChild)
        display:SetPoint("TOP", Frame.ScrollChild, "TOP", 0, -(i-1)*90)
        display:Show()
        totalHeight = totalHeight + 90
    end
    
    Frame.ScrollChild:SetHeight(math.max(totalHeight, 1))
end

-- Function to apply filter
function HeirloomDeliver:ApplyFilter(filter)
    if filter then
        HeirloomDeliver.currentFilter = filter
        -- Highlight the active filter button
        for _, btn in ipairs(HeirloomDeliver.FilterButtons) do
            if btn.filterKey == filter then
                btn:LockHighlight()
            else
                btn:UnlockHighlight()
            end
        end
    end
    
    HeirloomDeliver:RefreshSets()
end

-- Slash command to show/hide frame
SLASH_HEIRLOOMDELIVER1 = "/heirlooms"
SLASH_HEIRLOOMDELIVER2 = "/hd"

SlashCmdList["HEIRLOOMDELIVER"] = function(msg)
    if Frame:IsShown() then
        Frame:Hide()
    else
        Frame:Show()
        HeirloomDeliver:ApplyFilter("ALL")
    end
end

-- Event handling
Frame:RegisterEvent("ADDON_LOADED")
Frame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "HeirloomDeliver" then
        print("HeirloomDeliver loaded. Type /heirlooms or /hd to open.")
        
        -- Initial refresh after a delay to ensure VANITY_ITEMS is loaded
        C_Timer.After(2, function()
            if VANITY_ITEMS then
                local count = 0
                for _ in pairs(VANITY_ITEMS) do count = count + 1 end
            else
                print("HeirloomDeliver: VANITY_ITEMS not found. Make sure vanity store is loaded.")
            end
            HeirloomDeliver:ApplyFilter("ALL")
        end)
    end
end)

-- Make frame draggable from title area
Frame:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        self:StartMoving()
    end
end)

Frame:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
        self:StopMovingOrSizing()
    end
end)

Frame:SetScript("OnDragStart", Frame.StartMoving)
Frame:SetScript("OnDragStop", Frame.StopMovingOrSizing)