-- ENG N1 Values

-- Abuelo007X		Add to the ENGs Keys also N1 values beyond N2 values - sim/flightmodel/engine/ENGN_N1_[0/1]

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	-- X-KeyPad Custom Strings
	local STR_7 = dataref_table("SRS/X-KeyPad/custom_string_7") -- For the N1 ENG1
	local STR_8 = dataref_table("SRS/X-KeyPad/custom_string_8") -- For the N1 ENG2
	
	-- Simulator datarefs
	local N1_ENG = dataref_table("sim/flightmodel/engine/ENGN_N1_") -- To obtain values for N1

	STR_7[0] = string.format("%02.1f",N1_ENG[0])
	STR_8[0] = string.format("%02.1f",N1_ENG[1])

	function UpdateN1()
		STR_7[0] = string.format("%02.1f",N1_ENG[0])
		STR_8[0] = string.format("%02.1f",N1_ENG[1])
	end

	do_every_frame ("UpdateN1()")

end
