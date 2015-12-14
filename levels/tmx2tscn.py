"""
tmx2tscn
Copyright: Alket Rexhepi - https://github.com/alketii
License: https://opensource.org/licenses/MIT
"""
import sys, json

# Default values for args
file_input = "input.json"
file_output = "output.tscn"
origin_offset = True

# Getting args
for arg in sys.argv:
    arg = arg.split("=")
    if arg[0] == "-h":
        print """
Usage:
    tmx2tscn [options]

Options:
    -i=file.json    : Input file, default: input.json
    -o=file.tscn    : Output file, default: output.tscn
    -oo=true/false  : Origin offset, default: true
    -h              : This help file
"""
        sys.exit()
    elif arg[0] == "-i":
        file_input = str(arg[1])
    elif arg[0] == "-o":
        file_output = str(arg[1])
    elif arg[0] == "-oo":
        if str(arg[1]) == "0" or str(arg[1]) == "false":
            origin_offset = False


# Read json
with open(file_input) as data_file:
    data = json.load(data_file)

# Some parameters from json
map_width = int(data['width'])
map_height = int(data['height'])
tile_width = int(data['tilewidth'])
tile_height = int(data['tileheight'])
tile_properties = data['tilesets'][0]['tileproperties']

# Origin Offset
origin_offset_x = tile_width/2
origin_offset_y = tile_height/2
if not origin_offset:
    origin_offset_x = 0
    origin_offset_y = 0

# Create file if it doesn't exists, empty if exists
open(file_output, 'w').close()

# Open file in Appending mode
f = open(file_output, 'a')

# Write this
f.write('[gd_scene load_steps=3 format=1]\n\n')

# Get external scenes (as defined in Custom Properties at tmx) and assign ids.
tile_id = 0
for tile in tile_properties:
    tile_id = int(tile)+1
    f.write('[ext_resource path="'+tile_properties[tile]['scene']+'" type="PackedScene" id='+str(tile_id)+']\n')
f.write('\n')

# Write Root Node
f.write('[node name="level" type="Node2D"]\n\n')

# Write metadata, set snap size
f.write('__meta__ = { "__editor_plugin_screen__":"2D", "__editor_plugin_states__":{ "2D":{ "ofs":Vector2( 0, 0 ), "snap_grid":true, "snap_offset":Vector2( 0, 0 ), "snap_pixel":false, "snap_relative":false, "snap_rotation":false, "snap_rotation_offset":0, "snap_rotation_step":0.261799, "snap_show_grid":true, "snap_step":Vector2( '+str(tile_width)+', '+str(tile_height)+' ), "zoom":1 }, "3D":{ "ambient_light_color":Color( 0.15, 0.15, 0.15, 1 ), "default_light":true, "default_srgb":false, "deflight_rot_x":0.942478, "deflight_rot_y":0.628319, "fov":45, "show_grid":true, "show_origin":true, "viewport_mode":1, "viewports":[ { "distance":4, "listener":true, "pos":Vector3( 0, 0, 0 ), "use_environment":false, "use_orthogonal":false, "x_rot":0, "y_rot":0 }, { "distance":4, "listener":false, "pos":Vector3( 0, 0, 0 ), "use_environment":false, "use_orthogonal":false, "x_rot":0, "y_rot":0 }, { "distance":4, "listener":false, "pos":Vector3( 0, 0, 0 ), "use_environment":false, "use_orthogonal":false, "x_rot":0, "y_rot":0 }, { "distance":4, "listener":false, "pos":Vector3( 0, 0, 0 ), "use_environment":false, "use_orthogonal":false, "x_rot":0, "y_rot":0 } ], "zfar":500, "znear":0.1 }, "Anim":{ "visible":false } }, "__editor_run_settings__":{ "custom_args":"-l $scene", "run_mode":0 } }\n\n')

# Write tiles in tscn
for layer in data['layers']:
    layer_name = layer['name']
    layers_data = layer['data']
    f.write('[node name="'+layer_name+'" type="Node" parent="."]\n\n')
    tile_count = 0
    tile_count_used = 1
    tile_x = 0
    tile_y = 0
    for y in range(map_height):
        for x in range(map_width):
            if layers_data[tile_count] > 0:
                f.write('[node name="tile_'+str(tile_count_used)+'" parent="'+layer_name+'" instance=ExtResource( '+str(layers_data[tile_count])+' )]\n\ntransform/pos = Vector2( '+str(tile_x+origin_offset_x)+', '+str(tile_y+origin_offset_y)+' )\n\n')
                tile_count_used += 1
            tile_count += 1
            tile_x += tile_width

        tile_x = 0
        tile_y += tile_height

# Close file
f.close()

print "Done."
