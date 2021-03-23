script_name("Contacts")
script_description("Add your contacts and see if they are online!")
script_version_number("1")
script_version("1.2")
script_authors("Nisad Rahman/Brad Ringer/Farid Speed/Adib Itsuki")
script_dependencies("Libraries: ImGui , Events , Encoding , Default")

samp, sampev, imgui, inicfg, ec = require 'sampfuncs', require 'samp.events', require 'imgui', require 'inicfg', require 'encoding'

ec.default, u8 = 'CP1251', ec.UTF8

dir = getWorkingDirectory() .. "\\config\\Ringer's Config\\"
dir2 = getWorkingDirectory() .. "\\config\\"
config = dir .. "contacts.ini"

if not doesDirectoryExist(dir2) then createDirectory(dir2) end
if not doesDirectoryExist(dir) then createDirectory(dir) end
if not doesFileExist(config) then
	file = io.open(config, "w")
	file:write(" ")
	file:close()
	local directIni = config
	local mainIni = inicfg.load(inicfg.load({
		settings = {
			ShowNumbers = true,
			ShowPing = true,
			ShowLevels = true,
			ShowNonLogged = true
		},
	}, directIni))
	
	inicfg.save(mainIni, directIni)
end

local directIni = config
local mainIni = inicfg.load(nil, directIni)
inicfg.save(mainIni, directIni)

numloc = "moonloader/config/Ringer's Config/contacts.ringer"
numbertable = {}
numberdb = io.open(numloc, "a+")
for number in numberdb:lines() do
	table.insert(numbertable, number:lower())
end
io.close(numberdb)

dbloc = "moonloader/config/Ringer's Config/numbers.ringer"
contacttable = {}
contactdb = io.open(dbloc, "a+")
for name in contactdb:lines() do
	table.insert(contacttable, name:lower())
end
io.close(contactdb)

function addcontact(name)
	if(string.len(name) > 0 and string.len(name) < 3 or string.len(name) > 24)then
		sampAddChatMessage("{686868}The name can not be lower than 3 or greater than 24 characters (samp restriction)", 0xFFFFFF)
		return
	elseif(name == "") then
		sampAddChatMessage("Usage: {686868}[/addcontact Nisad_Rahman]", 0xFFFFFF)
		return
	end
	tempaList = {}
	numberdb = io.open(numloc, "r")
	for number in numberdb:lines() do
		table.insert(tempaList, number:lower())
	end
	io.close(numberdb)
	for k,n in pairs(contacttable) do
		if(n:lower() == name:lower()) then
			-- This checks if there is a number for the contact which failed to be added as it already existed
			if(tempaList[k] == nil) then
				sampAddChatMessage("The name {e61920}" .. name .. "{FFFFFF} is already in your contact list and doesn't have a number assigned to it.", 0xFFFFFF)
				sampAddChatMessage("Use the command {e61920}[/addnumber] {FFFFFF}to add one!", 0xFFFFFF)
			else
				sampAddChatMessage("The name {e61920}" .. name .. "{FFFFFF} is already in your contact list!", 0xFFFFFF)
			end
			return
		end
	end
	contactdb = io.open(dbloc, "a+")
	io.output(contactdb)
	io.write(name .. "\n")
	io.close(contactdb)
	table.insert(contacttable, name:lower())
	-- This checks if there is a number for the contact added
	for k,n in pairs(contacttable) do
		if(n:lower() == name:lower()) then
			if(tempaList[k] == nil) then
				sampAddChatMessage("You have added {686868}" .. name .. "{FFFFFF} in your contact list but it doesn't have a number assigned to it.", 0xFFFFFF)
				sampAddChatMessage("Use the command {686868}[/addnumber] {FFFFFF}to add a number for the contact {686868}" .. name .. "{FFFFFF}!", 0xFFFFFF)
			else
				sampAddChatMessage("You have added {686868}" .. name .. "{FFFFFF} in your contact list and it's linked to the number {686868}" .. tempaList[k], 0xFFFFFF)
			end
		end
	end
end

