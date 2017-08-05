local L = Kazzak.Boop.Lib
local API = Kazzak.Boop.API
local T = Kazzak.Boop.Types
local UI = Kazzak.Boop.UI
local H = Kazzak.Boop.Helper

function Kazzak.Boop.UI:CreateText(parent, opt)
	local parent = parent
  local opt = opt or {}

  H:SetOpt(opt, 'font', Kazzak.Boop.Media.Font.PT_Sans_Narrow)
  H:SetOpt(opt, 'fontFlags', 'OUTLINE')
  H:SetOpt(opt, 'fontSize', 12)
  H:SetOpt(opt, 'xOffset', 0)
  H:SetOpt(opt, 'yOffset', 0)
  H:SetOpt(opt, 'anchor', 'CENTER')
  H:SetOpt(opt, 'containment', 'INSIDE')
  H:SetOpt(opt, 'color', { r=1,g=1,b=1,a=1 })
  H:SetOpt(opt, 'justifyHor', 'CENTER')
  H:SetOpt(opt, 'justifyVer', 'TOP')
  H:SetOpt(opt, 'wordWrap', true)
  H:SetOpt(opt, 'textWidth', 0) -- 0 to adjust dynamically
  H:SetOpt(opt, 'textHeight', 0) -- 0 to adjust dynamically
  H:SetOpt(opt, 'rotate', 0)
	H:SetOpt(opt, 'additionalFrameLevel', 1)
  local f = CreateFrame('frame', nil, parent)
  local t = f:CreateFontString(nil, 'OVERLAY')

  f:SetFrameLevel(parent:GetFrameLevel() + opt.additionalFrameLevel)

  if(opt.containment == 'INSIDE') then
      t:ClearAllPoints()
      t:SetPoint(opt.anchor, parent, opt.anchor, opt.xOffset, opt.yOffset);
  else
      local selfPoint = T.inverse_point_types[anchor];
      t:ClearAllPoints()
      t:SetPoint(selfPoint, parent, opt.anchor, opt.xOffset, opt.yOffset);
  end

  t:SetFont(opt.font, opt.fontSize, opt.fontFlags)
  t:SetTextColor(opt.color.r, opt.color.g, opt.color.b, opt.color.a)
  t:SetJustifyH(opt.justifyHor)
  t:SetJustifyV(opt.justifyVer)
  t:SetWordWrap(opt.wordWrap)
  t:SetSize(opt.textWidth, opt.textHeight)
  t:SetText('')
	t:Show()
  --if opt.rotate ~= 0 then animRotate(altText, rotate) end

  return t
end

function Kazzak.Boop.UI:CreateIconFrame(parent, opt)
  local parent = parent
  local opt = opt or {}
  H:SetOpt(opt, 'texture', '')
  H:SetOpt(opt, 'multiplier', 1.1)
  H:SetOpt(opt, 'frameLevel', parent:GetFrameLevel() + 1)
  H:SetOpt(opt, 'anchor', 'TOPLEFT')
  H:SetOpt(opt, 'texCoord', {l=0, r=1, t=0, b=1})
  H:SetOpt(opt, 'backdrop', {r=1,g=1,b=1,a=1})

  local w, h = parent:GetWidth(), parent:GetHeight()
  local diffW, diffH = (w * opt.multiplier) - w,
                       (h * opt.multiplier) - h

  local frame = CreateFrame('frame', nil, parent)
  frame:SetFrameLevel(opt.frameLevel)
  frame:SetSize(w * opt.multiplier, h * opt.multiplier)

  local tex = frame:CreateTexture(nil, 'BACKGROUND')
  tex:SetTexture(opt.texture)
  tex:SetVertexColor(opt.backdrop.r, opt.backdrop.g,
                     opt.backdrop.b, opt.backdrop.a)
  tex:SetTexCoord(opt.texCoord.l, opt.texCoord.r,
                  opt.texCoord.t, opt.texCoord.b)
  tex:SetAllPoints(frame)

  frame.texture = tex
  frame:SetPoint(opt.anchor, -1 * diffW/2, diffH/2)
  frame:Show()
  return frame
end

