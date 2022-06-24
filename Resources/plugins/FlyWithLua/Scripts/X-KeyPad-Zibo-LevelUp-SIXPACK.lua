-- SIXPACK CAPT & FO

-- enjxp		2022.01.18	-- Read the CAPT & FO Sixpack Annunciators status

local LOG_ID = "FWL 4 XKP B737 VD : SIXPACK : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- X-KeyPad Custom Strings or Values
	local SI_SIXPACK = dataref_table("SRS/X-KeyPad/SharedInt")

	-- Simulator datarefs

	local ZIBO_SIXPACK_FLTCONT	= dataref_table("laminar/B738/annunciator/six_pack_flt_cont")	-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_IRS		= dataref_table("laminar/B738/annunciator/six_pack_irs")			-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_FUEL		= dataref_table("laminar/B738/annunciator/six_pack_fuel")		-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_ELEC		= dataref_table("laminar/B738/annunciator/six_pack_elec")		-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_APU		= dataref_table("laminar/B738/annunciator/six_pack_apu")			-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_OVHTDET	= dataref_table("laminar/B738/annunciator/six_pack_fire")		-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_ANTIICE	= dataref_table("laminar/B738/annunciator/six_pack_ice")			-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_HYD		= dataref_table("laminar/B738/annunciator/six_pack_hyd")			-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_DOORS	= dataref_table("laminar/B738/annunciator/six_pack_doors")		-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_ENG		= dataref_table("laminar/B738/annunciator/six_pack_eng")			-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_OVH		= dataref_table("laminar/B738/annunciator/six_pack_overhead")	-- 1 ON, 0 OFF
	local ZIBO_SIXPACK_AIRCOND	= dataref_table("laminar/B738/annunciator/six_pack_air_cond")	-- 1 ON, 0 OFF

	SI_SIXPACK[36] = 0	-- CAPT Sixpack 1
	SI_SIXPACK[37] = 0	-- CAPT Sixpack 2
	SI_SIXPACK[38] = 0	-- FO Sixpack 1
	SI_SIXPACK[39] = 0	-- FO Sixpack 2

	local cmp = 0
	local cmp36 = 0
	local cmp37 = 0
	local cmp38 = 0
	local cmp39 = 0

	function pr_calc_sixpack()

		-- CAPT_SIXPACK
		cmp1 = string.format("%0d",ZIBO_SIXPACK_FLTCONT[0])
		cmp2 = string.format("%0d",ZIBO_SIXPACK_IRS[0])
		cmp3 = string.format("%0d",ZIBO_SIXPACK_FUEL[0])
		cmp4 = string.format("%0d",ZIBO_SIXPACK_ELEC[0])
		cmp5 = string.format("%0d",ZIBO_SIXPACK_APU[0])
		cmp6 = string.format("%0d",ZIBO_SIXPACK_OVHTDET[0])
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp36 ~= cmp then SI_SIXPACK[36] = cmp end cmp36 = cmp
		cmp = tonumber(cmp4..cmp5..cmp6,2) if cmp37 ~= cmp then SI_SIXPACK[37] = cmp end cmp37 = cmp

		-- FO_SIXPACK
		cmp1 = string.format("%0d",ZIBO_SIXPACK_ANTIICE[0])
		cmp2 = string.format("%0d",ZIBO_SIXPACK_HYD[0])
		cmp3 = string.format("%0d",ZIBO_SIXPACK_DOORS[0])
		cmp4 = string.format("%0d",ZIBO_SIXPACK_ENG[0])
		cmp5 = string.format("%0d",ZIBO_SIXPACK_OVH[0])
		cmp6 = string.format("%0d",ZIBO_SIXPACK_AIRCOND[0])
		cmp = tonumber(cmp1..cmp2..cmp3,2) if cmp38 ~= cmp then SI_SIXPACK[38] = cmp end cmp38 = cmp
		cmp = tonumber(cmp4..cmp5..cmp6,2) if cmp39 ~= cmp then SI_SIXPACK[39] = cmp end cmp39 = cmp

	end

	do_every_frame("pr_calc_sixpack()")

end
