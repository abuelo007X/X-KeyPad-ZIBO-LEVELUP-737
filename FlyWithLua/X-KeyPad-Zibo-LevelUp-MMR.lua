-- MMR Values Formatting
-- This script is used to format the MMR key

-- @abuelo007X		2022-01-10	Added comments

-- We put aircraft guards on all of this so that if you want to use the strings for a different plane
-- we won't have two scripts fighting over them

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then

	-- This will be to tell us when a new configuration has been loaded
	local CONFIG_LOAD_COUNTER = dataref_table("SRS/X-KeyPad/ConfigLoadCounter")

	-- These are all the custom string definitions
	
	local STR_4 = dataref_table("SRS/X-KeyPad/custom_string_4")	-- This will be for the MMR	1
	local STR_6 = dataref_table("SRS/X-KeyPad/custom_string_6")	-- This will be for the MMR	2

	-- Simulator datarefs

	local MMR1_STBY_VALUE = dataref_table("laminar/B738/mmr/cpt/stby_value")
	local MMR1_STBY_MODE = dataref_table("laminar/B738/mmr/cpt/stby_mode")

	local MMR2_STBY_VALUE = dataref_table("laminar/B738/mmr/fo/stby_value")
	local MMR2_STBY_MODE = dataref_table("laminar/B738/mmr/fo/stby_mode")

	-- We will keep track of the previous values of the datarefs so we
	-- only update the strings if they change. String manipulation is a bit
	-- expensive so this approach helps with frame rates

	local last_mmr1 = -1
	local last_mmr2 = -1
	local last_config_load_counter = -1

	function fullRefresh()
		last_mmr1 = -1
		last_mmr2 = -1
	end

	function doStrings()	-- Update any custom strings if necessary

		-- We refresh all strings if a new configuration has been loaded since
		-- they get cleared out on reload by X-KeyPad
			
		if(last_config_load_counter ~= CONFIG_LOAD_COUNTER[0]) then
			fullRefresh()
			last_config_load_counter = CONFIG_LOAD_COUNTER[0]
		end			


		if MMR1_STBY_MODE[0] == 2 then
			STR_4[0] = string.format("%.0f%.0f%.0f%.0f%.0f",MMR1_STBY_VALUE[4],MMR1_STBY_VALUE[3],MMR1_STBY_VALUE[2],MMR1_STBY_VALUE[1],MMR1_STBY_VALUE[0])
		else
			STR_4[0] = string.format("%.0f%.0f%.0f.%.0f%.0f",MMR1_STBY_VALUE[4],MMR1_STBY_VALUE[3],MMR1_STBY_VALUE[2],MMR1_STBY_VALUE[1],MMR1_STBY_VALUE[0])
		end

		if MMR2_STBY_MODE[0] == 2 then
			STR_6[0] = string.format("%.0f%.0f%.0f%.0f%.0f",MMR2_STBY_VALUE[4],MMR2_STBY_VALUE[3],MMR2_STBY_VALUE[2],MMR2_STBY_VALUE[1],MMR2_STBY_VALUE[0])
		else
			STR_6[0] = string.format("%.0f%.0f%.0f.%.0f%.0f",MMR2_STBY_VALUE[4],MMR2_STBY_VALUE[3],MMR2_STBY_VALUE[2],MMR2_STBY_VALUE[1],MMR2_STBY_VALUE[0])
		end

	end -- end custom string check

	-- Update them every frame
	do_every_frame ("doStrings()")

end	-- end aircraft check
		
		