function Kazzak.Boop.UI:SetupIconFrame(frame, tex, opt)
	local frame = frame
  local opt = opt or {}
	local parent = frame:GetParent()

  H:SetOpt(opt, 'multiplier', 1.1)
  H:SetOpt(opt, 'frameLevel', parent:GetFrameLevel() + 1)
  H:SetOpt(opt, 'anchor', 'TOPLEFT')
  H:SetOpt(opt, 'texCoord', {l=0, r=1, t=0, b=1})
  H:SetOpt(opt, 'backdrop', {r=1,g=1,b=1,a=1})

  local w, h = parent:GetWidth(), parent:GetHeight()
  local diffW, diffH = (w * opt.multiplier) - w,
                       (h * opt.multiplier) - h

  --local frame = CreateFrame('frame', nil, parent)
  frame:SetFrameLevel(opt.frameLevel)
  frame:SetSize(w * opt.multiplier, h * opt.multiplier)
	frame.texture = UI:SetupIconFrameTexture(tex, opt)
  frame:SetPoint(opt.anchor, -1 * diffW/2, diffH/2)
  frame:Show()
  return frame
end

function UI:SetupIconFrameTexture(tex, opt)
	local opt = opt or {}
	H:SetOpt(opt, 'texture', '')
	H:SetOpt(opt, 'backdrop', {r=1,g=1,b=1,a=1})
	H:SetOpt(opt, 'texCoord', {l=0,r=1,t=0,b=1})


	--local tex = frame:CreateTexture(nil, 'BACKGROUND')
	tex:SetTexture(opt.texture)
	tex:SetVertexColor(opt.backdrop.r, opt.backdrop.g,
										 opt.backdrop.b, opt.backdrop.a)
	tex:SetTexCoord(opt.texCoord.l, opt.texCoord.r,
									opt.texCoord.t, opt.texCoord.b)
	tex:SetAllPoints(tex:GetParent())
	return tex
end

