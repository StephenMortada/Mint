#!/bin/lua

io.write("[ Mint Package System ]\n")

if arg[1] == nil or arg[1] == "help" then
	io.write("made by StephenMortada\n\n")
	io.write("For more details, go to https://stephenmortada.github.io/MintPkg/\n")
	io.write("Need anything? email NoForgetAtAll@hotmail.com.)
	io.write([[Options:
	install [name]
		Install package with name [name]
	remove [name]
		Uninstall package with name [name]
	upload [name].zip
		Submit an extension to be installed by users.
]])
if arg[1] == "install" then
	if arg[2] == nil then
		io.write("Error: Missing package name. Please specify\nthe name of the package to install.\n")
		os.exit(200)
	end
	
	io.write("Fetching file...\n")
	local download_url = "https://raw.githubusercontent.com/StephenMortada/MintPkg/main/" .. arg[2] .. ".zip"
	local package_zip = home .. "/.mint/pkg/" .. arg[2] .. ".zip"
	
	-- Download the package
	local download_command = "curl -LJO " .. download_url
	local download_success = os.execute(download_command)
	
	if download_success then
		io.write("Extracting...\n")
		local extract_command = "unzip " .. package_zip .. " -d " .. home .. "/.mint/pkg/" .. arg[2]
		local extract_success = os.execute(extract_command)
		
		if extract_success then
			io.write("Finishing...\n")
			-- Add the installed package to the list of installed packages
			local installed_packages_file = io.open(home .. "/.mint/installed_packages.txt", "a")
			if installed_packages_file then
				installed_packages_file:write(arg[2] .. "\n")
				installed_packages_file:close()
			else
				io.write("Error: Could not update installed packages list.\nPlease update it manually by adding a new line with\nthe name of the package you are trying to install.\n")
				os.exit(203)
			end
			
			io.write("Done!\n")
		else
			io.write("Error: Failed to extract the package.\n")
			os.exit(202)
		end
	else
		io.write("Error: Failed to download the package.\n")
		os.exit(201)
	end
	os.exit(0)
end