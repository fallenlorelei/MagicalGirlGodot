extends "res://entities/EntityBase.gd"

export(int) var JUMP_SPEED = 110

var jump_vector = Vector2.LEFT
#var abilityPressed setget set_attack
var cursorDirection = Vector2()
var cursorLocation = Vector2()
var selected_skill = "skill" setget set_attack

onready var hurtbox = $Hurtbox
onready var attackManager = $AttackManager
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(delta): 
	match state:
		MOVE:
			move_state(delta)
		JUMP:
			jump_state()
		DYING:
			dead_state()
			
			
#	== USE ABILITIES ==
	if state != JUMP or state != DEAD:
		if Input.is_action_just_pressed("left_click"):
			self.selected_skill = "Basic"

	if Input.is_action_just_pressed("jump") and state != JUMP:
		state = JUMP
	
#	== MOVING ==
func move_state(delta):
	if attackManager.attackAnimationTimer.is_stopped():
		if input_vector != Vector2.ZERO:
			jump_vector = input_vector
	#		
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationTree.set("parameters/Jump/blend_position", input_vector)
			
			animationState.travel("Run")
			
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			
		else:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

		move()


#	== ATTACKING ==
func set_attack(value):
	cursorDirection = (get_global_mouse_position() - position).normalized()
	cursorLocation = get_global_mouse_position()
	
	velocity = velocity.move_toward(Vector2.ZERO, ATTACK_FRICTION)
	
	if attackManager.check_global_cooldown():
		print("player use ability: ", value)
		attackManager.use_ability(value)
		
func attack_animation_finished():
	state = MOVE
	move()

#	== JUMPING ==	
func jump_state():
	if input_vector != Vector2.ZERO:
		velocity = input_vector * JUMP_SPEED
	else:
		velocity = jump_vector * JUMP_SPEED
		
	animationState.travel("Jump")
	velocity = move_and_slide(velocity)
	
	# Sets collision mask so that girl can jump through enemies
	# This is reset when jump animation is finished
	# Current problem: I would like the slimes to still "see" her when she's jumping, to chase, just not collide
	set_collision_layer_bit(1, false)
	set_collision_layer_bit(4, true)
	set_collision_mask_bit(2, false)
	hurtbox.set_collision_layer_bit(5, false)

func jump_landed():
	velocity = Vector2.ZERO
	
func jump_animation_finished():
	velocity = Vector2.ZERO
	set_collision_layer_bit(1, true)
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(2, true)
	hurtbox.set_collision_layer_bit(5, true)
	state = 0
	

#	== DYING ==	
func dead_state():
	velocity = Vector2.ZERO
	animationState.travel("death")
	
func death_animation_finished():
	die()
