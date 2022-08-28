-- ENG N1 Values

-- Abuelo007X	2022.01.10	-- Add to the ENGs Keys also N1 values beyond N2 values - sim/flightmodel/engine/ENGN_N1_[0/1]

local LOG_ID = "FWL 4 XKP B737 VD : ENG N1 : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- X-KeyPad Custom Strings
	local STR_7 = dataref_table("SRS/X-KeyPad/custom_string_7") -- For the N1 ENG1
	local STR_8 = dataref_table("SRS/X-KeyPad/custom_string_8") -- For the N1 ENG2
	
	-- Simulator datarefs
	local N1_ENG = dataref_table("sim/flightmodel/engine/ENGN_N1_") -- To obtain values for N1

	STR_7[0] = string.format("%02.1f",N1_ENG[0])
	STR_8[0] = string.format("%02.1f",N1_ENG[1])

	function pr_calc_eng_n1()
		STR_7[0] = string.format("%02.1f",N1_ENG[0])
		STR_8[0] = string.format("%02.1f",N1_ENG[1])
	end

	do_often("pr_calc_eng_n1()")
	-- do_every_frame("pr_calc_eng_n1()")

end
