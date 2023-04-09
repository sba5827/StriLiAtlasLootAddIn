local EventFrame =  CreateFrame("FRAME");
local addonLoaded, AtlasLootLoaded = false, false;
local CharWishList = nil;
local ItemID, ItemName, ItemBoss = 2, 4, 5
local itemLinkPatern = "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?";
local playerTradeDone, firstCallItemChange = false, true;
local timerFrame = CreateFrame("Frame")
local waitTimeAfterTrade = 0.5; --after trading, items in bag are not updated instant.

local _, _, _, StriLiEnabled = GetAddOnInfo("StriLi")


local function getItemIdFromString(aString) 
	local _, _, _, _, Id = string.find(aString, itemLinkPatern);
	return tonumber(Id);
end

local function isItemInWishList(aString)
	  
	for i = 1, table.getn(CharWishList) do
		for j = 1, table.getn(CharWishList[i]) do
			if tonumber(CharWishList[i][j][ItemID]) == getItemIdFromString(aString) then
				return tonumber(CharWishList[i][j][ItemID]);
			end
		end
	end
	
	return nil;
end

local function removeFromAtlasWishlist(itemID)

	local found = true;

	while found do
		found = false;
		for i = 1, table.getn(CharWishList) do
			for j = 1, table.getn(CharWishList[i]) do
				if CharWishList[i][j] then
					if tonumber(CharWishList[i][j][ItemID]) == itemID then
						found = true;
						table.remove(CharWishList[i], j);
					end
				end
			end
		end
	end

end

local function checkForAtlasLoot()
	local _, _, _, AtlasLootEnabled = GetAddOnInfo("AtlasLoot")

	if not AtlasLootEnabled then
		print("|cffff3333 AtlasLoot not found. This Addon only works properly with AtlasLoot installed/enabled. |r");
	end
end

local function checkForReceivedItem(bagID)
	local numberOfSlots = GetContainerNumSlots(bagID);

	for i = 1, numberOfSlots do
		local itemId = GetContainerItemID(bagID, i);
		if itemId ~= nil then
			removeFromAtlasWishlist(itemId);
		end
	end

end

local function informPlayerOnDemand(textMessage)

	local charName = UnitName("player");
	CharWishList = AtlasLootWishList["Own"][charName];
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
		
		if addonLoaded and AtlasLootLoaded and (CharWishList == nil) then
			local charName = UnitName("player");
			CharWishList = AtlasLootWishList["Own"][charName];
			EventFrame:RegisterEvent("CHAT_MSG_RAID_WARNING");
			EventFrame:RegisterEvent("TRADE_ACCEPT_UPDATE");
			EventFrame:RegisterEvent("BAG_UPDATE");
			EventFrame:RegisterEvent("PLAYER_LOGOUT");
			if not StriLiEnabled then
				EventFrame:RegisterEvent("CHAT_MSG_ADDON");
			end
			EventFrame:UnregisterEvent("ADDON_LOADED");
			checkForAtlasLoot();
		end
	elseif event == "CHAT_MSG_RAID_WARNING" then
		informPlayerOnDemand(arg1);
	elseif event == "PLAYER_LOGOUT" and not StriLiEnabled then
		StriLi_finalizeAddon();
	elseif event == "CHAT_MSG_ADDON" and not StriLiEnabled then
		StriLi.CommunicationHandler:On_CHAT_MSG_ADDON(...);
	elseif event == "TRADE_ACCEPT_UPDATE"then
		if (arg1 == 1) and (arg2 == 1) then
			playerTradeDone = true;
		end
	elseif event == "BAG_UPDATE" and playerTradeDone then
		if arg1 < 0 then return end -- smaller than zero is not an bagID where items are stored from a trade.
		playerTradeDone = false; --only if trade is done the BAG_UPDATE was called from an item receive ore remove from this trade. Other can be ignored.

		local timeToWait = waitTimeAfterTrade;
		local bagID = arg1;
		timerFrame:SetScript("OnUpdate", function(_, elapsed)

			timeToWait = timeToWait - elapsed;
			if timeToWait < 0.0 then
				-- time exceeded
				timerFrame:SetScript("OnUpdate", nil);
				checkForReceivedItem(bagID);
			end
		end);

	end
	
end

EventFrame:SetScript("OnEvent", function(_, event, ...) localOnEvent(event, ...); end);
EventFrame:RegisterEvent("ADDON_LOADED");