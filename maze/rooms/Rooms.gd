extends Node2D

const enemyPortal = preload("res://enemies/EnemyPortal.tscn")

func _ready():
	yield(get_tree(), "idle_frame")
	var first_tile = get_parent().first_tile * Vector2(640,640)
	if global_position != first_tile:
		var portalSpawn = enemyPortal.instance()
		add_child(portalSpawn)
		portalSpawn.position = Vector2(340,280)
