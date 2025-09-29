---@alias SingleHeroDraftPhase
---|`SINGLE_HERO_DRAFT_PHASE_BAN`
---|`SINGLE_HERO_DRAFT_PHASE_PICK`
SINGLE_HERO_DRAFT_PHASE_BAN = 1
SINGLE_HERO_DRAFT_PHASE_PICK = 2

---@class PlayerDraftableHero
---@field owner PlayerID
---@field player_portait string
---@field opponent_portrait string
---@field picked fun(initiator: string)
---@field banned fun(initiator: string)
PlayerDraftableHero = {}

---@alias DraftActionType
---|`HERO_SELF_PICKED`
---|`HERO_SELF_BANNED`
---|`HERO_BANNED_FOR_OPP`
---|`HERO_PICKED_FOR_OPP`
HERO_SELF_PICKED = 1
HERO_SELF_BANNED = 2
HERO_BANNED_FOR_OPP = 3
HERO_PICKED_FOR_OPP = 4

---@class CompletedDraftAction
---@field made_by PlayerID
---@field type DraftActionType
---@field hero string
CompletedDraftAction = {}

---@alias PortraitDisplaceReason
---|`PORTRAIT_DISPLACE_REASON_PICK`
---|`PORTRAIT_DISPLACE_REASON_BAN`
PORTRAIT_DISPLACE_REASON_PICK = 1
PORTRAIT_DISPLACE_REASON_BAN = 2