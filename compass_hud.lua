compass_hud={}
compass_hud.hud_list = {}

function compass_hud.animate_gauge(player, ids, prefix, x, y, angle)
    local deg_angle = angle + 180
    if deg_angle > 360 then deg_angle = deg_angle - 360 end
    if deg_angle < 0 then deg_angle = deg_angle + 360 end

    --mostra a direção, mas como na vida real
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

    --aqui exibe no analogico
    local angle_in_rad = math.rad(deg_angle)

    local dim = 5
    local pos_x = math.sin(angle_in_rad) * dim
    local pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "2"], "offset", {x = pos_x + x, y = pos_y + y})
    dim = 10
    pos_x = math.sin(angle_in_rad) * dim
    pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "3"], "offset", {x = pos_x + x, y = pos_y + y})
    dim = 15
    pos_x = math.sin(angle_in_rad) * dim
    pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "4"], "offset", {x = pos_x + x, y = pos_y + y})
    dim = 20
    pos_x = math.sin(angle_in_rad) * dim
    pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "5"], "offset", {x = pos_x + x, y = pos_y + y})
    dim = 25
    --if prefix == "N_pt_" then
        pos_x = math.sin(angle_in_rad) * dim
        pos_y = math.cos(angle_in_rad) * dim
        player:hud_change(ids[prefix .. "6"], "offset", {x = pos_x + x, y = pos_y + y})
        dim = 30
        pos_x = math.sin(angle_in_rad) * dim
        pos_y = math.cos(angle_in_rad) * dim
        player:hud_change(ids[prefix .. "7"], "offset", {x = pos_x + x, y = pos_y + y})
    --end
end

function compass_hud.update_hud(player)
    local player_name = player:get_player_name()

    local main_x_pos = 1
    local main_y_pos = 0.33

    local screen_pos_y = 0
    local screen_pos_x = 0

    local N_gauge_x = screen_pos_x - 116
    local N_gauge_y = screen_pos_y + 116
    local S_gauge_x = screen_pos_x - 116
    local S_gauge_y = screen_pos_y + 116

    local ids = compass_hud.hud_list[player_name]
    if ids then
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
        local N_angle = math.deg(player_yaw)
        local S_angle = N_angle + 180

        compass_hud.animate_gauge(player, ids, "N_pt_", N_gauge_x, N_gauge_y, N_angle)
        compass_hud.animate_gauge(player, ids, "S_pt_", S_gauge_x, S_gauge_y, S_angle)

    else
        ids = {}
        local S_pointer_texture = "direction_compass_ind_box.png"
        local N_pointer_texture = "direction_compass_ind_box_red.png"
        local elementN = {
            hud_elem_type = "image",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = N_gauge_x, y = N_gauge_y},
            text      = N_pointer_texture,
            scale     = { x = 5, y = 5},
            alignment = { x = -1.12, y = 1.12 },
        }
        local elementS = {
            hud_elem_type = "image",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = S_gauge_x, y = S_gauge_y},
            text      = S_pointer_texture,
            scale     = { x = 5, y = 5},
            alignment = { x = -1.12, y = 1.12 },
        }


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

        ids["bg"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x, y = screen_pos_y},
            text      = "direction_compass_face.png",
            scale     = { x = 0.5, y = 0.5 },
            alignment = { x = -2.25, y = 2.25 },
        })

        ids["N_pt_1"] = player:hud_add(elementN)
        ids["N_pt_2"] = player:hud_add(elementN)
        ids["N_pt_3"] = player:hud_add(elementN)
        ids["N_pt_4"] = player:hud_add(elementN)
        ids["N_pt_5"] = player:hud_add(elementN)
        ids["N_pt_6"] = player:hud_add(elementN)
        ids["N_pt_7"] = player:hud_add(elementN)

        ids["S_pt_1"] = player:hud_add(elementS)
        ids["S_pt_2"] = player:hud_add(elementS)
        ids["S_pt_3"] = player:hud_add(elementS)
        ids["S_pt_4"] = player:hud_add(elementS)
        ids["S_pt_5"] = player:hud_add(elementS)
        ids["S_pt_6"] = player:hud_add(elementS)
        ids["S_pt_7"] = player:hud_add(elementS)

        ids["compass_center"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = main_x_pos, y = main_y_pos},
            offset    = {x = screen_pos_x - 108, y = screen_pos_y + 108},
            text      = "direction_compass_center.png",
            scale     = { x = 4, y = 4 },
            alignment = { x = -1.52, y = 1.50 },
        })


        compass_hud.hud_list[player_name] = ids
    end
    core.after(0.1, function()
        compass_hud.update_hud(player)
	end)
end


function compass_hud.remove_hud(player)
    if player then
        local player_name = player:get_player_name()
        --minetest.chat_send_all(player_name)
        local ids = compass_hud.hud_list[player_name]
        if ids then
            if(ids["hdg"]) then
                player:hud_remove(ids["lblx"])
                player:hud_remove(ids["lbly"])
                player:hud_remove(ids["lblz"])
                player:hud_remove(ids["x"])
                player:hud_remove(ids["y"])
                player:hud_remove(ids["z"])

                player:hud_remove(ids["hdg"])
                player:hud_remove(ids["cardinal"])
                player:hud_remove(ids["bg"])
                player:hud_remove(ids["N_pt_7"])
                player:hud_remove(ids["N_pt_6"])
                player:hud_remove(ids["N_pt_5"])
                player:hud_remove(ids["N_pt_4"])
                player:hud_remove(ids["N_pt_3"])
                player:hud_remove(ids["N_pt_2"])
                player:hud_remove(ids["N_pt_1"])

                player:hud_remove(ids["S_pt_7"])
                player:hud_remove(ids["S_pt_6"])
                player:hud_remove(ids["S_pt_5"])
                player:hud_remove(ids["S_pt_4"])
                player:hud_remove(ids["S_pt_3"])
                player:hud_remove(ids["S_pt_2"])
                player:hud_remove(ids["S_pt_1"])
                player:hud_remove(ids["compass_center"])
            end
        end
        compass_hud.hud_list[player_name] = nil
    end

end

minetest.register_on_joinplayer(compass_hud.update_hud)

minetest.register_on_leaveplayer(function(player)
    compass_hud.remove_hud(player)
end)