function addnumber(number)
	if(string.len(number) > 9) then
		sampAddChatMessage("{686868}The number can not be greater that 9 digits (script restriction)", 0xFFFFFF)
		return
	elseif(number == "") then
		sampAddChatMessage("Usage: {686868}[/addnumber (number) or - (dash) for none]", 0xFFFFFF)
		return
	end
	tempList = {}
	contactdb = io.open(dbloc, "r")
	for name in contactdb:lines() do
		table.insert(tempList, name:lower())
	end
	io.close(contactdb)
	for k,n in pairs(numbertable) do
		if(n:lower() == number:lower() and number ~= "-") then
			-- This checks if there is a name for the number which failed to be added as it already existed
			if(tempList[k] == nil) then
				sampAddChatMessage("The number {e61920}" .. number .. "{FFFFFF} is already in your number list and doesn't have a name linked to it.", 0xFFFFFF)
				sampAddChatMessage("Use the command {e61920}[/addcontact] {FFFFFF}to add one!", 0xFFFFFF)
			else
				sampAddChatMessage("The number {e61920}" .. number .. "{FFFFFF} is already in your number list!", 0xFFFFFF)
			end
			return
		end
	end
	numberdb = io.open(numloc, "a+")
	io.output(numberdb)
	io.write(number .. "\n")
	io.close(numberdb)
	table.insert(numbertable, number:lower())
	-- This checks if there is a name for the number added
	for k,n in pairs(numbertable) do
		if(n:lower() == number:lower()) then
			if(tempList[k] == nil) then
				sampAddChatMessage("You have added {686868}" .. number .. "{FFFFFF} in your number list but it doesn't have a name linked to it.", 0xFFFFFF)
				sampAddChatMessage("Use the command {686868}[/addcontact] {FFFFFF}to add a name for the number {686868}" .. number .. "{FFFFFF}!", 0xFFFFFF)
			else
				sampAddChatMessage("You have added {686868}" .. number .. "{FFFFFF} in your number list and it's linked to the name {686868}" .. tempList[k], 0xFFFFFF)
			end
		end
	end
end

function removecontact(name)
    f = false
	if(name == "") then
		sampAddChatMessage("Usage: {686868}[/removecontact Nisad_Rahman]", 0xFFFFFF)
		f = true
		return
	end
	i = 1
	for k,n in pairs(contacttable) do
		if(n:lower() == name) then
			table.remove(contacttable,i)
			sampAddChatMessage("You have removed {686868}" .. name .. "{FFFFFF} from your contact list!" , 0xFFFFFF)
			f = true
		end
		i = i+1
	end
	if(f == false) then
		sampAddChatMessage("The name {e61920}" .. name .. "{FFFFFF} was not found in your contact list!" , 0xFFFFFF)
	    return
	end
	contactdb = io.open(dbloc, "w")
	io.output(contactdb)
	for k,n in pairs(contacttable) do
		io.write(n .. "\n")
	end
	io.close(contactdb)
end

function removenumber(number)
    f = false
	if(number == "") then
		sampAddChatMessage("Usage: {686868}[/removenumber (number)]", 0xFFFFFF)
		f = true
		return
	end
	i = 1
	for k,n in pairs(numbertable) do
		if(n:lower() == number) then
			table.remove(numbertable,i)
			if(number == "-") then
				sampAddChatMessage("You have removed {686868}" .. number .. "{FFFFFF} from your number list, however..." , 0xFFFFFF)
				sampAddChatMessage("The {686868}- (dash) {FFFFFF}can be used for more than one number contact so when removing it it's suggested that you do it from the number file" , 0xFFFFFF)
			else
				sampAddChatMessage("You have removed {686868}" .. number .. "{FFFFFF} from your number list!" , 0xFFFFFF)
			end
			f = true
		end
		i = i+1
	end
	if(f == false) then
		sampAddChatMessage("The number {e61920}" .. number .. "{FFFFFF} was not found in your number list!" , 0xFFFFFF)
	    return
	end	
	numberdb = io.open(numloc, "w")
	io.output(numberdb)
	for k,n in pairs(numbertable) do
		io.write(n .. "\n")
	end
	io.close(numberdb)
end

