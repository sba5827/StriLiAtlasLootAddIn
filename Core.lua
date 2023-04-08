local EventFrame =  CreateFrame("FRAME");
local addonLoaded, AtlasLootLoaded = false, false;
local CharWhishList = nil;
local ItemID, ItemName, ItemBoss = 2, 4, 5
local itemLinkPatern = "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?";

local _, _, _, StriLiEnabled = GetAddOnInfo("StriLi")

local function getItemIdFromString(aString) 
	local _, _, _, _, Id = string.find(aString, itemLinkPatern);
	return tonumber(Id);
end

local function isItemInWishList(aString)
	  
	for i = 1, table.getn(CharWhishList) do
		for j = 1, table.getn(CharWhishList[i]) do
			if tonumber(CharWhishList[i][j][ItemID]) == getItemIdFromString(aString) then
				return tonumber(CharWhishList[i][j][ItemID]);
			end
		end
	end
	
	return nil;
end

local function removeFromAtlasWishlist(itemID)
	for i = 1, table.getn(CharWhishList) do
		for j = 1, table.getn(CharWhishList[i]) do
			if tonumber(CharWhishList[i][j][ItemID]) == itemID then
				CharWhishList[i][j] = nil;
			end
		end
	end
end

local function informPlayerOnDemand(textMessage)

	local charName = UnitName("player");
	CharWhishList = AtlasLootWishList["Own"][charName];
	if not select(3, string.find(textMessage, "|c(.+)|r")) then return end
	local itemLink = "|c"..select(3, string.find(textMessage, "|c(.+)|r")).."|r"

	if isItemInWishList(itemLink) then
		ItemRollInformFrame_show(itemLink, getItemIdFromString(itemLink));
	end
end

local function localOnEvent(event, ...)
	
	if event == "ADDON_LOADED" then
		if arg1 == "StriLiAtlasLootAddIn" then
			addonLoaded = true;
			if IsAddOnLoaded("AtlasLoot") then
				AtlasLootLoaded = true;
			end
			if not StriLiEnabled then
				StriLi_initAddon();
			end
		elseif arg1 == "AtlasLoot" then
			AtlasLootLoaded = true;
		end
		
		if addonLoaded and AtlasLootLoaded and (CharWhishList == nil) then 
			local charName = UnitName("player");
			CharWhishList = AtlasLootWishList["Own"][charName];
			EventFrame:RegisterEvent("CHAT_MSG_RAID_WARNING");
			EventFrame:RegisterEvent("CHAT_MSG_LOOT");
			EventFrame:RegisterEvent("PLAYER_LOGOUT");
			if not StriLiEnabled then
				EventFrame:RegisterEvent("CHAT_MSG_ADDON");
			end
			EventFrame:UnregisterEvent("ADDON_LOADED");
		end
	elseif event == "CHAT_MSG_RAID_WARNING" then
		informPlayerOnDemand(arg1);
	elseif event == "CHAT_MSG_LOOT" then
		if string.find(arg1, "Ihr erhaltet") or string.find(arg1, "Ihr bekommt") then
			if isItemInWishList(arg1) then
				print("StriLiAtlasLootAddIn entfernt erhaltenes Item von der Wunschliste: ".."|c"..select(3, string.find(arg1, "|c(.+)|r")).."|r")
			end
			removeFromAtlasWishlist(getItemIdFromString("|c"..select(3, string.find(arg1, "|c(.+)|r")).."|r"))
		end
	elseif event == "PLAYER_LOGOUT" and not StriLiEnabled then
		StriLi_finalizeAddon();
	elseif event == "CHAT_MSG_ADDON" and not StriLiEnabled then
		StriLi.CommunicationHandler:On_CHAT_MSG_ADDON(...);
	end
	
end

EventFrame:SetScript("OnEvent", function(_, event, ...) localOnEvent(event, ...); end);
EventFrame:RegisterEvent("ADDON_LOADED");