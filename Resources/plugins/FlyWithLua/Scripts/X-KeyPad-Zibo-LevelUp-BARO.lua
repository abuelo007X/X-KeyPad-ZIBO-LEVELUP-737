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

	STR_6[0] = " "
	F_BARO = 0
	STR_BARO_LAST = -1
	SHOW_STD_LAST = -1
	ZIBO_BARO_HPA_LAST = -1
	LAST_CONFIG_LOAD_COUNTER = CONFIG_LOAD_COUNTER[0]

	function UpdateBAROString()	-- Update custom strings if necessary
		if(ZIBO_BARO_HPA[0] == 1) then
			STR_6[0] = string.format("%.0f",F_BARO)
		else
			STR_6[0] = string.format("%.2f",F_BARO)
		end
	end

	function pr_calc_baro()
		-- If value changed since last input
		if (STR_BARO_LAST ~= ZIBO_BARO[0]) or (SHOW_STD_LAST ~= SHOW_STD[0]) or (ZIBO_BARO_HPA_LAST ~= ZIBO_BARO_HPA[0]) or (LAST_CONFIG_LOAD_COUNTER ~= CONFIG_LOAD_COUNTER[0]) then
			-- If Hecto Pascal (HPA) is selected
			if (ZIBO_BARO_HPA[0] == 1) then
				F_BARO = ZIBO_BARO[0] * 33.863886666667
			-- If Inch of Mecury (IN) is selected
			else
				F_BARO = ZIBO_BARO[0]
			end
			-- Place New Input Value in Last Input Value
			STR_BARO_LAST = ZIBO_BARO[0]
			SHOW_STD_LAST = SHOW_STD[0]
			ZIBO_BARO_HPA_LAST = ZIBO_BARO_HPA[0]
			LAST_CONFIG_LOAD_COUNTER = CONFIG_LOAD_COUNTER[0]
			
			if (SHOW_STD[0] == 1) then
				STR_6[0] = " "
			else
				UpdateBAROString()
			end
		end
	end

	do_often("pr_calc_baro()")
	-- do_every_frame("pr_calc_baro()")
end
