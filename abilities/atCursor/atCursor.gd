extends "res://attacks/Hitbox.gd"

onready var animationPlayer = $AnimationPlayer

func _ready():
	pass

func _physics_process(_delta):
	pass
#
func execute():
	pass

func start_finished():
	animationPlayer.play("finish")
	
func finish_finished():
	destroy()
