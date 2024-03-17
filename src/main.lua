#!/bin/lua

local home = os.getenv("HOME")

-- Non-blocking user input
-- System dependent; probably works only on UNIX-like systems
function getch()
	os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
	local key = ""
	local seq = ""
	local c = io.read(1)  -- Read one character
	-- Check for escape sequence
	if c == "\27" then
		-- Start of escape sequence detected
		seq = c
		while #seq < 3 do
			c = io.read(1)  -- Read next character
			if not c then break end  -- End of input
			seq = seq .. c
		end
		key = seq  -- Return the complete escape sequence
	else
		-- Single character input
		key = c
	end
	
	os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	return key
end

--[[

function get_terminal_size2()
	local terminal_size = {}
	
	-- Send ANSI escape sequence to get the cursor position
	io.write("\27[999;999H")
	io.write("\27[6n")
	io.flush()
	
	-- Read the cursor position report
	local report = io.read("*a")
	
	-- Extract row and column from the report
	local row, col = report:match("(%d+);(%d+)R")
	
	-- Convert row and column to integers and store in the result table
	terminal_size.width = tonumber(col)
	terminal_size.height = tonumber(row)
	
	io.write(terminal_size.width, ", ", terminal_size.height)
	io.read()
	
	return terminal_size
end

-- Function to retrieve terminal size
function get_terminal_size3()
    io.write("\027[18t")  -- Send ANSI escape sequence for requesting terminal size
    io.flush()  -- Ensure the escape sequence is sent immediately
    local response = io.read()  -- Read the response from the terminal
    local _, _, width, height = response:find("\027%[(%d+);(%d+)R")  -- Parse the response
    return tonumber(width), tonumber(height)  -- Return width and height as numbers
end
]]

-- Function to retrieve terminal size
-- Got this baby from ChatGPT
function get_terminal_size()
    local width = tonumber(io.popen('tput cols'):read('*a'))
    local height = tonumber(io.popen('tput lines'):read('*a'))
    return width, height
end

function split(inp, sep) -- Custom split str into tbl
	-- The one I found on the internet had a major issue for my use case
	-- Probably slower, since it loops over every character
	-- May create a version with string.find()
	local t = {""} -- Output
	local e = 1 -- Table index
	
	for a = 1, inp:len() do
		local c = inp:sub(a, a)
		if c == sep then
			e = e + 1
			t[e] = ""
		else
			t[e] = t[e] .. c
		end
	end
	
	return t
end

function input_handler(str)
	if str == "q" then
		return 1
	end
	return 0
end

function draw_screen()
	
end

local t_size = {} -- Terminal size
local width, height = get_terminal_size()
t_size.width, t_size.height = width, height
local handle_list
local handle, text = nil, ""

if #arg ~= 0 then
	if arg[1] == "--install" then
		-- Will be made later
	else
		-- Has a file name
		handle = io.open(arg[1], "r")
		text = handle:read("*a")
		handle_list[1] = handle
	end
end

os.execute("mkdir " .. home .. "/.mint/; touch " .. home .. "/.mintrc")

-- Open cfg file
rchan = io.open(home .. "/.mintrc", "r")
rcstr = rchan:read("*a")
rchan:close()

-- Parse the cfg file
local rctbl = split(rcstr, "\n")
for i = 1, #rctbl do
	rctbl[i] = split(rctbl[i], " ")
end

local cfg = { -- Default values
	n_of_lines = t_size.height - 3,
	width = t_size.width,
	lnum = 6
}

