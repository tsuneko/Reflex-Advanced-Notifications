AdvNotifs = {}

function AdvNotifs:initialize()
	self.userData = loadUserData()
	CheckSetDefaultValue(self, "userData", "table", {})

	CheckSetDefaultValue(self.userData, "notifyPickups", "boolean", true)
	CheckSetDefaultValue(self.userData, "notifyOnRespawn", "boolean", true)
	
	CheckSetDefaultValue(self.userData, "notifyBeforeRespawn", "boolean", true)
	CheckSetDefaultValue(self.userData, "beforeRespawnTimer", "number", 5)
	
	CheckSetDefaultValue(self.userData, "drawIcons", "boolean", true)
	CheckSetDefaultValue(self.userData, "drawTime", "boolean", true)
	CheckSetDefaultValue(self.userData, "drawRespawnTime", "boolean", false)
	
	CheckSetDefaultValue(self.userData, "notifyGreen", "boolean", false)
	CheckSetDefaultValue(self.userData, "notifyYellow", "boolean", true)
	CheckSetDefaultValue(self.userData, "notifyRed", "boolean", true)
	CheckSetDefaultValue(self.userData, "notifyMega", "boolean", true)
	
	CheckSetDefaultValue(self.userData, "notifyCustom", "boolean", false)
	
	CheckSetDefaultValue(self.userData, "countDown", "boolean", true)
	CheckSetDefaultValue(self.userData, "maxNotifs", "number", 3)
	CheckSetDefaultValue(self.userData, "notifyDuration", "number", 1.8)
	
	CheckSetDefaultValue(self.userData, "textRed", "number", 255)
	CheckSetDefaultValue(self.userData, "textGreen", "number", 255)
	CheckSetDefaultValue(self.userData, "textBlue", "number", 255)
	CheckSetDefaultValue(self.userData, "textAlpha", "number", 220)
	
	CheckSetDefaultValue(self.userData, "bgRed", "number", 0)
	CheckSetDefaultValue(self.userData, "bgGreen", "number", 0)
	CheckSetDefaultValue(self.userData, "bgBlue", "number", 0)
	CheckSetDefaultValue(self.userData, "bgAlpha", "number", 180)
	
	font = "monof55"
	fontSize = 26
	textColor = Color(255,255,255,255)
	bgColor = Color(120,120,120,80)
	
	widgetCreateConsoleVariable("notify", "string", "")
	
	notifications = {}
	warmupTimeElapsed = 0
	timestamp = ""
	
	pending = {} -- future notifications
	
	lastFrame = {time=0} -- player's information on last frame (check for changes on per-frame basis)

	-- data on notification per item (icon, text)
	icon = {}
	icon["Green Armor"] = {
		icon = "internal/ui/icons/armor",
		color = {0, 255, 0}
	}
	icon["Yellow Armor"] = {
		icon = "internal/ui/icons/armor",
		color = {255, 255, 0}
	}
	icon["Red Armor"] = {
		icon = "internal/ui/icons/armor",
		color = {255, 0, 0}
	}
	icon["Mega Health"] = {
		icon = "internal/ui/icons/health",
		color = {60, 80, 255}
	}
	icon["Lost Mega Health"] = {
		icon = "internal/ui/icons/health",
		color = {60, 80, 255},
		drawx = true
	}
	icon["Custom"] = {
		icon = "internal/ui/icons/CTFflag",
		color = {255,255,255}
	}
end

function AdvNotifs:getOptionsHeight()
	local user = self.userData
	local height = 42 + 32 + 50 * (29 + 5)
	return height
end

function delaynotify(msg, delay, icon)
	table.insert(pending, 1, {["message"]=msg,["time"]=delay*1000+gameTime,["icon"]=icon})
end

function notify(msg, icon)
	table.insert(notifications, 1, {["message"]=msg,t=0,["icon"]=icon})
end

function newline(y,l)
	l = l or 1
	return y + 50*l
end -- increment y in drawOptions

