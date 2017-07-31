local L = Kazzak.Boop.Lib
local A = Kazzak.Boop.API
local T = Kazzak.Boop.Types
local UI = Kazzak.Boop.UI
local H = Kazzak.Boop.Helper

local function createAura(...)
	local arg = {...}
	return {
		name = arg[1] or nil,
		rank = arg[2] or nil,
		icon = arg[3] or nil,
		count = arg[4] or nil,
		dispelType = arg[5] or nil,
		duration = arg[6] or nil,
		expires = arg[7] or nil,
		caster = arg[8] or nil,
		isStealable = arg[9] or nil,
		nameplateShowPersonal = arg[10] or nil,
		spellID = arg[11] or nil,
		canApplyAura = arg[12] or nil,
		isBossDebuff = arg[13] or nil,
		nameplateShowAll = arg[14] or nil,
		timeMod = arg[15] or nil,
		value1 = arg[16] or nil,
		value2 = arg[17] or nil,
		value3 = arg[18] or nil }
end

function Kazzak.Boop.API:UnitAura(unit, name, filter)
	return createAura(UnitAura(unit, name, filter))
end

function Kazzak.Boop.API:UnitBuff(unit, name, filter)
	return createAura(UnitBuff(unit, name, filter))
end

function Kazzak.Boop.API:UnitDebuff(unit, name, filter)
	return createAura(UnitDebuff(unit, name, filter))
end

function Kazzak.Boop.API:GetSpellInfo(spell)
	local name, rank, icon, castingTime, minRange,
	maxRange, spellID = GetSpellInfo(spell)
	return {
		name = name,
		rank = rank,
		icon= icon,
		castingTime = castingTime,
		minRange = minRange,
		maxRange = maxRange,
		spellID = spellID
	}
end

function Kazzak.Boop.API:UnitCastingInfo(unit)
	local name, subText, text, texture, startTime,
	endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit)

	return {
		name = name,
		subText = subText,
		text = text,
		texture = texture,
		startTime = startTime,
		endtime = endtime,
		isTradeSkill = isTradeSkill,
		castID = castID,
		notInterruptible = notInterruptible
	}
end