local main_window_state = imgui.ImBool(false)
function imgui.OnDrawFrame()
	-- This counts how many contacts are online
	tempL = {}
	contactdb = io.open(dbloc, "r")
	for name in contactdb:lines() do
		table.insert(tempL, name:lower())
	end
	io.close(contactdb)
	maxPlayerOnline = sampGetMaxPlayerId(false)
	s = 1
	for i = 0, maxPlayerOnline do
		if sampIsPlayerConnected(i) then
			name = sampGetPlayerNickname(i)
			c = 1
			for k,n in pairs(tempL) do
				if(name:lower() == n:lower()) then
					table.remove(tempL,c)
					s = s + 1
				end
				c = c + 1
			end
		end
	end
	b = s - 1
	if main_window_state.v then
		-- window settings
		width, height = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(width / 2, height / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(700, 245), imgui.Cond.FirstUseEver)
		if(b == 0) then
			imgui.Begin('You have no online contacts', main_window_state, imgui.WindowFlags.NoResize)
		elseif(b == 1) then
			imgui.Begin('You have 1 online contact', main_window_state, imgui.WindowFlags.NoResize)
		else
			imgui.Begin('You have '.. b ..' online contacts', main_window_state, imgui.WindowFlags.NoResize)
		end
		-- menu functions
		tempList = {}
		tempaList = {}
		contactdb = io.open(dbloc, "r")
		for name in contactdb:lines() do
			table.insert(tempList, name:lower())
		end
		io.close(contactdb)
		numberdb = io.open(numloc, "r")
		for number in numberdb:lines() do
			table.insert(tempaList, number:lower())
		end
		io.close(numberdb)
		pr = '. '
		if(mainIni.settings.ShowNumbers == false) then
			nf = ''
		else
			nf = ' || (number): '
		end
		sp = ''
		afks  = ' ~~ TABBED'
		if(mainIni.settings.ShowPing == false) then
			pings = ''
		else
			pings = ' || (Ping): '
		end
		if(mainIni.settings.ShowLevels == false) then
			lvls = ''
		else
			lvls = ' || (Level): '
		end
		s = 1
		maxPlayerOnline = sampGetMaxPlayerId(false)
		for i = 0, maxPlayerOnline do
			if sampIsPlayerConnected(i) then
				afkState = sampIsPlayerPaused(i)
				name = sampGetPlayerNickname(i)
				if(mainIni.settings.ShowPing == false) then
					ping = ''
				else
					ping = sampGetPlayerPing(i)
				end
				if(mainIni.settings.ShowLevels == false) then
					lvl = ''
				else
					lvl = sampGetPlayerScore(i)
				end
				c = 1
				for k,n in pairs(tempList) do
					if tempaList[c] == nil then
						number = "-"
						f = true
					else
						if(mainIni.settings.ShowNumbers == true) then
							number = tempaList[c]
						else
							number = "-"
						end
						f = false
					end
					if(lvl == 1 and mainIni.settings.ShowNonLogged == false) then
						show = false
					elseif(lvl == 1 and mainIni.settings.ShowNonLogged == true) then
						show = true
						ids = '* (ID): '
					else
						show = true
						ids = ' (ID): '
					end
					if(name:lower() == n:lower() and show == true) then
						if(afkState == true) then
							imgui.Text(s..pr..name..ids..i..lvls..lvl..afks)
							imgui.Text(sp)
						else
							if(number == "-") then
							imgui.Text(s..pr..name..ids..i..lvls..lvl..pings..ping)
							imgui.Text(sp)
						else
							imgui.Text(s..pr..name..ids..i..nf..number..lvls..lvl..pings..ping)
							imgui.SameLine()
							if(smessage == nil) then
								smessage = "Hi!"
							end
							if imgui.Button("Call", imgui.ImVec2(60, 25)) then
								sampSendChat(string.format("/call %s", number))
								main_window_state.v = not main_window_state.v
								imgui.Process = main_window_state.v
							end
							imgui.SameLine()
							if imgui.Button("SMS", imgui.ImVec2(60, 25)) then
								sampSendChat(string.format("/sms %s %s", number, smessage))
								main_window_state.v = not main_window_state.v
								imgui.Process = main_window_state.v
							end
						end
					end
					table.remove(tempList,c)
					if(f == false) then
						table.remove(tempaList,c)
					end
					s = s + 1
				end
				c = c + 1
			end
		end
	end
	imgui.End() -- end of window
	end
