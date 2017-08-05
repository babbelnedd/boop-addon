local L = Kazzak.Boop.Lib
local API = Kazzak.Boop.API
local T = Kazzak.Boop.Types
local UI = Kazzak.Boop.UI
local H = Kazzak.Boop.Helper

function Kazzak.Boop.Lib:GroupMembers(reversed, forceParty)
    local unit  = (not forceParty and IsInRaid()) and 'raid' or 'party'
    local numGroupMembers = forceParty and GetNumSubgroupMembers()  or GetNumGroupMembers()
    local i = reversed and numGroupMembers or (unit == 'party' and 0 or 1)
    return function()
        local ret
        if i == 0 and unit == 'party' then
            ret = 'player'
        elseif i <= numGroupMembers and i > 0 then
            ret = unit .. i
        end
        i = i + (reversed and -1 or 1)
        return ret
    end
end

function Kazzak.Boop.Lib:Auras(unit, filter)
  local i = 0

  return function()
    local aura
    while i < 41 do
      i = i + 1
      aura = API:UnitAura(unit, i, filter)
      if aura.name == nil then return nil end
      return aura
    end
    return nil
  end
end

function Kazzak.Boop.Lib:GetSpellIcon(name)
    _, _, icon = GetSpellInfo(name)
    return icon
end

function Kazzak.Boop.Lib:GetRemainingCooldown(name, ignore_gcd)
    local start, duration = GetSpellCooldown(name)
    local remaining = 0

		if not start or not duration then return nil end

    if (duration > 0) then
        if((ignore_gcd ~= true) or (ignore_gcd == true and duration ~= WeakAuras.gcdDuration())) then
            remaining = math.abs(GetTime() - (start + duration))
        end
    end

    return remaining
end

function Kazzak.Boop.Lib:GetDurationInfo(name)
    local start, duration = GetSpellCooldown(name)
    return duration, start + duration
end

function Kazzak.Boop.Lib:GetGCD(id)
  local spell = API:GetSpellInfo(id)
  local cd = L:GetRemainingCooldown(spell.name, true)
  local gcd = L:GetRemainingCooldown(spell.name, false)
  if cd <= 0 and gcd > 0 then
    local now = GetTime()
    return gcd, now+gcd
  else
    return false
  end
end

function Kazzak.Boop.Lib:ShortenNumber(number)
    if type(number) ~= "number" then  number = tonumber(number) end
    if not number then return end

    local affixes = { '', 'k', 'm', 'b' }
    
    local affix = 1
    local dec = 0
    local num1 = math.abs(number)
    while num1 >= 1000 and affix < #affixes do
        num1 = num1 / 1000
        affix = affix + 1
    end
    if affix > 1 then
        dec = 2
        local num2 = num1
        while num2 >= 10 do
            num2 = num2 / 10
            dec = dec - 1
        end
    end
    if number < 0 then
        num1 = -num1
    end

    return string.format("%."..dec.."f"..affixes[affix], num1)
end
