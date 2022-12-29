extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 100
export var FRICTION = 500
export var JUMP_SPEED = 150

enum {
	MOVE,
	JUMP,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var jump_vector = Vector2.DOWN

onready var animationPlayer = $"%AnimationPlayer"
onready var animationTree = $"%AnimationTree"
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.active = true


func _process(_delta):
	pass

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		JUMP:
			jump_state(delta)
		ATTACK:
			attack_state(delta)
	

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
	if Input.is_action_just_pressed("ability1") or Input.is_action_just_pressed("left_click"):
		state = ATTACK
		
func jump_state(_delta):
	velocity = jump_vector * JUMP_SPEED
	animationState.travel("Jump")
	move()
#
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func jump_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE
#
func attack_animation_finished():
	state = MOVE
