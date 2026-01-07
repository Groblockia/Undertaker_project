Make sure to turn on `Physics interpolation` and set `Physics jitter tick` to 0 
in Physics/common

make the camera_pivot `top_level`,
add a marker at same place as the pivot,
rotate the marker instead of the pivot in script,
and make the pivot follow marker using this line `global_transform = player.camera_controller_anchor.get_global_transform_interpolated()`
