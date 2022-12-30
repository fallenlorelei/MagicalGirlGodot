extends KinematicBody2D

onready var enemyManager = $EnemyManager

var velocity = Vector2.ZERO


func _ready():
	velocity = enemyManager.velocity

func _on_EnemyManager_start_movement():
	velocity = enemyManager.velocity
	velocity = move_and_slide(velocity)

