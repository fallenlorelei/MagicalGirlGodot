extends KinematicBody2D

const EnemyDeathEffect = preload("res://enemies/enemy_effects/SlimeDeath.tscn")

onready var enemyManager = $EnemyManager


var velocity = Vector2.ZERO


func _ready():
	velocity = enemyManager.velocity

func _on_EnemyManager_start_movement():
	velocity = enemyManager.velocity
	velocity = move_and_slide(velocity)


func _on_EnemyManager_death_effect():
	var enemyDeathEffect = EnemyDeathEffect.instance()
	enemyDeathEffect.global_position = global_position - Vector2(0,17)
	get_parent().add_child(enemyDeathEffect)