function AdvNotifs:drawOptions(x,y,intensity)
    local optargs = {intensity = intensity}
	local data = self.userData
	
	i = WIDGET_PROPERTIES_COL_INDENT
	w = WIDGET_PROPERTIES_COL_WIDTH
	
	y = newline(y)
	
	if intensity >= 0.8 then
		nvgFillColor(Color(255,188,188))
		nvgFontSize(38)
		nvgFontFace(font)
		nvgText(x, y, "Advanced Notifications ~ v1.0") y = y + 38
		nvgFillColor(Color(255,220,220))
		nvgFontSize(26)
		nvgText(x+168, y, "tsuneko (/id/tsuneko)") y = y + 32
	end

	ui2Label("Notification Settings", x, y, optargs) y = newline(y)
	data.notifyPickups = ui2RowCheckbox(x, y, i, "Notify on Item Take", data.notifyPickups, optargs) y = newline(y)
	data.notifyOnRespawn = ui2RowCheckbox(x, y, i, "Notify on Item Spawn", data.notifyOnRespawn, optargs) y = newline(y)
	data.notifyBeforeRespawn = ui2RowCheckbox(x, y, i, "Notify before Item Spawn", data.notifyBeforeRespawn, optargs) y = newline(y)
	if data.notifyBeforeRespawn == false then
		optargs.intensity = intensity / 3
	end
	data.beforeRespawnTimer = ui2RowSliderEditBox2Decimals(x, y, i, w, 80, "Item Respawn Warning", data.beforeRespawnTimer, 0.1, 20, optargs) y = newline(y)
	if data.beforeRespawnTimer < 0.1 then data.beforeRespawnTimer = 0.1 end if data.beforeRespawnTimer > 20 then data.beforeRespawnTimer = 20 end
	optargs.intensity = intensity
	
	y = newline(y)
	ui2Label("Item Notification Toggles", x, y, optargs) y = newline(y)
	if data.notifyPickups == false and data.notifyOnRespawn == false and data.notifyBeforeRespawn == false then
		optargs.intensity = intensity/3
	end
	data.notifyGreen = ui2RowCheckbox(x, y, i, "Green Armor", data.notifyGreen, optargs) y = newline(y)
	data.notifyYellow = ui2RowCheckbox(x, y, i, "Yellow Armor", data.notifyYellow, optargs) y = newline(y)
	data.notifyRed = ui2RowCheckbox(x, y, i, "Red Armor", data.notifyRed, optargs) y = newline(y)
	data.notifyMega = ui2RowCheckbox(x, y, i, "Mega Health", data.notifyMega, optargs) y = newline(y)
	optargs.intensity = intensity
	
	y = newline(y)
	if data.notifyCustom == false then
		optargs.intensity = intensity / 3
	end
	data.notifyCustom = ui2RowCheckbox(x, y, i, "Custom Notifications", data.notifyCustom, optargs) y = newline(y)
	ui2Label("bind [key] ui_advnotifs_notify [delay] [message]", x, y, optargs) y = newline(y)
	ui2Label("Eg. bind q ui_advnotifs_notify 85 Carnage will respawn soon!", x, y, optargs) y = newline(y)
	optargs.intensity = intensity
	
	y = newline(y)
	ui2Label("Message Settings", x, y, optargs) y = newline(y)
	data.maxNotifs = ui2RowSliderEditBox0Decimals(x, y, i, w, 80, "Max Notifications", data.maxNotifs, 1, 5, optargs) y = newline(y)
	if data.maxNotifs < 1 then data.maxNotifs = 1 end if data.maxNotifs > 6 then data.maxNotifs = 6 end
	data.notifyDuration = ui2RowSliderEditBox2Decimals(x, y, i, w, 80, "Message Duration", data.notifyDuration, 0.1, 6.0, optargs) y = newline(y)
	if data.notifyDuration < 0.1 then data.notifyDuration = 0.1 end if data.notifyDuration > 6.0 then data.notifyDuration = 6.0 end
	data.countDown = ui2RowCheckbox(x, y, i, "Count Time Down", data.countDown, optargs) y = newline(y)
	data.drawIcons = ui2RowCheckbox(x, y, i, "Show Icon", data.drawIcons, optargs) y = newline(y)
	if data.notifyPickups == false and data.notifyOnRespawn == false and data.notifyBeforeRespawn == false then
		optargs.intensity = intensity/3
	end
	data.drawTime = ui2RowCheckbox(x, y, i, "Show Time", data.drawTime, optargs) y = newline(y)
	if data.notifyBeforeRespawn == false then
		optargs.intensity = intensity / 3
	end
	data.drawRespawnTime = ui2RowCheckbox(x, y, i, "Show Item Respawn Time", data.drawRespawnTime, optargs) y = newline(y)
	optargs.intensity = intensity
	
	y = newline(y)
	ui2Label("Colour Settings", x, y, optargs) y = newline(y)
	data.textRed = ui2RowSliderEditBox0Decimals(x, y, i, w, 80, "Text Red", data.textRed, 0, 255, optargs)%256 y = newline(y)
	data.textGreen = ui2RowSliderEditBox0Decimals(x, y, i, w, 80, "Text Green", data.textGreen, 0, 255, optargs)%256 y = newline(y)
	data.textBlue = ui2RowSliderEditBox0Decimals(x, y, i, w, 80, "Text Blue", data.textBlue, 0, 255, optargs)%256 y = newline(y)
	data.textAlpha = ui2RowSliderEditBox0Decimals(x, y, i, w, 80, "Text Alpha", data.textAlpha, 0, 255, optargs)%256 y = newline(y)

	data.bgRed = ui2RowSliderEditBox0Decimals(x, y, i, w, 80, "Background Red", data.bgRed, 0, 255, optargs)%256 y = newline(y)
	data.bgGreen = ui2RowSliderEditBox0Decimals(x, y, i, w, 80, "Background Green", data.bgGreen, 0, 255, optargs)%256 y = newline(y)
	data.bgBlue = ui2RowSliderEditBox0Decimals(x, y, i, w, 80, "Background Blue", data.bgBlue, 0, 255, optargs)%256 y = newline(y)
	data.bgAlpha = ui2RowSliderEditBox0Decimals(x, y, i, w, 80, "Background Alpha", data.bgAlpha, 0, 255, optargs)%256 y = newline(y)
	
	textColor = Color(data.textRed,data.textGreen,data.textBlue,data.textAlpha)
	bgColor = Color(data.bgRed,data.bgGreen,data.bgBlue,data.bgAlpha)
	
	saveUserData(data)
