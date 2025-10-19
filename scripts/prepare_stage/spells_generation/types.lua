---@class MagicLineModel Модель данных о линейке спеллов
---@field school SpellSchoolType? Единственная школа спеллов в линейке
---@field schools SpellSchoolType[]? Несколько возможных школ спеллов в линейке(взаимоисключает предыдущее поле)
---@field count number Число спеллов в линейке
---@field min_lvl number? Минимальный уровень спеллов в линейке
---@field max_lvl number? Максимальный уровень спеллов в линейке
---@field space number? Число тайлов между спеллами при визуализации линейки
MagicLineModel = {}

---@class MagicLineEntry Модель сгенерированного спелла в линейке
---@field spell number Id спелла
---@field placeholder string Объект, на котором визуализируется спелл
---@field position Position Позиция объекта на карте
MagicLineEntry = {}