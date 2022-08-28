compass_hud={}
compass_hud.hud_list = {}
compass_hud.pos = 116

local function add_analog_compass(ids, player, main_x_pos, main_y_pos, screen_pos_x, screen_pos_y, show_analogic)
    show_analogic = show_analogic or false
    if show_analogic and not ids["bg"] then
        local player_name = player:get_player_name()
        
        ids["bg"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x, y = screen_pos_y},
            text      = "direction_compass_face.png",
            scale     = { x = 0.5, y = 0.5 },
            alignment = { x = -2.24, y = 2.24 },
        })

        ids["pointer"] = player:hud_add({
            hud_elem_type = "compass",
            size = {x=120,y=120},
            direction = 0,
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x, y = screen_pos_y},
            text="direction_compass_pointer.png",
            alignment = { x = -2.0, y = 2.0 },
        })

        compass_hud.hud_list[player_name] = ids
    end
end

local function remove_analog_compass(ids, player, show_analogic)
    show_analogic = show_analogic or false
    if not show_analogic and ids["bg"] then
        local player_name = player:get_player_name()
        player:hud_remove(ids["bg"])
        player:hud_remove(ids["pointer"])
        ids["bg"] = nil
        ids["pointer"] = nil

        compass_hud.hud_list[player_name] = ids
    end
end

function compass_hud.update_hud(player, show_analogic)
    show_analogic = show_analogic or false
    local player_name = player:get_player_name()

    local main_x_pos = 1
    local main_y_pos = 0.33

    local screen_pos_y = 0
    local screen_pos_x = 0

    local ids = compass_hud.hud_list[player_name]
    if ids then
        local N_gauge_x = screen_pos_x - compass_hud.pos
        local N_gauge_y = screen_pos_y + compass_hud.pos
        local S_gauge_x = screen_pos_x - compass_hud.pos
        local S_gauge_y = screen_pos_y + compass_hud.pos

        --analogic part
        add_analog_compass(ids, player, main_x_pos, main_y_pos, screen_pos_x, screen_pos_y, show_analogic)
        remove_analog_compass(ids, player, show_analogic)

        local player_yaw = 0
        if player then
            player_yaw = player:get_look_horizontal()
            local player_pos = player:get_pos()
            if player_pos then
                player:hud_change(ids["x"], "text", string.format("%.1f", player_pos.x ))
                player:hud_change(ids["y"], "text", string.format("%.1f", player_pos.y ))
                player:hud_change(ids["z"], "text", string.format("%.1f", player_pos.z ))
            end
        end
        if player_yaw then
            local N_angle = math.deg(player_yaw)
            local S_angle = N_angle + 180

            --mostra a direção, mas como na vida real
            local deg_angle = N_angle
            local exibition_angle = deg_angle - (2*deg_angle)
            if exibition_angle > 360 then exibition_angle = exibition_angle - 360 end
            if exibition_angle < 0 then exibition_angle = exibition_angle + 360 end
            local formatted = string.format(
               "%.2fº",
               exibition_angle
            )
            player:hud_change(ids["hdg"], "text", formatted)

            --mostre-me também o nome
            local dir_name = "---"
            if exibition_angle > 337.5 or exibition_angle <= 22.5 then dir_name = "North" end
            if exibition_angle > 22.5 and exibition_angle <= 67.5 then dir_name = "Northeast" end
            if exibition_angle > 67.5 and exibition_angle <= 112.5 then dir_name = "East" end
            if exibition_angle > 112.5 and exibition_angle <= 157.5 then dir_name = "Southeast" end
            if exibition_angle > 157.5 and exibition_angle <= 202.5 then dir_name = "South" end
            if exibition_angle > 202.5 and exibition_angle <= 247.5 then dir_name = "Southwest" end
            if exibition_angle > 247.5 and exibition_angle <= 292.5 then dir_name = "West" end
            if exibition_angle > 292.5 and exibition_angle <= 337.5 then dir_name = "Northwest" end
            player:hud_change(ids["cardinal"], "text", dir_name)
        end

    else
        ids = {}

        --labels posição
        ids["lblx"] = player:hud_add({
            hud_elem_type = "text",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x - 150, y = screen_pos_y - 25},
            text      = "x:",
            alignment = {x=-1,y=0},
            scale     = { x = 100, y = 30},
            number    = 0xFFFFFF,
        })
        ids["x"] = player:hud_add({
            hud_elem_type = "text",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x - 85, y = screen_pos_y - 25},
            text      = "-31000.0",
            alignment = {x=-1,y=0},
            scale     = { x = 100, y = 30},
            number    = 0xFFFFFF,
        })
        ids["lbly"] = player:hud_add({
            hud_elem_type = "text",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x - 150, y = screen_pos_y - 5},
            text      = "y:",
            alignment = {x=-1,y=0},
            scale     = { x = 100, y = 30},
            number    = 0xFFFFFF,
        })
        ids["y"] = player:hud_add({
            hud_elem_type = "text",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x - 85, y = screen_pos_y - 5},
            text      = "-31000.0",
            alignment = {x=-1,y=0},
            scale     = { x = 100, y = 30},
            number    = 0xFFFFFF,
        })
        ids["lblz"] = player:hud_add({
            hud_elem_type = "text",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x - 150, y = screen_pos_y + 15},
            text      = "z:",
            alignment = {x=-1,y=0},
            scale     = { x = 100, y = 30},
            number    = 0xFFFFFF,
        })
        ids["z"] = player:hud_add({
            hud_elem_type = "text",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x - 85, y = screen_pos_y + 15},
            text      = "-31000.0",
            alignment = {x=-1,y=0},
            scale     = { x = 100, y = 30},
            number    = 0xFFFFFF,
        })

        --bussola
        ids["hdg"] = player:hud_add({
            hud_elem_type = "text",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x - 120, y = screen_pos_y + 40},
            text      = "HDG: ",
            alignment = 0,
            scale     = { x = 100, y = 30},
            number    = 0x00FF00,
        })

        ids["cardinal"] = player:hud_add({
            hud_elem_type = "text",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x - 120, y = screen_pos_y + 60},
            text      = "---",
            alignment = 0,
            scale     = { x = 100, y = 30},
            number    = 0xFFFF00,
        })

        compass_hud.hud_list[player_name] = ids
    end
    --[[core.after(0.1, function()
        compass_hud.update_hud(player)
	end)]]--
end


function compass_hud.remove_hud(player)
    if player then
        local player_name = player:get_player_name()
        --minetest.chat_send_all(player_name)
        local ids = compass_hud.hud_list[player_name]
        if ids then
            if(ids["lblx"]) then
                player:hud_remove(ids["lblx"])
                player:hud_remove(ids["lbly"])
                player:hud_remove(ids["lblz"])
                player:hud_remove(ids["x"])
                player:hud_remove(ids["y"])
                player:hud_remove(ids["z"])

                player:hud_remove(ids["hdg"])
                player:hud_remove(ids["cardinal"])

                remove_analog_compass(ids, player, true)

            end
        end
        compass_hud.hud_list[player_name] = nil
    end

end

--minetest.register_on_joinplayer(compass_hud.update_hud)

minetest.register_on_leaveplayer(function(player)
    compass_hud.remove_hud(player)
end)


