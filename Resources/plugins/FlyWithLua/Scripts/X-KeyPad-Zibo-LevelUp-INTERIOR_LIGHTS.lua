-- COMMANDS INTERIOR LIGHTS

-- enjxp		2022.08.26	-- Reworked script to fix handling of full ZiboMod and LevelUP at best
--								enhanced method for dataref updating and simplified script logic
-- enjxp		2022.06.15	-- Fixed wrong dataref issue with LevelUP
-- enjxp		2022.06.06	-- Fixed wrong function name call
-- enjxp		2022.01.26	-- Reworked the whole structure
--							-- Added Intermediate bright levels
-- enjxp		2022.01.24	-- Added DIM Lights feature
--							-- Cleaning script
-- Magicnorm	2020.09		-- Initial Configuration

local LOG_ID = "FWL 4 XKP B737 VD : INTERIOR LIGHTS : "

logMsg(LOG_ID .. "LUA | START")

local unit_zibo = 1
local unit_levelup = 2
local unit_active = 2
local PANEL_LIGHT_DRF_ZIBO = "laminar/B738/electric/generic_brightness"
local PANEL_LIGHT_DRF_LEVELUP = "sim/cockpit2/switches/generic_lights_switch"
-- local PANEL_LIGHT_DRF_LEVELUP = "sim/flightmodel2/lights/generic_lights_brightness_ratio"	-- old dataref : not able to override values

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	local PANEL_BRIGHT = dataref_table("laminar/B738/electric/panel_brightness")						-- PANEL LIGHTS

-- PLANE_DESCRIP == "Boeing 737-800X"
----------------------------------------

-- BRIGHT

-- CAPT MAIN PANEL BRIGHT			: laminar/B738/electric/panel_brightness[0]
-- FO MAIN PANEL BRIGHT				: laminar/B738/electric/panel_brightness[1]
-- OVERHEAD PANEL BRIGHT			: laminar/B738/electric/panel_brightness[2]
-- PEDESTAL PANEL BRIGHT			: laminar/B738/electric/panel_brightness[3]

-- FLOOD

-- CAPT BACKGROUND BRIGHT			: laminar/B738/electric/generic_brightness[6]
-- CAPT AFDS FLOOD					: laminar/B738/electric/generic_brightness[7]
-- PEDESTAL FLOOD BRIGHT			: laminar/B738/electric/generic_brightness[8]

-- SPECIFIC

-- CAPT CHART BRIGHT				: laminar/B738/electric/generic_brightness[10]
-- FO CHART BRIGHT					: laminar/B738/electric/generic_brightness[11]
-- OVERHEAD CIRCUIT BREAKER BRIGHT	: laminar/B738/electric/generic_brightness[12]

