local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

QBCore = exports['qb-core']:GetCoreObject()
PlayerGang = {}
employees = {}
bank = 0
unemployed = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerGang = QBCore.Functions.GetPlayerData().gang
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate')
AddEventHandler('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerGang = GangInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerGang = {}
    bank = 0
    employees = {}
    unemployed = {}
end)

AddEventHandler('onClientResourceStart',function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    PlayerGang = QBCore.Functions.GetPlayerData().gang
end)

-- Functions

local function OpenWeaponCraftingMenu()
    local columns = {
        {
            header = "Weapon Crafting",
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.Weapons) do
        local item = {}
        item.header = "<img src=nui://"..Config["Inv-Link"]..QBCore.Shared.Items[v.hash].image.." width=35px style='margin-right: 10px'> " .. v.label
        local text = ""
        for k, v in pairs(v.materials) do
            text = text .. "- " .. v.item .. ": " .. v.amount .. "<br>"
        end
        item.text = text
        item.params = {
            event = 'qb-gunplug:client:craftWeapon',
            args = {
                type = k
            }
        }
        table.insert(columns, item)
    end

    exports['qb-menu']:openMenu(columns)
end

local function OpenAmmoCraftingMenu()
    local columns = {
        {
            header = "Ammo Crafting",
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.Ammo) do
        local item = {}
        item.header = "<img src=nui://"..Config["Inv-Link"]..QBCore.Shared.Items[v.hash].image.." width=35px style='margin-right: 10px'> " .. v.label
        local text = ""
        for k, v in pairs(v.materials) do
            text = text .. "- " .. v.item .. ": " .. v.amount .. "<br>"
        end
        item.text = text
        item.params = {
            event = 'qb-gunplug:client:craftAmmo',
            args = {
                type = k
            }
        }
        table.insert(columns, item)
    end

    exports['qb-menu']:openMenu(columns)
end

local function OpenAttachmentCraftingMenu()
    local columns = {
        {
            header = "Attachment Crafting",
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.Attachment) do
        local item = {}
        item.header = "<img src=nui://"..Config["Inv-Link"]..QBCore.Shared.Items[v.hash].image.." width=35px style='margin-right: 10px'> " .. v.label
        local text = ""
        for k, v in pairs(v.materials) do
            text = text .. "- " .. v.item .. ": " .. v.amount .. "<br>"
        end
        item.text = text
        item.params = {
            event = 'qb-gunplug:client:craftAttachment',
            args = {
                type = k
            }
        }
        table.insert(columns, item)
    end

    exports['qb-menu']:openMenu(columns)
end

local function OpenTintCraftingMenu()
    local columns = {
        {
            header = "Weapon Tint Crafting",
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.Tint) do
        local item = {}
        item.header = "<img src=nui://"..Config["Inv-Link"]..QBCore.Shared.Items[v.hash].image.." width=35px style='margin-right: 10px'> " .. v.label
        local text = ""
        for k, v in pairs(v.materials) do
            text = text .. "- " .. v.item .. ": " .. v.amount .. "<br>"
        end
        item.text = text
        item.params = {
            event = 'qb-gunplug:client:craftTint',
            args = {
                type = k
            }
        }
        table.insert(columns, item)
    end

    exports['qb-menu']:openMenu(columns)
end

local function CraftWeapon(weapon)
    QBCore.Functions.Progressbar('crafting_weapon', 'Crafting '..Config.Weapons[weapon].label, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        QBCore.Functions.Notify("Crafted "..Config.Weapons[weapon].label, 'success')
        TriggerServerEvent('qb-gunplug:server:craftWeapon', Config.Weapons[weapon].hash)
        for k, v in pairs(Config.Weapons[weapon].materials) do
             TriggerServerEvent('QBCore:Server:RemoveItem', v.item, v.amount)
             TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[v.item], "remove")
        end
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify('You have cancelled the crafting process', 'error')
    end)
end

local function CraftAmmo(ammo)
    QBCore.Functions.Progressbar('crafting_ammo', 'Crafting '..Config.Ammo[ammo].label, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        QBCore.Functions.Notify("Crafted "..Config.Ammo[ammo].label, 'success')
        TriggerServerEvent('qb-gunplug:server:craftAmmo', Config.Ammo[ammo].hash)
        for k, v in pairs(Config.Ammo[ammo].materials) do
             TriggerServerEvent('QBCore:Server:RemoveItem', v.item, v.amount)
             TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[v.item], "remove")
        end
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify('You have cancelled the crafting process', 'error')
    end)
end

local function CraftAttachment(attachment)
    QBCore.Functions.Progressbar('crafting_ttachment', 'Crafting '..Config.Attachment[attachment].label, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        QBCore.Functions.Notify("Crafted "..Config.Attachment[attachment].label, 'success')
        TriggerServerEvent('qb-gunplug:server:craftAttachment', Config.Attachment[attachment].hash)
        for k, v in pairs(Config.Attachment[attachment].materials) do
             TriggerServerEvent('QBCore:Server:RemoveItem', v.item, v.amount)
             TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[v.item], "remove")
        end
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify('You have cancelled the crafting process', 'error')
    end)
end

local function CraftTint(tint)
    QBCore.Functions.Progressbar('crafting_weapontint', 'Crafting '..Config.Tint[tint].label, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        QBCore.Functions.Notify("Crafted "..Config.Tint[tint].label, 'success')
        TriggerServerEvent('qb-gunplug:server:craftTint', Config.Tint[tint].hash)
        for k, v in pairs(Config.Tint[tint].materials) do
             TriggerServerEvent('QBCore:Server:RemoveItem', v.item, v.amount)
             TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[v.item], "remove")
        end
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify('You have cancelled the crafting process', 'error')
    end)
