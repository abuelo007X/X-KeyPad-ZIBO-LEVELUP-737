-- RECIRC FAN

-- enjxp		2022.06.10	-- Initial Configuration

local LOG_ID = "FWL 4 XKP B737 VD : RECIRC FAN : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- X-KeyPad Custom Strings
	local SI_RECIRC_FAN			= dataref_table("SRS/X-KeyPad/SharedInt")						-- For the AIRCRAFT CHECK
	local CONFIG_LOAD_COUNTER	= dataref_table("SRS/X-KeyPad/ConfigLoadCounter")				-- New configuration has been loaded

	-- Simulator datarefs

	local SI_RECIRC_FAN_L		= dataref_table("laminar/B738/air/l_recirc_fan_pos")			-- For the LEFT RECIRC FAN
	local SI_RECIRC_FAN_R		= dataref_table("laminar/B738/air/r_recirc_fan_pos")			-- For the RIGHT RECIRC FAN

	SI_RECIRC_FAN[0] = 0
	SI_RECIRC_FAN[1] = 0
	local SI_RECIRC_FAN_L_LAST = -1
	local SI_RECIRC_FAN_R_LAST = -1
	local I_RECIRC_FAN = 0

	-- Keep track of the previous contents of the datarefs so we only update the strings if they change.
	local last_config_load_counter = -1

	function RefreshValue()
		SI_RECIRC_FAN_L_LAST = -1
		SI_RECIRC_FAN_R_LAST = -1
		SI_RECIRC_FAN[0] = I_RECIRC_FAN + SI_RECIRC_FAN_L[0]
		SI_RECIRC_FAN[1] = I_RECIRC_FAN + SI_RECIRC_FAN_R[0]
	end

	function UpdateValue()	-- Update custom strings if necessary
		-- Refresh if a new configuration has been loaded since they get cleared on reload by X-KeyPad
		if(last_config_load_counter ~= CONFIG_LOAD_COUNTER[0]) then
			RefreshValue()
			last_config_load_counter = CONFIG_LOAD_COUNTER[0]
		end
	end

	function pr_calc_recirc()
		-- If value changed since last input
		if (SI_RECIRC_FAN[0] ~= SI_RECIRC_FAN_LAST)  then

			if (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") then
				I_RECIRC_FAN = 2
			else
				I_RECIRC_FAN = 0
			end

			SI_RECIRC_FAN_L_LAST = I_RECIRC_FAN + SI_RECIRC_FAN_L[0]
			SI_RECIRC_FAN_R_LAST = I_RECIRC_FAN + SI_RECIRC_FAN_R[0]
			SI_RECIRC_FAN[0] = I_RECIRC_FAN + SI_RECIRC_FAN_L[0] -- so in the related key, we will check between value = 0 or 1 if not "Boeing 737-600NG" or "Boeing 737-700NG", or value = 2 or 3 otherwise
			SI_RECIRC_FAN[1] = I_RECIRC_FAN + SI_RECIRC_FAN_R[0] -- so in the related key, we will check between value = 0 or 1 if not "Boeing 737-600NG" or "Boeing 737-700NG", or value = 2 or 3 otherwise
		end

		UpdateValue()
	end

	do_every_frame("pr_calc_recirc()")

end
