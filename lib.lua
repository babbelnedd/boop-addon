local L = Kazzak.Boop.Lib
local A = Kazzak.Boop.API
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
