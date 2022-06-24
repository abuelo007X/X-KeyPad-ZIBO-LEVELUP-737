-- HYD PUMPS

-- enjxp		2022.06.02	-- refined script due to issues
-- Abuelo007X	2022.02.05	-- Ability to show the current Hyp Pumps state based on the switches and annunciators states

local LOG_ID = "FWL 4 XKP B737 VD : HYD PUMPS : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- X-KeyPad Custom Strings or Values
	local SI_HYD_PUMP = dataref_table("SRS/X-KeyPad/SharedInt")

	-- Simulator datarefs

	local ZIBO_HYD_PUMP_ENG1_POS	= dataref_table("laminar/B738/toggle_switch/hydro_pumps1_pos")				-- 1 ON, 0 OFF
	local ZIBO_HYD_PUMP_ELEC2_POS	= dataref_table("laminar/B738/toggle_switch/electric_hydro_pumps1_pos")		-- 1 ON, 0 OFF

	local ZIBO_HYD_PUMP_ELEC1_POS	= dataref_table("laminar/B738/toggle_switch/electric_hydro_pumps2_pos")		-- 1 ON, 0 OFF
	local ZIBO_HYD_PUMP_ENG2_POS	= dataref_table("laminar/B738/toggle_switch/hydro_pumps2_pos")				-- 1 ON, 0 OFF

	local ZIBO_HYD_PUMP_ENG1_ANN	= dataref_table("laminar/B738/annunciator/hyd_press_a")						-- 1 ON, 0 OFF
	local ZIBO_HYD_PUMP_ELEC2_ANN	= dataref_table("laminar/B738/annunciator/hyd_el_press_a")					-- 1 ON, 0 OFF

	local ZIBO_HYD_PUMP_ELEC1_ANN	= dataref_table("laminar/B738/annunciator/hyd_el_press_b")					-- 1 ON, 0 OFF
	local ZIBO_HYD_PUMP_ENG2_ANN	= dataref_table("laminar/B738/annunciator/hyd_press_b")						-- 1 ON, 0 OFF

	local ZIBO_BATT_BUS				= dataref_table("laminar/B738/electric/batbus_status")						-- 1 ON, 0 OFF

	local SRS_CL = dataref_table("SRS/X-KeyPad/ConfigLoadCounter")												-- This will be to tell us when a new configuration has been loaded

	local cmp = 0
	local cmp1 = "0"
	local cmp2 = "0"
	local cmp3 = "0"
	local cmp4 = "0"
	local cmp43 = -1
	local cmp44 = -1
	local cmp45 = -1
	local cmp46 = -1

	SI_HYD_PUMP[43] = 0		-- KEY 88
	SI_HYD_PUMP[44] = 0		-- KEY 97
	SI_HYD_PUMP[45] = 0		-- KEY 106
	SI_HYD_PUMP[46] = 0		-- KEY 115
	SRS_CL_SAVE = -1

	function fullRefresh()

		-- logMsg(LOG_ID .. "LUA | FULL REFRESH")

		cmp43 = -1
		cmp44 = -1
		cmp45 = -1
		cmp46 = -1
	end

	function pr_calc_hyd_pumps()

		-- logMsg(LOG_ID .. "LUA | PR_CALC")

		if(SRS_CL_SAVE ~= SRS_CL[0]) then
			fullRefresh()
			SRS_CL_SAVE = SRS_CL[0]
		end			

		-- HYD_PUMP_ENG1
		-- Read binary value 0 or 1
		cmp1 = string.format("%0d",ZIBO_HYD_PUMP_ENG1_POS[0])
		cmp2 = string.format("%0d",ZIBO_HYD_PUMP_ENG1_ANN[0])
		cmp3 = string.format("%0d",ZIBO_BATT_BUS[0])
		-- Concatenate the 3 binaries then convert to decimal and compare to last save value. If different store new value to Sharedint then backup new value to last save
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp43 ~= cmp then SI_HYD_PUMP[43] = cmp cmp43 = cmp end

		-- logMsg(LOG_ID .. "CALC | HYD_PUMP_ENG1 = " .. cmp)

		-- HYD_PUMP_ELEC2
		cmp1 = string.format("%0d",ZIBO_HYD_PUMP_ELEC2_POS[0])
		cmp2 = string.format("%0d",ZIBO_HYD_PUMP_ELEC2_ANN[0])
		cmp3 = string.format("%0d",ZIBO_BATT_BUS[0])
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp44 ~= cmp then SI_HYD_PUMP[44] = cmp cmp44 = cmp end

		-- logMsg(LOG_ID .. "CALC | HYD_PUMP_ELEC2 = " .. cmp)

		-- HYD_PUMP_ELEC1
		cmp1 = string.format("%0d",ZIBO_HYD_PUMP_ELEC1_POS[0])
		cmp2 = string.format("%0d",ZIBO_HYD_PUMP_ELEC1_ANN[0])
		cmp3 = string.format("%0d",ZIBO_BATT_BUS[0])
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp45 ~= cmp then SI_HYD_PUMP[45] = cmp cmp45 = cmp end

		-- logMsg(LOG_ID .. "CALC | HYD_PUMP_ELEC1 = " .. cmp)

 		-- HYD_PUMP_ENG2
		cmp1 = string.format("%0d",ZIBO_HYD_PUMP_ENG2_POS[0])
		cmp2 = string.format("%0d",ZIBO_HYD_PUMP_ENG2_ANN[0])
		cmp3 = string.format("%0d",ZIBO_BATT_BUS[0])
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp46 ~= cmp then SI_HYD_PUMP[46] = cmp cmp46 = cmp end

		-- logMsg(LOG_ID .. "CALC | HYD_PUMP_ENG2 = " .. cmp)

	end

	do_every_frame("pr_calc_hyd_pumps()")

end
