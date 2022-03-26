-- COMMANDS FOR MFD

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then
	
	-- ASSIGN DEFAULT VALUES
	ENGSYS = 1

	function switchMFD()		
		-- IF ENGSYS = 1
		if ENGSYS == 1  then
			command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
		-- IF ENGSYS = 2
		elseif ENGSYS == 2 then
			command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
		-- IF ENGSYS = 3
		elseif ENGSYS == 3 then
			command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
		end
		ENGSYS = ENGSYS + 1
		if ENGSYS == 4 then
			ENGSYS = 1
		end
	end

	-- SWITCH MFD
	create_command("zibo/switch_mfd", 
		"Switch MFD values.", 
		"switchMFD()",
		"",
		"")

end
