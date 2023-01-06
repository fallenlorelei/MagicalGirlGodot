extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var sprite = $Sprite

export(float) var spawnTimer = 1.0
var randomEnemy

var enemy_dict = {
#	"Slime": preload("res://enemies/Slime.tscn"),
	"Slime2": preload("res://entities/EnemySlime.tscn"),
	}

export var spawnAmount = 1

func _ready():
	randomEnemy = get_random_enemy()

func get_random_enemy():
	var random_id = randi() % enemy_dict.size()
	var random_value = enemy_dict.values()[random_id]
	return random_value

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "opening":
		animationPlayer.play("idle")
		spawn_enemies()
	if anim_name == "closing":
		sprite.hide()

func spawn_enemies():
	var enemySpawn = randomEnemy.instance()
	enemySpawn.global_position = global_position
	get_parent().add_child(enemySpawn)
	spawnAmount -= 1
	if spawnAmount >= 0:
		timer.start(spawnTimer)


func _on_Timer_timeout():
	if spawnAmount <= 0:
		animationPlayer.play("closing")
	else:
		spawn_enemies()
