-- IRS

-- enjxp		2022.06.15	-- Added IRS SET POS autoset
-- enjxp		2022.06.07	-- Initial Configuration

local LOG_ID = "FWL 4 XKP B737 VD : IRS : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- X-KeyPad Custom Strings
	local STR_9					= dataref_table("SRS/X-KeyPad/custom_string_9")					-- For the IRS
	local CONFIG_LOAD_COUNTER	= dataref_table("SRS/X-KeyPad/ConfigLoadCounter")				-- New configuration has been loaded

	-- Simulator datarefs
	local IRS_MODE				= dataref_table("laminar/B738/irs/irs_mode")					-- IRS CURRENT MODE
	local IRS_DISP_SEL			= dataref_table("laminar/B738/toggle_switch/irs_dspl_sel")		-- IRS DISPLAY SELECTOR MODE
	local IRS_POS				= dataref_table("laminar/B738/irs/irs2_pos")					-- IRS POS
	local IRS_L_REM				= dataref_table("laminar/B738/irs/alignment_left_remain")		-- IRS LEFT REMAIN

	local IRS_LEFT_1			= dataref_table("laminar/B738/irs_left1")						-- LEFT IRS display segment #1
	local IRS_LEFT_2			= dataref_table("laminar/B738/irs_left2")						-- LEFT IRS display segment #2
	local IRS_RIGHT_1			= dataref_table("laminar/B738/irs_right1")						-- RIGHT IRS display segment #1
	local IRS_RIGHT_2			= dataref_table("laminar/B738/irs_right2")						-- RIGHT IRS display segment #2

	local IRS_LEFT_1_SHOW		= dataref_table("laminar/B738/irs_left1_show")					-- LEFT IRS display segment #1
	local IRS_LEFT_2_SHOW		= dataref_table("laminar/B738/irs_left2_show")					-- LEFT IRS display segment #2
	local IRS_RIGHT_1_SHOW		= dataref_table("laminar/B738/irs_right1_show")					-- RIGHT IRS display segment #1
	local IRS_RIGHT_2_SHOW		= dataref_table("laminar/B738/irs_right2_show")					-- RIGHT IRS display segment #2

	STR_9[0]				= "             "
	F_IRS					= ""
	STR_IRS_LAST			= "-1"
	local fmc_refresh		= false
	local irs_set_pos		= false
	local start_irs_set_pos	= 0
	local delay				= 0.3	-- 0.07 = 70msecs / 0.1 = 100msecs / 0.5 = 5000msecs / 1 = 1sec
	local press_1_ok		= false
	local press_2_ok		= false
	local press_3_ok		= false
	local press_4_ok		= false
	local press_5_ok		= false
	local press_6_ok		= false
	local press_7_ok		= false

	-- Keep track of the previous contents of the datarefs so we only update the strings if they change.
	local last_config_load_counter = -1

	function RefreshString()
		STR_IRS_LAST = -1
		STR_9[0] = "             "
		if IRS_MODE[0] == 0  then
			fmc_refresh = false
		end
	end

	-- function sleep(gap)
		-- local dlay = tonumber(os.clock() + gap);

		-- logMsg(LOG_ID .. "Sleep | dlay = " .. dlay)

		-- while (os.clock() < dlay) do
		-- end
	-- end

	function press_1() command_once("laminar/B738/button/fmc1_menu") end
	function press_2() command_once("laminar/B738/button/fmc1_1L") end
	function press_3() command_once("laminar/B738/button/fmc1_6R") end
	function press_4() command_once("laminar/B738/button/fmc1_next_page") end
	function press_5() command_once("laminar/B738/button/fmc1_4L") end
	function press_6() command_once("laminar/B738/button/fmc1_prev_page") end
	function press_7() command_once("laminar/B738/button/fmc1_4R") end

	function pr_irs_set_pos()
		curr_time = tonumber(os.clock())
		
		if curr_time < (start_irs_set_pos + delay) and press_1_ok == false then
			press_1() press_1_ok = true
			-- logMsg(LOG_ID .. "IRS SET POS | Press1 = " .. curr_time)
		elseif curr_time > (start_irs_set_pos + delay) and curr_time < (start_irs_set_pos + (delay * 2)) and press_2_ok == false then
            press_2() press_2_ok = true
			-- logMsg(LOG_ID .. "IRS SET POS | Press2 = " .. curr_time)
		elseif curr_time > (start_irs_set_pos + (delay * 2)) and curr_time < (start_irs_set_pos + (delay * 3)) and press_3_ok == false then
            press_3() press_3_ok = true
			-- logMsg(LOG_ID .. "IRS SET POS | Press3 = " .. curr_time)
		elseif curr_time > (start_irs_set_pos + (delay * 3)) and curr_time < (start_irs_set_pos + (delay * 4)) and press_4_ok == false then
            press_4() press_4_ok = true
			-- logMsg(LOG_ID .. "IRS SET POS | Press4 = " .. curr_time)
		elseif curr_time > (start_irs_set_pos + (delay * 4)) and curr_time < (start_irs_set_pos + (delay * 5)) and press_5_ok == false then
            press_5() press_5_ok = true
			-- logMsg(LOG_ID .. "IRS SET POS | Press5 = " .. curr_time)
		elseif curr_time > (start_irs_set_pos + (delay * 5)) and curr_time < (start_irs_set_pos + (delay * 6)) and press_6_ok == false then
            press_6() press_6_ok = true
			-- logMsg(LOG_ID .. "IRS SET POS | Press6 = " .. curr_time)
		elseif curr_time > (start_irs_set_pos + (delay * 6)) and curr_time < (start_irs_set_pos + (delay * 7)) and press_7_ok == false then
            press_7() press_7_ok = true
			irs_set_pos = false
			-- logMsg(LOG_ID .. "IRS SET POS | Press7 = " .. curr_time)
		end
	end

	function UpdateString()	-- Update custom strings if necessary
		-- Refresh if a new configuration has been loaded since they get cleared on reload by X-KeyPad
		STR_9[0] = F_IRS
		if IRS_MODE[0] == 1 and IRS_L_REM[0] == 0 and fmc_refresh == false then
			fmc_refresh = true
			irs_set_pos = true
			press_1_ok	= false
			press_2_ok	= false
			press_3_ok	= false
			press_4_ok	= false
			press_5_ok	= false
			press_6_ok	= false
			press_7_ok	= false
			start_irs_set_pos = tonumber(os.clock())
			
			-- logMsg(LOG_ID .. "UpdateString | delay = " .. delay)

		end
		
		if(last_config_load_counter ~= CONFIG_LOAD_COUNTER[0]) then
			RefreshString()
			last_config_load_counter = CONFIG_LOAD_COUNTER[0]
		end
	end

	function pr_calc_irs()
		if irs_set_pos == true then
			pr_irs_set_pos()
		end
		
		SEP = " "
		if IRS_LEFT_1_SHOW[0] == 1 then
			L1 = string.format("%03d",IRS_LEFT_1[0])
		else
			L1 = "   "
		end
		if IRS_RIGHT_1_SHOW[0] == 1 then
			R1 = string.format("%03d",IRS_RIGHT_1[0])
			SEP = "8"
		else
			R1 = "   "
		end
		if IRS_LEFT_2_SHOW[0] == 1 then
			L2 = string.format("%03d",IRS_LEFT_2[0])
		else
			L2 = "   "
		end
		if IRS_RIGHT_2_SHOW[0] == 1 then
			R2 = string.format("%03d",IRS_RIGHT_2[0])
		else
			R2 = "   "
		end

		F_IRS = L1..L2..SEP..R1..R2

		if (IRS_DISP_SEL[0] == 0) then
		elseif (IRS_DISP_SEL[0] == 1) then
		elseif (IRS_DISP_SEL[0] == 2) then
			s = IRS_POS[0]
			F_IRS = s:sub(1,5)..s:sub(7,13)..s:sub(15,15)
		elseif (IRS_DISP_SEL[0] == 3) then
		elseif (IRS_DISP_SEL[0] == 4) then
		end

		-- If value changed since last input
		if (STR_IRS_LAST ~= F_IRS) then
			-- Place New Input Value in Last Input Value
			STR_IRS_LAST = F_IRS
		end
		UpdateString()
	end

	do_every_frame("pr_calc_irs()")

end
