extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var sprite = $Sprite
onready var ySort = $"../../YSort"

export(float) var spawnTimer = 1.0
export var spawnAmount_min = 2
export var spawnAmount_max = 6

var spawnAmount
var randomEnemy
var portalOpened = false

var enemy_dict = {
	"Slime": preload("res://enemies/Slime.tscn"),
	}

func _ready():
	spawnAmount = int(rand_range(spawnAmount_min, spawnAmount_max))
	
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
		queue_free()

func spawn_enemies():
	var enemySpawn = get_random_enemy().instance()
	enemySpawn.global_position = global_position
	ySort.add_child(enemySpawn)
	spawnAmount -= 1
	if spawnAmount >= 0:
		timer.start(spawnTimer)


func _on_Timer_timeout():
	if spawnAmount <= 0:
		animationPlayer.play("closing")
	else:
		spawn_enemies()


func _on_PlayerActivate_body_entered(body):
	if portalOpened == false:
		portalOpened = true
		sprite.show()
		animationPlayer.play("opening")
		yield(animationPlayer, "animation_finished")
