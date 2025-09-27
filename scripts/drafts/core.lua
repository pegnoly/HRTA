-- Общая логика для всех черков

while not DRAFT_TYPE_FIVE and asha do
    sleep()
end

print"Ok"

drafts_core = {

    path = "/Text/HRTA/drafts/",

    town_representations = {
        [TOWN_HEAVEN] = CREATURE_SWORDSMAN,
        [TOWN_INFERNO] = CREATURE_SUCCUBUS_SEDUCER,
        [TOWN_NECROMANCY] = CREATURE_VAMPIRE_LORD,
        [TOWN_PRESERVE] = CREATURE_SHARP_SHOOTER,
        [TOWN_DUNGEON] = CREATURE_BLOOD_WITCH,
        [TOWN_ACADEMY] = CREATURE_ARCH_MAGI,
        [TOWN_FORTRESS] = CREATURE_FLAME_MAGE,
        [TOWN_STRONGHOLD] = CREATURE_ORCCHIEF_EXECUTIONER
    },

    heroes_pool = {
        [TOWN_HEAVEN] = {
            "Orrin",
            "Christian",
            "Mardigo",
            "Maeve",
            "Ving",
            "Sarge",
            "Nathaniel",
            "Alaric",
            "Godric",
            "RedHeavenHero03"
        },
        [TOWN_INFERNO] = {
            "Agrael",
            "Orlando",
            "Nymus",
            "Efion",
            "Deleb",
            "Calid",
            "Oddrema",
            "Grok",
            "Marder",
            "Jazaz"
        },
        [TOWN_NECROMANCY] = {
            "Pelt",
            "Nemor",
            "Muscip",
            "Aberrar",
            "Effig",
            "Berein",
            "OrnellaNecro",
            "Straker",
            "Tamika",
            "Gles"
        },
        [TOWN_PRESERVE] = {
            "Diraya",
            "Metlirn",
            "Linaas",
            "Elleshar",
            "Gillion",
            "Itil",
            "Nadaur",
            "Heam",
            "Ildar",
            "Ossir"
        },
        [TOWN_DUNGEON] = {
            "Urunir",
            "Almegir",
            "Menel",
            "Dalom",
            "Inagost",
            "Ferigl",
            "Eruina",
            "Kelodin",
            "Shadwyn",
            "Ohtarig"
        },
        [TOWN_ACADEMY] = {
            "Zehir",
            "Tan",
            "Maahir",
            "Razzak",
            "Nur",
            "Astral",
            "Sufi",
            "Faiz",
            "Havez",
            "Nur"
        },
        [TOWN_FORTRESS] = {
            "Brand",
            "Bersy",
            "Una",
            "Ingvar",
            "Skeggy",
            "Vegeyr",
            "Ottar",
            "Egil",
            "Wulfstan",
            "Rolf"
        },
        [TOWN_STRONGHOLD] = {
            "Hero1",
            "Hero2",
            "Hero3",
            "Hero4",
            "Hero6",
            "Hero7",
            "Hero8",
            "Hero9",
            "Gottai",
            "Kujin",
            "Quroq"
        }
    },

    Init = 
    --- Старт любого драфта - записать тип драфта в Асху, убрать мувы героев, вывести сообщение о скипе
    ---@param day number
    function (day)
        if day == DRAFTS_SKIP_DAY then
            asha.AddGlobalField("DraftType", drafts_core.GetDraftType())
            for player = PLAYER_1, PLAYER_2 do
                local hero = GetPlayerHeroes(player)[0]
                unlim_moves_threads.UpdateMoveThreadType(hero, MOVE_THREAD_TYPE_NO_MOVES)
                MessageQueue.AddMessage(player, drafts_core.path.."skip_day.txt", hero, 7.0)
            end
        end
    end,

    GetDraftType = 
    --- Возвращает выбранный тип драфта
    ---@return DraftType result
    function ()
        local result = GetDifficulty() + 1
        return result
    end
}

NewDayEvent.AddListener("HRTA_drafts_core_new_day_listener",
function (day)
    startThread(drafts_core.Init, day)
end)