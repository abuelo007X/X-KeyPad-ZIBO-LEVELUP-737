-- MMR 1 CAPT side

-- enjxp		2021.07.05 	-- MMR UNIT #1 Separation made from original single MMR lua file - INPUT XKEYPAD BUFFER INTO MMR #1

local LOG_ID = "FWL 4 XKP B737 VD : MMR1 : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	function Input_MMR1()

		local XKEYPAD_BUFFER = dataref_table("SRS/X-KeyPad/numeric_buffer")

		logMsg(LOG_ID .. "Input_MMR1 | XKEYPAD_BUFFER = " .. XKEYPAD_BUFFER)

		-- POSITION IN STRING
		POS = 1
		
		while POS < 6 do
		
			DIGIT = string.sub(XKEYPAD_BUFFER[0], POS, POS)

			logMsg(LOG_ID .. "Input_MMR1 | DIGIT = " .. DIGIT)

			if DIGIT == "0" then
				command_once("laminar/B738/push_button/mmr1_0")
			elseif DIGIT == "1" then
				command_once("laminar/B738/push_button/mmr1_1")
			elseif DIGIT == "2" then
				command_once("laminar/B738/push_button/mmr1_2")
			elseif DIGIT == "3" then
				command_once("laminar/B738/push_button/mmr1_3")
			elseif DIGIT == "4" then
				command_once("laminar/B738/push_button/mmr1_4")
			elseif DIGIT == "5" then
				command_once("laminar/B738/push_button/mmr1_5")
			elseif DIGIT == "6" then
				command_once("laminar/B738/push_button/mmr1_6")
			elseif DIGIT == "7" then
				command_once("laminar/B738/push_button/mmr1_7")
			elseif DIGIT == "8" then
				command_once("laminar/B738/push_button/mmr1_8")
			elseif DIGIT == "9" then
				command_once("laminar/B738/push_button/mmr1_9")
			end

			POS = POS + 1

		end
		
		command_once("SRS/X-KeyPad/Keypad_Clear")

	end

	create_command("zibo/input_into_mmr1", 
		"Input X-KeyPad Buffer into MMR1.", 
		"Input_MMR1()",
		"",
		"")

end
