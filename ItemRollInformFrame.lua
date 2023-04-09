---------------------
---PRIVATE SECTION---
---------------------
local ItemRollInformFrame = CreateFrame("FRAME", "ItemRollInformFrame", UIParent);
local frameWidth, frameHeight = 300, 185;
local buttonWidth, buttonHeight = 50, 24;
local iconWidth, iconHeight = 46, 46;
local headerText = "Folgendes Item auf deiner Wunschliste wird verrollt.";
local itemLink = "|cffffffff|Hitem:6948:0000:0000:0000:0000:0:0:0:80|h[Das ist ein Dummy Item Text]|h|r";

local function onClickRoll(range)
    SlashCmdList["RANDOM"](range);
    ItemRollInformFrame:Hide();
end

ItemRollInformFrame:SetPoint("CENTER",0,0);
ItemRollInformFrame:SetFrameStrata("DIALOG");
ItemRollInformFrame:EnableMouse(true);
ItemRollInformFrame:SetSize(frameWidth, frameHeight);
ItemRollInformFrame:SetBackdrop({bgFile="Interface/DialogFrame/UI-DialogBox-Background",
                                 edgeFile="Interface/BUTTONS/UI-SliderBar-Border",
                                 tile=true,
                                 tileSize=32,
                                 edgeSize = 8,
                                 insets = { left = 1, right = 1, top = 3, bottom = 3 }
                                });
ItemRollInformFrame:SetBackdropBorderColor(0,0,0,1);
ItemRollInformFrame:Hide();

local HeaderFontString = ItemRollInformFrame:CreateFontString("ARTWORK", nil, "GameFontNormalLarge");
HeaderFontString:SetPoint("TOP", 0, -10);
HeaderFontString:SetText(headerText);
HeaderFontString:SetWidth(frameWidth*0.9);
HeaderFontString:SetJustifyH("CENTER");

local MainRollButton = CreateFrame("BUTTON", "MainRollButton", ItemRollInformFrame, "StriLi_Custom_Button_Template");
MainRollButton:SetPoint("BOTTOM",-70,10);
MainRollButton:SetSize(buttonWidth, buttonHeight);
MainRollButton:SetText("100");
MainRollButton:SetScript("OnClick", function(self, button, down) onClickRoll(100) end)
MainRollButton:Show();

local SecRollButton = CreateFrame("BUTTON", "SecRollButton", ItemRollInformFrame, "StriLi_Custom_Button_Template");
SecRollButton:SetPoint("BOTTOM", 0,10);
SecRollButton:SetSize(buttonWidth, buttonHeight);
SecRollButton:SetText("99");
SecRollButton:SetScript("OnClick", function(self, button, down) onClickRoll(99) end);
SecRollButton:Show();

local PassRollButton = CreateFrame("BUTTON", "PassRollButton", ItemRollInformFrame, "StriLi_Custom_Button_Template");
PassRollButton:SetPoint("BOTTOM",70,10);
PassRollButton:SetSize(buttonWidth, buttonHeight);
PassRollButton:SetText("Passen");
PassRollButton:SetScript("OnClick", function(self, button, down) ItemRollInformFrame:Hide() end);
PassRollButton:Show();

local ItemIconFrame = CreateFrame("FRAME", "ItemIconFrame", ItemRollInformFrame);
ItemIconFrame:EnableMouse(true);
ItemIconFrame:SetPoint("LEFT",35,0);
ItemIconFrame:SetSize(iconWidth,iconHeight);
ItemIconFrame:Show();
local ItemIcon = ItemIconFrame:CreateTexture()
ItemIcon:SetTexture(GetItemIcon(6948));
ItemIcon:SetSize(iconWidth,iconHeight);
ItemIcon:SetPoint("CENTER",0,0);
ItemIcon:Show();

ItemIconFrame:SetScript("OnEnter", function()
    if (itemLink) then
        GameTooltip:SetOwner(ItemIconFrame, "ANCHOR_TOP")
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    end
end)

ItemIconFrame:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

local ItemLinkFrame = CreateFrame("FRAME", "ItemIconFrame", ItemRollInformFrame);
ItemLinkFrame:EnableMouse(true);
ItemLinkFrame:SetPoint("CENTER",10,0);
ItemLinkFrame:SetWidth(frameWidth/2);
ItemLinkFrame:SetHeight(iconHeight);
ItemLinkFrame:Show();

ItemLinkFrame:SetScript("OnEnter", function()
    if (itemLink) then
        GameTooltip:SetOwner(ItemLinkFrame, "ANCHOR_TOP")
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    end
end)

ItemLinkFrame:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

local ItemLink = ItemLinkFrame:CreateFontString("ItemLink", "ARTWORK", "GameFontNormalLarge");
ItemLink:SetPoint("CENTER", 0, 0);
ItemLink:SetWidth(frameWidth/2);
ItemLink:SetHeight(iconHeight);
ItemLink:SetJustifyH("CENTER");
ItemLink:SetText(itemLink);

local StriLiPersonalTallyMarkFrame = ItemRollInformFrame:CreateFontString("StriLiPersonalTallyMarkFrame", "ARTWORK", "GameFontNormal");
StriLiPersonalTallyMarkFrame:SetPoint("CENTER", 0, -iconHeight);
StriLiPersonalTallyMarkFrame:SetJustifyH("CENTER");
StriLiPersonalTallyMarkFrame:SetText("InitialDummy");

local function updateTallyMarkString()
    if StriLi.master:get() ~= "" then
        local playerMarks = RaidMembersDB:get(UnitName("player"));
        if playerMarks == nil then return end

        StriLiPersonalTallyMarkFrame:SetText("Deine Striche: Main: "..playerMarks["Main"]:get().." Sec: "..playerMarks["Sec"]:get().." Token: "..playerMarks["Token"]:get()+playerMarks["TokenSec"]:get().." Fail: "..playerMarks["Fail"]:get());
        StriLiPersonalTallyMarkFrame:Show();
    else
        StriLiPersonalTallyMarkFrame:Hide();
    end
end

--------------------
---PUBLIC SECTION---
--------------------

function ItemRollInformFrame_show(aItemLink, aItemID)
    itemLink = aItemLink;
    ItemLink:SetText(aItemLink);
    ItemIcon:SetTexture(GetItemIcon(aItemID));
    updateTallyMarkString();
    ItemRollInformFrame:Show();
end



