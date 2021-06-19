ESX = nil

CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(100) end
	local GUI, MenuType = {}, 'default'
	GUI.Time = 0
	local vrijeme = GetGameTimer()

	local openMenu = function(namespace, name, data)
		SendNUIMessage({
			action = 'openMenu',
			namespace = namespace,
			name = name,
			data = data
		})
	end

	local closeMenu = function(namespace, name)
		SendNUIMessage({
			action = 'closeMenu',
			namespace = namespace,
			name = name,
			data = data
		})
	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	AddEventHandler('esx_menu_default:message:menu_submit', function(data)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.submit then
			if GetGameTimer()-vrijeme > 200 then
				vrijeme = GetGameTimer()
				menu.submit(data, menu)
			end
		end
	end)

	AddEventHandler('esx_menu_default:message:menu_cancel', function(data)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.cancel then
			menu.cancel(data, menu)
		end
	end)

	AddEventHandler('esx_menu_default:message:menu_change', function(data)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		for i=1, #data.elements, 1 do
			menu.setElement(i, 'value', data.elements[i].value)

			if data.elements[i].selected then
				menu.setElement(i, 'selected', true)
			else
				menu.setElement(i, 'selected', false)
			end
		end

		if menu.change then
			menu.change(data, menu)
		end
	end)

	CreateThread(function()
		while true do
			Wait(15)

			if IsControlPressed(0, 18) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({action = 'controlPressed', control = 'ENTER'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 177) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({action  = 'controlPressed', control = 'BACKSPACE'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 27) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 200 then
				SendNUIMessage({action  = 'controlPressed', control = 'TOP'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 173) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 200 then
				SendNUIMessage({action  = 'controlPressed', control = 'DOWN'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 174) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({action  = 'controlPressed', control = 'LEFT'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 175) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({action  = 'controlPressed', control = 'RIGHT'})
				GUI.Time = GetGameTimer()
			end
		end
	end)
end)