function Kazzak.Boop.UI:ActionbarItem(spellID, env, opt)
  local function GetSpellID(spellID)
		local spellID = spellID
		if type(spellID) == 'table' then
			for i, sid in ipairs(spellID) do
				if IsSpellKnown(sid) then
					return sid
				end
			end
		end
		return spellID
	end


	Kazzak.Boop.FRAMES.ActionBarItems = Kazzak.Boop.FRAMES.ActionBarItems or {}
	local ABI = Kazzak.Boop.FRAMES.ActionBarItems

	ABI[env.id] = ABI[env.id] or {}
	local F = ABI[env.id]
	local env = env
	local spellID = spellID
	local opt = opt or {}
	local region = WeakAuras.regions[env.id].region
	H:SetOpt(opt, 'threshold', 3)
	H:SetOpt(opt, 'useBuff', true)
  H:SetOpt(opt, 'color', {
			border = {
  			active = {r = 0, g = 1, b = 1, a = 1},
  			default = {r = 1, g = 1, b = 1, a = 1},
  			cooldown = {r = 0.33, g = 0.33, b = 0.33, a = 1}
			},
			overlay = {
				default = {r = 0.1, g = 0.1, b = 0.1, a = 0.75},
				active = {r=0, g=0.75,b=0.75, a=0.75}
			},
			text = {
				default = {r = 1, g = 1, b = 1, a = 1},
				active = {r=0, g=1,b=1, a=1},
				threshold = {r=1, g=0, b=0, a=1}
			}
		})

  env.selectedTalent = GetSpellID(spellID)
	env.spellID = GetSpellID(spellID)
	env.name = API:GetSpellInfo(env.spellID).name
	env.icon = L:GetSpellIcon(env.spellID)
	env.text = {}
	env.texture = {	}
	env.text.center = F.textCenter or UI:CreateText(region, { fontSize = 18	})

	-- DevTools_Dump(spellID)
	-- DevTools_Dump(env.spellID)
	-- print '-------------'

	env.texture.border = F.textureBorder or CreateFrame('frame', nil, region)
	env.texture.overlay = F.textureOverlay or CreateFrame('frame', nil, region)
	F.textureBorderTex = F.textureBorderTex or env.texture.border:CreateTexture(nil, 'BACKGROUND')
	F.textureOverlayTex = F.textureOverlayTex or env.texture.overlay:CreateTexture(nil, 'BACKGROUND')

	env.texture.border = UI:SetupIconFrame(env.texture.border, F.textureBorderTex, {
		texture = 'interface\\addons\\boop\\media\\textures\\Normal_NS',
		multiplier = 1.166666666666667,
		frameLevel = region:GetFrameLevel() + 2,
		color = opt.color.default })
	env.texture.overlay = UI:SetupIconFrame(env.texture.overlay, F.textureOverlayTex, {
		texture = Kazzak.Boop.Media.Background.Solid,
		backdrop = {r = 0.1, g = 0.1, b = 0.1, a = 0.75},
		multiplier = 1,
		anchor = 'BOTTOM',
		frameLevel = region:GetFrameLevel() + 1 })

  F.textureBorderTex = env.texture.border.texture
	F.textureOverlayTex = env.texture.overlay.texture
	F.textCenter = F.textCenter or env.text.center
	F.textureBorder = F.textureBorder or env.texture.border
	F.textureOverlay = F.textureOverlay or env.texture.overlay

	env.texture.overlay:Hide()

	F.textureBorder:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
	F.textureBorder:SetScript('OnEvent', function(self, e)
		if e ~= 'PLAYER_SPECIALIZATION_CHANGED' then return end
		env.selectedTalent = GetSpellID(spellID)
		env.spellID = env.selectedTalent
		env.name = API:GetSpellInfo(env.spellID).name
		env.icon = L:GetSpellIcon(env.spellID)
	end)

	function env:Update()
		local cd = L:GetRemainingCooldown(self.name, true)
		local ov = self.texture.overlay
		local center = self.text.center

		if cd > 0 then
			local aura = API:UnitBuff('player', self.name)
			local active = aura.name ~= nil
			local start, dur = GetSpellCooldown(self.name)
			local maxH = region:GetHeight()
			local height = 0
			local rem = ''

			if active and opt.useBuff == true then
				local c = opt.color.border.active
				env.texture.border.texture:SetVertexColor(c.r, c.g, c.b, c.a)
				c = opt.color.overlay.active
				env.texture.overlay.texture:SetVertexColor(c.r, c.g, c.b, c.a)
				c = opt.color.text.active
				env.text.center:SetTextColor(c.r, c.g, c.b, c.a)
				rem = (aura.expires - GetTime())
				height = maxH - math.floor((rem / (aura.duration / 100)) * (maxH / 100))
				region:Color(1, 1, 1, 1)
			else
				local c = opt.color.border.cooldown
				env.texture.border.texture:SetVertexColor(c.r, c.g, c.b, c.a)
				c = opt.color.overlay.default
				env.texture.overlay.texture:SetVertexColor(c.r, c.g, c.b, c.a)
				height = math.floor(cd / (dur / 100) * (maxH / 100))
				rem = cd

				if rem <= opt.threshold and not active then
					c = opt.color.text.threshold
					env.text.center:SetTextColor(c.r, c.g, c.b, c.a)
				else
					c = opt.color.text.default
					env.text.center:SetTextColor(c.r, c.g, c.b, c.a)
				end

				region:Color(0.6, 0.6, 0.6, 1)
			end

			ov:SetHeight(height)
			ov:Show()
			if rem < 1 then rem = H:Round(cd, 1) else rem = H:Round(rem) end
			center:SetText(H:ConvertSecToMS(rem))
			center:Show()
		else
			center:Hide()
			ov:Hide()
			local c = opt.color.border.default
			env.texture.border.texture:SetVertexColor(c.r, c.g, c.b, c.a)
			region:Color(1, 1, 1, 1)
		end
	end

	return env
end

