RegisterNetEvent('sync:client', function(eventData)
  SendNUIMessage({
    action = "startEvent",
    event = eventData
  })
end)

RegisterNUICallback("create_event", function(data, cb)
	if data then
		TriggerServerEvent('sync:server', data)
		SetNuiFocus(false, false)
	end
	cb({})
end)

RegisterNUICallback("close_nui", function(_, cb)
	SetNuiFocus(false, false)
	cb({
    success = true
  })
end)

RegisterCommand('a', function()
  SetNuiFocus(true, true)
  SendNUIMessage({
    action = "showEvent"
  })
end)