-- MMR 2 FO side
-- enjxp 	MMR UNIT #2 Separation made from original single MMR lua file - INPUT XKEYPAD BUFFER INTO MMR #2

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	function Input_MMR2()

		dataref("XKEYPAD_BUFFER","SRS/X-KeyPad/numeric_buffer","readonly")

		-- POSITION IN STRING
		POS = 1
		
		while POS < 6 do
		
			DIGIT = string.sub(XKEYPAD_BUFFER, POS, POS)

			if DIGIT == "0" then
				command_once("laminar/B738/push_button/mmr2_0")
			elseif DIGIT == "1" then
				command_once("laminar/B738/push_button/mmr2_1")
			elseif DIGIT == "2" then
				command_once("laminar/B738/push_button/mmr2_2")
			elseif DIGIT == "3" then
				command_once("laminar/B738/push_button/mmr2_3")
			elseif DIGIT == "4" then
				command_once("laminar/B738/push_button/mmr2_4")
			elseif DIGIT == "5" then
				command_once("laminar/B738/push_button/mmr2_5")
			elseif DIGIT == "6" then
				command_once("laminar/B738/push_button/mmr2_6")
			elseif DIGIT == "7" then
				command_once("laminar/B738/push_button/mmr2_7")
			elseif DIGIT == "8" then
				command_once("laminar/B738/push_button/mmr2_8")
			elseif DIGIT == "9" then
				command_once("laminar/B738/push_button/mmr2_9")
			end

			POS = POS + 1

		end
		
		command_once("SRS/X-KeyPad/Keypad_Clear")

	end

	create_command("zibo/input_into_mmr2", 
		"Input X-KeyPad Buffer into MMR2.", 
		"Input_MMR2()",
		"",
		"")
 
end