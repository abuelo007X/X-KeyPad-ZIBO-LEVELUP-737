-- FUEL PUMPS

-- enjxp		2022.06.02	-- FIX: moved dataref usage to dataref_table and added tonumber() conversions as well as dataref_table index on all variables
-- enjxp		2022.02.22	-- FIX: Updated Fuel QTY value format to allow proper substring in Key Editor Label tab
-- enjxp		2022.01.25	-- ADD: Switching between LBS and KG
-- enjxp		2022.01.20	-- ADD: Reworked to incorporate Binary computing using aggregated dataref values
--							-- FIX: Dataref subscription updated to non table scheme
--							-- ADD: fuel pressure datarefs
-- Abuelo007X	2022.01.10	-- Ability to show the current Fuel Pumps state based on the switches changes and annunciators states
-- Magicnorm	2020.09		-- Initial Configuration

local LOG_ID = "FWL 4 XKP B737 VD : FUEL : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- X-KeyPad Custom Strings or Values
	local SI_FUEL = dataref_table("SRS/X-KeyPad/SharedInt")

	-- Simulator datarefs

	local ZIBO_FUEL_PRESS_LEFT1		= dataref_table("laminar/B738/system/fuel_press_l1")			-- 1 ON, 0 OFF with moving state : trigger on rising and falling edge
	local ZIBO_FUEL_PRESS_LEFT2		= dataref_table("laminar/B738/system/fuel_press_l2")			-- 1 ON, 0 OFF with moving state : trigger on rising and falling edge
	local ZIBO_FUEL_PRESS_CTR1		= dataref_table("laminar/B738/system/fuel_press_c1")			-- 1 ON, 0 OFF with moving state : trigger on rising and falling edge
	local ZIBO_FUEL_PRESS_CTR2		= dataref_table("laminar/B738/system/fuel_press_c2")			-- 1 ON, 0 OFF with moving state : trigger on rising and falling edge
	local ZIBO_FUEL_PRESS_RIGHT1	= dataref_table("laminar/B738/system/fuel_press_r1")			-- 1 ON, 0 OFF with moving state : trigger on rising and falling edge
	local ZIBO_FUEL_PRESS_RIGHT2	= dataref_table("laminar/B738/system/fuel_press_r2")			-- 1 ON, 0 OFF with moving state : trigger on rising and falling edge

	local ZIBO_FUEL_PUMP_LEFT1_ANN	= dataref_table("laminar/B738/annunciator/low_fuel_press_l1")	-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_LEFT2_ANN	= dataref_table("laminar/B738/annunciator/low_fuel_press_l2")	-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_CTR1_ANN	= dataref_table("laminar/B738/annunciator/low_fuel_press_c1")	-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_CTR2_ANN	= dataref_table("laminar/B738/annunciator/low_fuel_press_c2")	-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_RIGHT1_ANN	= dataref_table("laminar/B738/annunciator/low_fuel_press_r1")	-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_RIGHT2_ANN	= dataref_table("laminar/B738/annunciator/low_fuel_press_r2")	-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_LEFT1_POS	= dataref_table("laminar/B738/fuel/fuel_tank_pos_lft1")			-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_LEFT2_POS	= dataref_table("laminar/B738/fuel/fuel_tank_pos_lft2")			-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_CTR1_POS	= dataref_table("laminar/B738/fuel/fuel_tank_pos_ctr1")			-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_CTR2_POS	= dataref_table("laminar/B738/fuel/fuel_tank_pos_ctr2")			-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_RIGHT1_POS	= dataref_table("laminar/B738/fuel/fuel_tank_pos_rgt1")			-- 1 ON, 0 OFF
	local ZIBO_FUEL_PUMP_RIGHT2_POS	= dataref_table("laminar/B738/fuel/fuel_tank_pos_rgt2")			-- 1 ON, 0 OFF

	local ZIBO_BATT_BUS				= dataref_table("laminar/B738/electric/batbus_status")		-- 1 ON, 0 OFF

	local ZIBO_LEFT_TANK_LBS		= dataref_table("laminar/B738/fuel/left_tank_lbs")				-- QTY LEFT
	local ZIBO_CTR_TANK_LBS			= dataref_table("laminar/B738/fuel/center_tank_lbs")			-- QTY CENTER
	local ZIBO_RIGHT_TANK_LBS		= dataref_table("laminar/B738/fuel/right_tank_lbs")				-- QTY RIGHT
	local ZIBO_LEFT_TANK_KG			= dataref_table("laminar/B738/fuel/left_tank_kgs")				-- QTY LEFT
	local ZIBO_CTR_TANK_KG			= dataref_table("laminar/B738/fuel/center_tank_kgs")			-- QTY CENTER
	local ZIBO_RIGHT_TANK_KG		= dataref_table("laminar/B738/fuel/right_tank_kgs")				-- QTY RIGHT

	local STR_0 = dataref_table("SRS/X-KeyPad/custom_string_0")										-- For ZIBO_LEFT_TANK QTY
	local STR_1 = dataref_table("SRS/X-KeyPad/custom_string_1")										-- For ZIBO_CTR_TANK QTY
	local STR_2 = dataref_table("SRS/X-KeyPad/custom_string_2")										-- For ZIBO_RIGHT_TANK QTY
	local ZIBO_EFB_UNITS = dataref_table("laminar/B738/FMS/fmc_units")								-- UNITS: 0=LBS / 1=KG
	
	local SRS_CFGLD = dataref_table("SRS/X-KeyPad/ConfigLoadCounter")								-- This will be to tell us when a new configuration has been loaded
	local SRS_CFGLD_SAVE = -1

	local cmp = 0
	local cmp30 = -1
	local cmp31 = -1
	local cmp32 = -1
	local cmp33 = -1
	local cmp34 = -1
	local cmp35 = -1

	local cmpunits = -1
	
	local fprs_l1_save = -1
	local fprs_l2_save = -1
	local fprs_c1_save = -1
	local fprs_c2_save = -1
	local fprs_r1_save = -1
	local fprs_r2_save = -1

	SI_FUEL[30] = 0
	SI_FUEL[31] = 0
	SI_FUEL[32] = 0
	SI_FUEL[33] = 0
	SI_FUEL[34] = 0
	SI_FUEL[35] = 0
	STR_0[0] = "[0]"
	STR_1[0] = "[0]" 
	STR_2[0] = "[0]"
	local cmp40 = "init0"
	local cmp41 = "init0"
	local cmp42 = "init0"
	local cmpstr = "0"

	function fullrefresh()
		cmp30 = -1
		cmp31 = -1
		cmp32 = -1
		cmp33 = -1
		cmp34 = -1
		cmp35 = -1
		fprs_l1_save = -1
		fprs_l2_save = -1
		fprs_c1_save = -1
		fprs_c2_save = -1
		fprs_r1_save = -1
		fprs_r2_save = -1
		cmpunits = math.ceil(ZIBO_EFB_UNITS[0])
	end

	function pr_calc_fuel()

		-- logMsg(LOG_ID .. "LUA | PR_CALC")

		STR_0[0] = cmp40
		STR_1[0] = cmp41 
		STR_2[0] = cmp42

		if(SRS_CFGLD_SAVE ~= SRS_CFGLD[0]) then
			fullrefresh()
			SRS_CFGLD_SAVE = SRS_CFGLD[0]
		end			

		-- FUEL_PUMP_LEFT1
		-- Read moving value from 0 to 1 or 1 to 0 : cmp1 is set on rising and falling edge
		fuelpress = string.format("%0d",ZIBO_FUEL_PRESS_LEFT1[0]) if fuelpress ~= fprs_l1_save then cmp1 = 1 fprs_l1_save = fuelpress else cmp1 = 0 end
		-- Read binary value 0 or 1
		cmp2 = string.format("%0d",ZIBO_FUEL_PUMP_LEFT1_POS[0])
		cmp3 = string.format("%0d",ZIBO_FUEL_PUMP_LEFT1_ANN[0])
		cmp4 = string.format("%0d",ZIBO_BATT_BUS[0])
		-- Concatenate the 4 binaries then convert to decimal and compare to last save value. If different store new value to SI_FUEL then backup new value to last save
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp30 ~= cmp then SI_FUEL[30] = cmp cmp30 = cmp end

		-- logMsg(LOG_ID .. "CALC | FUEL_PUMP_LEFT1 = " .. cmp)

		-- FUEL_PUMP_LEFT2
		fuelpress = string.format("%0d",ZIBO_FUEL_PRESS_LEFT2[0]) if fuelpress ~= fprs_l2_save then cmp1 = 1 fprs_l2_save = fuelpress else cmp1 = 0 end
		cmp2 = string.format("%0d",ZIBO_FUEL_PUMP_LEFT2_POS[0])
		cmp3 = string.format("%0d",ZIBO_FUEL_PUMP_LEFT2_ANN[0])
		cmp4 = string.format("%0d",ZIBO_BATT_BUS[0])
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp31 ~= cmp then SI_FUEL[31] = cmp cmp31 = cmp end

		-- FUEL_PUMP_CTR1
		fuelpress = string.format("%0d",ZIBO_FUEL_PRESS_CTR1[0]) if fuelpress ~= fprs_c1_save then cmp1 = 1 fprs_c1_save = fuelpress else cmp1 = 0 end
		cmp2 = string.format("%0d",ZIBO_FUEL_PUMP_CTR1_POS[0])
		cmp3 = string.format("%0d",ZIBO_FUEL_PUMP_CTR1_ANN[0])
		cmp4 = string.format("%0d",ZIBO_BATT_BUS[0])
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp32 ~= cmp then SI_FUEL[32] = cmp cmp32 = cmp end

		-- FUEL_PUMP_CTR2
		fuelpress = string.format("%0d",ZIBO_FUEL_PRESS_CTR2[0]) if fuelpress ~= fprs_c2_save then cmp1 = 1 fprs_c2_save = fuelpress else cmp1 = 0 end
		cmp2 = string.format("%0d",ZIBO_FUEL_PUMP_CTR2_POS[0])
		cmp3 = string.format("%0d",ZIBO_FUEL_PUMP_CTR2_ANN[0])
		cmp4 = string.format("%0d",ZIBO_BATT_BUS[0])
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp33 ~= cmp then SI_FUEL[33] = cmp cmp33 = cmp end

		-- FUEL_PUMP_RIGHT1
		fuelpress = string.format("%0d",ZIBO_FUEL_PRESS_RIGHT1[0]) if fuelpress ~= fprs_r1_save then cmp1 = 1 fprs_r1_save = fuelpress else cmp1 = 0 end
		cmp2 = string.format("%0d",ZIBO_FUEL_PUMP_RIGHT1_POS[0])
		cmp3 = string.format("%0d",ZIBO_FUEL_PUMP_RIGHT1_ANN[0])
		cmp4 = string.format("%0d",ZIBO_BATT_BUS[0])
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp34 ~= cmp then SI_FUEL[34] = cmp cmp34 = cmp end

		-- FUEL_PUMP_RIGHT2
		fuelpress = string.format("%0d",ZIBO_FUEL_PRESS_RIGHT2[0]) if fuelpress ~= fprs_r2_save then cmp1 = 1 fprs_r2_save = fuelpress else cmp1 = 0 end
		cmp2 = string.format("%0d",ZIBO_FUEL_PUMP_RIGHT2_POS[0])
		cmp3 = string.format("%0d",ZIBO_FUEL_PUMP_RIGHT2_ANN[0])
		cmp4 = string.format("%0d",ZIBO_BATT_BUS[0])
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp35 ~= cmp then SI_FUEL[35] = cmp cmp35 = cmp end

		cmpunits = math.ceil(ZIBO_EFB_UNITS[0])

		-- FUEL QUANTITY
		if cmpunits == 0 then -- LBS
			cmpstr = string.format("%5d",ZIBO_LEFT_TANK_LBS[0]).." LB" if cmp40 ~= cmpstr then STR_0[0] = cmpstr cmp40 = cmpstr end
			cmpstr = string.format("%5d",ZIBO_CTR_TANK_LBS[0]).." LB" if cmp41 ~= cmpstr then STR_1[0] = cmpstr cmp41 = cmpstr end
			cmpstr = string.format("%5d",ZIBO_RIGHT_TANK_LBS[0]).." LB" if cmp42 ~= cmpstr then STR_2[0] = cmpstr cmp42 = cmpstr end
		elseif cmpunits == 1 then -- KG
			cmpstr = string.format("%5d",ZIBO_LEFT_TANK_KG[0]).." KG" if cmp40 ~= cmpstr then STR_0[0] = cmpstr cmp40 = cmpstr end
			cmpstr = string.format("%5d",ZIBO_CTR_TANK_KG[0]).." KG" if cmp41 ~= cmpstr then STR_1[0] = cmpstr cmp41 = cmpstr end
			cmpstr = string.format("%5d",ZIBO_RIGHT_TANK_KG[0]).." KG" if cmp42 ~= cmpstr then STR_2[0] = cmpstr cmp42 = cmpstr end
		end

		-- logMsg(LOG_ID .. "Fuel QTY | CMPSTR = " .. cmpstr)

	end

	-- logMsg(LOG_ID .. "LUA | PR_CALC Before EVERY FRAME")

	do_often("pr_calc_fuel()")
	-- do_every_frame("pr_calc_fuel()")

end
