extends KinematicBody2D

onready var enemyManager = $EnemyManager

var velocity = Vector2.ZERO

#func _physics_process(delta):
#	velocity = get_node("EnemyManager").velocity
#	velocity = move_and_slide(velocity)

func _ready():
	velocity = get_node("EnemyManager").velocity

func _on_EnemyManager_start_movement():
	velocity = get_node("EnemyManager").velocity
	velocity = move_and_slide(velocity)
