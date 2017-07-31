local Boop = LibStub('AceAddon-3.0'):NewAddon('Boop', 'AceConsole-3.0', 'AceEvent-3.0');
local Database = LibStub('AceDB-3.0');
local Config = LibStub('AceConfig-3.0');
local LSM = LibStub('LibSharedMedia-3.0')

Kazzak.Boop.Addon = Boop

function Boop:OnInitialize()
  print("Initialize Library Kazza.Boop")
  local defaultValues = {}
  self.db = Database:New('BoopDB', defaultValues)
  LSM:Register(LSM.MediaType.FONT, 'Boop PT Sans Narrow',
                      [[Interface\Addons\boop\media\fonts\PT_Sans_Narrow.ttf]])
  LSM:Register(LSM.MediaType.FONT, 'Boop Homespun',
                      [[Interface\Addons\boop\media\fonts\Homespun.ttf]])
  LSM:Register(LSM.MediaType.FONT, 'Boop Expressway',
                      [[Interface\Addons\boop\media\fonts\Expressway.ttf]])
  LSM:SetDefault(LSM.MediaType.FONT, 'Boop PT Sans Narrow')

  LSM:Register(LSM.MediaType.BACKGROUND, 'Boop Solid',
                      [[Interface\Addons\boop\media\textures\Solid.tga]])

  LSM:Register(LSM.MediaType.STATUSBAR, 'Boop Blank',
                      [[Interface\BUTTONS\WHITE8X8.blp]])
end

function Boop:OnEnable()
end

function Boop:OnDisable()
  Kazzak.Boop = nil
  Database = nil
  Config = nil
end


function Boop:SlashBoopProcessorFunc(args)
    print('hehexd')
end
Boop:RegisterChatCommand('boop', 'SlashBoopProcessorFunc')
