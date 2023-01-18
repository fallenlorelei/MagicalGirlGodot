class_name EntityBase extends KinematicBody2D

signal hp_max_changed(new_hp_max)
signal hp_changed(new_hp)
signal died

export(int) var hp_max = 100 setget set_hp_max
export(int) var hp = hp_max setget set_hp
export(int) var defense = 0
export(float) var invincibleDuration = .5

export(int) var ACCELERATION = 450
export(int) var MAX_SPEED = 80
export(int) var FRICTION = 550
export(int) var ATTACK_FRICTION = 100

var knockback = Vector2.ZERO
var input_vector = Vector2.ZERO
var hpPercentage
var hpBar
var hpBarAnimation

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


func set_hp_max(value):
	if value != hp_max:
		hp_max = max(0, value)
		emit_signal("hp_max_changed", hp_max)
		self.hp = hp
		
		
func set_hp(value):
	if value != hp:
		hp = clamp(value, 0, hp_max)
		emit_signal("hp_changed", hp)
		
		if hp == 0:
			emit_signal("died")
			state = DYING

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

func die():
	queue_free()

	
func _on_Hurtbox_area_entered(area):
	
	if area.is_in_group("Player") and area.skillType == "front_arc":
		var AP = area.global_position.direction_to(global_position)
		if AP.dot((get_global_mouse_position() - position).normalized()) > 0:
			skill_damage(area)
	else:
		skill_damage(area)

func skill_damage(area):
	receive_damage(area.skillDamage)
	if area.canKnockback == true and area.is_in_group("Player"):
		knockback = area.knockback_vector * area.knockbackModifier
	
func receive_damage(base_damage):
	var actual_damage = base_damage
	actual_damage -= defense	
	self.hp -= actual_damage
	return actual_damage

func hpBarUpdate(hp):
	if hp < hp_max:
		hpBar.show()
		
	hpPercentage = int((float(hp) / hp_max) * 100)

	var TW = get_tree().create_tween()
	TW.tween_property(hpBar, "value", float(hpPercentage), .2)
	
	if hpPercentage > 75:
		hpBar.set_tint_progress("7ac240")
	elif hpPercentage <= 75 and hpPercentage >=30:
		TW.tween_property(hpBar, "tint_progress", Color(0.870588, 0.415686, 0.219608), .2)
	else:
		TW.tween_property(hpBar, "tint_progress", Color(0.65098, 0.192157, 0.27451), .2)
	
	if hpBar.is_in_group("Player"):
		hpBarAnimation.play("shake")
		yield(hpBarAnimation, "animation_finished")
