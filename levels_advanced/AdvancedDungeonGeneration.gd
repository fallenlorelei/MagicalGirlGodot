extends Node2D

const STARTING_ROOMS = [
	preload("res://levels_advanced/rooms/StartingRooms.tscn")
]
const END_ROOMS = [
	preload("res://levels_advanced/rooms/EndingRooms.tscn")
]
const LEFT_END_ROOMS =[
	preload("res://levels_advanced/rooms/LeftEnd.tscn")
]
const RIGHT_END_ROOMS =[
	preload("res://levels_advanced/rooms/RightEnd.tscn")
]
const TOP_OPEN =[
	preload("res://levels_advanced/rooms/UpDown.tscn"),
	preload("res://levels_advanced/rooms/UpDownLeftRight.tscn"),
]

const TILE_SIZE = 32

export(int) var num_rooms = 5

onready var ySort = $YSort
onready var player = $YSort/Player

func _ready():
	randomize()
	_spawn_rooms(null)
	
func _spawn_rooms(type):
	var previous_room: Node2D
	var previous_room_end
	var next_spawn_type
	
	for i in num_rooms:
		var room: Node2D
		if i == 0:
			room = STARTING_ROOMS[randi() % STARTING_ROOMS.size()].instance()
			player.position = room.get_node("StartPos").position
			add_child(room)
			previous_room = room
		
		elif i == num_rooms - 1:
					room = END_ROOMS[randi() % END_ROOMS.size()].instance()
					previous_room_end = floor(previous_room.get_node("ExitPos").global_position.x / TILE_SIZE)
					set_room_position(room, previous_room, previous_room_end)
					add_child(room)
					previous_room = room
		
		# Spawning any "top open" rooms since the starting room will always
		# have a road going down
		elif next_spawn_type == null:
			room = TOP_OPEN[randi() % TOP_OPEN.size()].instance()
			previous_room_end = floor(previous_room.get_node("ExitPos").global_position.x / TILE_SIZE)
			set_room_position(room, previous_room, previous_room_end)
			add_child(room)
			previous_room = room
			
			# If it spawned UpDownLeftRight, we need Left/Right caps
			if room.name == "UpDownLeftRight":
				pass
				# Set up spawning the caps in the right position, and then
				# continue going down?
				# Or add a Left/Right and bottom cap this one. Idk.


func set_room_position(room, previous_room, previous_room_end):
	var new_room_start = floor(room.get_node("StartPos").position.x / TILE_SIZE)
	var startEndDifference = (new_room_start - previous_room_end) * TILE_SIZE
	var room_x = (previous_room_end - new_room_start) * TILE_SIZE
	var room_y = previous_room.get_node("ExitPos").global_position.y
	room.global_position = Vector2(room_x,room_y)
