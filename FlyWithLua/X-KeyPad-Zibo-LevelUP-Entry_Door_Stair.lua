-- COMMANDS TO Stair and main passenger doors (open/closing)
-- @Abuelo007X -> Created with the objective to facilitate open main entry door and set stair in just one key

if (PLANE_DESCRIP == "Boeing 737-800X") or (PLANE_DESCRIP == "Boeing 737-600NG") or (PLANE_DESCRIP == "Boeing 737-700NG") or (PLANE_DESCRIP == "Boeing 737-800NG") or (PLANE_DESCRIP == "Boeing 737-900NG") or (PLANE_DESCRIP == "Boeing 737-900ER") then
	
	-- ASSIGN DEFAULT VALUES
	dataref("dt_airstairs_hide","laminar/B738/airstairs_hide","readonly")
	dataref("dt_fwd_l_door_open","737u/doors/L1","readonly")
	open_position = dt_fwd_l_door_open


	function set_stair_and_fwd_l_door()		
    	if (dt_airstairs_hide == 1) and (dt_fwd_l_door_open*100 > 5) and (open_position == 0) then
			-- Set stairs as door open conditions are met
        	command_once("laminar/B738/airstairs_toggle")
			-- Establish door in progress condition
			open_position = 0.5
		end
-- 	For troubleshooting purposes. Will require to activate do_every_draw instead of do_often
--    	if (dt_airstairs_hide == 0)and (dt_fwd_l_door_open*100 > 5) and (open_position == 0.5) then
--			draw_string(50,800,"opening", "red")
--		end
		if (open_position == 0.5) and (dt_fwd_l_door_open*100 == 100) then
			open_position = 1
-- 	For troubleshooting purposes. Will require to activate do_every_draw instead of do_often
--			draw_string(50,800,"full open", "red")
		end
		if (open_position == 1) and (dt_fwd_l_door_open*100 == 100) then
-- 	For troubleshooting purposes. Will require to activate do_every_draw instead of do_often
--			draw_string(50,800,"full open", "red")
		end
    	if (dt_airstairs_hide == 1) and (dt_fwd_l_door_open < 1) and (open_position == 1) then
			open_position = 0.5
-- 	For troubleshooting purposes. Will require to activate do_every_draw instead of do_often
--			draw_string(50,800,"closing", "red")
		end
-- 	For troubleshooting purposes. Will require to activate do_every_draw instead of do_often
--    	if (dt_airstairs_hide == 1) and (dt_fwd_l_door_open < 1) and (open_position == 0.5) then
--			draw_string(50,800,"closing", "red")
--		end
		if (open_position == 0.5) and (dt_fwd_l_door_open == 0) then
			open_position = 0
-- 	For troubleshooting purposes. Will require to activate do_every_draw instead of do_often
--			draw_string(50,800,"full close", "red")
		end
-- 	For troubleshooting purposes. Will require to activate do_every_draw instead of do_often
--		if (open_position == 0) and (dt_fwd_l_door_open == 0) then
--			draw_string(50,800,"full close", "red")
--		end
--		draw_string(50,920,dt_airstairs_hide, "red")
--		draw_string(50,900,dt_fwd_l_door_open*100, "red")
--		draw_string(50,850,open_position, "red")
	end

	do_often ("set_stair_and_fwd_l_door()")
-- 	For troubleshooting purposes. Comment the do_often sentence and apply the do_every_draw
--	do_every_draw ("set_stair_and_fwd_l_door()") -- This when using draw_string for functionality validation/troubleshooting with values and status
end