end

-- Events

RegisterNetEvent('qb-gunplug:client:craftWeapon', function(data)
    QBCore.Functions.TriggerCallback("qb-gunplug:server:enoughMaterials", function(hasMaterials)
        if (hasMaterials) then
            CraftWeapon(data.type)
        else
            QBCore.Functions.Notify("You do not have enough materials", "error")
            return
        end
    end, Config.Weapons[data.type].materials)
end)

RegisterNetEvent('qb-gunplug:client:craftAmmo', function(data)
    QBCore.Functions.TriggerCallback("qb-gunplug:server:enoughMaterials", function(hasMaterials)
        if (hasMaterials) then
            CraftAmmo(data.type)
        else
            QBCore.Functions.Notify("You do not have enough materials", "error")
            return
        end
    end, Config.Ammo[data.type].materials)
end)

RegisterNetEvent('qb-gunplug:client:craftAttachment', function(data)
    QBCore.Functions.TriggerCallback("qb-gunplug:server:enoughMaterials", function(hasMaterials)
        if (hasMaterials) then
            CraftAttachment(data.type)
        else
            QBCore.Functions.Notify("You do not have enough materials", "error")
            return
        end
    end, Config.Attachment[data.type].materials)
end)

RegisterNetEvent('qb-gunplug:client:craftTint', function(data)
    QBCore.Functions.TriggerCallback("qb-gunplug:server:enoughMaterials", function(hasMaterials)
        if (hasMaterials) then
            CraftTint(data.type)
        else
            QBCore.Functions.Notify("You do not have enough materials", "error")
            return
        end
    end, Config.Tint[data.type].materials)
end)

-- Threads

CreateThread(function()
    for k,v in pairs(Config.GangLocation) do
        for k, v in pairs(v) do
         exports['qb-target']:AddBoxZone(v.name, v.loc, v.length, v.width, {
            name = v.name,
            heading = v.heading,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ
    },{
            options = {
                {
                    icon = 'fa-solid fa-gun',
                    label = 'Craft Weapons',
                    gang = k,
                    action = function()
                        OpenWeaponCraftingMenu()
                    end,
                },
                {
                    icon = 'fa-solid fa-box',
                    label = 'Craft Ammo',
                    gang = k,
                    action = function()
                        OpenAmmoCraftingMenu()
                    end,
                },
                {
                    icon = 'fa-solid fa-box',
                    label = 'Craft Attachments',
                    gang = k,
                    action = function()
                        OpenAttachmentCraftingMenu()
                    end,
                },
                {
                    icon = 'fa-solid fa-spray-can',
                    label = 'Craft Weapon Tints',
                    gang = k,
                    action = function()
                        OpenTintCraftingMenu()
                    end,
                },
            },
                distance = 1.5
            })
        end
    end
end)

CreateThread(function()
    for k,v in pairs(Config.JobLocation) do
        for k, v in pairs(v) do 
            exports['qb-target']:AddBoxZone(v.name, v.loc, v.length, v.width, {
                name = v.name,
                heading = v.heading,
                debugPoly = false,
                minZ = v.minZ,
                maxZ = v.maxZ
        },{
            options = {
                {
                    icon = 'fa-solid fa-gun',
                    label = 'Craft Weapons',
                    job = k,
                    action = function()
                        OpenWeaponCraftingMenu()
                    end,
                },
                {
                    icon = 'fa-solid fa-box',
                    label = 'Craft Ammo',
                    job = k,
                    action = function()
                        OpenAmmoCraftingMenu()
                    end,
                },
                {
                    icon = 'fa-solid fa-box',
                    label = 'Craft Attachments',
                    job = k,
                    action = function()
                        OpenAttachmentCraftingMenu()
                    end,
                },
                {
                    icon = 'fa-solid fa-spray-can',
                    label = 'Craft Weapon Tints',
                    job = k,
                    action = function()
                        OpenTintCraftingMenu()
                    end,
                },
            },
                distance = 1.5
            })
        end
    end
end)

CreateThread(function()
    for k,v in pairs(Config.PublicLocation) do
        for k, v in pairs(v) do 
            exports['qb-target']:AddBoxZone(v.name, v.loc, v.length, v.width, {
                name = v.name,
                heading = v.heading,
                debugPoly = false,
                minZ = v.minZ,
                maxZ = v.maxZ
        },{
            options = {
                {
                    icon = 'fa-solid fa-gun',
                    label = 'Craft Weapons',
                    action = function()
                        OpenWeaponCraftingMenu()
                    end,
                },
                {
                    icon = 'fa-solid fa-box',
                    label = 'Craft Ammo',
                    action = function()
                        OpenAmmoCraftingMenu()
                    end,
                },
                {
                    icon = 'fa-solid fa-box',
                    label = 'Craft Attachments',
                    action = function()
                        OpenAttachmentCraftingMenu()
                    end,
                },
                {
                    icon = 'fa-solid fa-spray-can',
                    label = 'Craft Weapon Tints',
                    action = function()
                        OpenTintCraftingMenu()
                    end,
                },
            },
                distance = 1.5
            })
        end
    end
end)