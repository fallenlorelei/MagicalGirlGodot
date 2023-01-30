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
var states = {}

func _ready():
	pass

func _physics_process(delta):
	pass
	
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
			knockback = area.knockback_vector * area.knockbackModifier
			
	if group == "Player":
		if enemyStats.hp > 0:
			enemyStats.receive_damage(area.skillDamage)
			knockback = area.knockback_vector * area.knockbackModifier
