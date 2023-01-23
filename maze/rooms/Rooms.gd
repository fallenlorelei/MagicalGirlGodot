extends Node2D

const enemyPortal = preload("res://enemies/EnemyPortal.tscn")

func _ready():
	yield(get_tree(), "idle_frame")
	var first_tile = get_parent().first_tile * 640
	if global_position.x != first_tile.x:
		var portalSpawn = enemyPortal.instance()
		add_child(portalSpawn)
		portalSpawn.position = Vector2(340,280)
