-- ELEV_TRIM

-- enjxp		2022.01.20	-- FIX: removed 100 multiplicator
--							-- FIX: dataref subscribe ZIBO_ELEV_TRIM to lower memory usage
-- Abuelo007X	2022.01.10	-- Ability to change Elev Trim using the X-KeyPad buffer or show the current Trim based on the changes done using the Trim wheel in the airplane
--								(The Ability to use X-KeyPad buffer requires to enable the "do_every_frame "("Check_Elev_Trim()")" instead of "do_often ("UpdateString_9()")",
--								but right now is inefficient and slows trim operation when using the trim wheel)

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	-- X-KeyPad Custom Strings
	local STR_9 = dataref_table("SRS/X-KeyPad/custom_string_9") -- For the ELEV_TRIM
	local SHAREDFLOAT_ET = dataref_table("SRS/X-KeyPad/SharedFloat")	-- For SHAREDFLOAT value. In the case of Elev_Trim we will use position 9
    	
	-- Simulator datarefs
	dataref("ZIBO_ELEV_TRIM","sim/flightmodel/controls/elv_trim") -- For Elev_TRIM value

    local CONVERTED_TRIM = (ZIBO_ELEV_TRIM*8.5)+8.5
    STR_9[0] =  string.format("%.2f",CONVERTED_TRIM) 
    SHAREDFLOAT_ET[9] = CONVERTED_TRIM

    local LAST_SHAREDFLOAT_9 = SHAREDFLOAT_ET[9]

	function UpdateString_9()
        CONVERTED_TRIM = (ZIBO_ELEV_TRIM*8.5)+8.5
        STR_9[0] =  string.format("%.2f",CONVERTED_TRIM) 
        SHAREDFLOAT_ET[9] = CONVERTED_TRIM
	end

	function Check_Elev_Trim()

        -- If value changed since last input
		if (LAST_SHAREDFLOAT_9 ~= SHAREDFLOAT_ET[9]) then
			if (SHAREDFLOAT_ET[9] >= 0 and SHAREDFLOAT_ET[9] <= 1700) then -- Elev_Trim Lowest is 0.00 and Highest is 17.00
                -- Because value is entered without decimal point it is divided by 100
                ZIBO_ELEV_TRIM = ((SHAREDFLOAT_ET[9]/100-8.5)/8.5) -- Elev_Trim value is set
			end
			-- Place New Input Value in Last Input Value
			LAST_SHAREDFLOAT_9 = SHAREDFLOAT_ET[9]
		end

        UpdateString_9()
    end

	-- do_every_frame ("Check_Elev_Trim()")
	do_every_frame ("UpdateString_9()")

end
