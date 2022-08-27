# direction_compass
A mod that adds a compass with clockwise orientation, against the counter-clockwise of the debug info

The intention of creating this mod was to avoid the error and mistake of players who use minetest debug
information for guidance. While the debug yaw may somehow guide the player, it does not match the
orientation that a real compass uses, whether for cartography or navigation. So this mod implements a
compass that is oriented by the left hand rule, oriented clockwise, considering east at 090 and west
at 270. Also to help players, it displays position information and the names of cardinal and collateral
points. To display the analog version, which actually displays the player's direction, the compass must
be in the player's hand. For other information, the compass just needs to be in the inventory.
