extends TileMap
class_name InteractiveTilemap

#export var type0 = [preload("res://maze/rooms/00/0-1.tscn")]
#export var type1 = [preload("res://maze/rooms/01/1-1.tscn")]
#export var type2 = [preload("res://maze/rooms/02/2-1.tscn")]
#export var type3 = [preload("res://maze/rooms/03/3-1.tscn")]
#export var type4 = [preload("res://maze/rooms/04/4-1.tscn")]
#export var type5 = [preload("res://maze/rooms/05/5-1.tscn")]
#export var type6 = [preload("res://maze/rooms/06/6-1.tscn")]
#export var type7 = [preload("res://maze/rooms/07/7-1.tscn")]
#export var type8 = [preload("res://maze/rooms/08/8-1.tscn")]
#export var type9 = [preload("res://maze/rooms/09/9-1.tscn")]
#export var type10 = [preload("res://maze/rooms/10/10-1.tscn")]
#export var type11 = [preload("res://maze/rooms/11/11-1.tscn")]
#export var type12 = [preload("res://maze/rooms/12/12-1.tscn")]
#export var type13 = [preload("res://maze/rooms/13/13-1.tscn")]
#export var type14 = [preload("res://maze/rooms/14/14-1.tscn")]
#export var type15 = [preload("res://maze/rooms/15/15-1.tscn")]
#
#var TILE_SCENES = {
#	0: type0[randi() % type0.size()],
#	1: type1[randi() % type1.size()],
#	2: type2[randi() % type2.size()],
#	3: type3[randi() % type3.size()],
#	4: type4[randi() % type4.size()],
#	5: type5[randi() % type5.size()],
#	6: type6[randi() % type6.size()],
#	7: type7[randi() % type7.size()],
#	8: type8[randi() % type8.size()],
#	9: type9[randi() % type9.size()],
#	10: type10[randi() % type10.size()],
#	11: type11[randi() % type11.size()],
#	12: type12[randi() % type12.size()],
#	13: type13[randi() % type13.size()],
#	14: type14[randi() % type14.size()],
#	15: type15[randi() % type15.size()]
#}

var TILE_SCENES = {
	0: preload("res://maze/rooms/00/0-1.tscn"),
	1: preload("res://maze/rooms/01/1-1.tscn"),
	2: preload("res://maze/rooms/02/2-1.tscn"),
	3: preload("res://maze/rooms/03/3-1.tscn"),
	4: preload("res://maze/rooms/04/4-1.tscn"),
	5: preload("res://maze/rooms/05/5-1.tscn"),
	6: preload("res://maze/rooms/06/6-1.tscn"),
	7: preload("res://maze/rooms/07/7-1.tscn"),
	8: preload("res://maze/rooms/08/8-1.tscn"),
	9: preload("res://maze/rooms/09/9-1.tscn"),
	10: preload("res://maze/rooms/10/10-1.tscn"),
	11: preload("res://maze/rooms/11/11-1.tscn"),
	12: preload("res://maze/rooms/12/12-1.tscn"),
	13: preload("res://maze/rooms/13/13-1.tscn"),
	14: preload("res://maze/rooms/14/14-1.tscn"),
	15: preload("res://maze/rooms/15/15-1.tscn"),
}
onready var half_cell_size = cell_size * 0.5

func _ready():
	yield(get_tree(),'idle_frame')
	_replace_tiles_with_scenes()

func _replace_tiles_with_scenes(scene_dictionary: Dictionary = TILE_SCENES):
	for tile_pos in get_used_cells():
		var tile_id = get_cell(tile_pos.x, tile_pos.y)
		
		if scene_dictionary.has(tile_id):
			var object_scene = scene_dictionary[tile_id]
			_replace_tile_with_object(tile_pos, object_scene)
	
func _replace_tile_with_object(tile_pos: Vector2, object_scene: PackedScene, parent: Node = get_tree().current_scene):
	#Clear the cell in tilemap
#	if get_cellv(tile_pos) != INVALID_CELL:
#		set_cellv(tile_pos, -1)
#		update_bitmask_region()
	
	#Spawn object
	if object_scene:
		var obj = object_scene.instance()
		var ob_pos = map_to_world(tile_pos) #+ half_cell_size
		parent.add_child(obj)
		obj.global_position = ob_pos
