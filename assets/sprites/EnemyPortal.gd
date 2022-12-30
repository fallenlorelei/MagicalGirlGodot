extends KinematicBody2D



onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer

onready var Slime = preload("res://enemies/Slime.tscn")

func _ready():
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "opening":
		animationPlayer.play("idle")
		spawn_enemies()
		

func spawn_enemies():
	var slimeSpawn = Slime.instance()
	add_child(slimeSpawn)
	slimeSpawn.global_position = global_position
	timer.start()
	

func _on_Timer_timeout():
	spawn_enemies()
