local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("js_machinecola:checkMoney", function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local money = xPlayer.getMoney()

    cb(money)
end)


RegisterServerEvent("js_machinecola:removeMoney")
AddEventHandler("js_machinecola:removeMoney", function(money)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    xPlayer.removeMoney(money)
end)