-- Rethemer 1.1 MUOS - Pixie alternative theme creator
-- April, 2025

local meta = getmetatable("") -- get the string metatable

meta.__add = function(a,b) -- the + operator
    return a..b
end

meta.__sub = function(a,b) -- the - operator
    return a:gsub(b,"")
end

meta.__mul = function(a,b) -- the * operator
    return a:rep(b)
end

-- if you have string.explode (check out the String exploding snippet) you can also add this:
meta.__div = function(a,b) -- the / operator
    return a:explode(b)
end

meta.__index = function(a,b) -- if you attempt to do string[id]
    if type(b) ~= "number" then
        return string[b]
    end
    return a:sub(b,b)
end

--[[

]]

local TITLE = "Rethemer"
local WINDOWWIDTH  = 640
local WINDOWHEIGHT = 480
local BGCOLOR = { .2,  .2,  .2 }

-- rgb strings RRGGBB hex
local redSTR = ""
local greenSTR = ""
local blueSTR = ""

-- r,g,b 0 to 1
local r = 0.01 
local g = 0.01 
local b = 0.01
local tempR = 0.01 
local tempG = 0.01 
local tempB = 0.01

-- red,green,blue 0 to 255 
local red   = 0
local green = 0
local blue  = 0
local tempRed   = 0
local tempGreen = 0
local tempBlue  = 0

-- drawing
local x = 0
local y = 0
local z = 0
local o = 120 -- offset to list
local ls = 18 -- linespace
local help = 0 -- a countdown on the help screen text

-- mouse
local mx = 0
local my = 0
local mdelay = 0

-- handheld
local TOGGLE = -1

-- data
local contents = "" -- reads the current .ini file

-- int character location inside muOS-Alt.ini
local POS = {155, 190, 249, 368, 457, 620, 674, 728, 782, 836, 890, 947,
			1024, 1072, 1101, 1138, 1205, 1237, 1283, 1308, 1343, 1518, 1573, 1608 }

-- 6 digit RRGGBB string from the above positions in the contents data 
local COL = {"","","","","","","","","","","","","","","","","","","","","","","",""}

-- used with the above arrays
local SEL = 1

--[[these stay as reference for the COL and POS arrays
-- these names are from the muOS ini file
local BACKGROUND = ""
local BACKGROUND_GRADIENT_COLOR = ""
local NETWORK_ACTIVE = ""
local BLUETOOTH_ACTIVE = ""
local DATETIME_TEXT = ""
local NAV_A_GLYPH = ""
local NAV_B_GLYPH = ""
local NAV_C_GLYPH = ""
local NAV_X_GLYPH = ""
local NAV_Y_GLYPH = ""
local NAV_Z_GLYPH = ""
local NAV_MENU_GLYPH = "" 
local CELL_DEFAULT_BACKGROUND = "" 
local CELL_DEFAULT_BACKGROUND_GRADIENT_COLOR = "" 
local CELL_DEFAULT_BORDER = ""
local CELL_DEFAULT_IMAGE_RECOLOUR = "" 
local CELL_DEFAULT_TEXT = ""
local CELL_FOCUS_BACKGROUND = ""
local CELL_FOCUS_BACKGROUND_GRADIENT_COLOR = ""
local CELL_FOCUS_TEXT = ""
local CELL_FOCUS_IMAGE_RECOLOUR = ""
local LIST_FOCUS_BACKGROUND = ""
local LIST_FOCUS_TEXT = ""
local LIST_FOCUS_GLYPH_RECOLOUR = ""

-- the exact character position in the file 
local BACKGROUND_POS = 155
local BACKGROUND_GRADIENT_COLOR_POS = 190
local NETWORK_ACTIVE_POS = 249
local BLUETOOTH_ACTIVE_POS = 368
local DATETIME_TEXT_POS = 457
local NAV_A_GLYPH_POS = 620
local NAV_B_GLYPH_POS = 674
local NAV_C_GLYPH_POS = 728
local NAV_X_GLYPH_POS = 782
local NAV_Y_GLYPH_POS = 836
local NAV_Z_GLYPH_POS = 890
local NAV_MENU_GLYPH_POS = 947
local CELL_DEFAULT_BACKGROUND_POS = 1024
local CELL_DEFAULT_BACKGROUND_GRADIENT_COLOR_POS = 1072
local CELL_DEFAULT_BORDER_POS = 1101
local CELL_DEFAULT_IMAGE_RECOLOUR_POS = 1138
local CELL_DEFAULT_TEXT_POS = 1205
local CELL_FOCUS_BACKGROUND_POS = 1237
local CELL_FOCUS_BACKGROUND_GRADIENT_COLOR_POS = 1283
local CELL_FOCUS_TEXT_POS = 1308
local CELL_FOCUS_IMAGE_RECOLOUR_POS = 1343
local LIST_FOCUS_BACKGROUND_POS = 1518
local LIST_FOCUS_TEXT_POS = 1573
local LIST_FOCUS_GLYPH_RECOLOUR_POS = 1608
]]

