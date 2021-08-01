ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('js_machinecol:OpenMenu', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Coca Cola Machine",
            txt = ""
        },
        {
            id = 2,
            header = "Do you want to buy a coca cola?",
            txt = "Pulse here to buy",
            params = {
                event = "js_machinecola:FoodMeny",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
    })
end)

Citizen.CreateThread(function()
    local coca = {
		`prop_vend_soda_01`
    }

    exports['bt-target']:AddTargetModel(coca, {
        options = {
            {
                event = 'js_machinecol:OpenMenu',
                icon = 'fas fa-glass-martini-alt',
                label = "Open Menu"
            },
        },
        job = {'all'},
        distance = 1.5
    })
end)


function FoodMeny()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'foodstand',
          {
              title    = 'Coca Cola Machine',
              align    = 'center',
              elements = {
                   {label = 'Coca Cola 7oz <span style="color:green"> '  .. Config.EatPrice ..'  $</span> ',                  prop = 'prop_ecola_can',    type = 'drink'},
                


               }
         }, function(data, menu)
                local selected = data.current.type
                if selected == 'drink' then
          
                   ESX.TriggerServerCallback("js_machinecola:checkMoney", function(money)
                       if money >= Config.DrinkPrice then
                          ESX.UI.Menu.CloseAll()
                          TriggerServerEvent("js_machinecola:removeMoney", Config.DrinkPrice)
                          drink(data.current.prop) 
                      else
                         ESX.ShowNotification("You do not have enough money.")
                     end
                    end)
              end
          end, function(data, menu)
              menu.close() 
     end)
end

RegisterNetEvent("js_machinecola:FoodMeny")
AddEventHandler("js_machinecola:FoodMeny", function()
    FoodMeny("foodmenu")
end)



function drink(prop)
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    prop = CreateObject(GetHashKey(prop), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.15, 0.025, 0.010, 270.0, 175.0, 0.0, true, true, false, true, 1, true)
    RequestAnimDict('mp_player_intdrink')
    while not HasAnimDictLoaded('mp_player_intdrink') do
        Wait(50)
    end
    TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 8.0, -8, -1, 49, 0, 0, 0, 0)
    for i=1, 50 do
        Wait(500)
        TriggerEvent('esx_status:add', 'thirst', 10000)
    end
    IsAnimated = false
    ClearPedSecondaryTask(playerPed)
    DeleteObject(prop)
end
