-- HYD PUMPS

-- Abuelo007X	2022.02.05	-- Ability to show the current Windows state based on the annunciators states

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	-- X-KeyPad Custom Strings or Values
	local SHAREDINT = dataref_table("SRS/X-KeyPad/SharedInt")
	local SHAREDFLT = dataref_table("SRS/X-KeyPad/SharedFloat")
    	
	-- Simulator datarefs

	dataref("ZIBO_WIN_HEAT_SIDEL_POS_ANN","laminar/B738/annunciator/window_heat_l_side","readonly")				-- 1 ON, 0 OFF
	dataref("ZIBO_WIN_HEAT_SIDEL_OVHT_ANN","laminar/B738/annunciator/window_heat_ovht_ls","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_WIN_HEAT_FWDL_POS_ANN","laminar/B738/annunciator/window_heat_l_fwd","readonly")				-- 1 ON, 0 OFF
	dataref("ZIBO_WIN_HEAT_FWDL_OVHT_ANN","laminar/B738/annunciator/window_heat_ovht_lf","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_WIN_HEAT_FWDR_POS_ANN","laminar/B738/annunciator/window_heat_r_fwd","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_WIN_HEAT_FWDR_OVHT_ANN","laminar/B738/annunciator/window_heat_ovht_rf","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_WIN_HEAT_SIDER_POS_ANN","laminar/B738/annunciator/window_heat_r_side","readonly")				-- 1 ON, 0 OFF
	dataref("ZIBO_WIN_HEAT_SIDER_OVHT_ANN","laminar/B738/annunciator/window_heat_ovht_rs","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_BATT_BUS","laminar/B738/electric/dir_batbus_status","readonly")								-- 1 ON, 0 OFF

	local SRS_CL = dataref_table("SRS/X-KeyPad/ConfigLoadCounter")												-- This will be to tell us when a new configuration has been loaded

	local cmp = 0
	local cmp1 = "0"
	local cmp2 = "0"
	local cmp3 = "0"
	local cmp4 = "0"
	local cmp20 = -1
	local cmp21 = -1
	local cmp22 = -1
	local cmp23 = -1

	SHAREDINT[20] = 0
	SHAREDINT[21] = 0
	SHAREDINT[22] = 0
	SHAREDINT[23] = 0
	SRS_CL_SAVE = -1

	function fullRefresh()
		cmp20 = -1
		cmp21 = -1
		cmp22 = -1
		cmp23 = -1
	end

	function wh_handling()

		if(SRS_CL_SAVE ~= SRS_CL[0]) then
			fullRefresh()
			SRS_CL_SAVE = SRS_CL[0]
		end			

		-- WIN_HEAT_SIDEL
		-- Read binary value 0 or 1
		cmp2 = string.format("%0d",ZIBO_WIN_HEAT_SIDEL_POS_ANN)
		cmp3 = string.format("%0d",ZIBO_WIN_HEAT_SIDEL_OVHT_ANN)
		cmp4 = string.format("%0d",ZIBO_BATT_BUS)
		-- Concatenate the 4 binaries then convert to decimal and compare to last save value. If different store new value to Sharedint then backup new value to last save
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp20 ~= cmp then SHAREDINT[20] = cmp cmp20 = cmp end

 		-- WIN_HEAT_FWDL
		cmp2 = string.format("%0d",ZIBO_WIN_HEAT_FWDL_POS_ANN)
		cmp3 = string.format("%0d",ZIBO_WIN_HEAT_FWDL_OVHT_ANN)
		cmp4 = string.format("%0d",ZIBO_BATT_BUS)
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp21 ~= cmp then SHAREDINT[21] = cmp cmp21 = cmp end

		-- WIN_HEAT_FWDR
		cmp2 = string.format("%0d",ZIBO_WIN_HEAT_FWDR_POS_ANN)
		cmp3 = string.format("%0d",ZIBO_WIN_HEAT_FWDR_OVHT_ANN)
		cmp4 = string.format("%0d",ZIBO_BATT_BUS)
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp22 ~= cmp then SHAREDINT[22] = cmp cmp22 = cmp end

		-- WIN_HEAT_SIDER
		cmp2 = string.format("%0d",ZIBO_WIN_HEAT_SIDER_POS_ANN)
		cmp3 = string.format("%0d",ZIBO_WIN_HEAT_SIDER_OVHT_ANN)
		cmp4 = string.format("%0d",ZIBO_BATT_BUS)
		cmp = tonumber(cmp1..cmp2..cmp3..cmp4,2) if cmp23 ~= cmp then SHAREDINT[23] = cmp cmp23 = cmp end

	end

	do_every_frame ("wh_handling()")

end
