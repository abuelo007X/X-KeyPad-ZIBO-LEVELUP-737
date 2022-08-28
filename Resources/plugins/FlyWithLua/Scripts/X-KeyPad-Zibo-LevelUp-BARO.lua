-- BARO

-- enjxp		2022.05.28	-- FIX: Variable names standardization
-- enjxp		2022.01.20	-- FIX: Simulator dataref subscribe to lower memory usage
-- Abuelo007X	2022.01.10	-- ADD: Initial build
-- Magicnorm	2020.09		-- Initial Configuration

local LOG_ID = "FWL 4 XKP B737 VD : BARO : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- X-KeyPad Custom Strings
	local STR_6					= dataref_table("SRS/X-KeyPad/custom_string_6")					-- For the BARO
	local CONFIG_LOAD_COUNTER	= dataref_table("SRS/X-KeyPad/ConfigLoadCounter")				-- New configuration has been loaded

	-- Simulator datarefs
	local SHOW_STD				= dataref_table("laminar/B738/EFIS/baro_set_std_pilot")			-- To show STD on PFD
	local ZIBO_BARO_HPA			= dataref_table("laminar/B738/EFIS_control/capt/baro_in_hpa")	-- For HPA value
	local ZIBO_BARO				= dataref_table("laminar/B738/EFIS/baro_sel_in_hg_pilot")		-- For BARO value

	STR_6[0] = ZIBO_BARO[0]
	F_BARO = 0
	STR_BARO_LAST = -1
	SHOW_STD_LAST = -1
	ZIBO_BARO_HPA_LAST = -1

	-- Keep track of the previous contents of the datarefs so we only update the strings if they change.
	local last_config_load_counter = -1

	function RefreshString()
		STR_BARO_LAST = -1
		STR_6[0] = string.format("%.0f",F_BARO)
	end

	function UpdateString()	-- Update custom strings if necessary
		-- Refresh if a new configuration has been loaded since they get cleared on reload by X-KeyPad
		if(last_config_load_counter ~= CONFIG_LOAD_COUNTER[0]) then
			RefreshString()
			last_config_load_counter = CONFIG_LOAD_COUNTER[0]
		end
	end

	function pr_calc_baro()
		-- If value changed since last input
		if (STR_BARO_LAST ~= F_BARO) or (SHOW_STD_LAST ~= SHOW_STD) or (ZIBO_BARO_HPA_LAST ~= ZIBO_BARO_HPA[0]) then
			-- If Hecto Pascal (HPA) is selected
			if (ZIBO_BARO_HPA[0] == 1) then
				F_BARO = ZIBO_BARO[0] * 33.863886666667
			-- If Inch of Mecury (IN) is selected
			elseif (ZIBO_BARO[0] >= 2900 and ZIBO_BARO[0] <= 3100) then -- Lowest IN is 29.00 and Highest is 31.00
				F_BARO = ZIBO_BARO[0]
			end
			-- Place New Input Value in Last Input Value
			STR_BARO_LAST = F_BARO
			SHOW_STD_LAST = SHOW_STD[0]
			ZIBO_BARO_HPA_LAST = ZIBO_BARO_HPA[0]
		end

		-- If STD set string to 29.92
		if (SHOW_STD[0] == 0) then
			-- Update String
			RefreshString()
			-- UpdateString()
		else
			STR_6[0] = " "
		end
		UpdateString()
	end

	do_often("pr_calc_baro()")
	-- do_every_frame("pr_calc_baro()")

end
