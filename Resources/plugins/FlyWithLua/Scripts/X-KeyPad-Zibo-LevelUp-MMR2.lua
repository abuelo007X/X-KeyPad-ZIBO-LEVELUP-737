-- MMR 2 FO side

-- enjxp		2022.08.27 	-- Full reworking to fix Configuration and ZiboMod freezing
-- enjxp		2021.07.05 	-- MMR UNIT #2 Separation made from original single MMR lua file - INPUT XKEYPAD BUFFER INTO MMR #2

-- require("_enjxp_fwl_log2display")

if not SUPPORTS_FLOATING_WINDOWS then
    logMsg("imgui not supported by your FlyWithLua version")
    return
end

require("graphics")

local x_width = 800
local y_height = 100
local debug_string21 = "MMR 2 FO side LOAD"
local debug_string22 = ""
local debug_string23 = ""
local debug_string24 = ""
local debug_string25 = ""

local lastClickX3 = x_width / 2
local lastClickY3 = y_height / 2

local line_y_inc = 20

function create_window()
	debug_mmr2_wnd = float_wnd_create(x_width, y_height, 1, false)
	float_wnd_set_title(debug_mmr2_wnd, "FWL 4 XKP Debug MMR2")
	float_wnd_set_position(debug_mmr2_wnd, 20, SCREEN_HEIGHT - 280)
	float_wnd_set_ondraw(debug_mmr2_wnd, "on_draw_floating_window2")
	float_wnd_set_onclick(debug_mmr2_wnd, "on_click_floating_window2")
	float_wnd_set_onclose(debug_mmr2_wnd, "on_close_floating_window2")
end

-- create_window()

function on_draw_floating_window2(debug_mmr2_wnd, x3, y3)
    centerX3 = x3 + lastClickX3
    centerY3 = y3 + lastClickY3
    glColor3f(1,1,0)
    draw_string_Helvetica_18(x3, y3 + (line_y_inc * 4) , debug_string21)
    draw_string_Helvetica_18(x3, y3 + (line_y_inc * 3) , debug_string22)
    draw_string_Helvetica_18(x3, y3 + (line_y_inc * 2) , debug_string23)
    draw_string_Helvetica_18(x3, y3 + (line_y_inc * 1) , debug_string24)
    draw_string_Helvetica_18(x3, y3 + (line_y_inc * 0) , debug_string25)
end

function on_click_floating_window2(debug_mmr2_wnd, x3, y3)
    lastClickX3 = x3
    lastClickY3 = y3
end

function on_close_floating_window2(debug_mmr2_wnd)
end

local LOG_ID = "FWL 4 XKP B737 VD : MMR2 : "
dataref("XKEYPAD_BUFFER","SRS/X-KeyPad/numeric_buffer")

debug_string22 = LOG_ID .. "LUA | START"
logMsg(debug_string22)
-- _enjxp_fwl_log2display.show_info(debug_string22)

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	debug_string23 = LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP
	logMsg(debug_string23)
	-- _enjxp_fwl_log2display.show_info(debug_string23)

	function pr_input_mmr2()

		debug_string24 = LOG_ID .. "pr_input_mmr2 | XKEYPAD_BUFFER = " .. XKEYPAD_BUFFER
		logMsg(debug_string24)
		-- _enjxp_fwl_log2display.show_info(debug_string24)

		-- POSITION IN STRING
		POS = 1
		DIGITS_CHECK = ""
		
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

			DIGITS_CHECK = DIGITS_CHECK..DIGIT

			POS = POS + 1

		end
		
		debug_string25 = LOG_ID .. "pr_input_mmr1 | FREQUENCY_CHECK = " .. DIGITS_CHECK
		logMsg(debug_string25)
		-- _enjxp_fwl_log2display.show_info(debug_string25)

		command_once("SRS/X-KeyPad/Keypad_Clear")

	end

	create_command("zibo/input_into_mmr2", "Input X-KeyPad Buffer into MMR2.", "pr_input_mmr2()", "", "")
 
end
