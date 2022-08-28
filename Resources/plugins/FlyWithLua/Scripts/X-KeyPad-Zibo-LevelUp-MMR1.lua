-- MMR 1 CAPT side

-- enjxp		2022.08.27 	-- Full reworking to fix Configuration and ZiboMod freezing
-- enjxp		2021.07.05 	-- MMR UNIT #1 Separation made from original single MMR lua file - INPUT XKEYPAD BUFFER INTO MMR #1

-- require("_enjxp_fwl_log2display")

if not SUPPORTS_FLOATING_WINDOWS then
    logMsg("imgui not supported by your FlyWithLua version")
    return
end

require("graphics")

local x_width = 800
local y_height = 100
local debug_string11 = "MMR 1 CAPT side LOAD"
local debug_string12 = ""
local debug_string13 = ""
local debug_string14 = ""
local debug_string15 = ""

local lastClickX2 = x_width / 2
local lastClickY2 = y_height / 2

local line_y_inc = 20

function create_window()
	debug_mmr1_wnd = float_wnd_create(x_width, y_height, 1, false)
	float_wnd_set_title(debug_mmr1_wnd, "FWL 4 XKP Debug MMR1")
	float_wnd_set_position(debug_mmr1_wnd, 20, SCREEN_HEIGHT - 120)
	float_wnd_set_ondraw(debug_mmr1_wnd, "on_draw_floating_window1")
	float_wnd_set_onclick(debug_mmr1_wnd, "on_click_floating_window1")
	float_wnd_set_onclose(debug_mmr1_wnd, "on_close_floating_window1")
end

-- create_window()

function on_draw_floating_window1(debug_mmr1_wnd, x2, y2)
    centerX2 = x2 + lastClickX2
    centerY2 = y2 + lastClickY2
    glColor3f(1,1,0)
    draw_string_Helvetica_18(x2, y2 + (line_y_inc * 4) , debug_string11)
    draw_string_Helvetica_18(x2, y2 + (line_y_inc * 3) , debug_string12)
    draw_string_Helvetica_18(x2, y2 + (line_y_inc * 2) , debug_string13)
    draw_string_Helvetica_18(x2, y2 + (line_y_inc * 1) , debug_string14)
    draw_string_Helvetica_18(x2, y2 + (line_y_inc * 0) , debug_string15)
end

function on_click_floating_window1(debug_mmr1_wnd, x2, y2)
    lastClickX2 = x2
    lastClickY2 = y2
end

function on_close_floating_window1(debug_mmr1_wnd)
end

local LOG_ID = "FWL 4 XKP B737 VD : MMR1 : "
dataref("XKEYPAD_BUFFER","SRS/X-KeyPad/numeric_buffer")

debug_string12 = LOG_ID .. "LUA | START"
logMsg(debug_string12)
-- _enjxp_fwl_log2display.show_info(debug_string12)

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	debug_string13 = LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP
	logMsg(debug_string13)
	-- _enjxp_fwl_log2display.show_info(debug_string13)

	function pr_input_mmr1()

		debug_string14 = LOG_ID .. "pr_input_mmr1 | XKEYPAD_BUFFER = " .. XKEYPAD_BUFFER
		logMsg(debug_string14)
		-- _enjxp_fwl_log2display.show_info(debug_string14)

		-- POSITION IN STRING
		POS = 1
		DIGITS_CHECK = ""
		
		while POS < 6 do
		
			DIGIT = string.sub(XKEYPAD_BUFFER, POS, POS)

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

			DIGITS_CHECK = DIGITS_CHECK..DIGIT

			POS = POS + 1

		end

		debug_string15 = LOG_ID .. "pr_input_mmr1 | FREQUENCY_CHECK = " .. DIGITS_CHECK
		logMsg(debug_string15)
		-- _enjxp_fwl_log2display.show_info(debug_string15)
		
		command_once("SRS/X-KeyPad/Keypad_Clear")

	end

	create_command("zibo/input_into_mmr1", "Input X-KeyPad Buffer into MMR1.", "pr_input_mmr1()", "", "")

end