for i = 1, #cfg do
	-- I may create a parser function for this, it is getting repetitive
	if rctbl[i][1] == "n_of_lines" then -- Number of lines to be displayed
		if rctbl[i][2] == "auto" then
			cfg.n_of_lines = t_size.height - 3
		else
			cfg.n_of_lines = tonumber(rctbl[i][2])
			if cfg.n_of_lines == nil then
				io.write("SYNTAX ERROR IN ~/.mintrc\nline: " .. tostring(i) .. "\nInvalid value for n_of_lines: " .. rctbl[i][2] .. "\nPress Enter to exit.")
				io.read()
				os.exit()
			end	
		end
	elseif rctbl[i][1] == "width" then -- Window width
		if rctbl[i][2] == "auto" then
			cfg.width = t_size.width
		else
			cfg.width = tonumber(rctbl[i][2])
			if cfg.width == nil then
				io.write("SYNTAX ERROR IN ~/.mintrc\nline: " .. tostring(i) .. "\nInvalid value for width: " .. rctbl[i][2] .. "\nPress Enter to exit.")
				io.read()
				os.exit()
			end	
		end
	elseif rctbl[i][1] == "lnum" then -- Space given for line numbers (not too sure how to describe it)
		cfg.lnum = tonumber(tctbl[i][2])
		if cfg.lnum == nil then
			io.write("SYNTAX ERROR IN ~/.mintrc\nline: " .. tostring(i) .. "\nInvalid value for lnum: " .. rctbl[i][2] .. "\nPress Enter to exit.")
			io.read()
			os.exit()
		end
	end
end

-- Cursor
local col, row, line = 1, 1, 1

io.write(type(handle)) io.read()
if handle ~= nil then
	--text = handle:read("*a")
	handle:close()
	io.write(text) io.read()
end

local text2 = split(text, "\n")

local mode = 0
--[[
0	general
1	insert
2	file

]]

io.write("\27[2J\27[25h")
while true do
	for i = line, line + cfg.n_of_lines do
		if i <= #text2 then
			-- Display line
			-- Line number, padded with whitespace
			io.write("\27[" .. tostring(i - line + 1) .. ";1H" .. tostring(i) ..  string.rep(" ", cfg.lnum - string.len(tostring(i))) .. text2[i] .. string.rep(" ", cfg.width - cfg.lnum - string.len(text2[i])))
		else
			-- Empty line
			io.write("\27[" .. tostring(i - line + 1) .. ";1H\27[2K~")
		end
	end
	-- Mode display
	io.write("\27[" .. tostring(cfg.n_of_lines + 2) .. ";1H" .. string.sub("GENERAL     INSERT      FILE        ", mode * 12 + 1, mode * 12 + 12))
	io.write("\27[" .. tostring(cfg.n_of_lines + 3) .. ";1H\27[2K")
	-- Display cursor
	if not (row - line + 1 < 1 or row - line + 1 > cfg.n_of_lines) then
		io.write("\27[" .. tostring(row - line + 1) .. ";" .. tostring(col + cfg.lnum) .. "H")
	else
		io.write("\27[" .. tostring(cfg.n_of_lines + 3) .. ";1H")
	end
	
	-- Get input
	inp = getch()
	
	if mode == 0 then
		if inp == ":" then -- Command input (similar to vim maybe) ((So same problem of people not knowing how to exit probably))
			io.write("\27[" .. tostring(cfg.n_of_lines + 3) .. ";1H:")
			local inp2 = io.read()
			io.write("\27[0m")
			local r = input_handler(inp2)
			if r == 1 then
				os.exit(0)
			end
		elseif inp == "`" then -- Clear screen
			io.write("\27[2J")
		elseif inp == "\27[A" then -- Arrow up
			row = row - 1
			if row < 1 then
				row = 1
				io.write("\a")
			end
		elseif inp == "\27[B" then -- Arrow down
			row = row + 1
			if row > #text2 then
				row = #text2
				io.write("\a")
			end
		elseif inp == "\27[D" then -- Arrow left
			col = col - 1
			if col < 1 then
				row = row - 1
				if row < 1 then
					row = 1
				io.write("\a")
				end
				col = text2[row]:len() + 1
			end
		elseif inp == "\27[C" then -- Arrow right
			col = col + 1
			if col > text2[row]:len() + 1 then
				row = row + 1
				if row > #text2 then
					io.write("\a")
					row = #text2
				end
				col = 1
			end
		elseif inp == "w" then -- Screen up
			line = line - 1
			if line < 1 then
				io.write("\a")
				line = 1
			end
		elseif inp == "s" then -- Screen down
			line = line + 1
		end
	end
end
