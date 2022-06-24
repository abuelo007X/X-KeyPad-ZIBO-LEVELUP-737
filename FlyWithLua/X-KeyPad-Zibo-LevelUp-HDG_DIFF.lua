-- HDG DIFF computing
-- This script is used to format the MMR key

-- enjxp	2022.05.29		-- Initial Configuration

-- We put aircraft guards on all of this so that if you want to use the strings for a different plane
-- we won't have two scripts fighting over them

local LOG_ID = "FWL 4 XKP B737 VD : HDG DIFF : "

logMsg(LOG_ID .. "LUA | START")

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	logMsg(LOG_ID .. "Aircraft Handled | PLANE_DESCRIP = " .. PLANE_DESCRIP)

	-- This will be to tell us when a new configuration has been loaded
	local CONFIG_LOAD_COUNTER = dataref_table("SRS/X-KeyPad/ConfigLoadCounter")

	-- Simulator datarefs

	local SI_HDG_DIFF = dataref_table("SRS/X-KeyPad/SharedInt")
	SI_HDG_DIFF_LAST = SI_HDG_DIFF[3]

	-- if(HDG_MODE = 1						laminar/B738/autopilot/hdg_sel_status
	-- ,
	-- HDG_MAG + MCP_HDG_DIAL				laminar/B738/nd/hdg_mag + laminar/B738/autopilot/mcp_hdg_dial
	-- ,
	-- HDG_MAG + (D1-48)*10 + D2-48)		laminar/B738/nd/hdg_mag + tonumber(laminar/B738/fmc1/Line01_X[1]..laminar/B738/fmc1/Line01_X[2]..laminar/B738/fmc1/Line01_X[3])	-- Not correct due to proper page potentially not diplayed / 

-- FMS_CRS		laminar/B738/fms/rest_wpt_alt_t
-- LNAV_MODE	laminar/B738/autopilot/lnav_engaged
-- MAG_VAR		sim/flightmodel/position/magnetic_variation

	-- We will keep track of the previous values of the datarefs so we
	-- only update the strings if they change. String manipulation is a bit
	-- expensive so this approach helps with frame rates

	local last_config_load_counter = -1

	function fullRefresh()
	end

	function pr_calc_hdg_diff()	-- Update any custom strings if necessary

		-- We refresh all strings if a new configuration has been loaded since
		-- they get cleared out on reload by X-KeyPad
			
		if(last_config_load_counter ~= CONFIG_LOAD_COUNTER[0]) then
			fullRefresh()
			last_config_load_counter = CONFIG_LOAD_COUNTER[0]
		end			



	end -- end custom string check

	-- Update them every frame
	do_every_frame("pr_calc_hdg_diff()")

end	-- end aircraft check
		
		