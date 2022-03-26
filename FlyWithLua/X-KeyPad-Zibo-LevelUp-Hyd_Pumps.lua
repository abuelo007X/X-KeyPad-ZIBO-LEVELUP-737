-- HYD PUMPS

-- Abuelo007X	2022.02.05	-- Ability to show the current Hyp Pumps state based on the switches and annunciators states

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	-- X-KeyPad Custom Strings or Values
	local SHAREDINT = dataref_table("SRS/X-KeyPad/SharedInt")
    	
	-- Simulator datarefs

	dataref("ZIBO_HYD_PUMP_ENG1_POS","laminar/B738/toggle_switch/hydro_pumps1_pos","readonly")						-- 1 ON, 0 OFF
	dataref("ZIBO_HYD_PUMP_ENG1_ANN","laminar/B738/annunciator/hyd_press_a","readonly")								-- 1 ON, 0 OFF
	dataref("ZIBO_HYD_PUMP_ENG2_POS","laminar/B738/toggle_switch/hydro_pumps2_pos","readonly")						-- 1 ON, 0 OFF
	dataref("ZIBO_HYD_PUMP_ENG2_ANN","laminar/B738/annunciator/hyd_press_b","readonly")								-- 1 ON, 0 OFF
	dataref("ZIBO_HYD_PUMP_ELEC1_POS","laminar/B738/toggle_switch/electric_hydro_pumps2_pos","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_HYD_PUMP_ELEC1_ANN","laminar/B738/annunciator/hyd_el_press_b","readonly")							-- 1 ON, 0 OFF
	dataref("ZIBO_HYD_PUMP_ELEC2_POS","laminar/B738/toggle_switch/electric_hydro_pumps1_pos","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_HYD_PUMP_ELEC2_ANN","laminar/B738/annunciator/hyd_el_press_a","readonly")							-- 1 ON, 0 OFF
	dataref("ZIBO_BATT_BUS","laminar/B738/electric/dir_batbus_status","readonly")									-- 1 ON, 0 OFF

	local SRS_CL = dataref_table("SRS/X-KeyPad/ConfigLoadCounter")													-- This will be to tell us when a new configuration has been loaded

	local cmp = 0
	local cmp1 = "0"
	local cmp2 = "0"
	local cmp3 = "0"
	local cmp4 = "0"
	local cmp43 = -1
	local cmp44 = -1
	local cmp45 = -1
	local cmp46 = -1

	SHAREDINT[43] = 0
	SHAREDINT[44] = 0
	SHAREDINT[45] = 0
	SHAREDINT[46] = 0
	SRS_CL_SAVE = -1

	function fullRefresh()
		cmp43 = -1
		cmp44 = -1
		cmp45 = -1
		cmp46 = -1
	end

	function hp_handling()

		if(SRS_CL_SAVE ~= SRS_CL[0]) then
			fullRefresh()
			SRS_CL_SAVE = SRS_CL[0]
		end			

		-- HYD_PUMP_ENG1
		-- Read binary value 0 or 1
		cmp1 = string.format("%0d",ZIBO_HYD_PUMP_ENG1_POS)
		cmp2 = string.format("%0d",ZIBO_HYD_PUMP_ENG1_ANN)
		cmp3 = string.format("%0d",ZIBO_BATT_BUS)
		-- Concatenate the 3 binaries then convert to decimal and compare to last save value. If different store new value to Sharedint then backup new value to last save
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp43 ~= cmp then SHAREDINT[43] = cmp cmp43 = cmp end

 		-- HYD_PUMP_ENG2
		cmp1 = string.format("%0d",ZIBO_HYD_PUMP_ENG2_POS)
		cmp2 = string.format("%0d",ZIBO_HYD_PUMP_ENG2_ANN)
		cmp3 = string.format("%0d",ZIBO_BATT_BUS)
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp44 ~= cmp then SHAREDINT[44] = cmp cmp44 = cmp end

		-- HYD_PUMP_ELEC1
		cmp1 = string.format("%0d",ZIBO_HYD_PUMP_ELEC1_POS)
		cmp2 = string.format("%0d",ZIBO_HYD_PUMP_ELEC1_ANN)
		cmp3 = string.format("%0d",ZIBO_BATT_BUS)
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp45 ~= cmp then SHAREDINT[45] = cmp cmp45 = cmp end

		-- HYD_PUMP_ELEC2
		cmp1 = string.format("%0d",ZIBO_HYD_PUMP_ELEC2_POS)
		cmp2 = string.format("%0d",ZIBO_HYD_PUMP_ELEC2_ANN)
		cmp3 = string.format("%0d",ZIBO_BATT_BUS)
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp46 ~= cmp then SHAREDINT[46] = cmp cmp46 = cmp end

	end

	do_every_frame ("hp_handling()")

end
