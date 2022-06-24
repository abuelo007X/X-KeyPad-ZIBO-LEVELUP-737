-- COMMANDS INTERIOR LIGHTS

-- enjxp		2022.06.06	-- Fixed wrong function name call
-- enjxp		2022.01.26	-- Reworked the whole structure
--							-- Added Intermediate bright levels
-- enjxp		2022.01.24	-- Added DIM Lights feature
--							-- Cleaning script
-- Magicnorm	2020.09		-- Initial Configuration

local LOG_ID = "FWL 4 XKP B737 VD : INTERIOR LIGHTS : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	local PANEL_BRIGHT = dataref_table("laminar/B738/electric/panel_brightness")		-- PANEL LIGHTS
	local GENERIC_LIGHT = dataref_table("laminar/B738/electric/generic_brightness")		-- GENERIC LIGHTS
	local GENERIC_BRIGHT = dataref_table("laminar/B738/lights_sw")	-- GENERIC BRIGHT
	-- local GENERIC_BRIGHT = dataref_table("sim/cockpit2/switches/generic_lights_switch")	-- GENERIC BRIGHT
	local STR_3 = dataref_table("SRS/X-KeyPad/custom_string_3")							-- TRANSMIT SET nbr to Virtual Device
	local create_light_state = create_dataref_table("zibo/SRSlights_state", "Data")
	local light_state = dataref_table("zibo/SRSlights_state")

	-- Setting values in two steps, don't modify this structure in two steps, only customize the values if needed

	local DARK			= 0															-- FULL DARK
	local PERC_0		= 0.1														-- ALMOST DARK
	local PERC_1		= 0.25														-- 25% BRIGHT
	local PERC_2		= 0.33														-- 33% BRIGHT
	local PERC_3		= 0.5														-- HALF BRIGHT
	local PERC_4		= 0.66														-- 66% BRIGHT
	local PERC_5		= 0.80														-- 80% BRIGHT
	local PERC_6		= 0.90														-- 90% BRIGHT
	local PERC_7		= 0.95														-- 95% BRIGHT
	local BRIGHT		= 1															-- BRIGHT

	-- WARNING !!! Don't change the structure below, just update the values above if needed

	local SET_OFF		= DARK														-- ALL OFF
	local SET_0			= PERC_0													-- ALL PERCENT0 VALUE
	local SET_1			= PERC_1													-- ALL PERCENT1 VALUE
	local SET_2			= PERC_2													-- ALL PERCENT2 VALUE
	local SET_3			= PERC_3													-- ALL PERCENT3 VALUE
	local SET_4			= PERC_4													-- ALL PERCENT4 VALUE
	local SET_5			= PERC_5													-- ALL PERCENT5 VALUE
	local SET_6			= PERC_6													-- ALL PERCENT6 VALUE
	local SET_7			= PERC_7													-- ALL PERCENT7 VALUE
	local SET_FULL_ON	= BRIGHT													-- ALL ON
	local SET_STR		= "OFF"
	local LSET_NUM		= 0
	if STR_3[0] ~= "" then
		SET_STR = STR_3[0]
		light_state[0] = SET_STR
	else
		SET_STR = "OFF"
		light_state[0] = SET_STR
	end
	local LSET_SAVE = 0
	-- STR_3[0] = "OFF"
	STR_3[0] = SET_STR

	-- DOME DIM
	function Dome_Dim()
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")		-- DOME LIGHT DIM SEQUENCE 2 STEPS
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
	end

	-- DOME OFF
	function Dome_Off()
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")		-- DOME LIGHT OFF SEQUENCE 3 STEPS
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
		command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
	end

	-- DOME BRIGHT
	function Dome_Bright()
		command_once("laminar/B738/toggle_switch/cockpit_dome_dn")		-- DOME LIGHT BRIGHT SEQUENCE 2 STEPS
		command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
	end

	local switch_set_str = {
		[0] = function() SET_STR = "OFF" end,
		[1] = function() SET_STR = "SET0" end,
		[2] = function() SET_STR = "SET1" end,
		[3] = function() SET_STR = "SET2" end,
		[4] = function() SET_STR = "SET3" end,
		[5] = function() SET_STR = "SET4" end,
		[6] = function() SET_STR = "SET5" end,
		[7] = function() SET_STR = "SET6" end,
		[8] = function() SET_STR = "SET7" end,
		[9] = function() SET_STR = "FULL" end
	}

	function pr_calc_interior_lights()
		-- STR_3[0] = SET_STR
		STR_3[0] = SET_STR
		if LSET_NUM ~= LSET_SAVE then
			local f = switch_set_str[LSET_NUM]
			if(f) then
				f()
			else
			end
			STR_3[0] = SET_STR
			light_state[0] = SET_STR
		end
		LSET_SAVE = LSET_NUM
	end

	-- OFF
	function Lights_Off()
		LSET_NUM = 0
		pr_calc_interior_lights()
		Dome_Off()
		PANEL_BRIGHT[0]		= SET_OFF		-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_OFF		-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_OFF		-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_OFF		-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_OFF		-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_OFF		-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_OFF		-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_OFF		-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_OFF		-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_OFF		-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_OFF		-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_OFF		-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_OFF		-- CIRCUIT BREAKER FLOOD
	end	

	-- DIM
	function Lights_Set0()
		LSET_NUM = 1
		pr_calc_interior_lights()
		Dome_Off()
		PANEL_BRIGHT[0]		= SET_0			-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_0			-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_0			-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_0			-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_0			-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_0			-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_0			-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_0			-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_0			-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_0			-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_0			-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_0			-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_0			-- CIRCUIT BREAKER FLOOD
	end	

	-- Set #1
	function Lights_Set1()
		LSET_NUM = 2
		pr_calc_interior_lights()
		Dome_Off()
		PANEL_BRIGHT[0]		= SET_1			-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_1			-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_1			-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_1			-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_1			-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_1			-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_1			-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_1			-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_1			-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_1			-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_1			-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_1			-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_1			-- CIRCUIT BREAKER FLOOD
	end	

	-- Set #2
	function Lights_Set2()
		LSET_NUM = 3
		pr_calc_interior_lights()
		Dome_Dim()
		PANEL_BRIGHT[0]		= SET_2			-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_2			-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_2			-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_2			-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_2			-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_2			-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_2			-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_2			-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_2			-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_2			-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_2			-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_2			-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_2			-- CIRCUIT BREAKER FLOOD
	end	

	-- Set #3
	function Lights_Set3()
		LSET_NUM = 4
		pr_calc_interior_lights()
		Dome_Dim()
		PANEL_BRIGHT[0]		= SET_3			-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_3			-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_3			-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_3			-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_3			-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_3			-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_3			-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_3			-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_3			-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_3			-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_3			-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_3			-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_3			-- CIRCUIT BREAKER FLOOD
	end	

	-- Set #4
	function Lights_Set4()
		LSET_NUM = 5
		pr_calc_interior_lights()
		Dome_Bright()
		PANEL_BRIGHT[0]		= SET_4			-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_4			-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_4			-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_4			-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_4			-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_4			-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_4			-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_4			-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_4			-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_4			-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_4			-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_4			-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_4			-- CIRCUIT BREAKER FLOOD
	end	

	-- Set #5
	function Lights_Set5()
		LSET_NUM = 6
		pr_calc_interior_lights()
		Dome_Bright()
		PANEL_BRIGHT[0]		= SET_5			-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_5			-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_5			-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_5			-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_5			-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_5			-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_5			-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_5			-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_5			-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_5			-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_5			-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_5			-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_5			-- CIRCUIT BREAKER FLOOD
	end	

	-- Set #6
	function Lights_Set6()
		LSET_NUM = 7
		pr_calc_interior_lights()
		Dome_Bright()
		PANEL_BRIGHT[0]		= SET_6			-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_6			-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_6			-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_6			-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_6			-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_6			-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_6			-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_6			-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_6			-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_6			-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_6			-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_6			-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_6			-- CIRCUIT BREAKER FLOOD
	end	

	-- Set #7
	function Lights_Set7()
		LSET_NUM = 8
		pr_calc_interior_lights()
		Dome_Bright()
		PANEL_BRIGHT[0]		= SET_7			-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_7			-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_7			-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_7			-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_7			-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_7			-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_7			-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_7			-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_7			-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_7			-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_7			-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_7			-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_7			-- CIRCUIT BREAKER FLOOD
	end	

	-- FULLON
	function Lights_FullOn()

	logMsg(LOG_ID .. "DEC | LSET_NUM = " .. LSET_NUM)

		LSET_NUM = 9
		pr_calc_interior_lights()
		Dome_Bright()
		PANEL_BRIGHT[0]		= SET_FULL_ON	-- CAPTAIN MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[1]		= SET_FULL_ON	-- FIRST OFFICER MAIN PANEL BRIGTHNESS
		PANEL_BRIGHT[2]		= SET_FULL_ON	-- OVERHEAD PANEL BRIGTHNESS
		PANEL_BRIGHT[3]		= SET_FULL_ON	-- PEDESTAL PANEL BRIGTHNESS
		GENERIC_LIGHT[6]	= SET_FULL_ON	-- FORWARD PANEL FLOOD
		GENERIC_LIGHT[7]	= SET_FULL_ON	-- GLARESHIELD FLOOD
		GENERIC_LIGHT[8]	= SET_FULL_ON	-- PEDESTAL FLOOD
		GENERIC_BRIGHT[6]	= SET_FULL_ON	-- FORWARD PANEL FLOOD
		GENERIC_BRIGHT[7]	= SET_FULL_ON	-- GLARESHIELD FLOOD
		GENERIC_BRIGHT[8]	= SET_FULL_ON	-- PEDESTAL FLOOD
		GENERIC_LIGHT[10]	= SET_FULL_ON	-- CAPTAIN CHART LIGHT
		GENERIC_LIGHT[11]	= SET_FULL_ON	-- FIRST OFFICER CHART LIGHT
		GENERIC_LIGHT[12]	= SET_FULL_ON	-- CIRCUIT BREAKER FLOOD
	end

	local switch_bright = {
		[0] = function() Lights_Off() end,
		[1] = function() Lights_Set0() end,
		[2] = function() Lights_Set1() end,
		[3] = function() Lights_Set2() end,
		[4] = function() Lights_Set3() end,
		[5] = function() Lights_Set4() end,
		[6] = function() Lights_Set5() end,
		[7] = function() Lights_Set6() end,
		[8] = function() Lights_Set7() end,
		[9] = function() Lights_FullOn() end
	}

	-- Set Light
	function Lights_Set()
		local f = switch_bright[LSET_NUM]
		if(f) then
			f()
		else
		end
	end

	-- Decrease Light
	function Lights_Decrease()
		LSET_NUM = LSET_NUM - 1
		if LSET_NUM < 0 then
			LSET_NUM = 0
		end

	logMsg(LOG_ID .. "DEC | LSET_NUM = " .. LSET_NUM)

		Lights_Set()
	end

	-- Increase Light
	function Lights_Increase()
		LSET_NUM = LSET_NUM + 1
		if LSET_NUM > 9 then
			LSET_NUM = 9
		end

	logMsg(LOG_ID .. "INC | LSET_NUM = " .. LSET_NUM)

		Lights_Set()
	end

	create_command("zibo/int_bright_off",	"L1 - Interior lights ALL OFF","Lights_Off()","","")	-- OFF
	create_command("zibo/int_bright_Set0",	"L2 - Interior lights ALL Set0","Lights_Set0()","","")	-- Set0
	create_command("zibo/int_bright_Set1",	"L3 - Interior lights ALL Set1","Lights_Set1()","","")	-- Set1
	create_command("zibo/int_bright_Set2",	"L4 - Interior lights ALL Set2","Lights_Set2()","","")	-- Set2
	create_command("zibo/int_bright_Set3",	"L5 - Interior lights ALL Set3","Lights_Set3()","","")	-- Set3
	create_command("zibo/int_bright_Set4",	"L6 - Interior lights ALL Set4","Lights_Set4()","","")	-- Set4
	create_command("zibo/int_bright_Set5",	"L7 - Interior lights ALL Set5","Lights_Set5()","","")	-- Set5
	create_command("zibo/int_bright_Set6",	"L8 - Interior lights ALL Set6","Lights_Set6()","","")	-- Set6
	create_command("zibo/int_bright_Set7",	"L9 - Interior lights ALL Set7","Lights_Set7()","","")	-- Set7
	create_command("zibo/int_bright_on",	"LA - Interior lights ALL ON","Lights_FullOn()","","")	-- FULL ON

	create_command("zibo/int_bright_dec",	"L_dec - Interior lights Decrease","Lights_Decrease()","","")	-- Decrease Light
	create_command("zibo/int_bright_inc",	"L_inc - Interior lights Increase","Lights_Increase()","","")	-- Increase Light

	do_every_frame("pr_calc_interior_lights()")

end
