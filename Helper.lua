local L = Kazzak.Boop.Lib
local A = Kazzak.Boop.API
local T = Kazzak.Boop.Types
local UI = Kazzak.Boop.UI
local H = Kazzak.Boop.Helper

local function TableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                TableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function Kazzak.Boop.Helper:SetOpt(o, n, d)
	if o == nil then o = {} end
	if o[n] == nil then
	  o[n] = d
	else
	  if type(o[n]) == 'table' and type(d) == 'table' then
	    TableMerge(d, o[n])
	    o[n] = d
	  end
	end
end

function Kazzak.Boop.Helper:Compare(field)
  return function(a,b)
    if field then return (a[field] or '') < (b[field] or '') end
    return a < b
    end
end

function Kazzak.Boop.Helper:Equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or Equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

function Kazzak.Boop.Helper:TableHasValue(t, v)
	for index, value in ipairs(t) do
		if value == v then
			return true
		end
	end
	return false
end

function Kazzak.Boop.Helper:TableHasAnyValue(t, v)
  for i=1, #v do
		if self:TableHasValue(t, v[i]) then return true end
	end
	return false
end

function Kazzak.Boop.Helper:Round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function Kazzak.Boop.Helper:Split(input, sep)
	local input = tostring(input)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(input, "([^"..sep.."]+)") do
	        t[i] = str
	        i = i + 1
	end
	return t
end

function Kazzak.Boop.Helper:ConvertSecToMS(duration)
	local duration = duration
	if duration > 1 then durtation = self:Split(duration, '.')[1] end
	local minutes = math.floor(duration / 60)
	local seconds = math.floor(duration - minutes * 60)

	if minutes > 0 then
	 if seconds < 10 then seconds = '0'..seconds end
		return string.format('%s:%s', minutes, seconds)
	else
		return duration
	end
end


function Kazzak.Boop.Helper:ColorGradient(from, to, progress)


end
