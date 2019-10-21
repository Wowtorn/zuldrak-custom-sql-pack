/*
-- ################################################################################### --
--  ____    __                                         ____                           
-- /\  _`\ /\ \__                  __                 /\  _`\                         
-- \ \,\L\_\ \ ,_\  __  __     __ /\_\     __      ___\ \ \/\_\    ___   _ __    __   
--  \/_\__ \\ \ \/ /\ \/\ \  /'_ `\/\ \  /'__`\  /' _ `\ \ \/_/_  / __`\/\`'__\/'__`\ 
--    /\ \L\ \ \ \_\ \ \_\ \/\ \L\ \ \ \/\ \L\.\_/\ \/\ \ \ \L\ \/\ \L\ \ \ \//\  __/ 
--    \ `\____\ \__\\/`____ \ \____ \ \_\ \__/.\_\ \_\ \_\ \____/\ \____/\ \_\\ \____\
--     \/_____/\/__/ `/___/> \/___L\ \/_/\/__/\/_/\/_/\/_/\/___/  \/___/  \/_/ \/____/
--                      /\___/ /\____/                                                
--                      \/__/  \_/__/          http://stygianthebest.github.io                                         
-- 
-- ################################################################################### --
--
-- WORLD: PORTAL MASTER
-- NPC ID: 601019
--
-- Adds portal masters that can teleport the player to many places. Portal masters are 
-- located in all major cities and other areas of interest.
--
-- ################################################################################### --
--
-- By Rochet2
-- Ported to AzerothCore by StygianTheBest
-- Downloaded from http://rochet2.github.io/
-- Bugs and contact with E-mail: Rochet2@post.com
--
-- ################################################################################### --
*/

USE dev_world;

SET
@ENTRY          := 190000,
@NAME           := "Pauly",
@SUBNAME        := "Portal Master",
@MODEL          := 21572,
@AURA           := "30540", -- "35766" = casting
@TEXT_ID        := 300000,
@GOSSIP_MENU    := 50000,
@RUNE           := 194394;

-- --------------------------------------------------------------------------------------
-- Deleting code
-- --------------------------------------------------------------------------------------
DELETE FROM creature_template WHERE entry = @ENTRY;
DELETE FROM creature_template_addon WHERE Entry = @ENTRY ;
DELETE FROM gossip_menu WHERE entry BETWEEN @GOSSIP_MENU AND @GOSSIP_MENU+9;
DELETE FROM npc_text WHERE ID BETWEEN @TEXT_ID AND @TEXT_ID+5;
DELETE FROM gossip_menu_option WHERE menu_id BETWEEN @GOSSIP_MENU AND @GOSSIP_MENU+9;
DELETE FROM smart_scripts WHERE entryorguid = @ENTRY AND source_type = 0;
DELETE FROM conditions WHERE (SourceTypeOrReferenceId = 15 OR SourceTypeOrReferenceId = 14) AND SourceGroup BETWEEN @GOSSIP_MENU AND @GOSSIP_MENU+9;
DELETE from creature WHERE ID = @ENTRY;
DELETE from gameobject WHERE ID = @RUNE AND guid >= 200000;

-- --------------------------------------------------------------------------------------
-- Teleporter
-- --------------------------------------------------------------------------------------
INSERT INTO creature_template (entry, modelid1, name, subname, IconName, gossip_menu_id, minlevel, maxlevel, faction, npcflag, speed_walk, speed_run, scale, rank, unit_class, unit_flags, type, type_flags, InhabitType, RegenHealth, flags_extra, AiName) VALUES
(@ENTRY, @MODEL, @NAME, @SUBNAME, "Directions", @GOSSIP_MENU, 71, 71, 35, 3, 1, 1.14286, 1.25, 1, 1, 2, 7, 138936390, 3, 1, 2, "SmartAI");

-- --------------------------------------------------------------------------------------
-- Teleporter aura
-- --------------------------------------------------------------------------------------
INSERT INTO creature_template_addon (entry, mount, bytes1, bytes2, emote, path_id, auras) VALUES (@ENTRY, 0, 0, 0, 0, 0, @AURA);

-- --------------------------------------------------------------------------------------
-- Gossip header text link to menus
-- --------------------------------------------------------------------------------------
REPLACE INTO gossip_menu (menuid, textid) VALUES
(@GOSSIP_MENU+4, @TEXT_ID+3),
(@GOSSIP_MENU+3, @TEXT_ID+2),
(@GOSSIP_MENU+2, @TEXT_ID+2),
(@GOSSIP_MENU+1, @TEXT_ID+2),
(@GOSSIP_MENU+8, @TEXT_ID+4),
(@GOSSIP_MENU+9, @TEXT_ID+5),
(@GOSSIP_MENU+7, @TEXT_ID+4),
(@GOSSIP_MENU+6, @TEXT_ID+4),
(@GOSSIP_MENU+5, @TEXT_ID+4),
(@GOSSIP_MENU, @TEXT_ID+1),
(@GOSSIP_MENU, @TEXT_ID);

-- --------------------------------------------------------------------------------------
-- Gossip header texts
-- --------------------------------------------------------------------------------------
INSERT INTO npc_text (ID, text0_0, em0_1) VALUES
(@TEXT_ID+5, "$BWhich portal would you like to take?$B", 0),
(@TEXT_ID+4, "$BWhere would you like to be ported?$B", 0),
(@TEXT_ID+3, "$BBe careful with choosing raids, I won't be there if you wipe!$B", 0),
(@TEXT_ID+2, "$BUp for some dungeon exploring?$B", 0),
(@TEXT_ID+1, "$B For The Alliance!$B", 6),
(@TEXT_ID,  "$B For the Horde!$B", 6);

