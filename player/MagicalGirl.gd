extends KinematicBody2D

export var ACCELERATION = 600
export var MAX_SPEED = 130
export var FRICTION = 650
export var JUMP_SPEED = 200

enum {
	MOVE,
	JUMP,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var jump_vector = Vector2.DOWN

var attack_manager : Node2D

onready var animationPlayer = $"%AnimationPlayer"
onready var animationTree = $"%AnimationTree"
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.active = true
	attack_manager = get_node("AttackManager") 


func _process(_delta):
	pass

func _physics_process(delta): 
	if state != JUMP:
		if Input.is_action_pressed("ability1") or Input.is_action_pressed("left_click"):
			attack_state(delta, 'shoot', 'shootAttack', 250, { 'origin': get_global_position() })
		if Input.is_action_pressed("ability2"):
			attack_state(delta, 'gem', 'staticAttack', 3000, { 'origin': get_global_mouse_position() })
	match state:
		MOVE:
			move_state(delta)
		JUMP:
			jump_state(delta)
	

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		jump_vector = input_vector
#		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Jump/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("jump"):
		state = JUMP
#
		
		
func jump_state(delta):
	velocity = jump_vector * JUMP_SPEED
	animationState.travel("Jump")
	velocity = move_and_collide(velocity * delta)
	# Sets collision mask so that girl can jump through enemies
	# This is reset when jump animation is finished
	# Current problem: I would like the slimes to still "see" her when she's jumping, to chase, just not collide
	set_collision_mask_bit(2, false)
	set_collision_layer_bit(1, false)
	set_collision_layer_bit(4, true)
#
func attack_state(_delta, uid, type, time, params = {}):
	# velocity = Vector2.ZERO
	attack_manager.attack(uid, type, time, params)
	var mouseclick = (get_global_mouse_position() - position).normalized()
	animationTree.set("parameters/Attack/blend_position", mouseclick)
	animationState.travel("Attack")
	
	attack_manager.attack('basic', 'shoot', 250)

func move():
	velocity = move_and_slide(velocity)

func jump_landed():
	# I want to remove the slide when the sprite lands but it doesn't do much right now
	velocity = Vector2.ZERO


func jump_animation_finished():
	velocity = Vector2.ZERO
	# Resetting collision mask so player once again collides with enemies after jumping
	set_collision_mask_bit(2, true)
	set_collision_layer_bit(1, true)
	set_collision_layer_bit(4, false)
	state = MOVE
#
func attack_animation_finished():
	state = MOVE
