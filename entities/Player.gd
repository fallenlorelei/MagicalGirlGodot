extends "res://entities/EntityBase.gd"

onready var sprite = $Sprite
onready var attackManager = $AttackManager
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var skillManager = $SkillManager

export(int) var JUMP_SPEED = 110

export var minimap_icon = "icon"

var jump_vector = Vector2.LEFT
var cursorDirection = Vector2()
var cursorLocation = Vector2()
var selectedSkill = null setget set_attack
var selected_skill = null
var selected_skillSlot = null
var mouse_over_ui = false
var jumpFinished = false
var attackAnimationFinished = false
var releaseAbility = false
var cancelled = false
var dead = false
var map_pos = Vector2()
var saved_input_vector

func _ready():
	animationTree.active = true
	playerStats = $PlayerStats
	playerStats.parent_group = "Player"
	SignalBus.connect("died", self, "begin_dying")
	SignalBus.connect("mouseover", self, "set_mouseover")
	SignalBus.connect("mouseOverLock", self, "set_mouseover")
	SignalBus.emit_signal("update_player_hp_bar", playerStats.hp, playerStats.hp_max)

func get_cursor_info():
	cursorDirection = (get_global_mouse_position() - position).normalized()
	cursorLocation = get_global_mouse_position()
	
func check_input():
	if selected_skill != null:
		if Input.is_action_just_pressed(str(selected_skillSlot)):
			return "using_skill"
			
	if Input.is_action_just_pressed("jump"):
		return "jump"
		
	if Input.is_action_pressed("up") or \
	Input.is_action_pressed("down") or \
	Input.is_action_pressed("left") or \
	Input.is_action_pressed("right"):
		return "moving"
		
func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
#	== MOVING ==
func move_state(_delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	update_input_vector()
	set_animation_blend()
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)

func update_input_vector():
	if input_vector != Vector2.ZERO:
		saved_input_vector = input_vector
		jump_vector = input_vector

func set_animation_blend():
	animationTree.set("parameters/Idle/blend_position", saved_input_vector)
	animationTree.set("parameters/Run/blend_position", saved_input_vector)
	animationTree.set("parameters/Jump/blend_position", saved_input_vector)
	animationTree.set("parameters/Attack/blend_position", saved_input_vector)
	
#	== ATTACKING ==
func set_attack(value):
	selected_skill = value
	
func begin_cast():
	velocity = velocity.move_toward(input_vector * (MAX_SPEED/2), FRICTION)	
	if selected_skill != null:
		if Input.is_action_pressed(str(selected_skillSlot)):
			attackManager.start_ability(selected_skill, selected_skillSlot)

func casting():
	pass
	
func attack_animation_finished():
	attackAnimationFinished = true
	
#	== JUMPING ==	
func jump_state(_delta):
	if input_vector != Vector2.ZERO:
		velocity = saved_input_vector * JUMP_SPEED
	else:
		velocity = jump_vector * JUMP_SPEED
		
	velocity = move_and_slide(velocity)
	
# Sets collision mask so that girl can jump through enemies
# This is reset when jump animation is finished
# Current problem: I would like the slimes to still "see" her when she's jumping, to chase, just not collide
	turn_off_collision_masks()

#Trying to stop the slide after jumping but it's not really working
func jump_landed():
	velocity = Vector2.ZERO
	
func jump_animation_finished():
	jumpFinished = true

#	== DYING ==	
func begin_dying():
	dead = true
	
func dying_state():
	velocity = Vector2.ZERO
	
func death_animation_finished():
	playerStats.die()

func set_mouseover(TF):
	if TF == true:
		mouse_over_ui = true
	else:
		mouse_over_ui = false
		
func turn_off_collision_masks():
	set_collision_layer_bit(1, false)
	set_collision_layer_bit(4, true)
	set_collision_mask_bit(2, false)
	hurtbox.set_collision_layer_bit(5, false)
	
func reset_collision_masks():
	set_collision_layer_bit(1, true)
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(2, true)
	hurtbox.set_collision_layer_bit(5, true)