-- --------------------------------------------------------------------------------------
-- Conditions for gossip option and menu factions
-- ConditionTypeOrReference = 6 (Faction - 67 Horde, 469 - Alliance)
-- ConditionTypeOrReference = 27 (Level Required - )
-- --------------------------------------------------------------------------------------
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, ConditionTypeOrReference, ConditionValue1, Comment) VALUES
(15, @GOSSIP_MENU, 1, 6, 469, "Stormwind"),
 (15, @GOSSIP_MENU+5, 2, 6, 469, "Dun Morogh"),
 (15, @GOSSIP_MENU+5, 3, 6, 67, "Tirisfal Glades"),
 (15, @GOSSIP_MENU+5, 4, 6, 67, "Ghostlands"),
 (15, @GOSSIP_MENU+5, 5, 6, 469, "Loch modan"),
 (15, @GOSSIP_MENU+5, 6, 6, 67, "Silverpine Forest"),
 (15, @GOSSIP_MENU+5, 7, 6, 469, "Westfall"),
 (15, @GOSSIP_MENU+5, 8, 6, 469, "Redridge mountains"),
 (15, @GOSSIP_MENU+5, 9, 6, 469, "Duskwood"),
 (15, @GOSSIP_MENU+5, 11, 6, 469, "Wetlands"),
 (15, @GOSSIP_MENU+6, 0, 6, 469, "Azuremyst Isle"),
 (15, @GOSSIP_MENU+6, 1, 6, 469, "Teldrassil"),
 (15, @GOSSIP_MENU+6, 2, 6, 67, "Durotar"),
 (15, @GOSSIP_MENU+6, 3, 6, 67, "Mulgore"),
 (15, @GOSSIP_MENU+6, 4, 6, 469, "Bloodmyst Isle"),
 (15, @GOSSIP_MENU+6, 5, 6, 469, "Darkshore"),
 (15, @GOSSIP_MENU+6, 6, 6, 67, "The Barrens"),
 (15, @GOSSIP_MENU+5, 1, 6, 67, "Eversong Woods"),
 (15, @GOSSIP_MENU+5, 0, 6, 469, "Elwynn Forest"),
 (15, @GOSSIP_MENU+4, 22, 6, 67, "Zul'Aman"),
 (15, @GOSSIP_MENU, 2, 6, 67, "Orgrimmar"),
 (15, @GOSSIP_MENU, 3, 6, 469, "Darnassus"),
 (15, @GOSSIP_MENU, 4, 6, 469, "Ironforge"),
 (15, @GOSSIP_MENU, 5, 6, 469, "Exodar"),
 (15, @GOSSIP_MENU, 6, 6, 67, "Thunder bluff"),
 (15, @GOSSIP_MENU, 7, 6, 67, "Undercity"),
 (15, @GOSSIP_MENU, 8, 6, 67, "Silvermoon city"),
 (15, @GOSSIP_MENU+1, 0, 6, 469, "Gnomeregan"),
 (15, @GOSSIP_MENU+1, 1, 6, 469, "The Deadmines"),
 (15, @GOSSIP_MENU+1, 2, 6, 469, "The Stockade"),
 (15, @GOSSIP_MENU+1, 3, 6, 67, "Ragefire Chasm"),
 (15, @GOSSIP_MENU+1, 4, 6, 67, "Razorfen Downs"),
 (15, @GOSSIP_MENU+1, 5, 6, 67, "Razorfen Kraul"),
 (15, @GOSSIP_MENU+1, 6, 6, 67, "Scarlet Monastery"),
 (15, @GOSSIP_MENU+1, 7, 6, 67, "Shadowfang Keep"),
 (15, @GOSSIP_MENU+1, 8, 6, 67, "Wailing Caverns"),
 (15, @GOSSIP_MENU+6, 9, 6, 67, "Thousand Needles"),
(14, @GOSSIP_MENU, @TEXT_ID+1, 6, 469, "For the Alliance"),
(14, @GOSSIP_MENU, @TEXT_ID, 6, 67, "For the Horde");

-- --------------------------------------------------------------------------------------
-- Conditions for gossip option levels
--
-- ConditionTypeOrReference = 27 (Level Required - Level)
--
-- --------------------------------------------------------------------------------------
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, ConditionTypeOrReference, ConditionValue1, ConditionValue2, ConditionValue3, Comment) VALUES
(15, @GOSSIP_MENU+8, 9, 27, 77, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+8, 8, 27, 77, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+8, 7, 27, 77, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+8, 6, 27, 77, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+8, 5, 27, 76, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+8, 4, 27, 74, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+8, 3, 27, 73, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+8, 2, 27, 71, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+8, 1, 27, 68, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+8, 0, 27, 68, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+7, 6, 27, 67, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+7, 5, 27, 67, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+7, 4, 27, 65, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+7, 3, 27, 64, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+7, 2, 27, 62, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+7, 1, 27, 60, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+7, 0, 27, 58, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 18, 27, 55, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 17, 27, 55, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 16, 27, 48, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 15, 27, 48, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 14, 27, 45, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 13, 27, 40, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 12, 27, 40, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 11, 27, 35, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 10, 27, 30, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 9, 27, 25, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 8, 27, 18, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 7, 27, 15, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 6, 27, 10, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 5, 27, 10, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+6, 4, 27, 15, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 23, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 22, 27, 53, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 21, 27, 51, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 20, 27, 50, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 19, 27, 45, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 18, 27, 43, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 17, 27, 40, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 16, 27, 35, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 15, 27, 35, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 14, 27, 30, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 13, 27, 30, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 12, 27, 30, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 11, 27, 20, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 10, 27, 20, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 9, 27, 18, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 8, 27, 15, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 7, 27, 10, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 6, 27, 10, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 5, 27, 10, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+5, 4, 27, 10, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 22, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 21, 27, 57, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 19, 27, 80, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 18, 27, 80, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 17, 27, 80, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 16, 27, 80, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 15, 27, 60, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 14, 27, 67, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 13, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 12, 27, 60, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 11, 27, 80, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 10, 27, 80, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 9, 27, 60, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 8, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 7, 27, 80, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 6, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 5, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 4, 27, 80, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 3, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 2, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 1, 27, 60, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+4, 0, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 11, 27, 75, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 10, 27, 69, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 9, 27, 77, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 8, 27, 79, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 7, 27, 75, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 6, 27, 71, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 5, 27, 79, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 4, 27, 71, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 3, 27, 74, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 2, 27, 79, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 1, 27, 79, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+3, 0, 27, 73, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+2, 5, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+2, 4, 27, 70, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+2, 3, 27, 59, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+2, 2, 27, 62, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+2, 1, 27, 66, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+2, 0, 27, 64, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 18, 27, 35, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 17, 27, 37, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 16, 27, 47, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 15, 27, 55, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 14, 27, 55, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 13, 27, 45, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 12, 27, 55, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 11, 27, 57, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 10, 27, 53, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 9, 27, 21, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 8, 27, 17, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 7, 27, 18, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 6, 27, 32, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 5, 27, 24, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 4, 27, 34, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 3, 27, 15, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 2, 27, 22, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 1, 27, 17, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU+1, 0, 27, 25, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 20, 27, 57, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 19, 27, 69, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 18, 27, 59, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 17, 27, 15, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 16, 27, 68, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 15, 27, 58, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 12, 27, 30, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 11, 27, 30, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 10, 27, 57, 3, 0, "Portal Master - Level req"),
(15, @GOSSIP_MENU, 9, 27, 67, 3, 0, "Portal Master - Level req");

REPLACE INTO gossip_menu_option (menuid, optionid, optionicon, optiontext, optionbroadcasttextid, optionnpcflag, actionmenuid, actionpoiid, boxcoded, boxmoney, boxtext) VALUES