end

function main()
	repeat wait(0) until isSampAvailable() and isSampfuncsLoaded()
		wait(2000)
		sampfuncsLog("Contacts [/conhelp] Authors: " .. table.concat(thisScript().authors, ", "))
		sampAddChatMessage("{686868}[Contacts] {FFFFFF}Made by Nisad Rahman & Brad Ringer {686868}- [/conhelp]", 0xe686868)
		sampRegisterChatCommand("conhelp", conhelp)
		sampRegisterChatCommand("addcontact", addcontact)
		sampRegisterChatCommand("removecontact", removecontact)
		sampRegisterChatCommand("addnumber", addnumber)
		sampRegisterChatCommand("removenumber", removenumber)
		sampRegisterChatCommand("ctoggle", ctoggle)
		sampRegisterChatCommand("cmessage", cmessage)
		sampRegisterChatCommand("contactlist", contactlist)
		sampRegisterChatCommand("onlines", onlines)
		sampRegisterChatCommand("contacts", function() main_window_state.v = not main_window_state.v end)
		while true do
		wait(50)
		imgui.Process = main_window_state.v
		-- This if statement will close the [/contacts] if ESC button was pressed/scoreboard list was opened (TAB list)/sampfuncs console was opened or a dialog was opened (Like /buy menu).
		if wasKeyPressed(27) or sampIsScoreboardOpen() or isSampfuncsConsoleActive() or sampIsDialogActive() then
			main_window_state.v = false
		end
	end
end

function contacts()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
		sampRegisterChatCommand("contacts", function() main_window_state.v = not main_window_state.v end)
	while true do
		wait(0)
		imgui.Process = main_window_state.v
	end
	wait(-1)
end

function ctoggle(option)
	if(option == "numbers") then
		mainIni.settings.ShowNumbers = not mainIni.settings.ShowNumbers
		inicfg.save(mainIni, directIni)
		if(mainIni.settings.ShowNumbers == true) then
			sampAddChatMessage("Numbers were {FFFFFF}enabled", 0xe686868)
		else
			sampAddChatMessage("Numbers were {FFFFFF}disabled", 0xe686868)
		end
	elseif(option == "ping") then
		mainIni.settings.ShowPing = not mainIni.settings.ShowPing
		inicfg.save(mainIni, directIni)
		if(mainIni.settings.ShowPing == true) then
			sampAddChatMessage("Ping was {FFFFFF}enabled", 0xe686868)
		else
			sampAddChatMessage("Ping was {FFFFFF}disabled", 0xe686868)
		end
	elseif(option == "levels") then
		mainIni.settings.ShowLevels = not mainIni.settings.ShowLevels
		inicfg.save(mainIni, directIni)
		if(mainIni.settings.ShowLevels == true) then
			sampAddChatMessage("Levels were {FFFFFF}enabled", 0xe686868)
		else
			sampAddChatMessage("Levels were {FFFFFF}disabled", 0xe686868)
		end
	elseif(option == "nonlogged") then
		mainIni.settings.ShowNonLogged = not mainIni.settings.ShowNonLogged
		inicfg.save(mainIni, directIni)
		if(mainIni.settings.ShowNonLogged == true) then
			sampAddChatMessage("Non logged players will now be shown", 0xe686868)
		else
			sampAddChatMessage("Non logged players will no longer be shown", 0xe686868)
		end
	else
		sampAddChatMessage("Usage: {686868}[/ctoggle Numbers/Ping/Levels/NonLogged]", 0xFFFFFF)
	end
end

