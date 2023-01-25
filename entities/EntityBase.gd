class_name EntityBase extends KinematicBody2D

onready var hurtbox = $Hurtbox

export(int) var ACCELERATION = 100
export(int) var MAX_SPEED = 120
export(int) var FRICTION = 100
export(int) var ATTACK_FRICTION = 100

var knockback = Vector2.ZERO
var input_vector = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var enemyStats
var state = null setget set_state
var previous_state = null
var states = {}

func _ready():
	pass

func _physics_process(delta):	
	if state !=null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

# == STATE MACHINE ==
func _state_logic(delta):
	pass
	
func _get_transition(delta):
	return null
	
func _enter_state(new_state, old_state):
	pass
	
func _exit_state(old_state, new_state):
	pass
	
func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state !=null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)
		
func add_state(state_name):
	states[state_name] = states.size()
	
# ===========================================
	
func move(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
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
	
	hurtbox.create_hit_effect(area, self)

#
func skill_damage(area, group):
	if group == "Enemy":
		if is_instance_valid(PlayerStats) and PlayerStats.hp > 0:
			PlayerStats.receive_damage(area.skillDamage)
			if area.canKnockback == true:
				knockback = area.knockback_vector * area.knockbackModifier
			
	if group == "Player":
		if enemyStats.hp > 0:
			enemyStats.receive_damage(area.skillDamage)
			if area.canKnockback == true:
				knockback = area.knockback_vector * area.knockbackModifier