function love.load()

    love.window.setTitle(TITLE)
    love.window.setMode(WINDOWWIDTH, WINDOWHEIGHT)
    love.graphics.setBackgroundColor(BGCOLOR)
    love.graphics.setColor(1,1,1,1)
	font = love.graphics.newFont(14)
	
	dot = love.graphics.newImage("gfx/dot.png")
	line = love.graphics.newImage("gfx/line.png")
	-- fake cursor for handheld devices
	cursor = love.graphics.newImage("gfx/cursor.png")
    love.mouse.setVisible(false)

	-- contents, size = love.filesystem.read("muOS-Alt.ini", all)
    local readFilePath = "/mnt/mmc/MUOS/theme/active/alternate/muOS-Alt.ini"
    local readFile = io.open(readFilePath, "r+") 
		    
	if readFile then
        contents = readFile:read "*all"
        readFile:close()
    else
        print("Failed to open system file for reading. Using local file.")
    	readFilePath = "./rethemer/muOS-Alt.ini"
        readFile = io.open(readFilePath, "r+") 
    	if readFile then
       		contents = readFile:read "*all"
       		readFile:close()
    	else
       		print("Failed to open local file for reading.")
    		readFilePath = "./muOS-Alt.ini"
       		readFile = io.open(readFilePath, "r+") 
    		if readFile then
       			contents = readFile:read "*all"
       			readFile:close()
    		else
       			print("Failed to open all files for reading.")
       		end
    	end
    end
	
	-- booting into background color for visual confirmation of loading a file XD
	red = tonumber(contents[POS[1]],16)*16 + tonumber(contents[POS[1]+1],16)
	r = red/255
	green = tonumber(contents[POS[1]+2],16)*16 + tonumber(contents[POS[1]+3],16)
	g = green/255
	blue = tonumber(contents[POS[1]+4],16)*16 + tonumber(contents[POS[1]+5],16)
	b = blue/255

	for x = 1, 24 do
		COL[x] = contents:sub(POS[x],POS[x]+6)
	end

end