function Kazzak.Boop.UI:CreateCastBar(env, opt)
	local env = env
	local region = WeakAuras.regions[env.id].region
	local opt = opt or {}

	H:SetOpt(opt, 'unit', 'player')
	H:SetOpt(opt, 'backdrop', {
		GetValues = function()
			local cur, max = math.max(0, UnitHealth(opt.unit)),
							         math.max(1, UnitHealthMax(opt.unit))

			return 0, max, cur
		end,
		GetText = function(self, min, max, cur)
			local p = cur / max * 100;
		  return string.format('%.f%%', p)
		 end,
		texture = Kazzak.Boop.Media.Background.Solid,
		color = {r=0.33,g=0.33,b=0.33,a=1},
		backgroundColor = {r=0,g=0,b=0,a=1},
		parent = region,
		alwaysVisible = false
	})
	H:SetOpt(opt, 'action', {
		IsActive = function(self) return false end,
		color = {r=1,g=0,b=0,a=0.25}
	})
	local r,g,b,a = region.bar:GetForegroundColor()
	H:SetOpt(opt, 'defaultColor', {r=r,g=g,b=b,a=a})
	H:SetOpt(opt, 'icon', {
		enabled = false,
		background = Kazzak.Boop.Media.Background.Solid,
		height = nil,
		width = nil,
		borderSize = 1,
		anchor = {
			relativeTo = nil,
			point = 'RIGHT',
			relativePoint = 'LEFT',
			xOffset = 0,
			yOffset = 0
		}
	})

	local function CreateStatusBar()
		--local f = CreateFrame('statusbar', nil, opt.backdrop.parent)
		--local f = CreateFrame('statusbar', nil, UIParent)
		local f = CreateFrame('statusbar', nil, region)
		f:SetFrameLevel(math.max(0, region:GetFrameLevel() - 1))
		f:SetPoint('TOPLEFT', region, 'TOPLEFT', 0, 0)
		f:SetSize(region:GetSize())
		f:SetBackdrop({ bgFile = opt.backdrop.texture })
		f:SetBackdropColor(opt.backdrop.backgroundColor.r, opt.backdrop.backgroundColor.g,
											 opt.backdrop.backgroundColor.b, opt.backdrop.backgroundColor.a)
		f:SetStatusBarTexture(opt.backdrop.texture)
		f:SetStatusBarColor(opt.backdrop.color.r, opt.backdrop.color.g,
												opt.backdrop.color.b, opt.backdrop.color.a)
		return f
	end
	local function CreateIcon()
		if opt.icon.enabled ~= true then return nil end
		local iFrame = CreateFrame('frame', nil, region)
		local iTex = iFrame:CreateTexture(nil, 'ARTWORK')
		local bFrame = CreateFrame('frame', nil, iFrame)
		local bTex = iFrame:CreateTexture(nil, 'BACKGROUND')
		local h = opt.icon.height or opt.icon.anchor.relativeTo:GetHeight()
		local w = opt.icon.width or opt.icon.anchor.relativeTo:GetHeight()
		bTex:SetTexture(opt.icon.background)
		bTex:SetAllPoints(bFrame)
		bTex:SetVertexColor(0, 0, 0, 1)
		bFrame.texture = bTex
		bFrame:SetPoint('TOPLEFT', -1, 1)
		bFrame:SetSize(w, h)
		bFrame.texture = bTex

		iFrame:SetSize(w - opt.icon.borderSize, h - opt.icon.borderSize)
		iTex:SetAllPoints(iFrame)
		iTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		iFrame.texture = iTex
		iFrame:SetPoint(opt.icon.anchor.point, opt.icon.anchor.relativeTo,
									  opt.icon.anchor.relativePoint, opt.icon.anchor.xOffset,
										opt.icon.anchor.yOffset)


		bFrame:Hide()
		iFrame:Hide()
		return iFrame, bFrame
	end

	local h = region:GetHeight()
	local cb = {}
	cb.backdrop = CreateStatusBar()
	cb.text = {
				left = UI:CreateText(cb.backdrop, {anchor = 'left', xOffset = h/10, additionalFrameLevel = 2}),
				center = UI:CreateText(cb.backdrop, {anchor = 'center', additionalFrameLevel = 2}),
				right = UI:CreateText(cb.backdrop, {anchor = 'right', xOffset = -(h/10), additionalFrameLevel = 2})
  }
	cb.icon, cb.border = CreateIcon()


	function cb:IsActive()
		return API:UnitCastingInfo(opt.unit).name ~= nil or
					 API:UnitChannelInfo(opt.unit).name ~= nil or false
	end
	function cb:DurationInfo()
		local _,_,_,_,start,finish = UnitCastingInfo(opt.unit)
		if start == nil then _,_,_,_,start,finish = UnitChannelInfo(opt.unit) end
		if start == nil then start,finish = 0,0 end
		--if start == nil then start,finish = 0, 0 end
		local duration = ((finish - start)/1000)
		local expiration = (finish/1000)
		return duration, expiration
	end
	function cb:GetName()
		return API:UnitCastingInfo(opt.unit).name or
					 API:UnitChannelInfo(opt.unit).name or ''
	end
	function cb:UpdateBackdrop(isActive)
			local min, max, cur = opt.backdrop:GetValues()
			self.backdrop:SetMinMaxValues(min, max)
			self.backdrop:SetValue(cur)
	end
	function cb:UpdateStatusBar(isActive)
		if isActive then
			local dur, exp = self:DurationInfo()
			local now = GetTime()
			local value = dur-(exp-now)
			if UnitChannelInfo(opt.unit) ~= nil then
				value = exp-now
			end
			region.bar:SetMinMaxValues(0, dur)
			region.bar:SetValue(value)
			region.bar:Show()
		else
			region.bar:SetMinMaxValues(0, 100)
			region.bar:SetValue(0)
			region.bar:Hide()
		end
	end
	function cb:UpdateTexts(isActive)
		local rem = H:Round(select(2, self:DurationInfo()) - GetTime(), 1)
		if rem > 0 then
			if not string.match(rem, '%.') then rem = rem..'.0' end
			self.text.left:SetText(rem)
		else
			self.text.left:SetText('')
		end
		self.text.center:SetText(self:GetName())
		self.text.right:SetText(opt.backdrop:GetText(opt.backdrop:GetValues()))
	end
	function cb:UpdateAction(isActive)
		if isActive and opt.action:IsActive() then
			region.bar:SetForegroundColor(opt.action.color.r, opt.action.color.g, opt.action.color.b, opt.action.color.a)
		else
			region.bar:SetForegroundColor(opt.defaultColor.r, opt.defaultColor.g, opt.defaultColor.b, opt.defaultColor.a)
		end
	end
	function cb:UpdateIcon(isActive)
		if opt.icon.enabled == true and isActive then
				local x = API:UnitCastingInfo(opt.unit)
				if x.name == nil then x = API:UnitChannelInfo(opt.unit) end
				self.icon.texture:SetTexture(x.texture)
				self.icon:Show()
				self.border:Show()
			else
				self.icon:Hide()
				self.border:Hide()
		end
	end
	function cb:Update()
		local isActive = self:IsActive()
		self:UpdateIcon(isActive)
		self:UpdateAction(isActive)
		self:UpdateBackdrop(isActive)
		self:UpdateStatusBar(isActive)
	  self:UpdateTexts(isActive)
	end

	env.castbar = cb
	return env