function cmessage(message)
	if(message == "") then
		sampAddChatMessage("Usage: {686868}[/cmessage (message)]", 0xFFFFFF)
	elseif(string.len(message) > 100) then
		sampAddChatMessage("{686868}The message can not be longer than 100 characters (script restriction)!", 0xFFFFFF)
	else
		smessage = message
		if(string.len(message) < 40) then
			sampAddChatMessage(string.format("{686868}The message was successfully changed! Your message sent will now be: {FFFFFF}%s", smessage), 0xFFFFFF)
		else
			sampAddChatMessage("{686868}The message was successfully changed! Your message sent will now be:", 0xFFFFFF)
			sampAddChatMessage(string.format("%s", smessage), 0xFFFFFF)
		end
	end
end

function conhelp()
	sampAddChatMessage("{686868}[-------- Contacts: Developed by: --------]", 0xFFFFFF)
	sampAddChatMessage("{686868}[--- Nisad Rahman and Brad Ringer ---]", 0xFFFFFF)
    sampAddChatMessage("                                      ", 0xFFFFFF)
	sampAddChatMessage("{686868}[/addcontact] - [/addnumber]{FFFFFF} to add", 0xFFFFFF)
	sampAddChatMessage("{686868}[/removecontact] - [/removenumber]{FFFFFF} to remove", 0xFFFFFF)
	sampAddChatMessage("{686868}[/ctoggle] {FFFFFF}to toggle Numbers/Ping/Levels/NonLogged", 0xFFFFFF)
	sampAddChatMessage("{686868}[/cmessage] {FFFFFF}to edit the messsage sent from the SMS button", 0xFFFFFF)
	sampAddChatMessage("{686868}[/contactlist] {FFFFFF}to see the full contacts list", 0xFFFFFF)
	sampAddChatMessage("{686868}[/contacts] - [/onlines] {FFFFFF}to see online contacts", 0xFFFFFF)
end

function contactlist()
	contacttable = {}
	contactdb = io.open(dbloc, "r")
	for name in contactdb:lines() do
		table.insert(contacttable, name:lower())
	end
	io.close(contactdb)
	numbertable = {}
	numberdb = io.open(numloc, "r")
	for number in numberdb:lines() do
		table.insert(numbertable, number:lower())
	end
	io.close(numberdb)
	-- This counts how many names and numbers you have saved
	i = 0
	for k,n in pairs(contacttable) do
		i = i + 1
	end
	b = 0
	for k,n in pairs(numbertable) do
		b = b + 1
	end
	f = false
	if(i ~= 1 and b == 1) then
		sampAddChatMessage("{686868}[---- Found ".. i .." names and 1 number ----]", 0xFFFFFF)
	elseif(i == 1 and b ~= 1) then
		sampAddChatMessage("{686868}[---- Found 1 name and ".. b .." numbers ----]", 0xFFFFFF)
	elseif(i == 1 and b == 1) then
		sampAddChatMessage("{686868}[---- Found 1 names and 1 number----]", 0xFFFFFF)
	else
		sampAddChatMessage("{686868}[---- Found ".. i .." names and ".. b .." numbers ----]", 0xFFFFFF)
	end
	f = false
	if(i ~= b) then
		f = true
	end
	i = 1
	for k,n in pairs(contacttable) do
		if(numbertable[i] == nil) then
			number = "-"
		else
			number = numbertable[i]
		end
		if(number == "-") then
			sampAddChatMessage("{686868}" .. i .. ". {FFFFFF}" .. n, 0xFFFFFF)
		else
			sampAddChatMessage("{686868}" .. i .. ". {FFFFFF}" .. n .. " | | (number): " .. number, 0xFFFFFF)
		end
		i = i + 1
	end
	if(f == true) then
		sampAddChatMessage("Please keep in mind that you have an {e61920}uneven {FFFFFF}amount of {686868}names {FFFFFF}and {686868}numbers{FFFFFF}!", 0xFFFFFF)
	end
end

