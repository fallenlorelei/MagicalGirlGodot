extends Node2D

const STARTING_ROOMS = [
	preload("res://levels/rooms/StartingRoom01.tscn")
]
const MIDDLE_ROOMS = [
	preload("res://levels/rooms/MiddleRoom01.tscn"),
	preload("res://levels/rooms/MiddleRoom02.tscn")
]
const END_ROOMS = [
	preload("res://levels/rooms/EndRoom01.tscn")
]
const ENEMY_PORTAL = preload("res://enemies/EnemyPortal.tscn")

const TILE_SIZE = 32
const MAP_SIZE = 20

export(int) var num_rooms = 5

onready var ySort = $YSort
onready var player = $YSort/Player

func _ready():
	randomize()
	_spawn_rooms()
	
func _spawn_rooms():
	var previous_room: Node2D
	var previous_room_end
	
	for i in num_rooms:
		var room: Node2D
		if i == 0:
			room = STARTING_ROOMS[randi() % STARTING_ROOMS.size()].instance()
			player.position = room.get_node("StartPos").position
			
		else:
			if i == num_rooms - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instance()
				previous_room_end = floor(previous_room.get_node("ExitPos").global_position.x / TILE_SIZE)
			else:
				room = MIDDLE_ROOMS[randi() % MIDDLE_ROOMS.size()].instance()
				previous_room_end = floor(previous_room.get_node("ExitPos").global_position.x / TILE_SIZE)
				
			var new_room_start = floor(room.get_node("StartPos").position.x / TILE_SIZE)
			
			var startEndDifference = (new_room_start - previous_room_end) * TILE_SIZE
			
			var room_x = (previous_room_end - new_room_start) * TILE_SIZE
			var room_y = previous_room.get_node("ExitPos").global_position.y
			
			room.global_position = Vector2(room_x,room_y)

		add_child(room)
		previous_room = room
		

#		var enemyPortal = ENEMY_PORTAL.instance()
#		enemyPortal.global_position = room.get_node("EnemyPortal").global_position
#		enemyPortal.spawnAmount = rand_range(3,8)
#		ySort.add_child(enemyPortal)
