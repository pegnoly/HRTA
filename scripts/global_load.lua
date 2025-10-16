doFile('/scripts/testing/core.lua')

-- Технические функции
doFile('/scripts/utils/unlim_moves_threads.lua')
doFile('/scripts/utils/player.lua')
doFile('/scripts/utils/map.lua')

-- Драфты
doFile('/scripts/drafts/consts.lua')
doFile('/scripts/drafts/core.lua')
doFile('/scripts/drafts/FivePairDraft/script.lua')

doFile('/scripts/drafts/HeroesDraft/types.lua')
doFile('/scripts/drafts/HeroesDraft/script.lua')

-- Подготовка к бою
doFile('/scripts/prepare_stage/types.lua')
doFile('/scripts/prepare_stage/core.lua')

doFile('/scripts/prepare_stage/towns_setup/script.lua')
-- doFile('/scripts/prepare_stage/army_generation/script.lua')

-- Режимы игры
doFile('/scripts/game_modes/types.lua')
doFile('/scripts/game_modes/core.lua')

-- Астрология
doFile('/scripts/game_modes/astrology/types.lua')
doFile('/scripts/game_modes/astrology/core.lua')
doFile('/scripts/game_modes/astrology/nargott/script.lua')
doFile('/scripts/game_modes/astrology/sithis/script.lua')
doFile('/scripts/game_modes/astrology/auotor/script.lua')
doFile('/scripts/game_modes/astrology/arhydevi/script.lua')