function onlines()
	-- This counts how many contacts are online
	tempList = {}
	contactdb = io.open(dbloc, "r")
	for name in contactdb:lines() do
		table.insert(tempList, name:lower())
	end
	io.close(contactdb)
	maxPlayerOnline = sampGetMaxPlayerId(false)
	s = 0
	for i = 0, maxPlayerOnline do
		if sampIsPlayerConnected(i) then
			name = sampGetPlayerNickname(i)
			c = 1
			for k,n in pairs(tempList) do
				if(name:lower() == n:lower()) then
					table.remove(tempList,c)
					s = s + 1
				end
				c = c + 1
			end
		end
	end
	if(s == 0) then
		sampAddChatMessage("{686868}[---- You have no online contacts ----]", 0xFFFFFF)
	elseif(s == 1) then
		sampAddChatMessage("{686868}[---- You have 1 online contact ----]", 0xFFFFFF)
	else
		sampAddChatMessage("{686868}[---- You have ".. s .." online contacts ----]", 0xFFFFFF)
	end
	tempList = {}
	tempaList = {}
	contactdb = io.open(dbloc, "r")
	for name in contactdb:lines() do
		table.insert(tempList, name:lower())
	end
	io.close(contactdb)
	numberdb = io.open(numloc, "r")
	for number in numberdb:lines() do
		table.insert(tempaList, number:lower())
	end
	io.close(numberdb)
	maxPlayerOnline = sampGetMaxPlayerId(false)
	pr = '. '
	gr = '{686868}'
	g = '{34eb46}'
	w = '{FFFFFF}'
	if(mainIni.settings.ShowNumbers == false) then
		nf = ''
	else
		nf = ' || (number): '
	end
	sp = ''
	afks  = ' ~~ TABBED'
	if(mainIni.settings.ShowPing== false) then
		pings = ''
	else
		pings = ' || (Ping): '
	end
	if(mainIni.settings.ShowLevels == false) then
		lvls = ''
	else
		lvls = ' || (Level): '
	end
	s = 1
	for i = 0, maxPlayerOnline do
		if sampIsPlayerConnected(i) then
				afkState = sampIsPlayerPaused(i)
				name = sampGetPlayerNickname(i)
				if(mainIni.settings.ShowPing == false) then
					ping = ''
				else
					ping = sampGetPlayerPing(i)
				end
				if(mainIni.settings.ShowLevels == false) then
					lvl = ''
				else
					lvl = sampGetPlayerScore(i)
				end
				c = 1
				for k,n in pairs(tempList) do
					if(mainIni.settings.ShowNumbers == true) then
						if(tempaList[c] == nil) then
							number = "-"
							fl = true
						else
							number = tempaList[c]
							fl = false
						end
					else
						number = "-"
					end
					if(lvl == 1 and mainIni.settings.ShowNonLogged == false) then
						show = false
					elseif(lvl == 1 and mainIni.settings.ShowNonLogged == true) then
						show = true
						ids = '* (ID): '
					else
						show = true
						ids = ' (ID): '
					end
					if(name:lower() == n:lower() and show == true) then
						if(afkState == true) then
							sampAddChatMessage(gr..s..pr..g..name..ids..i..w..lvls..lvl..afks, 0xFFFFFF)
						else
							if(number == "-") then
								sampAddChatMessage(gr..s..pr..g..name..ids..i..w..lvls..lvl..pings..ping, 0xFFFFFF)
							else
								sampAddChatMessage(gr..s..pr..g..name..ids..i..w..nf..number..lvls..lvl..pings..ping, 0xFFFFFF)
							end
						end
						table.remove(tempList,c)
						if fl == false then
							table.remove(tempaList,c)
						end
						s = s + 1
					end
					c = c + 1
				end
		end
	end
end

function onScriptTerminate(scr, quitGame) 
	if(scr == script.this) then 
		showCursor(false) 
		inicfg.save(config, dir)
	end
end

