class_name EntityBase extends KinematicBody2D

export(int) var ACCELERATION = 450
export(int) var MAX_SPEED = 80
export(int) var FRICTION = 550
export(int) var ATTACK_FRICTION = 100

var knockback = Vector2.ZERO
var input_vector = Vector2.ZERO
var playerStats = PlayerStats
var enemyStats


# Move 0, Jump 1, Attack 2, Casting 3, Wander 4, Idle 5, Chase 6, Dead 7, Dying 8
enum {
	MOVE,
	JUMP,
	ATTACK,
	CASTING,
	WANDER,
	IDLE,
	CHASE,
	DYING,
	DEAD
}

var velocity: Vector2 = Vector2.ZERO
var state = MOVE


func _ready():
	pass

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	move()
	
	
func move():
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Player") and area.skillType == "front_arc":
		var AP = area.global_position.direction_to(global_position)
		if AP.dot((get_global_mouse_position() - position).normalized()) > 0:
			skill_damage(area, "Player")
			
	elif area.is_in_group("Player"):
		skill_damage(area, "Player")
		
	else:
		skill_damage(area, "Enemy")
#
func skill_damage(area, group):
	if group == "Enemy":
		if playerStats.hp > 0:
			playerStats.receive_damage(area.skillDamage)
			if area.canKnockback == true:
				knockback = area.knockback_vector * area.knockbackModifier
			
	if group == "Player":
		if enemyStats.hp > 0:
			enemyStats.receive_damage(area.skillDamage)