end

--[[
function Kazzak.Boop.UI:InitializeAuraBars(env, opt)
	local env = env
	local region = WeakAuras.regions[env.id].region
	local opt = opt or {}
	local MAX_VALUE = 100000
	local MAX_VALUE_1P = MAX_VALUE / 100
	H:SetOpt(opt, 'backdrop', { bgFile = 'Interface\\BUTTONS\\WHITE8X8.blp'})
	H:SetOpt(opt, 'height', 25)
	H:SetOpt(opt, 'width', 200)
	H:SetOpt(opt, 'spacing', 3)
	H:SetOpt(opt, 'texture', 'Interface\\BUTTONS\\WHITE8X8.blp')
	H:SetOpt(opt, 'orderBy', 'remaining')
	H:SetOpt(opt, 'icon', {enabled = true, anchor = 'LEFT'})
	H:SetOpt(opt, 'zoom', 30)
	H:SetOpt(opt, 'anchor', 'TOPLEFT')
	H:SetOpt(opt, 'growUpwards', false)
	H:SetOpt(opt, 'filter', {})
	H:SetOpt(opt, 'tooltip', true)
	H:SetOpt(opt, 'text', {left='%n', center='', right='%r', digits=2})
	H:SetOpt(opt, 'getAuras', function(u,i) return API:unitBuff(u,i) end)
	H:SetOpt(opt, 'LTR', false)
	H:SetOpt(opt, 'color', {
		back = {r=0.11,g=0.11,b=0.11,a=1},
		front = {r=0.33,g=0.33,b=0.33,a=1}
	})
	H:SetOpt(opt, 'orientation', 'HORIZONTAL')
	env.opt = opt
	env.auras = {}
	env.sb = {}
	env.sbT = {}
	env.sbI = {}
	local y = 0

	local function grow(y)
		if opt.growUpwards then
			return y + opt.height + opt.spacing
		else
			return y - (opt.height + opt.spacing)
		end
	end

	local function OnEnter(self)
		if opt.tooltip == true then
			_G["GameTooltip"]:SetOwner(self, 'ANCHOR_CURSOR')
			_G["GameTooltip"]:SetSpellByID(self.__auraID)
			_G["GameTooltip"]:Show()
		end
	end

	local function OnLeave(self)
		if opt.tooltip == true then
			_G["GameTooltip"]:Hide()
		end
	end

	function UpdateText(text, aura)
		local text = text or ''
		if #text > 0 then
			local rem = H:Round(aura.expires - GetTime(), opt.text.digits)
			text = string.gsub(text, '%%r', H:ConvertSecToMS(rem))
			text = string.gsub(text, '%%d', aura.duration)
			text = string.gsub(text, '%%n', aura.name)
		end
		return text
	end

	function env:Update()
		local env = self
		local auras = {}
		local now = GetTime()
		local emptyAura = API:UnitAura('player', -1)

		for i=1,40 do
			--local aura = API:UnitBuff('player', i)
			local aura = opt.getAuras('player', i)
			function aurAPI:Remaining()
				if self.__remaining == nil then
					self.__remaining = (self.expires or 0) - now
				end
			  return self.__remaining
			end
			function aurAPI:Percent()

				return self:Remaining() / ((self.duration or 100) / 100)
			end

			if H:TableHasAnyValue(env.opt.filter, {aura.spellID, aura.name}) then
				 auras[i] = emptyAura
			 else
				 auras[i] = aura
			 end

		 	env.auras[i].bar.__auraID = aura.spellID
			env.auras[i].icon.__auraID =  aura.spellID
			env.auras[i].bar:Hide()
			env.auras[i].text:Hide()
		  env.auras[i].icon:Hide()
		end

		if opt.orderBy == 'remaining' or opt.orderBy == 'value' then
			table.sort(auras, function(a,b) return API:Remaining() < b:Remaining() end)
		elseif opt.orderBy == 'duration' then
			table.sort(auras, function(a, b) return (a.duration or 0) < (b.duration or 0) end)
		elseif opt.orderBy == 'percent' then
			table.sort(auras, function(a, b) return API:Percent() < b:Percent() end)
		elseif opt.orderBy == 'name' then
			table.sort(auras, Compare('name'))
		end

		local n = 1
		for i=1,40 do
			local aura = auras[i]
			if aura.name ~= nil and aura.duration > 0 then

				local v = aurAPI:Percent() * (MAX_VALUE_1P)
				--if opt.LTR == true then v = MAX_VALUE - v end

				env.auras[n].bar:SetValue(v)
				env.auras[n].icon.texture:SetTexture(aura.icon)

				env.auras[n].text.left:SetText(UpdateText(opt.text.left, aura))
				env.auras[n].text.center:SetText(UpdateText(opt.text.center, aura))
				env.auras[n].text.right:SetText(UpdateText(opt.text.right, aura))

				env.auras[n].bar:Show()
				env.auras[n].text:Show()
				if env.opt.icon.enabled == true then
					env.auras[n].icon:Show()
				end

				n = n + 1
			end
		end

		return env
	end

	for i=1, 40 do
		env.auras[i] = {bar, text, icon}
		y = grow(y)
	  local sb = CreateFrame("StatusBar", nil, region)
		local icon = CreateFrame("Frame",nil, sb)
		local iconTex = icon:CreateTexture(nil, "BACKGROUND")
		local text = {
			left = UI:CreateText(sb, {anchor = 'LEFT'}),
			center = UI:CreateText(sb, {anchor = 'CENTER'}),
			right = UI:CreateText(sb, {anchor = 'RIGHT'})
		}
		function text:Hide() self.left:Hide(); self.center:Hide(); self.right:Hide() end
		function text:Show() self.left:Show(); self.center:Show(); self.right:Show() end

	  sb:SetStatusBarTexture(opt.texture)
	  sb:SetMinMaxValues(0, MAX_VALUE)
	  sb:SetValue(0)
	  sb:SetWidth(opt.width)
	  sb:SetHeight(opt.height)
	  sb:SetBackdrop(opt.backdrop)
		sb:SetBackdropColor(opt.color.back.r, opt.color.back.g,
												opt.color.back.b, opt.color.back.a)
		sb:SetStatusBarColor(opt.color.front.r, opt.color.front.g,
		                     opt.color.front.b, opt.color.front.a)
		sb:SetReverseFill(opt.LTR)
		sb:SetOrientation(opt.orientation)
		sb:SetPoint(opt.anchor, 0, y)

		icon:SetFrameLevel(sb:GetFrameLevel())
		icon:SetSize(opt.height, opt.height)

		iconTex:SetAllPoints(icon)
		local z = (opt.zoom / 100) * 0.25
		iconTex:SetTexCoord(z, 1-z, z, 1-z)
		icon.texture = iconTex
		local w = opt.height
		if string.match(opt.icon.anchor:lower(), 'left') then w = -1 * w end
		icon:SetPoint(opt.icon.anchor, w, 0)

		sb:SetScript('OnEnter', OnEnter)
		icon:SetScript('OnEnter', OnEnter)
		sb:SetScript('OnLeave', OnLeave)
		icon:SetScript('OnLeave', OnLeave)

		text:Hide()
		sb:Hide()
		icon:Hide()

	  env.auras[i].bar = sb
		env.auras[i].icon = icon
		env.auras[i].text = text
	end

	return env
end
]]--
