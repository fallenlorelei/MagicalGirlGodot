extends Node2D

const enemyPortal = preload("res://enemies/EnemyPortal.tscn")

onready var portalPositionNodes = $PortalPositions

var room_size = Vector2(640,640)
var random_portal_position = 64

func _ready():
	yield(get_tree(), "idle_frame")
	var first_tile = get_parent().first_tile * room_size
	#Not spawning on the first tile doesn't work all the time :(
	if global_position != first_tile:
		if is_instance_valid(portalPositionNodes):
			var portalPositions = portalPositionNodes.get_children()
			for i in range(portalPositions.size()):
				if range(portalPositions.size()).has(i):
					var portalSpawn = enemyPortal.instance()
					add_child(portalSpawn)
					portalSpawn.position = portalPositions[i].position + Vector2(rand_range(-random_portal_position, random_portal_position), rand_range(-random_portal_position, random_portal_position))
