local currentEventId = 0

RegisterNetEvent('sync:server', function(data)
  local playerId <const> = source
  if data and data.title and data.description and data.duration then
    local coords = GetEntityCoords(GetPlayerPed(playerId))
    TriggerClientEvent('sync:client', -1, {
      id = currentEventId,
      title = data.title,
      description = data.description,
      duration = tonumber(data.duration),
      coords = {coords.x, coords.y}
    })
    currentEventId = currentEventId + 1
    return
  end
  print('Could not create')
end)