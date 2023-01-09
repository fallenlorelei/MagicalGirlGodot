extends "res://entities/EntityBase.gd"

export(int) var JUMP_SPEED = 110

var jump_vector = Vector2.LEFT
var abilityPressed setget set_attack
var mouseclick = Vector2()
var clickLocation = Vector2()

onready var hurtbox = $Hurtbox
onready var attackManager = $AttackManager
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


onready var move = $move
onready var jump = $jump


func _ready():
	animationTree.active = true

func _physics_process(delta): 
	match state:
		MOVE:
			move_state(delta)
		JUMP:
			jump_state()
		DEAD:
			dead_state()
			
			
#	== USE ABILITIES ==
	if state != JUMP or state != DEAD:
		if Input.is_action_just_pressed("left_click"):
			self.abilityPressed = 0

									
		if Input.is_action_just_pressed("ability1"):
			self.abilityPressed = 1


	if Input.is_action_just_pressed("jump") and state != JUMP:
		state = JUMP

#	== MOVING ==
func move_state(_delta):
	move.execute(self)

#	== ATTACKING ==
func set_attack(value):
	mouseclick = (get_global_mouse_position() - position).normalized()
	clickLocation = get_global_mouse_position()

	velocity = velocity.move_toward(Vector2.ZERO, ATTACK_FRICTION)

	attackManager.begin_attack(value)

func attack_animation_finished():
	state = MOVE
	move()

#	== JUMPING ==	
func jump_state():
	jump.execute(self)

func jump_landed():
	jump.landed(self)
	
func jump_animation_finished():
	jump.animation_finished(self)
	

#	== DYING ==	
func _on_Player_died():
	velocity = Vector2.ZERO
	state = DEAD

func dead_state():
	animationState.travel("death")
	
func death_animation_finished():
	die()
