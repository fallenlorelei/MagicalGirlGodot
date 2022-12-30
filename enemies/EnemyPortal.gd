extends Node2D



onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var sprite = $Sprite

onready var Slime = preload("res://enemies/Slime.tscn")

var spawnAmount = 3

func _ready():
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "opening":
		animationPlayer.play("idle")
		spawn_enemies()
	if anim_name == "closing":
		sprite.hide()

func spawn_enemies():
	var slimeSpawn = Slime.instance()
	get_parent().add_child(slimeSpawn)
	slimeSpawn.global_position = global_position
	spawnAmount -= 1
	timer.start()
	

func _on_Timer_timeout():
	if spawnAmount <= 0:
		animationPlayer.play("closing")
	else:
		spawn_enemies()
