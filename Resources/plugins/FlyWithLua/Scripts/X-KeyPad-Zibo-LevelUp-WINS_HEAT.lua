-- WINS HEAT

-- Abuelo007X	2022.02.05	-- Ability to show the current Windows state based on the annunciators states

local LOG_ID = "FWL 4 XKP B737 VD : WINS HEAT : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- X-KeyPad Custom Strings or Values
	local SI_WINHEAT = dataref_table("SRS/X-KeyPad/SharedInt")
    	
	-- Simulator datarefs

	local ZIBO_WIN_HEAT_SIDEL_POS		= dataref_table("laminar/B738/ice/window_heat_l_side_pos")				-- 1 ON, 0 OFF
	local ZIBO_WIN_HEAT_FWDL_POS		= dataref_table("laminar/B738/ice/window_heat_l_fwd_pos")				-- 1 ON, 0 OFF
	local ZIBO_WIN_HEAT_FWDR_POS		= dataref_table("laminar/B738/ice/window_heat_r_fwd_pos")				-- 1 ON, 0 OFF
	local ZIBO_WIN_HEAT_SIDER_POS		= dataref_table("laminar/B738/ice/window_heat_r_side_pos")				-- 1 ON, 0 OFF

	local ZIBO_WIN_HEAT_SIDEL_ANN		= dataref_table("laminar/B738/annunciator/window_heat_l_side")			-- 1 ON, 0 OFF
	local ZIBO_WIN_HEAT_FWDL_ANN		= dataref_table("laminar/B738/annunciator/window_heat_l_fwd")			-- 1 ON, 0 OFF
	local ZIBO_WIN_HEAT_FWDR_ANN		= dataref_table("laminar/B738/annunciator/window_heat_r_fwd")			-- 1 ON, 0 OFF
	local ZIBO_WIN_HEAT_SIDER_ANN		= dataref_table("laminar/B738/annunciator/window_heat_r_side")			-- 1 ON, 0 OFF

	local ZIBO_WIN_HEAT_SIDEL_OVHT_ANN	= dataref_table("laminar/B738/annunciator/window_heat_ovht_ls")			-- 1 ON, 0 OFF
	local ZIBO_WIN_HEAT_FWDL_OVHT_ANN	= dataref_table("laminar/B738/annunciator/window_heat_ovht_lf")			-- 1 ON, 0 OFF
	local ZIBO_WIN_HEAT_FWDR_OVHT_ANN	= dataref_table("laminar/B738/annunciator/window_heat_ovht_rf")			-- 1 ON, 0 OFF
	local ZIBO_WIN_HEAT_SIDER_OVHT_ANN	= dataref_table("laminar/B738/annunciator/window_heat_ovht_rs")			-- 1 ON, 0 OFF

	local ZIBO_BATT_BUS					= dataref_table("laminar/B738/electric/dir_batbus_status")				-- 1 ON, 0 OFF

	local SRS_CL = dataref_table("SRS/X-KeyPad/ConfigLoadCounter")												-- This will be to tell us when a new configuration has been loaded

	local cmp = 0
	local cmp1 = "0"
	local cmp2 = "0"
	local cmp3 = "0"
	local cmp20 = -1
	local cmp21 = -1
	local cmp22 = -1
	local cmp23 = -1

	SI_WINHEAT[20] = 0		-- Key 85
	SI_WINHEAT[21] = 0		-- Key 94
	SI_WINHEAT[22] = 0		-- Key 103
	SI_WINHEAT[23] = 0		-- Key 112
	SRS_CL_SAVE = -1

	function fullrefresh()
		cmp20 = -1
		cmp21 = -1
		cmp22 = -1
		cmp23 = -1
	end

	function pr_calc()

		-- logMsg(LOG_ID .. "LUA | PR_CALC")

		if(SRS_CL_SAVE ~= SRS_CL[0]) then
			fullrefresh()
			SRS_CL_SAVE = SRS_CL[0]
		end			

		-- WIN_HEAT_SIDEL
		-- Read binary value 0 or 1
		cmp1 = string.format("%0d",ZIBO_WIN_HEAT_SIDEL_POS[0])
		cmp2 = string.format("%0d",ZIBO_WIN_HEAT_SIDEL_ANN[0])
		cmp3 = string.format("%0d",ZIBO_WIN_HEAT_SIDEL_OVHT_ANN[0])
		-- Concatenate the 3 binaries then convert to decimal and compare to last save value. If different store new value to Sharedint then backup new value to last save
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp20 ~= cmp then SI_WINHEAT[20] = cmp cmp20 = cmp end

		-- logMsg(LOG_ID .. "CALC | WIN_HEAT_SIDEL = " .. cmp)

 		-- WIN_HEAT_FWDL
		cmp1 = string.format("%0d",ZIBO_WIN_HEAT_FWDL_POS[0])
		cmp2 = string.format("%0d",ZIBO_WIN_HEAT_FWDL_ANN[0])
		cmp3 = string.format("%0d",ZIBO_WIN_HEAT_FWDL_OVHT_ANN[0])
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp21 ~= cmp then SI_WINHEAT[21] = cmp cmp21 = cmp end

		-- logMsg(LOG_ID .. "CALC | WIN_HEAT_FWDL = " .. cmp)

		-- WIN_HEAT_FWDR
		cmp1 = string.format("%0d",ZIBO_WIN_HEAT_FWDR_POS[0])
		cmp2 = string.format("%0d",ZIBO_WIN_HEAT_FWDR_ANN[0])
		cmp3 = string.format("%0d",ZIBO_WIN_HEAT_FWDR_OVHT_ANN[0])
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp22 ~= cmp then SI_WINHEAT[22] = cmp cmp22 = cmp end

		-- logMsg(LOG_ID .. "CALC | WIN_HEAT_FWDR = " .. cmp)

		-- WIN_HEAT_SIDER
		cmp1 = string.format("%0d",ZIBO_WIN_HEAT_SIDER_POS[0])
		cmp2 = string.format("%0d",ZIBO_WIN_HEAT_SIDER_ANN[0])
		cmp3 = string.format("%0d",ZIBO_WIN_HEAT_SIDER_OVHT_ANN[0])
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp23 ~= cmp then SI_WINHEAT[23] = cmp cmp23 = cmp end

		-- logMsg(LOG_ID .. "CALC | WIN_HEAT_SIDER = " .. cmp)

	end

	do_often ("pr_calc()")
	-- do_every_frame ("pr_calc()")

end