-- OVERHEAD DOME WHITE				: laminar/B738/lights_sw[2]  -- set using command_once

	-- local PANEL_LIGHT_ZIBO = dataref_table(PANEL_LIGHT_DRF_ZIBO)
	-- local PANEL_LIGHT_LEVELUP = dataref_table(PANEL_LIGHT_DRF_LEVELUP)

	local PANEL_LIGHT_DRF = PANEL_LIGHT_DRF_LEVELUP

	if (PLANE_DESCRIP == "Boeing 737-800X") then
		logMsg(LOG_ID .. "INIT | ZIBOMOD")
		unit_active = unit_zibo
		PANEL_LIGHT_DRF = PANEL_LIGHT_DRF_ZIBO
	else
		logMsg(LOG_ID .. "INIT | LEVELUP")
		unit_active = unit_levelup
		PANEL_LIGHT_DRF = PANEL_LIGHT_DRF_LEVELUP
	end

	-- logMsg(LOG_ID .. "LOAD | PANEL_LIGHT_DRF = " .. PANEL_LIGHT_DRF)

	-- logMsg(LOG_ID .. "INIT | Datarefs Others")

	local STR_3 = dataref_table("SRS/X-KeyPad/custom_string_3")							-- TRANSMIT SET nbr to Virtual Device
	local create_light_state = create_dataref_table("zibo/SRSlights_state", "Data")
	local light_state = dataref_table("zibo/SRSlights_state")

	-- logMsg(LOG_ID .. "INIT | Datarefs End")

	-- Setting values in two steps, don't modify this structure in two steps, only customize the values if needed

	local DARK			= 0															-- FULL DARK
	local PERC_1		= 0.1														-- ALMOST DARK
	local PERC_2		= 0.25														-- 25% BRIGHT
	local PERC_3		= 0.33														-- 33% BRIGHT
	local PERC_4		= 0.5														-- HALF BRIGHT
	local PERC_5		= 0.66														-- 66% BRIGHT
	local PERC_6		= 0.80														-- 80% BRIGHT
	local PERC_7		= 0.90														-- 90% BRIGHT
	local PERC_8		= 0.95														-- 95% BRIGHT
	local BRIGHT		= 1															-- BRIGHT

	-- WARNING !!! Don't change the structure below, just update the values above if needed

	local SET_OFF		= DARK														-- ALL OFF
	local SET_1			= PERC_1													-- ALL PERCENT0 VALUE
	local SET_2			= PERC_2													-- ALL PERCENT1 VALUE
	local SET_3			= PERC_3													-- ALL PERCENT2 VALUE
	local SET_4			= PERC_4													-- ALL PERCENT3 VALUE
	local SET_5			= PERC_5													-- ALL PERCENT4 VALUE
	local SET_6			= PERC_6													-- ALL PERCENT5 VALUE
	local SET_7			= PERC_7													-- ALL PERCENT6 VALUE
	local SET_8			= PERC_8													-- ALL PERCENT7 VALUE
	local SET_FULL_ON	= BRIGHT													-- ALL ON
	local SET_STR		= "OFF"
	local LSET_NUM		= 0
	
	local switch_set_str = {
		[0] = function() SET_STR = "OFF" end,
		[1] = function() SET_STR = "SET1" end,
		[2] = function() SET_STR = "SET2" end,
		[3] = function() SET_STR = "SET3" end,
		[4] = function() SET_STR = "SET4" end,
		[5] = function() SET_STR = "SET5" end,
		[6] = function() SET_STR = "SET6" end,
		[7] = function() SET_STR = "SET7" end,
		[8] = function() SET_STR = "SET8" end,
		[9] = function() SET_STR = "FULL" end
	}

	local switch_bright = {
		[0] = function() pr_lights_setoff() end,
		[1] = function() pr_lights_set1() end,
		[2] = function() pr_lights_set2() end,
		[3] = function() pr_lights_set3() end,
		[4] = function() pr_lights_set4() end,
		[5] = function() pr_lights_set5() end,
		[6] = function() pr_lights_set6() end,
		[7] = function() pr_lights_set7() end,
		[8] = function() pr_lights_set8() end,
		[9] = function() pr_lights_setfullon() end
	}

	local switch_set_num = {
		["OFF"]		= function() LSET_NUM = 0 end,
		["SET1"]	= function() LSET_NUM = 1 end,
		["SET2"]	= function() LSET_NUM = 2 end,
		["SET3"]	= function() LSET_NUM = 3 end,
		["SET4"]	= function() LSET_NUM = 4 end,
		["SET5"]	= function() LSET_NUM = 5 end,
		["SET6"]	= function() LSET_NUM = 6 end,
		["SET7"]	= function() LSET_NUM = 7 end,
		["SET8"]	= function() LSET_NUM = 8 end,
		["FULL"]	= function() LSET_NUM = 9 end
	}

	if STR_3[0] ~= "" then
		SET_STR = STR_3[0]
		light_state[0] = SET_STR
		local f1 = switch_set_num[SET_STR]
		if(f1) then
			f1()
		else
		end
	else
		SET_STR = "OFF"
		light_state[0] = SET_STR
	end
	local LSET_SAVE = -1

	-- logMsg(LOG_ID .. "INIT | END")

	-- DOME DIM
	function pr_lights_setdomedim()
		-- logMsg(LOG_ID .. "DOME DIM | START")
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")		-- DOME LIGHT DIM SEQUENCE 2 STEPS
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
		-- logMsg(LOG_ID .. "DOME DIM | END")
	end

	-- DOME OFF
	function pr_lights_setdomeoff()
		-- logMsg(LOG_ID .. "DOME OFF | START")
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")		-- DOME LIGHT OFF SEQUENCE 3 STEPS
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
		command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
		-- logMsg(LOG_ID .. "DOME OFF | END")
	end

	-- DOME BRIGHT
	function pr_lights_setdomebright()
		-- logMsg(LOG_ID .. "DOME BRIGHT | START")
		command_once("laminar/B738/toggle_switch/cockpit_dome_dn")		-- DOME LIGHT BRIGHT SEQUENCE 2 STEPS
		command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
		-- logMsg(LOG_ID .. "DOME BRIGHT | END")
	end

	function pr_calc_interior_lights()
		-- STR_3[0] = SET_STR
		STR_3[0] = SET_STR
		if LSET_NUM ~= LSET_SAVE then
			local f2 = switch_set_str[LSET_NUM]
			if(f2) then
				f2()
			else
			end
			STR_3[0] = SET_STR
			light_state[0] = SET_STR
		end
		LSET_SAVE = LSET_NUM
	end

	pr_calc_interior_lights()

	function pr_panels_set(param)
		-- if unit_active == unit_zibo then
		-- elseif unit_active == unit_levelup then
		-- end
		logMsg(LOG_ID .. "PNL SET | PARAM = " .. param)
		logMsg(LOG_ID .. "LOAD | PANEL_LIGHT_DRF = " .. PANEL_LIGHT_DRF)
		set_array(PANEL_LIGHT_DRF,6,param)		-- FORWARD PANEL FLOOD
		set_array(PANEL_LIGHT_DRF,7,param)		-- GLARESHIELD FLOOD
		set_array(PANEL_LIGHT_DRF,8,param)		-- PEDESTAL FLOOD
		set_array(PANEL_LIGHT_DRF,10,param)		-- CAPTAIN CHART LIGHT)
		set_array(PANEL_LIGHT_DRF,11,param)		-- FIRST OFFICER CHART LIGHT)
		set_array(PANEL_LIGHT_DRF,12,param)		-- CIRCUIT BREAKER FLOOD)
		PANEL_BRIGHT[0]		= param				-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= param				-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= param				-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= param				-- PEDESTAL PANEL BRIGTHNESS
	end

	-- OFF
	function pr_lights_setoff()
		LSET_NUM = 0

		logMsg(LOG_ID .. "SETOFF | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_OFF)
		pr_lights_setdomeoff()
		-- LIGHTS_SWITCHES[6]	= SET_OFF		-- FORWARD PANEL FLOOD
		-- LIGHTS_SWITCHES[7]	= SET_OFF		-- GLARESHIELD FLOOD
		-- LIGHTS_SWITCHES[8]	= SET_OFF		-- PEDESTAL FLOOD
	end	

	-- Set #1
	function pr_lights_set1()
		LSET_NUM = 1

		logMsg(LOG_ID .. "SET1 | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_1)
		pr_lights_setdomeoff()
	end	

	-- Set #2
	function pr_lights_set2()
		LSET_NUM = 2

		logMsg(LOG_ID .. "SET2 | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_2)
		pr_lights_setdomeoff()
	end	

	-- Set #3
	function pr_lights_set3()
		LSET_NUM = 3

		logMsg(LOG_ID .. "SET3 | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_3)
		pr_lights_setdomedim()
	end	

	-- Set #4
	function pr_lights_set4()
		LSET_NUM = 4

		logMsg(LOG_ID .. "SET4 | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_4)
		pr_lights_setdomedim()
	end	

	-- Set #5
	function pr_lights_set5()
		LSET_NUM = 5

		logMsg(LOG_ID .. "SET5 | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_5)
		pr_lights_setdomebright()
	end	

	-- Set #6
	function pr_lights_set6()
		LSET_NUM = 6

		logMsg(LOG_ID .. "SET6 | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_6)
		pr_lights_setdomebright()
	end	

	-- Set #7
	function pr_lights_set7()
		LSET_NUM = 7

		logMsg(LOG_ID .. "SET7 | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_7)
		pr_lights_setdomebright()
	end	

	-- Set #8
	function pr_lights_set8()
		LSET_NUM = 8

		logMsg(LOG_ID .. "SET8 | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_8)
		pr_lights_setdomebright()
	end	

	-- FULLON
	function pr_lights_setfullon()
		LSET_NUM = 9

		logMsg(LOG_ID .. "SETFULLON | LSET_NUM = " .. LSET_NUM)

		pr_calc_interior_lights()
		pr_panels_set(SET_FULL_ON)
		pr_lights_setdomebright()
	end

	-- Set Light
	function pr_lights_set()
		local f3 = switch_bright[LSET_NUM]
		if(f3) then
			f3()
		else
		end
	end

	-- Decrease Light
	function pr_lights_decrease()
		LSET_NUM = LSET_NUM - 1
		if LSET_NUM < 0 then
			LSET_NUM = 0
		end

		logMsg(LOG_ID .. "DEC | LSET_NUM = " .. LSET_NUM)

		pr_lights_set()
	end

	-- Increase Light
	function pr_lights_increase()
		LSET_NUM = LSET_NUM + 1
		if LSET_NUM > 9 then
			LSET_NUM = 9
		end

		logMsg(LOG_ID .. "INC | LSET_NUM = " .. LSET_NUM)

		pr_lights_set()
	end

	-- logMsg(LOG_ID .. "INIT | Commands Start")

	create_command("zibo/int_bright_off",	"L1 - cockpit lights ALL OFF","pr_lights_setoff()","","")		-- OFF
	create_command("zibo/int_bright_Set1",	"L2 - cockpit lights ALL Set1","pr_lights_set1()","","")	-- Set1
	create_command("zibo/int_bright_Set2",	"L3 - cockpit lights ALL Set2","pr_lights_set2()","","")	-- Set2
	create_command("zibo/int_bright_Set3",	"L4 - cockpit lights ALL Set3","pr_lights_set3()","","")	-- Set3
	create_command("zibo/int_bright_Set4",	"L5 - cockpit lights ALL Set4","pr_lights_set4()","","")	-- Set4
	create_command("zibo/int_bright_Set5",	"L6 - cockpit lights ALL Set5","pr_lights_set5()","","")	-- Set5
	create_command("zibo/int_bright_Set6",	"L7 - cockpit lights ALL Set6","pr_lights_set6()","","")	-- Set6
	create_command("zibo/int_bright_Set7",	"L8 - cockpit lights ALL Set7","pr_lights_set7()","","")	-- Set7
	create_command("zibo/int_bright_Set8",	"L9 - cockpit lights ALL Set8","pr_lights_set8()","","")	-- Set8
	create_command("zibo/int_bright_on",	"LA - cockpit lights ALL ON","pr_lights_setfullon()","","")	-- FULL ON

	create_command("zibo/int_bright_dec",	"L_dec - cockpit lights Decrease","pr_lights_decrease()","","")	-- Decrease Light
	create_command("zibo/int_bright_inc",	"L_inc - cockpit lights Increase","pr_lights_increase()","","")	-- Increase Light

	pr_lights_set()

	-- logMsg(LOG_ID .. "INIT | Commands End")

	-- do_often("pr_calc_interior_lights()")

end
