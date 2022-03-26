-- BARO

-- enjxp		2022.01.20	FIX: Simulator dataref subscribe to lower memory usage

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	-- X-KeyPad Custom Strings
	local SHAREDFLOAT = dataref_table("SRS/X-KeyPad/SharedFloat")	-- For SHAREDFLOAT value
	local STR_5 = dataref_table("SRS/X-KeyPad/custom_string_5") -- For the BARO
	dataref("CONFIG_LOAD_COUNTER","SRS/X-KeyPad/ConfigLoadCounter")	-- New configuration has been loaded
	
	-- Simulator datarefs
	dataref("SHOW_STD","laminar/B738/EFIS/baro_set_std_pilot") -- To show STD on PFD
	dataref("ZIBO_BARO_HPA","laminar/B738/EFIS_control/capt/baro_in_hpa") -- For HPA value
	local ZIBO_BARO = dataref_table("laminar/B738/EFIS/baro_sel_in_hg_pilot") -- For BARO value

	STR_5[0] = ZIBO_BARO[0]
	LAST_SHAREDFLOAT = SHAREDFLOAT[5]

	-- Keep track of the previous contents of the datarefs so we only update the strings if they change. 
	local last_config_load_counter = -1
	local last_baro = -1000

	function RefreshString()
		last_baro = -1000		
	end

	function UpdateString()	-- Update custom strings if necessary
		-- Refresh if a new configuration has been loaded since they get cleared on reload by X-KeyPad
		if(last_config_load_counter ~= CONFIG_LOAD_COUNTER) then
			RefreshString()
			last_config_load_counter = CONFIG_LOAD_COUNTER
		end
		if(ZIBO_BARO_HPA == 1) then
			STR_5[0] = string.format("%.0f",(ZIBO_BARO[0] * 33.863886666667))
		else
			STR_5[0] =  string.format("%.2f",ZIBO_BARO[0]) 
		end
	end

	function CheckBaro()
		-- If value changed since last input
		if (LAST_SHAREDFLOAT ~= SHAREDFLOAT[5]) then
			-- If Hecto Pascal (HPA) is selected
			if (ZIBO_BARO_HPA == 1) then 
				if (SHAREDFLOAT[5] >= 982 and SHAREDFLOAT[5] <= 1050) then -- Lowest HPA is 982 and Highest is 1050
					ZIBO_BARO[0] = SHAREDFLOAT[5] / 33.863886666667
				end
			-- If Inch of Mecury (IN) is selected
			elseif (SHAREDFLOAT[5] >= 2900 and SHAREDFLOAT[5] <= 3100) then -- Lowest IN is 29.00 and Highest is 31.00
					-- Because value is entered without decimal point it is divided by 100
					ZIBO_BARO[0] = (SHAREDFLOAT[5] / 100) -- BARO value is set
			end
			-- Place New Input Value in Last Input Value
			LAST_SHAREDFLOAT = SHAREDFLOAT[5]
		end

		-- If STD set string to 29.92
		if (SHOW_STD == 0) then
			-- Update String
			UpdateString()
		else
			STR_5[0] = " "
		end	
	end

	do_every_frame ("CheckBaro()")

end
