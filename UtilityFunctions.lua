local _, _, _, StriLiEnabled = GetAddOnInfo("StriLi")
if not StriLiEnabled then

function protect(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(t, key, value)
            error("attempting to change constant " ..
                    tostring(key) .. " to " .. tostring(value), 2)
        end
    })
end

CONSTS = protect({
    itemLinkPatern = "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?",
    nextWordPatern = "([^%s]+)%s?(.*)",
    nextLinePatern = "([^\n]*)\n?(.*)",
    msgColorStringStart = "|cffFFFF00",
    msgColorStringEnd = "|r",
    striLiMsgFlag = "|cffFFFF00<|r|cff33FFF2StriLi|r|cffFFFF00>|r ",                                                                    
});

function StriLi_isPlayerMaster()
    return StriLi.master:get() == UnitName("player");
end                                
function StriLi_GetRaidIndexOfPlayer(playerName)

    for i = 1, GetNumRaidMembers(), 1 do
        local name = GetRaidRosterInfo(i);
        if (name == playerName) then
            return i
        end
    end

    return 0;

end

function StriLi_initAddon()

    --StriLi.InitLang()

    --local addonVersion = tonumber(GetAddOnMetadata("StriLiAtlasLootAddIn", "Version"));

    if StriLi_LatestVersion ~= nil then
        --Secure that StriLi_LatestVersion will never be a String.
        StriLi_LatestVersion = tonumber(StriLi_LatestVersion);
    end

    if StriLi_LatestVersion == nil then
        StriLi_LatestVersion = 0.0;
    elseif StriLi_LatestVersion < 0.0 then
        StriLi_LatestVersion = 0.0;
    end
    if StriLi_Master == nil then
        StriLi.master = ObservableString:new();
        StriLi.master:set("");
    else
        StriLi.master = ObservableString:new();
        StriLi.master:set(StriLi_Master);
    end
    if StriLi_newRaidGroup == nil then
        StriLi_newRaidGroup = true;
    end
    if StriLi_RaidMembersDB_members == nil then
        StriLi_RaidMembersDB_members ={};
    end
    if StriLi_ItemHistory == nil then
        StriLi_ItemHistory = {};
    end
    if StriLi_RulesTxt == nil then
        StriLi_RulesTxt = "";
    end       
    if StriLiOptions == nil then
        StriLiOptions = {
            ["DUMMY"] = false,
            ["DUMMY2"] = false,
        };
    end

    RaidMembersDB:initFromRawData(StriLi_RaidMembersDB_members);
    StriLi.ItemHistory:initFromRawData(StriLi_ItemHistory);

    StriLi.CommunicationHandler:ShoutVersion();

end

function StriLi_finalizeAddon()
    StriLi_RaidMembersDB_members = RaidMembersDB:getRawData();
    StriLi_Master = StriLi.master:get();
    StriLi_ItemHistory = StriLi.ItemHistory:getRawData();
end

---removes the first occurring 'value'
function table.removeByValue(list, value)
    for i, v in pairs(list) do
        if v == value then
            return table.remove(list,i);
        end
    end
end

end