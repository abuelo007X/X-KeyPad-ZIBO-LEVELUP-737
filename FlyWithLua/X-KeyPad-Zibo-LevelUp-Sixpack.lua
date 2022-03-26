-- SIXPACK CAPT & FO
-- enjxp		2022.01.18	Read the CAPT & FO Sixpack Annunciators status

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	-- X-KeyPad Custom Strings or Values
	local SHAREDINT = dataref_table("SRS/X-KeyPad/SharedInt")

	-- Simulator datarefs

	dataref("ZIBO_SIXPACK_FLTCONT","laminar/B738/annunciator/six_pack_flt_cont","readonly")	-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_IRS","laminar/B738/annunciator/six_pack_irs","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_FUEL","laminar/B738/annunciator/six_pack_fuel","readonly")		-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_ELEC","laminar/B738/annunciator/six_pack_elec","readonly")		-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_APU","laminar/B738/annunciator/six_pack_apu","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_OVHTDET","laminar/B738/annunciator/six_pack_fire","readonly")		-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_ANTIICE","laminar/B738/annunciator/six_pack_ice","readonly")		-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_HYD","laminar/B738/annunciator/six_pack_hyd","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_DOORS","laminar/B738/annunciator/six_pack_doors","readonly")		-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_ENG","laminar/B738/annunciator/six_pack_eng","readonly")			-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_OVH","laminar/B738/annunciator/six_pack_overhead","readonly")		-- 1 ON, 0 OFF
	dataref("ZIBO_SIXPACK_AIRCOND","laminar/B738/annunciator/six_pack_air_cond","readonly")	-- 1 ON, 0 OFF

	SHAREDINT[36] = 0	-- CAPT Sixpack 1
	SHAREDINT[37] = 0	-- CAPT Sixpack 2
	SHAREDINT[38] = 0	-- FO Sixpack 1
	SHAREDINT[39] = 0	-- FO Sixpack 2

	local cmp = 0
	local cmp36 = 0
	local cmp37 = 0
	local cmp38 = 0
	local cmp39 = 0

	function ColorUpdate_Sixpack()

		-- CAPT_SIXPACK
		cmp1 = string.format("%0d",ZIBO_SIXPACK_FLTCONT)
		cmp2 = string.format("%0d",ZIBO_SIXPACK_IRS)
		cmp3 = string.format("%0d",ZIBO_SIXPACK_FUEL)
		cmp4 = string.format("%0d",ZIBO_SIXPACK_ELEC)
		cmp5 = string.format("%0d",ZIBO_SIXPACK_APU)
		cmp6 = string.format("%0d",ZIBO_SIXPACK_OVHTDET)
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp36 ~= cmp then SHAREDINT[36] = cmp end cmp36 = cmp
		cmp = tonumber(cmp4..cmp5..cmp6,2) if cmp37 ~= cmp then SHAREDINT[37] = cmp end cmp37 = cmp

		-- FO_SIXPACK
		cmp1 = string.format("%0d",ZIBO_SIXPACK_ANTIICE)
		cmp2 = string.format("%0d",ZIBO_SIXPACK_HYD)
		cmp3 = string.format("%0d",ZIBO_SIXPACK_DOORS)
		cmp4 = string.format("%0d",ZIBO_SIXPACK_ENG)
		cmp5 = string.format("%0d",ZIBO_SIXPACK_OVH)
		cmp6 = string.format("%0d",ZIBO_SIXPACK_AIRCOND)
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp38 ~= cmp then SHAREDINT[38] = cmp end cmp38 = cmp
		cmp = tonumber(cmp4..cmp5..cmp6,2) if cmp39 ~= cmp then SHAREDINT[39] = cmp end cmp39 = cmp

	end

	do_every_frame ("ColorUpdate_Sixpack()")

end