-- --------------------------------------------------------------------------------------
-- MAIN MENU
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU, 21, 9, "Stygian Portals", 1, 1, @GOSSIP_MENU+9, 0, 0, 0, NULL),
(@GOSSIP_MENU, 1, 2, "Stormwind", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Stormwind?"),
(@GOSSIP_MENU, 2, 2, "Orgrimmar", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Orgrimmar?"),
(@GOSSIP_MENU, 3, 2, "Darnassus", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Darnassus?"),
(@GOSSIP_MENU, 4, 2, "Ironforge", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Ironforge?"),
(@GOSSIP_MENU, 5, 2, "Exodar", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Exodar?"),
(@GOSSIP_MENU, 6, 2, "Thunder bluff", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Thunder bluff?"),
(@GOSSIP_MENU, 7, 2, "Undercity", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Undercity?"),
(@GOSSIP_MENU, 8, 2, "Silvermoon city", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Silvermoon city?"),
(@GOSSIP_MENU, 9, 2, "Dalaran", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Dalaran?"),
(@GOSSIP_MENU, 10, 2, "Shattrath", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Shattrath?"),
(@GOSSIP_MENU, 11, 2, "Booty bay", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Booty bay?"),
(@GOSSIP_MENU, 12, 2, "Gurubashi arena", 1, 1, @GOSSIP_MENU, 0, 0, 0, "Are you sure, that you want to go to Arena?"),
(@GOSSIP_MENU, 13, 3, "Eastern Kingdoms", 1, 1, @GOSSIP_MENU+5, 0, 0, 0, NULL),
(@GOSSIP_MENU, 14, 3, "Kalimdor", 1, 1, @GOSSIP_MENU+6, 0, 0, 0, NULL),
(@GOSSIP_MENU, 15, 3, "Outland", 1, 1, @GOSSIP_MENU+7, 0, 0, 0, NULL),
(@GOSSIP_MENU, 16, 3, "Northrend", 1, 1, @GOSSIP_MENU+8, 0, 0, 0, NULL),
(@GOSSIP_MENU, 17, 9, "Classic Dungeons", 1, 1, @GOSSIP_MENU+1, 0, 0, 0, NULL),
(@GOSSIP_MENU, 18, 9, "BC Dungeons", 1, 1, @GOSSIP_MENU+2, 0, 0, 0, NULL),
(@GOSSIP_MENU, 19, 9, "Wrath Dungeons", 1, 1, @GOSSIP_MENU+3, 0, 0, 0, NULL),
(@GOSSIP_MENU, 20, 9, "Raid Teleports", 1, 1, @GOSSIP_MENU+4, 0, 0, 0, NULL),

-- --------------------------------------------------------------------------------------
-- CLASSIC DUNGEONS
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU+1, 0, 2, "Gnomeregan", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Gnomeregan?"),
(@GOSSIP_MENU+1, 1, 2, "The Deadmines", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Deadmines?"),
(@GOSSIP_MENU+1, 2, 2, "The Stockade", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Stockade?"),
(@GOSSIP_MENU+1, 3, 2, "Ragefire Chasm", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Ragefire Chasm?"),
(@GOSSIP_MENU+1, 4, 2, "Razorfen Downs", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Razorfen Downs?"),
(@GOSSIP_MENU+1, 5, 2, "Razorfen Kraul", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Razorfen Kraul?"),
(@GOSSIP_MENU+1, 6, 2, "Scarlet Monastery", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Scarlet Monastery?"),
(@GOSSIP_MENU+1, 7, 2, "Shadowfang Keep", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Shadowfang Keep?"),
(@GOSSIP_MENU+1, 8, 2, "Wailing Caverns", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Wailing Caverns?"),
(@GOSSIP_MENU+1, 9, 2, "Blackfathom Deeps", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Blackfathom Deeps?"),
(@GOSSIP_MENU+1, 10, 2, "Blackrock Depths", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Blackrock Depths?"),
(@GOSSIP_MENU+1, 11, 2, "Blackrock Spire", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Blackrock Spire?"),
(@GOSSIP_MENU+1, 12, 2, "Dire Maul", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Dire Maul?"),
(@GOSSIP_MENU+1, 13, 2, "Maraudon", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Maraudon?"),
(@GOSSIP_MENU+1, 14, 2, "Scholomance", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Scholomance?"),
(@GOSSIP_MENU+1, 15, 2, "Stratholme", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Stratholme?"),
(@GOSSIP_MENU+1, 16, 2, "Sunken Temple", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Sunken Temple?"),
(@GOSSIP_MENU+1, 17, 2, "Uldaman", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Uldaman?"),
(@GOSSIP_MENU+1, 18, 2, "Zul'Farrak", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Zul'Farrak?"),
(@GOSSIP_MENU+1, 19, 7, "Back..", 1, 1, @GOSSIP_MENU, 0, 0, 0, NULL),

-- --------------------------------------------------------------------------------------
-- BC DUNGEONS
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU+2, 0, 2, "Auchindoun", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Auchindoun?"),
(@GOSSIP_MENU+2, 1, 2, "Caverns of Time", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Caverns of Time?"),
(@GOSSIP_MENU+2, 2, 2, "Coilfang Reservoir", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Coilfang Reservoir?"),
(@GOSSIP_MENU+2, 3, 2, "Hellfire Citadel", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Hellfire Citadel?"),
(@GOSSIP_MENU+2, 4, 2, "Magisters' Terrace", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Magisters' Terrace?"),
(@GOSSIP_MENU+2, 5, 2, "Tempest Keep", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Tempest Keep?"),
(@GOSSIP_MENU+2, 6, 7, "Back..", 1, 1, @GOSSIP_MENU, 0, 0, 0, NULL),

-- --------------------------------------------------------------------------------------
-- WRATH DUNGEONS
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU+3, 0, 2, "Azjol-Nerub", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Azjol-Nerub?"),
(@GOSSIP_MENU+3, 1, 2, "The Culling of Stratholme", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Culling of Stratholme?"),
(@GOSSIP_MENU+3, 2, 2, "Trial of the Champion", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Trial of the Champion?"),
(@GOSSIP_MENU+3, 3, 2, "Drak'Tharon Keep", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Drak'Tharon Keep?"),
(@GOSSIP_MENU+3, 4, 2, "Gundrak", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Gundrak?"),
(@GOSSIP_MENU+3, 5, 2, "Icecrown Citadel Dungeons", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Icecrown Citadel Dungeons?"),
(@GOSSIP_MENU+3, 6, 2, "The Nexus Dungeons", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Nexus Dungeons?"),
(@GOSSIP_MENU+3, 7, 2, "The Violet Hold", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Violet Hold?"),
(@GOSSIP_MENU+3, 8, 2, "Halls of Lightning", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Halls of Lightning?"),
(@GOSSIP_MENU+3, 9, 2, "Halls of Stone", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Halls of Stone?"),
(@GOSSIP_MENU+3, 10, 2, "Utgarde Keep", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Utgarde Keep?"),
(@GOSSIP_MENU+3, 11, 2, "Utgarde Pinnacle", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Utgarde Pinnacle?"),
(@GOSSIP_MENU+3, 12, 7, "Back..", 1, 1, @GOSSIP_MENU, 0, 0, 0, NULL),

-- --------------------------------------------------------------------------------------
-- RAIDS
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU+4, 0, 2, "Black Temple", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Black Temple?"),
(@GOSSIP_MENU+4, 1, 2, "Blackwing Lair", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Blackwing Lair?"),
(@GOSSIP_MENU+4, 2, 2, "Hyjal Summit", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Hyjal Summit?"),
(@GOSSIP_MENU+4, 3, 2, "Serpentshrine Cavern", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Serpentshrine Cavern?"),
(@GOSSIP_MENU+4, 4, 2, "Trial of the Crusader", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Trial of the Crusader?"),
(@GOSSIP_MENU+4, 5, 2, "Gruul's Lair", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Gruul's Lair?"),
(@GOSSIP_MENU+4, 6, 2, "Magtheridon's Lair", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Magtheridon's Lair?"),
(@GOSSIP_MENU+4, 7, 2, "Icecrown Citadel", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Icecrown Citadel?"),
(@GOSSIP_MENU+4, 8, 2, "Karazhan", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Karazhan?"),
(@GOSSIP_MENU+4, 9, 2, "Molten Core", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Molten Core?"),
(@GOSSIP_MENU+4, 10, 2, "Naxxramas", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Naxxramas?"),
(@GOSSIP_MENU+4, 11, 2, "Onyxia's Lair", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Onyxia's Lair?"),
(@GOSSIP_MENU+4, 12, 2, "Ruins of Ahn'Qiraj", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Ruins of Ahn'Qiraj?"),
(@GOSSIP_MENU+4, 13, 2, "Sunwell Plateau", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Sunwell Plateau?"),
(@GOSSIP_MENU+4, 14, 2, "The Eye", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Eye?"),
(@GOSSIP_MENU+4, 15, 2, "Temple of Ahn'Qiraj", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Temple of Ahn'Qiraj?"),
(@GOSSIP_MENU+4, 16, 2, "The Eye of Eternity", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Eye of Eternity?"),
(@GOSSIP_MENU+4, 17, 2, "The Obsidian Sanctum", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Obsidian Sanctum?"),
(@GOSSIP_MENU+4, 18, 2, "Ulduar", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Ulduar?"),
(@GOSSIP_MENU+4, 19, 2, "Vault of Archavon", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Vault of Archavon?"),
(@GOSSIP_MENU+4, 21, 2, "Zul'Gurub", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Zul'Gurub?"),
(@GOSSIP_MENU+4, 22, 2, "Zul'Aman", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Zul'Aman?"),
(@GOSSIP_MENU+4, 23, 7, "Back..", 1, 1, @GOSSIP_MENU, 0, 0, 0, NULL),

-- --------------------------------------------------------------------------------------
-- EASTERN KINGDOMS
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU+5, 0, 2, "Elwynn Forest", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Elwynn Forest?"),
(@GOSSIP_MENU+5, 1, 2, "Eversong Woods", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Eversong Woods?"),
(@GOSSIP_MENU+5, 2, 2, "Dun Morogh", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Dun Morogh?"),
(@GOSSIP_MENU+5, 3, 2, "Tirisfal Glades", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Tirisfal Glades?"),
(@GOSSIP_MENU+5, 4, 2, "Ghostlands", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Ghostlands?"),
(@GOSSIP_MENU+5, 5, 2, "Loch modan", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Loch modan?"),
(@GOSSIP_MENU+5, 6, 2, "Silverpine Forest", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Silverpine Forest?"),
(@GOSSIP_MENU+5, 7, 2, "Westfall", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Westfall?"),
(@GOSSIP_MENU+5, 8, 2, "Redridge mountains", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Redridge mountains?"),
(@GOSSIP_MENU+5, 9, 2, "Duskwood", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Duskwood?"),
(@GOSSIP_MENU+5, 10, 2, "Hillsbrad Foothills", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Hillsbrad Foothills?"),
(@GOSSIP_MENU+5, 11, 2, "Wetlands", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Wetlands?"),
(@GOSSIP_MENU+5, 12, 2, "Alterac Mountains", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Alterac Mountains?"),
(@GOSSIP_MENU+5, 13, 2, "Arathi Highlands", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Arathi Highlands?"),
(@GOSSIP_MENU+5, 14, 2, "Stranglethorn Vale", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Stranglethorn Vale?"),
(@GOSSIP_MENU+5, 15, 2, "Badlands", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Badlands?"),
(@GOSSIP_MENU+5, 16, 2, "Swamp of Sorrows", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Swamp of Sorrows?"),
(@GOSSIP_MENU+5, 17, 2, "The Hinterlands", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Hinterlands?"),
(@GOSSIP_MENU+5, 18, 2, "Searing Gorge", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Searing Gorge?"),
(@GOSSIP_MENU+5, 19, 2, "The Blasted Lands", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Blasted Lands?"),
(@GOSSIP_MENU+5, 20, 2, "Burning Steppes", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Burning Steppes?"),
(@GOSSIP_MENU+5, 21, 2, "Western Plaguelands", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Western Plaguelands?"),
(@GOSSIP_MENU+5, 22, 2, "Eastern Plaguelands", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Eastern Plaguelands?"),
(@GOSSIP_MENU+5, 23, 2, "Isle of Quel'Danas", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Isle of Quel'Danas?"),
(@GOSSIP_MENU+5, 24, 7, "Back..", 1, 1, @GOSSIP_MENU, 0, 0, 0, NULL),

-- --------------------------------------------------------------------------------------
-- KALIMDOR
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU+6, 0, 2, "Azuremyst Isle", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Azuremyst Isle?"),
(@GOSSIP_MENU+6, 1, 2, "Teldrassil", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Teldrassil?"),
(@GOSSIP_MENU+6, 2, 2, "Durotar", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Durotar?"),
(@GOSSIP_MENU+6, 3, 2, "Mulgore", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Mulgore?"),
(@GOSSIP_MENU+6, 4, 2, "Bloodmyst Isle", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Bloodmyst Isle?"),
(@GOSSIP_MENU+6, 5, 2, "Darkshore", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Darkshore?"),
(@GOSSIP_MENU+6, 6, 2, "The Barrens", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to The Barrens?"),
(@GOSSIP_MENU+6, 7, 2, "Stonetalon Mountains", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Stonetalon Mountains?"),
(@GOSSIP_MENU+6, 8, 2, "Ashenvale Forest", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Ashenvale Forest?"),
(@GOSSIP_MENU+6, 9, 2, "Thousand Needles", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Thousand Needles?"),
(@GOSSIP_MENU+6, 10, 2, "Desolace", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Desolace?"),
(@GOSSIP_MENU+6, 11, 2, "Dustwallow Marsh", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Dustwallow Marsh?"),
(@GOSSIP_MENU+6, 12, 2, "Feralas", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Feralas?"),
(@GOSSIP_MENU+6, 13, 2, "Tanaris Desert", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Tanaris Desert?"),
(@GOSSIP_MENU+6, 14, 2, "Azshara", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Azshara?"),
(@GOSSIP_MENU+6, 15, 2, "Felwood", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Felwood?"),
(@GOSSIP_MENU+6, 16, 2, "Un'Goro Crater", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Un'Goro Crater?"),
(@GOSSIP_MENU+6, 17, 2, "Silithus", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Silithus?"),
(@GOSSIP_MENU+6, 18, 2, "Winterspring", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Winterspring?"),
(@GOSSIP_MENU+6, 19, 7, "Back..", 1, 1, @GOSSIP_MENU, 0, 0, 0, NULL),

-- --------------------------------------------------------------------------------------
-- OUTLAND
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU+7, 0, 2, "Hellfire Peninsula", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Hellfire Peninsula?"),
(@GOSSIP_MENU+7, 1, 2, "Zangarmarsh", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Zangarmarsh?"),
(@GOSSIP_MENU+7, 2, 2, "Terokkar Forest", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Terokkar Forest?"),
(@GOSSIP_MENU+7, 3, 2, "Nagrand", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Nagrand?"),
(@GOSSIP_MENU+7, 4, 2, "Blade's Edge Mountains", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Blade's Edge Mountains?"),
(@GOSSIP_MENU+7, 5, 2, "Netherstorm", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Netherstorm?"),
(@GOSSIP_MENU+7, 6, 2, "Shadowmoon Valley", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Shadowmoon Valley?"),
(@GOSSIP_MENU+7, 7, 7, "Back..", 1, 1, @GOSSIP_MENU, 0, 0, 0, NULL),

-- --------------------------------------------------------------------------------------
-- NORTHREND
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU+8, 0, 2, "Borean Tundra", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Borean Tundra?"),
(@GOSSIP_MENU+8, 1, 2, "Howling Fjord", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Howling Fjord?"),
(@GOSSIP_MENU+8, 2, 2, "Dragonblight", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Dragonblight?"),
(@GOSSIP_MENU+8, 3, 2, "Grizzly Hills", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Grizzly Hills?"),
(@GOSSIP_MENU+8, 4, 2, "Zul'Drak", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Zul'Drak?"),
(@GOSSIP_MENU+8, 5, 2, "Sholazar Basin", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Sholazar Basin?"),
(@GOSSIP_MENU+8, 6, 2, "Crystalsong Forest", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Crystalsong Forest?"),
(@GOSSIP_MENU+8, 7, 2, "Storm Peaks", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Storm Peaks?"),
(@GOSSIP_MENU+8, 8, 2, "Icecrown", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Icecrown?"),
(@GOSSIP_MENU+8, 9, 2, "Wintergrasp", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Wintergrasp?"),
(@GOSSIP_MENU+8, 10, 7, "Back..", 1, 1, @GOSSIP_MENU, 0, 0, 0, NULL),

-- --------------------------------------------------------------------------------------
-- Stygian Portals
-- --------------------------------------------------------------------------------------
(@GOSSIP_MENU+9, 0, 2, "Sunrock Retreat", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Sunrock Retreat?"),
(@GOSSIP_MENU+9, 1, 2, "Silithus Camp", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Silithus Camp?"),
(@GOSSIP_MENU+9, 2, 2, "Koiter's Shrine", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Koiter's Shrine?"),
(@GOSSIP_MENU+9, 3, 2, "Dead King's Crypt", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Dead King's Crypt?"),
(@GOSSIP_MENU+9, 4, 2, "Winterspring", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Winterspring?"),
(@GOSSIP_MENU+9, 5, 2, "Moonglade Gem Vendors", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Moonglade Gem Vendors?"),
(@GOSSIP_MENU+9, 6, 2, "Elise\'s Happy Place", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Elise\'s Happy Place?"),
(@GOSSIP_MENU+9, 7, 2, "Shatterspear Vale", 1, 1, 0, 0, 0, 0, "Are you sure, that you want to go to Shatterspear Vale?"),
(@GOSSIP_MENU+9, 8, 7, "Back..", 1, 1, @GOSSIP_MENU, 0, 0, 0, NULL);


-- --------------------------------------------------------------------------------------
-- Teleport scripts:
-- --------------------------------------------------------------------------------------
INSERT INTO smart_scripts (entryorguid, source_type, id, link, event_type, event_phase_mask, event_chance, event_flags, event_param1, event_param2, event_param3, event_param4, action_type, action_param1, action_param2, action_param3, action_param4, action_param5, action_param6, target_type, target_param1, target_param2, target_param3, target_x, target_y, target_z, target_o, comment) VALUES 
(@ENTRY, 0, 1, 0, 62, 0, 100, 0, @GOSSIP_MENU, 1, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -8842.09, 626.358, 94.0867, 3.61363, "Teleporter script"),
(@ENTRY, 0, 2, 0, 62, 0, 100, 0, @GOSSIP_MENU, 2, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1601.08, -4378.69, 9.9846, 2.14362, "Teleporter script"),
(@ENTRY, 0, 3, 0, 62, 0, 100, 0, @GOSSIP_MENU, 11, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -14281.9, 552.564, 8.90422, 0.860144, "Teleporter script"),
(@ENTRY, 0, 4, 0, 62, 0, 100, 0, @GOSSIP_MENU, 10, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -1887.62, 5359.09, -12.4279, 4.40435, "Teleporter script"),
(@ENTRY, 0, 5, 0, 62, 0, 100, 0, @GOSSIP_MENU, 9, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 5809.55, 503.975, 657.526, 2.38338, "Teleporter script"),
(@ENTRY, 0, 6, 0, 62, 0, 100, 0, @GOSSIP_MENU, 12, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -13181.8, 339.356, 42.9805, 1.18013, "Teleporter script"),
(@ENTRY, 0, 7, 0, 62, 0, 100, 0, @GOSSIP_MENU, 3, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 9869.91, 2493.58, 1315.88, 2.78897, "Teleporter script"),
(@ENTRY, 0, 8, 0, 62, 0, 100, 0, @GOSSIP_MENU, 4, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -4900.47, -962.585, 501.455, 5.40538, "Teleporter script"),
(@ENTRY, 0, 9, 0, 62, 0, 100, 0, @GOSSIP_MENU, 5, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -3864.92, -11643.7, -137.644, 5.50862, "Teleporter script"),
(@ENTRY, 0, 10, 0, 62, 0, 100, 0, @GOSSIP_MENU, 6, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -1274.45, 71.8601, 128.159, 2.80623, "Teleporter script"),
(@ENTRY, 0, 11, 0, 62, 0, 100, 0, @GOSSIP_MENU, 7, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1633.75, 240.167, -43.1034, 6.26128, "Teleporter script"),
(@ENTRY, 0, 12, 0, 62, 0, 100, 0, @GOSSIP_MENU, 8, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 9738.28, -7454.19, 13.5605, 0.043914, "Teleporter script"),
(@ENTRY, 0, 13, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -5163.54, 925.423, 257.181, 1.57423, "Teleporter script"),
(@ENTRY, 0, 14, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 1, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -11209.6, 1666.54, 24.6974, 1.42053, "Teleporter script"),
(@ENTRY, 0, 15, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 2, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -8799.15, 832.718, 97.6348, 6.04085, "Teleporter script"),
(@ENTRY, 0, 16, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 3, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1811.78, -4410.5, -18.4704, 5.20165, "Teleporter script"),
(@ENTRY, 0, 17, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 4, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -4657.3, -2519.35, 81.0529, 4.54808, "Teleporter script"),
(@ENTRY, 0, 18, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 5, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -4470.28, -1677.77, 81.3925, 1.16302, "Teleporter script"),
(@ENTRY, 0, 19, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 6, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 2873.15, -764.523, 160.332, 5.10447, "Teleporter script"),
(@ENTRY, 0, 20, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 7, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -234.675, 1561.63, 76.8921, 1.24031, "Teleporter script"),
(@ENTRY, 0, 21, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 8, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -731.607, -2218.39, 17.0281, 2.78486, "Teleporter script"),
(@ENTRY, 0, 22, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 9, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 4249.99, 740.102, -25.671, 1.34062, "Teleporter script"),
(@ENTRY, 0, 23, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 10, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -7179.34, -921.212, 165.821, 5.09599, "Teleporter script"),
(@ENTRY, 0, 24, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 11, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -7527.05, -1226.77, 285.732, 5.29626, "Teleporter script"),
(@ENTRY, 0, 25, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 12, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -3520.14, 1119.38, 161.025, 4.70454, "Teleporter script"),
(@ENTRY, 0, 26, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 13, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -1421.42, 2907.83, 137.415, 1.70718, "Teleporter script"),
(@ENTRY, 0, 27, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 14, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1269.64, -2556.21, 93.6088, 0.620623, "Teleporter script"),
(@ENTRY, 0, 28, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 15, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3352.92, -3379.03, 144.782, 6.25978, "Teleporter script"),
(@ENTRY, 0, 29, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 16, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -10177.9, -3994.9, -111.239, 6.01885, "Teleporter script"),
(@ENTRY, 0, 30, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 17, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -6071.37, -2955.16, 209.782, 0.015708, "Teleporter script"),
(@ENTRY, 0, 31, 0, 62, 0, 100, 0, @GOSSIP_MENU+1, 18, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -6801.19, -2893.02, 9.00388, 0.158639, "Teleporter script"),
(@ENTRY, 0, 32, 0, 62, 0, 100, 0, @GOSSIP_MENU+2, 0, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -3324.49, 4943.45, -101.239, 4.63901, "Teleporter script"),
(@ENTRY, 0, 33, 0, 62, 0, 100, 0, @GOSSIP_MENU+2, 1, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -8369.65, -4253.11, -204.272, -2.70526, "Teleporter script"),
(@ENTRY, 0, 34, 0, 62, 0, 100, 0, @GOSSIP_MENU+2, 2, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 738.865, 6865.77, -69.4659, 6.27655, "Teleporter script"),
(@ENTRY, 0, 35, 0, 62, 0, 100, 0, @GOSSIP_MENU+2, 3, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -347.29, 3089.82, 21.394, 5.68114, "Teleporter script"),
(@ENTRY, 0, 36, 0, 62, 0, 100, 0, @GOSSIP_MENU+2, 4, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 12884.6, -7317.69, 65.5023, 4.799, "Teleporter script"),
(@ENTRY, 0, 37, 0, 62, 0, 100, 0, @GOSSIP_MENU+2, 5, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3100.48, 1536.49, 190.3, 4.62226, "Teleporter script"),
(@ENTRY, 0, 38, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 0, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3707.86, 2150.23, 36.76, 3.22, "Teleporter script"),
(@ENTRY, 0, 39, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 1, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -8756.39, -4440.68, -199.489, 4.66289, "Teleporter script"),
(@ENTRY, 0, 40, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 2, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 8590.95, 791.792, 558.235, 3.13127, "Teleporter script"),
(@ENTRY, 0, 41, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 3, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 4765.59, -2038.24, 229.363, 0.887627, "Teleporter script"),
(@ENTRY, 0, 42, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 4, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 6722.44, -4640.67, 450.632, 3.91123, "Teleporter script"),
(@ENTRY, 0, 43, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 5, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 5643.16, 2028.81, 798.274, 4.60242, "Teleporter script"),
(@ENTRY, 0, 44, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 6, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3782.89, 6965.23, 105.088, 6.14194, "Teleporter script"),
(@ENTRY, 0, 45, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 7, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 5693.08, 502.588, 652.672, 4.0229, "Teleporter script"),
(@ENTRY, 0, 46, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 8, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 9136.52, -1311.81, 1066.29, 5.19113, "Teleporter script"),
(@ENTRY, 0, 47, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 9, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 8922.12, -1009.16, 1039.56, 1.57044, "Teleporter script"),
(@ENTRY, 0, 48, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 10, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1203.41, -4868.59, 41.2486, 0.283237, "Teleporter script"),
(@ENTRY, 0, 49, 0, 62, 0, 100, 0, @GOSSIP_MENU+3, 11, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1267.24, -4857.3, 215.764, 3.22768, "Teleporter script"),
(@ENTRY, 0, 50, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 0, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -3649.92, 317.469, 35.2827, 2.94285, "Teleporter script"),
(@ENTRY, 0, 51, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 1, 0, 0, 62, 229, 0, 0, 0, 0, 0, 7, 0, 0, 0, 152.451, -474.881, 116.84, 0.001073, "Teleporter script"),
(@ENTRY, 0, 52, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 2, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -8177.89, -4181.23, -167.552, 0.913338, "Teleporter script"),
(@ENTRY, 0, 53, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 3, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 797.855, 6865.77, -65.4165, 0.005938, "Teleporter script"),
(@ENTRY, 0, 54, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 4, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 8515.61, 714.153, 558.248, 1.57753, "Teleporter script"),
(@ENTRY, 0, 55, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 5, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3530.06, 5104.08, 3.50861, 5.51117, "Teleporter script"),
(@ENTRY, 0, 56, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 6, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -336.411, 3130.46, -102.928, 5.20322, "Teleporter script"),
(@ENTRY, 0, 57, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 7, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 5855.22, 2102.03, 635.991, 3.57899, "Teleporter script"),
(@ENTRY, 0, 58, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 8, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -11118.9, -2010.33, 47.0819, 0.649895, "Teleporter script"),
(@ENTRY, 0, 59, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 9, 0, 0, 62, 230, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1126.64, -459.94, -102.535, 3.46095, "Teleporter script"),
(@ENTRY, 0, 60, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 10, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3668.72, -1262.46, 243.622, 4.785, "Teleporter script"),
(@ENTRY, 0, 61, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 11, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -4708.27, -3727.64, 54.5589, 3.72786, "Teleporter script"),
(@ENTRY, 0, 62, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 12, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -8409.82, 1499.06, 27.7179, 2.51868, "Teleporter script"),
(@ENTRY, 0, 63, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 13, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 12574.1, -6774.81, 15.0904, 3.13788, "Teleporter script"),
(@ENTRY, 0, 64, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 14, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3088.49, 1381.57, 184.863, 4.61973, "Teleporter script"),
(@ENTRY, 0, 65, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 15, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -8240.09, 1991.32, 129.072, 0.941603, "Teleporter script"),
(@ENTRY, 0, 66, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 16, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3784.17, 7028.84, 161.258, 5.79993, "Teleporter script"),
(@ENTRY, 0, 67, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 17, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3472.43, 264.923, -120.146, 3.27923, "Teleporter script"),
(@ENTRY, 0, 68, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 18, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 9222.88, -1113.59, 1216.12, 6.27549, "Teleporter script"),
(@ENTRY, 0, 69, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 19, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 5453.72, 2840.79, 421.28, 0, "Teleporter script"),
(@ENTRY, 0, 70, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 21, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -11916.7, -1215.72, 92.289, 4.72454, "Teleporter script"),
(@ENTRY, 0, 71, 0, 62, 0, 100, 0, @GOSSIP_MENU+4, 22, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 6851.78, -7972.57, 179.242, 4.64691, "Teleporter script"),
(@ENTRY, 0, 72, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -9449.06, 64.8392, 56.3581, 3.07047, "Teleporter script"),
(@ENTRY, 0, 73, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 1, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 9024.37, -6682.55, 16.8973, 3.14131, "Teleporter script"),
(@ENTRY, 0, 74, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 2, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -5603.76, -482.704, 396.98, 5.23499, "Teleporter script"),
(@ENTRY, 0, 75, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 3, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 2274.95, 323.918, 34.1137, 4.24367, "Teleporter script"),
(@ENTRY, 0, 76, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 4, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 7595.73, -6819.6, 84.3718, 2.56561, "Teleporter script"),
(@ENTRY, 0, 77, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 5, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -5405.85, -2894.15, 341.972, 5.48238, "Teleporter script"),
(@ENTRY, 0, 78, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 6, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 505.126, 1504.63, 124.808, 1.77987, "Teleporter script"),
(@ENTRY, 0, 79, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 7, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -10684.9, 1033.63, 32.5389, 6.07384, "Teleporter script"),
(@ENTRY, 0, 80, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 8, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -9447.8, -2270.85, 71.8224, 0.283853, "Teleporter script"),
(@ENTRY, 0, 81, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 9, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -10531.7, -1281.91, 38.8647, 1.56959, "Teleporter script"),
(@ENTRY, 0, 82, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 10, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -385.805, -787.954, 54.6655, 1.03926, "Teleporter script"),
(@ENTRY, 0, 83, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 11, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -3517.75, -913.401, 8.86625, 2.60705, "Teleporter script"),
(@ENTRY, 0, 84, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 12, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 275.049, -652.044, 130.296, 0.502032, "Teleporter script"),
(@ENTRY, 0, 85, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 13, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -1581.45, -2704.06, 35.4168, 0.490373, "Teleporter script"),
(@ENTRY, 0, 86, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 14, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -11921.7, -59.544, 39.7262, 3.73574, "Teleporter script"),
(@ENTRY, 0, 87, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 15, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -6782.56, -3128.14, 240.48, 5.65912, "Teleporter script"),
(@ENTRY, 0, 88, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 16, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -10368.6, -2731.3, 21.6537, 5.29238, "Teleporter script"),
(@ENTRY, 0, 89, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 17, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 112.406, -3929.74, 136.358, 0.981903, "Teleporter script"),
(@ENTRY, 0, 90, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 18, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -6686.33, -1198.55, 240.027, 0.916887, "Teleporter script"),
(@ENTRY, 0, 91, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 19, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -11184.7, -3019.31, 7.29238, 3.20542, "Teleporter script"),
(@ENTRY, 0, 92, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 20, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -7979.78, -2105.72, 127.919, 5.10148, "Teleporter script"),
(@ENTRY, 0, 93, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 21, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1743.69, -1723.86, 59.6648, 5.23722, "Teleporter script"),
(@ENTRY, 0, 94, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 22, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 2280.64, -5275.05, 82.0166, 4.7479, "Teleporter script"),
(@ENTRY, 0, 95, 0, 62, 0, 100, 0, @GOSSIP_MENU+5, 23, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 12806.5, -6911.11, 41.1156, 2.22935, "Teleporter script"),
(@ENTRY, 0, 96, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 0, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -4192.62, -12576.7, 36.7598, 1.62813, "Teleporter script"),
(@ENTRY, 0, 97, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 1, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 9889.03, 915.869, 1307.43, 1.9336, "Teleporter script"),
(@ENTRY, 0, 98, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 2, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 228.978, -4741.87, 10.1027, 0.416883, "Teleporter script"),
(@ENTRY, 0, 99, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 3, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -2473.87, -501.225, -9.42465, 0.6525, "Teleporter script"),
(@ENTRY, 0, 100, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 4, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -2095.7, -11841.1, 51.1557, 6.19288, "Teleporter script"),
(@ENTRY, 0, 101, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 5, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 6463.25, 683.986, 8.92792, 4.33534, "Teleporter script"),
(@ENTRY, 0, 102, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 6, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -575.772, -2652.45, 95.6384, 0.006469, "Teleporter script"),
(@ENTRY, 0, 103, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 7, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1574.89, 1031.57, 137.442, 3.8013, "Teleporter script"),
(@ENTRY, 0, 104, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 8, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 1919.77, -2169.68, 94.6729, 6.14177, "Teleporter script"),
(@ENTRY, 0, 105, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 9, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -5375.53, -2509.2, -40.432, 2.41885, "Teleporter script"),
(@ENTRY, 0, 106, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 10, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -656.056, 1510.12, 88.3746, 3.29553, "Teleporter script"),
(@ENTRY, 0, 107, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 11, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -3350.12, -3064.85, 33.0364, 5.12666, "Teleporter script"),
(@ENTRY, 0, 108, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 12, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -4808.31, 1040.51, 103.769, 2.90655, "Teleporter script"),
(@ENTRY, 0, 109, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 13, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -6940.91, -3725.7, 48.9381, 3.11174, "Teleporter script"),
(@ENTRY, 0, 110, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 14, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3117.12, -4387.97, 91.9059, 5.49897, "Teleporter script"),
(@ENTRY, 0, 111, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 15, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3898.8, -1283.33, 220.519, 6.24307, "Teleporter script"),
(@ENTRY, 0, 112, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 16, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -6291.55, -1158.62, -258.138, 0.457099, "Teleporter script"),
(@ENTRY, 0, 113, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 17, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -6815.25, 730.015, 40.9483, 2.39066, "Teleporter script"),
(@ENTRY, 0, 114, 0, 62, 0, 100, 0, @GOSSIP_MENU+6, 18, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 6658.57, -4553.48, 718.019, 5.18088, "Teleporter script"),
(@ENTRY, 0, 115, 0, 62, 0, 100, 0, @GOSSIP_MENU+7, 0, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -207.335, 2035.92, 96.464, 1.59676, "Teleporter script"),
(@ENTRY, 0, 116, 0, 62, 0, 100, 0, @GOSSIP_MENU+7, 1, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -220.297, 5378.58, 23.3223, 1.61718, "Teleporter script"),
(@ENTRY, 0, 117, 0, 62, 0, 100, 0, @GOSSIP_MENU+7, 2, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -2266.23, 4244.73, 1.47728, 3.68426, "Teleporter script"),
(@ENTRY, 0, 118, 0, 62, 0, 100, 0, @GOSSIP_MENU+7, 3, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -1610.85, 7733.62, -17.2773, 1.33522, "Teleporter script"),
(@ENTRY, 0, 119, 0, 62, 0, 100, 0, @GOSSIP_MENU+7, 4, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 2029.75, 6232.07, 133.495, 1.30395, "Teleporter script"),
(@ENTRY, 0, 120, 0, 62, 0, 100, 0, @GOSSIP_MENU+7, 5, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, 3271.2, 3811.61, 143.153, 3.44101, "Teleporter script"),
(@ENTRY, 0, 121, 0, 62, 0, 100, 0, @GOSSIP_MENU+7, 6, 0, 0, 62, 530, 0, 0, 0, 0, 0, 7, 0, 0, 0, -3681.01, 2350.76, 76.587, 4.25995, "Teleporter script"),
(@ENTRY, 0, 122, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 0, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 2954.24, 5379.13, 60.4538, 2.55544, "Teleporter script"),
(@ENTRY, 0, 123, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 1, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 682.848, -3978.3, 230.161, 1.54207, "Teleporter script"),
(@ENTRY, 0, 124, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 2, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 2678.17, 891.826, 4.37494, 0.101121, "Teleporter script"),
(@ENTRY, 0, 125, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 3, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 4017.35, -3403.85, 290, 5.35431, "Teleporter script"),
(@ENTRY, 0, 126, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 4, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 5560.23, -3211.66, 371.709, 5.55055, "Teleporter script"),
(@ENTRY, 0, 127, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 5, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 5614.67, 5818.86, -69.722, 3.60807, "Teleporter script"),
(@ENTRY, 0, 128, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 6, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 5411.17, -966.37, 167.082, 1.57167, "Teleporter script"),
(@ENTRY, 0, 129, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 7, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 6120.46, -1013.89, 408.39, 5.12322, "Teleporter script"),
(@ENTRY, 0, 130, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 8, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 8323.28, 2763.5, 655.093, 2.87223, "Teleporter script"),
(@ENTRY, 0, 131, 0, 62, 0, 100, 0, @GOSSIP_MENU+8, 9, 0, 0, 62, 571, 0, 0, 0, 0, 0, 7, 0, 0, 0, 4522.23, 2828.01, 389.975, 0.215009, "Teleporter script"),

-- --------------------------------------------------------------------------------------
-- StygianCore Portals
-- SmartScript Action 62 = MAPID (0 - KALIMDOR, 1 - AZEROTH (Eastern Kingdoms))
-- Pay attention to the value of SmartScript action 62. It needs the correct value for the teleport location to work.
-- --------------------------------------------------------------------------------------
(@ENTRY, 0, 132, 0, 62, 0, 100, 0, @GOSSIP_MENU+9, 0, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 966.147, 926.499, 104.649, 1.27231, "Sunrock Retreat"),
(@ENTRY, 0, 133, 0, 62, 0, 100, 0, @GOSSIP_MENU+9, 1, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -10733.8, 2509.35, 5.88962, 0.899085, "Silthus Camp"),
(@ENTRY, 0, 134, 0, 62, 0, 100, 0, @GOSSIP_MENU+9, 2, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -396.86, -2183.42, 158.1, 0.162564, "Koiter's Shrine"),
(@ENTRY, 0, 135, 0, 62, 0, 100, 0, @GOSSIP_MENU+9, 3, 0, 0, 62, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, -6583.62, -3486.57, 318.362, 0.49825, "Dead King's Crypt"),
(@ENTRY, 0, 136, 0, 62, 0, 100, 0, @GOSSIP_MENU+9, 4, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 6769.96, -4633.98, 721.208, 0.927772, "Winterspring"),
(@ENTRY, 0, 137, 0, 62, 0, 100, 0, @GOSSIP_MENU+9, 5, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 7758.24, -2409.7, 489.282, 4.14574, "Gem Vendors Moonglade"),
(@ENTRY, 0, 138, 0, 62, 0, 100, 0, @GOSSIP_MENU+9, 6, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -745.952, -989.286, 194.098, 2.01729, "Elise\'s Happy Place"),
(@ENTRY, 0, 139, 0, 62, 0, 100, 0, @GOSSIP_MENU+9, 7, 0, 0, 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 7443.72, -1690.19, 194.643, 5.49535, "Shatterspear Vale");

-- --------------------------------------------------------------------------------------
-- Teleporter Spawns
-- --------------------------------------------------------------------------------------
ALTER TABLE creature AUTO_INCREMENT = 200000;
INSERT INTO creature (id, map, spawnMask, phaseMask, modelid, position_x, position_y, position_z, orientation, spawntimesecs, spawndist, curhealth, curmana) VALUES
(@ENTRY, 0, 1, 1, 0, -13180.5, 342.503, 43.1936, 4.32977, 25, 0, 13700, 6540), 
(@ENTRY, 530, 1, 1, 0, -3862.69, -11645.8, -137.629, 2.38273, 25, 0, 13700, 6540), 
(@ENTRY, 0, 1, 1, 0, -4898.37, -965.118, 501.447, 2.25986, 25, 0, 13700, 6540), 
(@ENTRY, 0, 1, 1, 0, -8845.09, 624.828, 94.2999, 0.44062, 25, 0, 13700, 6540), 
(@ENTRY, 1, 1, 1, 0, 1599.25, -4375.85, 10.0872, 5.23641, 25, 0, 13700, 6540), 
(@ENTRY, 1, 1, 1, 0, -1277.65, 72.9751, 128.742, 5.95567, 25, 0, 13700, 6540), 
(@ENTRY, 0, 1, 1, 0, 1637.21, 240.132, -43.1034, 3.13147, 25, 0, 13700, 6540), 
(@ENTRY, 530, 1, 1, 0, 9741.67, -7454.19, 13.5572, 3.14231, 25, 0, 13700, 6540), 
(@ENTRY, 571, 1, 1, 0, 5807.06, 506.244, 657.576, 5.54461, 25, 0, 13700, 6540), 
(@ENTRY, 1, 1, 1, 0, 9866.83, 2494.66, 1315.88, 5.9462, 25, 0, 13700, 6540), 
(@ENTRY, 0, 1, 1, 0, -14279.8, 555.014, 8.90011, 3.97606, 25, 0, 13700, 6540), 
(@ENTRY, 530, 1, 1, 0, -1888.65, 5355.88, -12.4279, 1.25883, 25, 0, 13700, 6540),
-- --------------------------------------------------------------------------------------
-- StygianCore
-- --------------------------------------------------------------------------------------
(@ENTRY, 1, 1, 1, 0, -10750.6, 2470.34, 5.34563, 5.86648, 25, 0, 13700, 6540), 	-- Silithus Camp
(@ENTRY, 1, 1, 1, 0, 6766.89, -4638.56, 722.002, 0.649926, 25, 0, 13700, 6540), -- Winterspring
(@ENTRY, 1, 1, 1, 0, 1009.35, 1031.26, 104.883, 1.52364, 25, 0, 13700, 6540); 	-- Sunrock Retreat


-- --------------------------------------------------------------------------------------
-- Rune Spawns
-- --------------------------------------------------------------------------------------




-- END OF LINE