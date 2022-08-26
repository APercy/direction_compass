modname = "direction_compass"

minetest.register_craft({
  output = 'direction_compass:compass',
  recipe = {
    {'', 'default:copper_ingot', ''},
    {'default:copper_ingot', 'default:steel_ingot', 'default:copper_ingot'},
    {'', 'default:copper_ingot', ''}
  }
})

minetest.register_craftitem("direction_compass:compass", {
	description = "Direction Compass",
	inventory_image = "direction_compass_face_ico.png",
	--groups = {book = 1},
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		--enable analogic here TODO
		return
	end
})

minetest.register_globalstep(function(dtime)
	local players  = minetest.get_connected_players()
	for i,player in ipairs(players) do
        local playername = player:get_player_name();

        local gotacompass=false
        local wielded=false
        local activeinv=nil
        local stackidx=0
        --first check to see if the user has a compass, because if they don't
        --there is no reason to waste time calculating bookmarks or spawnpoints.
        local wielded_item = player:get_wielded_item():get_name()
        local find_string = "direction_compass:compass"      

        if string.sub(wielded_item, 0, 25) == find_string then
            --if the player is wielding a compass, change the wielded image
            wielded=true
            stackidx=player:get_wield_index()
            gotacompass=true
        else
            --check to see if compass is in active inventory
            if player:get_inventory() then
                --problem being that arrays are not sorted in lua
                for i,stack in ipairs(player:get_inventory():get_list("main")) do
                    if string.sub(stack:get_name(),0,25) == find_string then
                        activeinv=stack  --store the stack so we can update it later with new image
                        stackidx=i --store the index so we can add image at correct location
                        gotacompass=true
                        break
                    end
                end --for loop
            end -- get_inventory
        end --if wielded else


        --dont mess with the rest of this if they don't have a compass
        if gotacompass then
            compass_hud.update_hud(player, wielded)
        else --remove the hud if player no longer has compass
            compass_hud.remove_hud(player)
        end --if gotacompass
    end --for i,player in ipairs(players)
end) -- register_globalstep

dofile(minetest.get_modpath(modname) .. DIR_DELIM .. "compass_hud.lua")