function love.draw()

	redSTR = string.format("%02x", red)
	greenSTR = string.format("%02x", green)
	blueSTR = string.format("%02x", blue)
	help = help - 1

	for x = 1 ,24 do -- loop through all the settings and draw the current color next to the text
		tempRed = tonumber(contents[POS[x]],16)*16 + tonumber(contents[POS[x]+1],16)
		tempR = tempRed/255
		tempGreen = tonumber(contents[POS[x]+2],16)*16 + tonumber(contents[POS[x]+3],16)
		tempG = tempGreen/255
		tempBlue = tonumber(contents[POS[x]+4],16)*16 + tonumber(contents[POS[x]+5],16)
		tempB = tempBlue/255
		love.graphics.setColor(tempR,tempG,tempB,1)	
		y = x
		z = 10
		if (x >= 13) then 
			z = 330 
			y = y - 12 
		end
		love.graphics.draw(dot, z, o + (y * ls))
		love.graphics.draw(dot, z+8, o + (y * ls))
		love.graphics.draw(dot, z+272, o + (y * ls))
		love.graphics.draw(dot, z+280, o + (y * ls))
	end

	x = 60
	y = o + ls
	z = 160
	love.graphics.setColor(.01,.01,.01,1)
	for tempR = 0, 1 do -- loop through text drawing with an offset and recolor for a cheap drop shadow
		x = x - tempR * 2
		y = y - tempR * 2
		if (SEL <= 12) then
			love.graphics.print("===>", x - 50, y - ls + SEL * ls)
			love.graphics.print("<===", 590 - 320, y - ls + SEL * ls)
		elseif (SEL >= 13) then
			love.graphics.print("===>", x - 50 + 320, y - ls + (SEL - 12) * ls)
			love.graphics.print("<===", 590, y - ls + (SEL - 12) * ls)
		end
		love.graphics.print("Background", x, y)
		love.graphics.print(COL[1], x + z, y)
		love.graphics.print("BKG Gradient", x, y + ls)
		love.graphics.print(COL[2], x + z, y + ls)
		love.graphics.print("Network", x, y + ls * 2)
		love.graphics.print(COL[3], x + z, y + ls * 2)
		love.graphics.print("Bluetooth", x, y + ls * 3)
		love.graphics.print(COL[4], x + z, y + ls * 3)
		love.graphics.print("Date and Time", x, y + ls * 4)
		love.graphics.print(COL[5], x + z, y + ls * 4)
		love.graphics.print("Nav. A Glyph", x, y + ls * 5)
		love.graphics.print(COL[6], x + z, y + ls * 5)
		love.graphics.print("Nav. B Glyph", x, y + ls * 6)
		love.graphics.print(COL[7], x + z, y + ls * 6)
		love.graphics.print("Nav. C Glyph", x, y + ls * 7)
		love.graphics.print(COL[8], x + z, y + ls * 7)
		love.graphics.print("Nav. X Glyph", x, y + ls * 8)
		love.graphics.print(COL[9], x + z, y + ls * 8)
		love.graphics.print("Nav. Y Glyph", x, y + ls * 9)
		love.graphics.print(COL[10], x + z, y + ls * 9)
		love.graphics.print("Nav. Z Glyph", x, y + ls * 10)
		love.graphics.print(COL[11], x + z, y + ls * 10)
		love.graphics.print("Nav. Menu Glyph", x, y + ls * 11)
		love.graphics.print(COL[12], x + z, y + ls * 11)
		x = x + 320 -- shift half the screen
		love.graphics.print("Cell Def Background", x, y)
		love.graphics.print(COL[13], x + z, y)
		love.graphics.print("Cell Def BKG Gradient", x, y + ls) 
		love.graphics.print(COL[14], x + z, y + ls)
		love.graphics.print("Cell Def Border", x, y + ls * 2)
		love.graphics.print(COL[15], x + z, y + ls * 2)
		love.graphics.print("Cell Def Image", x, y + ls * 3)
		love.graphics.print(COL[16], x + z, y + ls * 3)
		love.graphics.print("Cell Def Text", x, y + ls * 4)
		love.graphics.print(COL[17], x + z, y + ls * 4)
		love.graphics.print("Cell Focus Background", x, y + ls * 5)
		love.graphics.print(COL[18], x + z, y + ls * 5)
		love.graphics.print("Cell Focus BKG Gradient", x, y + ls * 6)
		love.graphics.print(COL[19], x + z, y + ls * 6)
		love.graphics.print("Cell Focus Text", x, y + ls * 7)
		love.graphics.print(COL[20], x + z, y + ls * 7)
		love.graphics.print("Cell Focus Image", x, y + ls * 8)
		love.graphics.print(COL[21], x + z, y + ls * 8)
		love.graphics.print("List Focus Background", x, y + ls * 9)
		love.graphics.print(COL[22], x + z, y + ls * 9)
		love.graphics.print("List Focus Text", x, y + ls * 10)
		love.graphics.print(COL[23], x + z, y + ls * 10)
		love.graphics.print("List Focus Glyph", x, y + ls * 11)
		love.graphics.print(COL[24], x + z, y + ls * 11)
		x = x - 320

		love.graphics.setColor(1,1,1,1)
	end

	y = o + ls
	mx, my = love.mouse.getPosition()
	mdelay = mdelay + 1
    if (mdelay >= 1 and love.mouse.isDown(1) or love.mouse.isDown(2) or love.mouse.isDown(3)) then
		-- chzy btn flthr trk, literally fall down(and right) writing else if buttons using outer x y limits, overlaps become irrelevant
		if (mx < 516 and my < 29) then -- red slider
			mdelay = 0
			red = math.floor(mx/2)
			if red > 255 then red = 255 end
			r = red/255
		elseif (mx < 516 and my < 51) then -- green slider
			mdelay = 0
			green = math.floor(mx/2)
			if green > 255 then green = 255 end
			g = green/255
		elseif (mx < 516 and my < 73) then -- blue slider
			mdelay = 0
			blue = math.floor(mx/2)
			if blue > 255 then blue = 255 end
			b = blue/255
		elseif (mdelay > 90 and mx > 570 and my < 80) then -- current color buffer button
			mdelay = 0 -- lets not multi write ^^ mdelay is checked again here
			contents = contents:sub(1,POS[SEL]-1)..redSTR..greenSTR..blueSTR..contents:sub(POS[SEL]+6)
			-- updating these here seems to work well
			COL[SEL] = contents:sub(POS[SEL],POS[SEL]+6)

		    local writeFilePath = "/mnt/mmc/MUOS/theme/active/alternate/muOS-Alt.ini"
			local writeFile = io.open(writeFilePath, "w")
			if writeFile then -- write to contents then write all of it to file
				writeFile:write(contents)
				writeFile:close()
			else
				print("Failed to open system file for writing. Using local file.")
		    	writeFilePath = "./rethemer/muOS-Alt.ini"
				writeFile = io.open(writeFilePath, "w")
				if writeFile then -- write to contents then write all of it to file
					writeFile:write(contents)
					writeFile:close()
				else
					print("Failed to open local default file for writing.")
		    		writeFilePath = "./muOS-Alt.ini"
					writeFile = io.open(writeFilePath, "w")
					if writeFile then -- write to contents then write all of it to file
						writeFile:write(contents)
						writeFile:close()
					else
						print("Failed to open all files for writing.")
					end
				end
			end
		elseif (my > y and my < y + ls * 12 and mx < 320) then -- SEL switching, column one
			mdelay = 0
			if (my < y + ls) then
				SEL = 1
			elseif (my < y + ls * 2) then
				SEL = 2
			elseif (my < y + ls * 3) then
				SEL = 3
			elseif (my < y + ls * 4) then
				SEL = 4
			elseif (my < y + ls * 5) then
				SEL = 5
			elseif (my < y + ls * 6) then
				SEL = 6
			elseif (my < y + ls * 7) then
				SEL = 7
			elseif (my < y + ls * 8) then
				SEL = 8
			elseif (my < y + ls * 9) then
				SEL = 9
			elseif (my < y + ls * 10) then
				SEL = 10
			elseif (my < y + ls * 11) then
				SEL = 11
			elseif (my < y + ls * 12) then
				SEL = 12
			end
			if (love.mouse.isDown(2)) then
				red = tonumber(contents[POS[SEL]],16)*16 + tonumber(contents[POS[SEL]+1],16)
				r = red/255
				green = tonumber(contents[POS[SEL]+2],16)*16 + tonumber(contents[POS[SEL]+3],16)
				g = green/255
				blue = tonumber(contents[POS[SEL]+4],16)*16 + tonumber(contents[POS[SEL]+5],16)
				b = blue/255
			end

		elseif (my > y and my < y + ls * 12 and mx > 320) then -- SEL switching, column two
			mdelay = 0
			if (my < y + ls) then
				SEL = 13
			elseif (my < y + ls * 2) then
				SEL = 14
			elseif (my < y + ls * 3) then
				SEL = 15
			elseif (my < y + ls * 4) then
				SEL = 16
			elseif (my < y + ls * 5) then
				SEL = 17
			elseif (my < y + ls * 6) then
				SEL = 18
			elseif (my < y + ls * 7) then
				SEL = 19
			elseif (my < y + ls * 8) then
				SEL = 20
			elseif (my < y + ls * 9) then
				SEL = 21
			elseif (my < y + ls * 10) then
				SEL = 22
			elseif (my < y + ls * 11) then
				SEL = 23
			elseif (my < y + ls * 12) then
				SEL = 24
			end
			if (love.mouse.isDown(2)) then
				red = tonumber(contents[POS[SEL]],16)*16 + tonumber(contents[POS[SEL]+1],16)
				r = red/255
				green = tonumber(contents[POS[SEL]+2],16)*16 + tonumber(contents[POS[SEL]+3],16)
				g = green/255
				blue = tonumber(contents[POS[SEL]+4],16)*16 + tonumber(contents[POS[SEL]+5],16)
				b = blue/255
			end
		elseif (help < 60 and my >  y + ls * 15 and mx < 320) then -- help menu
			mdelay = 0
			help = 1200
		elseif (help < 0 and mdelay > 30 and my >  y + ls * 17 and mx > 320) then -- presets
			mdelay = 0
			local readFilePath = "./rethemer/muOS-Alt.ini"
			if (mx < 320 + 320/4) then  	
				readFilePath = "./rethemer/presets/Max-Mustard.ini"
			elseif (mx < 320 + 320/2) then
				readFilePath = "./rethemer/presets/Neon-Dijon.ini"
			elseif (mx < 320 + (320/4)*3) then  	
				readFilePath = "./rethemer/presets/Red-Giant.ini"
    		else	
				readFilePath = "./rethemer/presets/Gray-Poupon.ini"
			end
    		local readFile = io.open(readFilePath, "r+") 
			if readFile then
    		    contents = readFile:read "*all"
    		    readFile:close()
    		else
    		    print("Failed to open system preset file for reading. Trying local filesystem.")
    			readFilePath = "."..readFilePath:sub(11)
    			readFile = io.open(readFilePath, "r+") 
				if readFile then
    			    contents = readFile:read "*all"
    			    readFile:close()
    			else
    			    print("Failed to open local preset file for reading. Aborted.")
    			end
    		end
			
			red = tonumber(contents[POS[1]],16)*16 + tonumber(contents[POS[1]+1],16)
			r = red/255
			green = tonumber(contents[POS[1]+2],16)*16 + tonumber(contents[POS[1]+3],16)
			g = green/255
			blue = tonumber(contents[POS[1]+4],16)*16 + tonumber(contents[POS[1]+5],16)
			b = blue/255
		
			for x = 1, 24 do
				COL[x] = contents:sub(POS[x],POS[x]+6)
			end
		end
	end
	
	x=0
	while x < 255 do -- the slider bars
		love.graphics.setColor(.7,.7,.7,1)
		love.graphics.draw(dot, x*2-2, 2)	 -- white backdrop	
		love.graphics.draw(dot, x*2-2, 20)	 -- white backdrop		
		love.graphics.draw(dot, x*2-2, 40)	 -- white backdrop		
		love.graphics.draw(dot, x*2-2, 58)	 -- white backdrop		
		love.graphics.setColor(x/255,0,0,1)
		love.graphics.draw(dot, x*2-4, 10)	 -- red
		love.graphics.setColor(0,x/255,0,1)
		love.graphics.draw(dot, x*2-4, 30)	 -- green
		love.graphics.setColor(0,0,x/255,1)
		love.graphics.draw(dot, x*2-4, 50)	 -- blue
		x = x + 2
	end
	
	-- the slider line
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(line, red * 2,   10)
	love.graphics.draw(line, green * 2, 30)
	love.graphics.draw(line, blue * 2,  50)

	x = 90
	y = o + 10
	love.graphics.setColor(.01,.01,.01,1)
	for tempR = 0, 1 do
		x = x - tempR * 2
		y = y - tempR * 2

		love.graphics.print("0 - 1 {", x - 50, y - ls * 2)
		love.graphics.print("Red", x, y - ls * 3)
		love.graphics.print(": "..string.format("%f", r), x + 50, y - ls * 3)
		love.graphics.print("Green", x, y - ls * 2)
		love.graphics.print(": "..string.format("%f", g), x + 50, y - ls * 2)
		love.graphics.print("Blue", x, y - ls)
		love.graphics.print(": "..string.format("%f", b), x + 50, y - ls)

		love.graphics.print("0 - 255 {", x + 250, y - ls * 2)
		love.graphics.print("Red", x + 310, y - ls * 3)
		love.graphics.print(": "..tostring(red), x + 360, y - ls * 3)
		love.graphics.print("Green", x + 310, y - ls * 2)
		love.graphics.print(": "..tostring(green), x + 360, y - ls * 2)
		love.graphics.print("Blue", x + 310, y - ls)
		love.graphics.print(": "..tostring(blue), x + 360, y - ls)

		love.graphics.print("HEXCODE : "..redSTR..greenSTR..blueSTR, x + 410, y - ls * 2)
	
		if help > 0 then 
			z = 15 -- in place of ls for compact text
			love.graphics.print("'Menu' and 'Start' to exit. Changes are saved to 'mmc/MUOS/theme/alternate/muOS-Alt.ini'", x - 70, y + z * 16)
			love.graphics.print("The 'D-Pad' works to change editing items, 'Select' = copy color to buffer.", x - 70, y + z * 17)
			love.graphics.print("Use 'L-stick' as mouse, 'L1' = Mouse 1, Select, 'R1' = Mouse 2, Select & copy color.", x - 70, y + z * 18)
			love.graphics.print("The Red, Green and Blue color bars are clickable sliders 'L1' or 'R1' work.", x - 70, y + z * 19)
			love.graphics.print("'X' (red) 'Y' (green) 'B' (blue) to adjust colors. Click 'R-Stick' to toggle negative/positive.", x - 70, y + z * 20)
			love.graphics.print("Press 'A' to set current color to selected editing item, or click the top right square.", x - 70, y + z * 21)
		else
			z = 15 -- in place of ls for compact text
			love.graphics.print("Rethemer 1.1 for MUOS - Pixie. Create an alternative color theme for your handheld on your handheld.", x - 75, y + z * 17)
			love.graphics.print("To use go to 'CONFIG > CUSTOMISATION > ALTERNATIVE THEME > MUOS-ALT' from the main menu.", x - 70, y + z * 18)
			love.graphics.print("	Click Here for Help Menu.  ???", x - 70, y + z * 20)
			love.graphics.print("	'Menu' and 'Start' to exit.", x - 70, y + z * 21)
			love.graphics.print("!! Presets !!", 450, y + z * 20)
			love.graphics.print("Max-Mustard |  Neon-Dijon |  Red-Giant | Gray-Poupon", 316, y + z * 21)
		end

		love.graphics.setColor(1,1,1,1)
	end
	

	x=530
	love.graphics.setColor(r,0,0,1)
	love.graphics.draw(dot, x, 10)	
	love.graphics.setColor(0,g,0,1)
	love.graphics.draw(dot, x, 30)	
	love.graphics.setColor(0,0,b,1)
	love.graphics.draw(dot, x, 50)
		
	-- behind buffer color	
	y=10
	x=560
	z=-1
	while y < 52 do
		while x < 604 do
			love.graphics.setColor(.5+z*.4,.5+z*.4,.5+z*.4,1)
			love.graphics.draw(dot, x, y)
			x = x + 4
			z = z * -1
		end
		x = 560
		y = y + 4
	end

	love.graphics.setColor(r,g,b,1)	
	y=20
	x=570
	while y < 44 do
		while x < 594 do
			love.graphics.draw(dot, x, y)
			x = x + 4
		end
		x = 570
		y = y + 4
	end
	
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())

