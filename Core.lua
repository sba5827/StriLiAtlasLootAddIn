local EventFrame =  CreateFrame("FRAME");
local addonLoaded, AtlasLootLoaded = false, false;
local CharWhishList = nil;
local ItemID, ItemName, ItemBoss = 2, 4, 5
local itemLinkPatern = "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?";

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

local function informPlayerOnDemand(textMessage)

	local charName = UnitName("player");
	CharWhishList = AtlasLootWishList["Own"][charName];

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
		elseif arg1 == "AtlasLoot" then
			AtlasLootLoaded = true;
		end
		
		if addonLoaded and AtlasLootLoaded and (CharWhishList == nil) then 
			local charName = UnitName("player");
			CharWhishList = AtlasLootWishList["Own"][charName];
			EventFrame:RegisterEvent("CHAT_MSG_RAID_WARNING");
			EventFrame:UnregisterEvent("ADDON_LOADED");
		end
	elseif event == "CHAT_MSG_RAID_WARNING" then
		informPlayerOnDemand(arg1);
	end
	
end

EventFrame:SetScript("OnEvent", function(_, event, ...) localOnEvent(event, ...); end);
EventFrame:RegisterEvent("ADDON_LOADED");