-- IRS

-- enjxp		2022.06.07	-- Initial Configuration

local LOG_ID = "FWL 4 XKP B737 VD : IRS : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- X-KeyPad Custom Strings
	local STR_9					= dataref_table("SRS/X-KeyPad/custom_string_9")					-- For the IRS
	local CONFIG_LOAD_COUNTER	= dataref_table("SRS/X-KeyPad/ConfigLoadCounter")				-- New configuration has been loaded

	-- Simulator datarefs
	local IRS_DISP_SEL			= dataref_table("laminar/B738/toggle_switch/irs_dspl_sel")		-- IRS DISPLAY SELECTOR MODE
	local IRS_POS				= dataref_table("laminar/B738/irs/irs2_pos")					-- IRS POS

	local IRS_LEFT_1			= dataref_table("laminar/B738/irs_left1")						-- LEFT IRS display segment #1
	local IRS_LEFT_2			= dataref_table("laminar/B738/irs_left2")						-- LEFT IRS display segment #2
	local IRS_RIGHT_1			= dataref_table("laminar/B738/irs_right1")						-- RIGHT IRS display segment #1
	local IRS_RIGHT_2			= dataref_table("laminar/B738/irs_right2")						-- RIGHT IRS display segment #2

	local IRS_LEFT_1_SHOW		= dataref_table("laminar/B738/irs_left1_show")					-- LEFT IRS display segment #1
	local IRS_LEFT_2_SHOW		= dataref_table("laminar/B738/irs_left2_show")					-- LEFT IRS display segment #2
	local IRS_RIGHT_1_SHOW		= dataref_table("laminar/B738/irs_right1_show")					-- RIGHT IRS display segment #1
	local IRS_RIGHT_2_SHOW		= dataref_table("laminar/B738/irs_right2_show")					-- RIGHT IRS display segment #2

	STR_9[0] = "             "
	F_IRS = ""
	STR_IRS_LAST = "-1"

	-- Keep track of the previous contents of the datarefs so we only update the strings if they change.
	local last_config_load_counter = -1

	function RefreshString()
		STR_IRS_LAST = -1
		STR_9[0] = "             "
	end

	function UpdateString()	-- Update custom strings if necessary
		-- Refresh if a new configuration has been loaded since they get cleared on reload by X-KeyPad
		STR_9[0] = F_IRS
		if(last_config_load_counter ~= CONFIG_LOAD_COUNTER[0]) then
			RefreshString()
			last_config_load_counter = CONFIG_LOAD_COUNTER[0]
		end
	end

	function pr_calc_irs()
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
