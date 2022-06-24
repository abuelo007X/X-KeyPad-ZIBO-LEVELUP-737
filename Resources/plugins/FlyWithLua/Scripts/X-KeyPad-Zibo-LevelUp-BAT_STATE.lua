-- BATTERY STATE computing
-- This script is used after a BAT key click is triggered

-- enjxp	2022.06.01		-- Fix, after some weird FWL internal issues, with the help of Mark Cellis, who pointed me out to the right direction. Thanks again Mark for your good advices !
-- enjxp	2022.05.29		-- Initial Configuration

-- We put aircraft guards on all of this so that if you want to use the strings for a different plane
-- we won't have two scripts fighting over them

local LOG_ID = "FWL 4 XKP B737 VD : BAT STATE : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- Simulator datarefs

	local BAT_COVER = dataref_table("laminar/B738/cover_tgt")
	dataref("BAT_BUS_STATE","laminar/B738/electric/batbus_status")


	local BAT_STATE = 0

	function Bat_Cover_toggle()
		command_once("laminar/B738/button_switch_cover02")		-- Battery Cover toggle
	end

	function Battery_Off()
		command_once("laminar/B738/switch/battery_up")			-- Battery OFF
	end

	function Battery_On()
		command_once("laminar/B738/switch/battery_dn")			-- Battery ON
	end

	function Battery_Toggle()
		if (BAT_COVER[2] == 1) then				-- BATTERY COVER opened
			if (BAT_BUS_STATE == 0) then		-- BATTERY is OFF
				BAT_STATE = 1
			elseif (BAT_BUS_STATE == 1) then	-- BATTERY is ON
				BAT_STATE = 2
			end
		elseif (BAT_COVER[2] == 0) then			-- BATTERY COVER closed - BATTERY is ON
			BAT_STATE = 3
		end

		-- logMsg(LOG_ID .. "Command received | BAT_STATE = " .. BAT_STATE)

		if BAT_STATE == 1 then
			Battery_On()
			Bat_Cover_toggle()
		elseif BAT_STATE == 2 then
			Battery_Off()
		elseif BAT_STATE == 3 then
			Bat_Cover_toggle()
			Battery_Off()
		end
	end

	create_command("zibo/battery_toggle", "Battery TOGGLE","Battery_Toggle()","","")	-- TOGGLE

end	-- end aircraft check
