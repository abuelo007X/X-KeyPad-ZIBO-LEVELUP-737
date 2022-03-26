-- COMMANDS FOR CAPT DU

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then
	
	-- DU VALUE
	dataref("DU_VALUE","laminar/B738/toggle_switch/main_pnl_du_capt","readonly")

	-- DU
	function toggleDU()
		-- MAIN DU
		if DU_VALUE == 0 then
			command_once("laminar/B738/toggle_switch/main_pnl_du_capt_right")
			command_once("laminar/B738/toggle_switch/main_pnl_du_capt_right")
			command_once("laminar/B738/toggle_switch/main_pnl_du_capt_right")
		-- LOWER DU
		elseif DU_VALUE == 3 then
			command_once("laminar/B738/toggle_switch/main_pnl_du_capt_left")
			command_once("laminar/B738/toggle_switch/main_pnl_du_capt_left")
			command_once("laminar/B738/toggle_switch/main_pnl_du_capt_left")
		end
	end
	
	-- TOGGLE DU
	create_command("zibo/toggle_capt_du", 
		"Toggle DU between main and lower.", 
		"toggleDU()",
		"",
		"")

end