end

function love.keypressed(k) -- using gptokey for all handheld commands, making rethemer keyboard compatible
	if k == "a" then
		contents = contents:sub(1,POS[SEL]-1)..redSTR..greenSTR..blueSTR..contents:sub(POS[SEL]+6)
		-- updating these here seems to work well
		COL[SEL] = contents:sub(POS[SEL],POS[SEL]+6)
		local writeFilePath = "/mnt/mmc/MUOS/theme/active/alternate/muOS-Alt.ini"
		local writeFile = io.open(writeFilePath, "w")
		if writeFile then -- write to contents then write all of it to file
			writeFile:write(contents)
			writeFile:close()
		else
			print("Failed to open system file for writing. Using local file.")
		   	writeFilePath = "./rethemer/muOS-Alt.ini"
			writeFile = io.open(writeFilePath, "w")
			if writeFile then -- write to contents then write all of it to file
				writeFile:write(contents)
				writeFile:close()
			else
				print("Failed to open local default file for writing.")
			end
		end
	elseif k =="up" then
		SEL = SEL - 1
		if SEL <= 0 then SEL = 24 end
	elseif k =="down" then
		SEL = SEL + 1
		if SEL >= 25 then SEL = 1 end
	elseif k =="left" or k == "right" then
		if SEL >= 13 then 
			SEL = SEL - 12 
		else 
			SEL = SEL + 12 
		end
	elseif k == "rctrl" or k == "lctrl" then
		TOGGLE = TOGGLE * - 1
	elseif k == "lshift" then
		TOGGLE = 1
	elseif k == "rshift" then
		TOGGLE = 8
	elseif k == "x" then
		red = red + TOGGLE
		if red > 255 then red = 255 end
		if red < 0 then red = 0 end
		r = red/255
	elseif k == "y" then
		green = green + TOGGLE
		if green > 255 then green = 255 end
		if green < 0 then green = 0 end
		g = green/255
	elseif k == "b" then
		blue = blue + TOGGLE
		if blue > 255 then blue = 255 end
		if blue < 0 then blue = 0 end
		b = blue/255
	elseif k == "return" then
		red = tonumber(contents[POS[SEL]],16)*16 + tonumber(contents[POS[SEL]+1],16)
		r = red/255
		green = tonumber(contents[POS[SEL]+2],16)*16 + tonumber(contents[POS[SEL]+3],16)
		g = green/255
		blue = tonumber(contents[POS[SEL]+4],16)*16 + tonumber(contents[POS[SEL]+5],16)
		b = blue/255
	elseif k == "escape" then
		love.event.quit() -- a keyboard based quit for console mode or debugging
	end
end
