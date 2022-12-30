extends Node2D



onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var sprite = $Sprite

onready var Slime = load("res://enemies/Slime.tscn")

export var spawnAmount = 1


func _ready():
	print("portal is", global_position)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "opening":
		animationPlayer.play("idle")
		spawn_enemies()
	if anim_name == "closing":
		sprite.hide()

func spawn_enemies():
	var slimeSpawn = Slime.instance()
	slimeSpawn.global_position = global_position
	get_parent().add_child(slimeSpawn)
	spawnAmount -= 1
	if spawnAmount >= 0:
		timer.start()
	

func _on_Timer_timeout():
	if spawnAmount <= 0:
		animationPlayer.play("closing")
	else:
		spawn_enemies()