end

function AdvNotifs:draw()
	if not shouldShowHUD() then return end
	
	local player = getPlayer()
	local localPlayer = getLocalPlayer()
	if player == nil
		or loading.loadScreenVisible
		or player.state == PLAYER_STATE_EDITOR
		or player.state == PLAYER_STATE_SPECTATOR
		or (playerIndexCameraAttachedTo == playerIndexLocalPlayer and localPlayer.state ~= PLAYER_STATE_INGAME)
		or world.gameState == GAME_STATE_GAMEOVER
		or consoleGetVariable("cl_show_hud") == 0
		or not player.connected
		or isInMenu()
		or replayName == "menu" then
			-- clear notifications
			if next(notifications) ~= nil then
				notifications = {}
			end
			-- clear pending notifications
			if next(pending) ~= nil then
				pending = {}
			end
			return nil
	end
	
	data = self.userData
	
	-- Get Game Time
	if world.gameState == GAME_STATE_ACTIVE or world.gameState == GAME_STATE_ROUNDACTIVE then
		gameTime = world.gameTime
		if warmupTimeElapsed ~= 0 then
			warmupTimeElapsed = 0
		end
	elseif world.gameState == GAME_STATE_WARMUP then
		warmupTimeElapsed = warmupTimeElapsed + deltaTime
		gameTime = warmupTimeElapsed * 1000
	else -- unknown game state
		gameTime = 0
		return nil
	end
	if data.countDown == true and world.gameState ~= GAME_STATE_WARMUP then
		gameTimeFormatted = FormatTime(world.gameTimeLimit-gameTime)
	else
		gameTimeFormatted = FormatTime(gameTime-1000)
	end
	timestamp = string.format("%d:%02d", gameTimeFormatted.minutes, gameTimeFormatted.seconds)
	
	if gameTime < lastFrame.time or lastFrame.time == 0 then -- player has loaded into a new game
		lastFrame.armor = player.armor
		lastFrame.hasMega = player.hasMega
	end
	
	-- check for changes
	
	item = ""
	
	if player.armor > lastFrame.armor and player.armor - lastFrame.armor > 5 then -- got an armour pickup
		if player.armorProtection == 0 and data.notifyGreen == true then
			item = "Green Armor"
		elseif player.armorProtection == 1 and data.notifyYellow == true then
			item = "Yellow Armor"
		elseif player.armorProtection == 2 and data.notifyRed == true then
			item = "Red Armor"
		end
	end
	
	if data.notifyMega == true then
		if player.hasMega == true and lastFrame.hasMega == false then -- got mega
			item = "Mega Health"
		elseif player.hasMega == false and lastFrame.hasMega == true then -- lost mega
			item = "Lost Mega Health"
		end
	end
	
	-- check which notifications to provide
	
	if item ~= "" then
		if data.notifyPickups == true then
			msgtime = ""
			if data.drawTime == true then
				msgtime = timestamp.." "
			end
			notify(msgtime..item, icon[item])
		end
		if data.notifyOnRespawn == true then
			if item == "Mega Health" then
				-- do nothing
			elseif item == "Lost Mega Health" then
				delaynotify("Mega Health has respawned", 30, icon[item])
			else
				delaynotify(item.." has respawned", 25, icon[item])
			end
		end
		if data.notifyBeforeRespawn == true then
			msgtime = ""
			if data.drawRespawnTime == true then
				if data.countDown == true and world.gameState ~= GAME_STATE_WARMUP then
					if item == "Lost Mega Health" then
						futureTimeFormatted = FormatTime(world.gameTimeLimit-gameTime-30000)
					else
						futureTimeFormatted = FormatTime(world.gameTimeLimit-gameTime-25000)
					end
				else
					if item == "Lost Mega Health" then
						futureTimeFormatted = FormatTime(gameTime+30000)
					else
						futureTimeFormatted = FormatTime(gameTime+25000)
					end
				end
				
				msgtime = " ("..string.format("%d:%02d", futureTimeFormatted.minutes, futureTimeFormatted.seconds)..")"
			end
			if item == "Mega Health" then
				-- do nothing
			elseif item == "Lost Mega Health" then
				delaynotify("Mega Health respawns in "..data.beforeRespawnTimer.."s"..msgtime, 30-data.beforeRespawnTimer, icon[item])
			else
				delaynotify(item.." respawns in "..data.beforeRespawnTimer.."s"..msgtime, 25-data.beforeRespawnTimer, icon[item])
			end
		end
	end
	
	-- update lastFrame
	
	if lastFrame.armor ~= player.armor then
		lastFrame.armor = player.armor
	end
	if lastFrame.hasMega ~= player.hasMega then
		lastFrame.hasMega = player.hasMega
	end
	if lastFrame.hasFlag ~= player.hasFlag then
		lastFrame.hasFlag = player.hasFlag
	end
	lastFrame.time = gameTime
	
	-- Check for custom notification (from cvar "notify")
	if data.notifyCustom == true then
		custom = widgetGetConsoleVariable("notify")
		if type(custom) == "string" and custom ~= "" then
			args = {}
			for arg in custom:gmatch("%S+") do table.insert(args, arg) end
			if #args > 1 and tonumber(args[1]) ~= nil then -- valid command
				delay = tonumber(args[1])
				table.remove(args,1)
				delaynotify(table.concat(args," "),delay,icon["Custom"])
				widgetSetConsoleVariable("notify", "")
			end
		end
	end
	
	-- Check pending notifications and see if they are ready for deployment
	if next(pending) ~= nil then
		for i,n in ipairs(pending) do
			if n.time <= gameTime then -- add to notifications
				notify(n.message,n.icon)
				table.remove(pending,i)
			end
		end
	end
	
	if next(notifications) ~= nil then
		nvgFontSize(fontSize)
		nvgFontFace(font)
		nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE)
		
		-- Draw Notifications & update timer / transparency
		for i,n in ipairs(notifications) do
			if i > data.maxNotifs then
				table.remove(notifications,i)
				goto continue
			end
			if n.t >= data.notifyDuration then
				table.remove(notifications,i)
				goto continue
			end
			
			notifWidth = string.len(n.message)*13+16
			if data.drawIcons == true then
				notifWidth = notifWidth + 36
			end
		
			nvgBeginPath()
			nvgRect(-notifWidth/2,-15-(i-1)*30,notifWidth,30)
			if n.t >= data.notifyDuration-0.2 then -- we fade out from here
				nvgFillColor(Color(data.bgRed,data.bgGreen,data.bgBlue,data.bgAlpha*(data.notifyDuration-n.t)/0.2))
			else
				nvgFillColor(bgColor)
			end
			nvgFill()
			
			if data.drawIcons == true then
				if n.t >= data.notifyDuration-0.2 then -- we fade out from here
					nvgFillColor(Color(n.icon.color[1],n.icon.color[2],n.icon.color[3],data.textAlpha*(data.notifyDuration-n.t)/0.2))
				else
					nvgFillColor(Color(n.icon.color[1],n.icon.color[2],n.icon.color[3],data.textAlpha))
				end
				nvgSvg(n.icon.icon, -notifWidth/2+18, -(i-1)*30, 12)
				
				-- check if lost mega and draw red X, thanks kyto for drawing functions
				if n.icon.drawx == true then
					nvgBeginPath()
					nvgMoveTo(-notifWidth/2+9, -(i-1)*30-9)
					nvgLineTo(-notifWidth/2+18+9, -(i-1)*30+9)
					nvgFillColor(Color(255, 0, 0, data.textAlpha))
					nvgFill()
					nvgBeginPath()
					nvgMoveTo(-notifWidth/2+9, -(i-1)*30+9)
					nvgLineTo(-notifWidth/2+18+9, -(i-1)*30-9)
					nvgFillColor(Color(255, 0, 0, data.textAlpha))
					nvgFill()
				end
			end
			
			if n.t >= data.notifyDuration-0.2 then -- we fade out from here
				nvgFillColor(Color(data.textRed,data.textGreen,data.textBlue,data.textAlpha*(data.notifyDuration-n.t)/0.2))
			else
				nvgFillColor(textColor)
			end
			textShift = 0
			if data.drawIcons == true then
				textShift = 18
			end
			nvgText(textShift, -(i-1)*30, n.message)
			
			n.t = n.t + deltaTime
			
			::continue::
		end
	end
end

registerWidget("AdvNotifs")
