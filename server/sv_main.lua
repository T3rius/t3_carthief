RegisterServerEvent('t3_easycar:reward')
AddEventHandler('t3_easycar:reward', function(reward)
    local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem('money', reward)
    lib.notify(source, {
        title = TranslateCap('buyer'),
        description = TranslateCap('got_paid')..reward.. ' $',
        type = 'success',
        icon = "money-bill",
    })
end)


