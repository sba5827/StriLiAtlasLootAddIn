local _, _, _, StriLiEnabled = GetAddOnInfo("StriLi")
if not StriLiEnabled then

StriLi.ItemHistory = { items = {}, players = {}, rollTypes = {}, rolls = {}, playerClasses = {}, count = 0, };

local function getItemID_fromLink(itemLink)

    assert(type(itemLink) == "string");
    local firstChar = string.sub(itemLink, 1, 1);
    assert(firstChar == "|");

    local _, _, _, _, Id = string.find(itemLink, CONSTS.itemLinkPatern)

    return Id;

end

function StriLi.ItemHistory:init()

end

function StriLi.ItemHistory:add(itemLink, player, playerClass, rollType, roll, externIndex)

    if externIndex ~= nil and externIndex <= self.count then
        return;
    end

    assert(type(player) == "string");
    assert(type(playerClass) == "string");
    assert(type(rollType) == "string");
    --assert(type(roll) == "number" or roll == "edited");

    local itemId = getItemID_fromLink(itemLink);

    table.insert(self.items, itemLink);
    table.insert(self.players, player);
    table.insert(self.playerClasses, playerClass);
    table.insert(self.rollTypes, rollType);
    table.insert(self.rolls, roll);

    self.count = self.count + 1;

end

function StriLi.ItemHistory:On_ItemHistoryChanged(itemLink, player, playerClass, rollType, roll, index)

    assert(type(player) == "string");
    assert(type(playerClass) == "string");
    assert(type(rollType) == "string");
    --assert(type(roll) == "number" or roll == "edited");

    local itemId = getItemID_fromLink(itemLink);

    self.items[index] = itemLink;
    self.players[index] = player;
    self.playerClasses[index] = playerClass;
    self.rollTypes[index] = rollType;
    self.rolls[index] = roll;

end

function StriLi.ItemHistory:remove(index)

    assert(type(index) == "number");

    if StriLi.master:get() == UnitName("player") then -- if not master this function was called by communication handler -> only edit UI.
        local exists, raidMember = pcall(RaidMembersDB.get, RaidMembersDB ,self.players[index]);

        if exists then
            if raidMember[self.rollTypes[index]]:get() > 0 then
                raidMember[self.rollTypes[index]]:sub(1);
            else
                return;
            end
        end
    end

    table.remove(self.items, index);
    table.remove(self.players, index);
    table.remove(self.playerClasses, index);
    table.remove(self.rollTypes, index);
    table.remove(self.rolls, index);

    self.count = self.count - 1;

    StriLi.CommunicationHandler:Send_ItemHistoryRemove(index);

end

function StriLi.ItemHistory:editItem(itemLink, index)

    assert(type(index) == "number");

    local itemId = getItemID_fromLink(itemLink);

    self.items[index] = itemLink;

    StriLi.ItemHistory:Send_ItemHistoryChanged(index)

end

function StriLi.ItemHistory:editRollType(rollType, index)

    assert(type(rollType) == "string");
    assert(type(index) == "number");

    local exists = RaidMembersDB:checkForMember(self.players[index]);

    if exists then
        local raidMember = RaidMembersDB:get(self.players[index]);

        if raidMember[self.rollTypes[index]]:get() > 0 then
            raidMember[self.rollTypes[index]]:sub(1);
            raidMember[rollType]:add(1);
        else
            return;
        end
    else
        return;
    end

    self.rollTypes[index] = rollType;
    self.rolls[index] = "edited";

    StriLi.ItemHistory:Send_ItemHistoryChanged(index);

end

function StriLi.ItemHistory:editPlayer(player, playerClass, index)

    assert(type(player) == "string");
    assert(type(playerClass) == "string");
    assert(type(index) == "number");

    local oldOwner = self.players[index];

    local exists = RaidMembersDB:checkForMember(oldOwner);

    if exists then
        if RaidMembersDB:get(oldOwner)[self.rollTypes[index]]:get() > 0 then
            RaidMembersDB:get(oldOwner)[self.rollTypes[index]]:sub(1);
            RaidMembersDB:get(player)[self.rollTypes[index]]:add(1);
        else
            return;
        end
    else
        RaidMembersDB:get(player)[self.rollTypes[index]]:add(1);
    end

    self.players[index] = player;
    self.playerClasses[index] = playerClass;
    self.rolls[index] = "edited";

    StriLi.ItemHistory:Send_ItemHistoryChanged(index)

end

function StriLi.ItemHistory:Send_ItemHistoryChanged(index)
    StriLi.CommunicationHandler:Send_ItemHistoryChanged(self.items[index], self.players[index], self.playerClasses[index], self.rollTypes[index], self.rolls[index], index);
end

function StriLi.ItemHistory:reset()

    for i = 1, self.count do
        self.items = {};
        self.players = {};
        self.playerClasses = {};
        self.rollTypes = {};
        self.rolls = {};
    end

    self.count = 0;

end

function StriLi.ItemHistory:getRawData()

    local t = {};

    t["count"] = self.count;
    t["items"] = self.items;
    t["players"] = self.players;
    t["playerClasses"] = self.playerClasses;
    t["rollTypes"] = self.rollTypes;
    t["rolls"] = self.rolls;

    return t;

end

function StriLi.ItemHistory:initFromRawData(rawData)

    self:init();

    if rawData["count"] == nil then return end

    for i = 1, rawData["count"] do
        self:add(rawData["items"][i], rawData["players"][i], rawData["playerClasses"][i], rawData["rollTypes"][i], rawData["rolls"][i]);
    end

end

end