function apply_style()
	local s = imgui.GetStyle()
	local clrs = s.Colors
	local clr = imgui.Col
	local im4 = imgui.ImVec4
	local im2 = imgui.ImVec2
	s.WindowPadding = im2(5, 5)
	s.WindowRounding = 6.0
	s.FramePadding = im2(5, 5)
	s.FrameRounding = 4.0
	s.ItemSpacing = im2(12, 8)
	s.ItemInnerSpacing = im2(8, 6)
	s.IndentSpacing = 25.0
	s.ScrollbarSize = 15.0
	s.ScrollbarRounding = 9.0
	s.GrabMinSize = 5.0
	s.GrabRounding = 3.0
	clrs[clr.Text] = im4(1.00, 1.00, 1.00, 1.00)
	clrs[clr.TextDisabled] = im4(0.70, 0.71, 0.74, 1.00)
	clrs[clr.WindowBg] = im4(0.11, 0.13, 0.16, 1.00)
	clrs[clr.ChildWindowBg] = im4(0.16, 0.17, 0.20, 1.00)
	clrs[clr.PopupBg] = im4(0.16, 0.17, 0.20, 1.00)
	clrs[clr.Border] = im4(0.12, 0.12, 0.16, 1.00)
	clrs[clr.BorderShadow] = im4(0.00, 0.00, 0.00, 0.00)
	clrs[clr.FrameBg] = im4(0.09, 0.10, 0.15, 1.00)
	clrs[clr.FrameBgHovered] = im4(0.12, 0.13, 0.17, 1.00)
	clrs[clr.FrameBgActive] = im4(0.07, 0.08, 0.13, 1.00)
	clrs[clr.TitleBg] = im4(0.14, 0.14, 0.14, 1.00)
	clrs[clr.TitleBgActive] = im4(0.14, 0.14, 0.14, 1.00)
	clrs[clr.TitleBgCollapsed] = im4(0.14, 0.14, 0.14, 1.00)
	clrs[clr.MenuBarBg] = im4(0.14, 0.14, 0.14, 1.00)
	clrs[clr.ScrollbarBg] = im4(0.17, 0.17, 0.17, 1.00)
	clrs[clr.ScrollbarGrab] = im4(0.25, 0.25, 0.25, 1.00)
	clrs[clr.ScrollbarGrabHovered] = im4(0.25, 0.25, 0.25, 1.00)
	clrs[clr.ScrollbarGrabActive] = im4(0.25, 0.25, 0.25, 1.00)
	clrs[clr.CheckMark] = im4(0.86, 0.87, 0.90, 1.00)
	clrs[clr.SliderGrab] = im4(0.48, 0.49, 0.51, 1.00)
	clrs[clr.SliderGrabActive] = im4(0.66, 0.67, 0.69, 1.00)
	clrs[clr.Button] = im4(0.09, 0.10, 0.15, 1.00)
	clrs[clr.ButtonHovered] = im4(0.12, 0.13, 0.17, 1.00)
	clrs[clr.ButtonActive] = im4(0.07, 0.08, 0.13, 1.00)
	clrs[clr.Header] = im4(0.29, 0.34, 0.43, 1.00)
	clrs[clr.HeaderHovered] = im4(0.21, 0.24, 0.31, 1.00)
	clrs[clr.HeaderActive] = im4(0.29, 0.34, 0.43, 1.00)
	clrs[clr.Separator] = im4(0.43, 0.43, 0.50, 0.50)
	clrs[clr.SeparatorHovered] = im4(0.43, 0.43, 0.50, 0.50)
	clrs[clr.SeparatorActive] = im4(0.43, 0.43, 0.50, 0.50)
	clrs[clr.ResizeGrip] = im4(0.26, 0.59, 0.98, 0.25)
	clrs[clr.ResizeGripHovered] = im4(0.26, 0.59, 0.98, 0.67)
	clrs[clr.ResizeGripActive] = im4(0.26, 0.59, 0.98, 0.95)
	clrs[clr.PlotLines] = im4(0.61, 0.61, 0.61, 1.00)
	clrs[clr.PlotLinesHovered] = im4(1.00, 0.43, 0.35, 1.00)
	clrs[clr.PlotHistogram] = im4(0.90, 0.70, 0.00, 1.00)
	clrs[clr.PlotHistogramHovered] = im4(1.00, 0.60, 0.00, 1.00)
	clrs[clr.TextSelectedBg] = im4(0.25, 0.25, 0.25, 0.50)
    clrs[clr.CloseButton] = im4(0.40, 0.39, 0.38, 0.16)
    clrs[clr.CloseButtonHovered] = im4(0.40, 0.39, 0.38, 0.39)
    clrs[clr.CloseButtonActive] = im4(0.40, 0.39, 0.38, 1.00)
end
apply_style()
