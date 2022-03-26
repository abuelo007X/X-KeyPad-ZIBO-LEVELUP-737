-- RUDDER_TRIM
-- Abuelo007X 		Ability to show the current Rudder Trim based on the changes while adjusting rudder

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	-- X-KeyPad Custom Strings
	local STR_10 = dataref_table("SRS/X-KeyPad/custom_string_10") -- For the RUDDER_TRIM
    	
	-- Simulator datarefs
	local ZIBO_ELEV_TRIM = dataref_table("sim/flightmodel2/controls/rudder_trim") -- For Rudder_TRIM value

    local CONVERTED_TRIM = (ZIBO_ELEV_TRIM[0]*17)
    STR_10[0] =  string.format("%.2f",CONVERTED_TRIM) 


	function UpdateString_10()
        CONVERTED_TRIM = (ZIBO_ELEV_TRIM[0]*17)
        STR_10[0] =  string.format("%.2f",CONVERTED_TRIM) 
	end

	do_every_frame ("UpdateString_10()")

end
