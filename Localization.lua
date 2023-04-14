StriLiAtlasLootAdIn = {Lang = nil};
local deDE = {
    YourVersion = "StriLiAtlasLootAddIn: Deine Version: ",
    AvailableVersion = "StriLiAtlasLootAddIn: Verfügbare Version:",
    GithubLinkVersion = "StriLiAtlasLootAddIn: Neue Version ist unter https://github.com/sba5827/StriLiAtlasLootAddIn verfügbar",
    AtlasLootNotFound = "AtlasLoot nicht gefunden. StriLiAtlasLootAddIn funktioniert nur richtig, wenn AtlasLoot installiert/aktiviert ist.",
    ItemRollFrame = {
        headerText = "Folgendes Item auf deiner Wunschliste wird verrollt.",
        buttonPass = "Passen",
        tallymarksText = "Deine Striche: Main: %d Sec: %d Token: %d Fail: %d"
    }
};
local enGB = {
    YourVersion = "StriLiAtlasLootAddIn: Your version: ",
    AvailableVersion = "StriLiAtlasLootAddIn: Version available: ",
    GithubLinkVersion = "StriLiAtlasLootAddIn: New version is available on https://github.com/sba5827/StriLiAtlasLootAddIn",
    AtlasLootNotFound = "AtlasLoot not found. StriLiAtlasLootAddIn only works properly with AtlasLoot installed/enabled.",
    ItemRollFrame = {
        headerText = "The following item on your wishlist is rolled.",
        buttonPass = "Pass",
        tallymarksText = "Your Tally-marks: Main: %d Sec: %d Token: %d Fail: %d"
    }
};
local enUS = enGB;
local esES = {
    YourVersion = "StriLiAtlasLootAddIn: Su versión: ",
    AvailableVersion = "StriLiAtlasLootAddIn: Versión disponible: ",
    GithubLinkVersion = "StriLiAtlasLootAddIn: La nueva versión está disponible en https://github.com/sba5827/StriLiAtlasLootAddIn",
    AtlasLootNotFound = "AtlasLoot not found. StriLiAtlasLootAddIn only works properly with AtlasLoot installed/enabled.",
    ItemRollFrame = {
        headerText = "The following item on your wishlist is rolled.",
        buttonPass = "Pass",
        tallymarksText = "Your Tally-marks: Main: %d Sec: %d Token: %d Fail: %d"
    }
};

local lang = GetLocale();

if lang == "deDE" then
    StriLiAtlasLootAdIn.Lang = deDE;
elseif lang == "enUS" then
    StriLiAtlasLootAdIn.Lang = enUS;
elseif lang == "enGB" then
    StriLiAtlasLootAdIn.Lang = enGB;
elseif lang == "esES" then
    StriLiAtlasLootAdIn.Lang = esES;
else
    StriLiAtlasLootAdIn.Lang = enGB;
end