extends "res://abilities/Skillsheet.gd"

func _ready():
	var direction = cursorDirection * distance
	var location = global_position + direction
	signalBus.emit_signal("begin_shadowmeld", location, projectileSpeed)
	animationPlayer.play("start")
