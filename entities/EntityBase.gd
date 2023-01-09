class_name EntityBase extends KinematicBody2D

signal hp_max_changed(new_hp_max)
signal hp_changed(new_hp)
signal died

#onready var sprite = $Sprite
#onready var collisionShape = $CollisionShape2D
#onready var animationPlayer = $AnimationPlayer
#onready var hurtbox = $Hurtbox

export(int) var hp_max = 100 setget set_hp_max
export(int) var hp = hp_max setget set_hp
export(int) var defense = 0
export(float) var invincibleDuration = .5

export(int) var ACCELERATION = 450
export(int) var MAX_SPEED = 80
export(int) var FRICTION = 550
export(int) var TOLERANCE = 60
export(int) var ATTACK_FRICTION = 100

var knockback = Vector2.ZERO
var input_vector = Vector2.ZERO

# Move 0, Jump 1, Attack 2, Wander 3, Idle 4, Chase 5, Dead 6
enum {
	MOVE,
	JUMP,
	ATTACK,
	WANDER,
	IDLE,
	CHASE,
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

func receive_damage(base_damage):
	var actual_damage = base_damage
	actual_damage -= defense	
	self.hp -= actual_damage
	return actual_damage
	
func _on_Hurtbox_area_entered(hitbox):
	var actual_damage = receive_damage(hitbox.damage)
	
	if hitbox.knocksback == true and hitbox.is_in_group("Player"):
		knockback = hitbox.knockback_vector * hitbox.knockbackModifier
		
	if hitbox.is_in_group("Projectile"):
		hitbox.destroy()
		
	print(name + " received " + str(actual_damage) + " damage.")

func _on_EntityBase_died():
	velocity = Vector2.ZERO
	state = DEAD
