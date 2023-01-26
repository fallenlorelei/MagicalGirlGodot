extends "res://entities/EntityBase.gd"

onready var sprite = $Sprite
onready var attackManager = $AttackManager
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

export(int) var JUMP_SPEED = 110

export var minimap_icon = "icon"

var jump_vector = Vector2.LEFT
var cursorDirection = Vector2()
var cursorLocation = Vector2()
var selected_skill = null setget set_attack
var selected_skillSlot = null
var mouse_over_ui = false
var jumpFinished = false
var attackFinished = false
var dead = false
var map_pos = Vector2()
var saved_input_vector

func _ready():
	animationTree.active = true
	
	add_state("IDLE")
	add_state("MOVE")
	add_state("JUMP")
	add_state("CASTING")
	add_state("DYING")
	call_deferred("set_state", states.IDLE)
	
	PlayerStats.hpBar = get_node("../../CanvasLayer/BottomUI/VBoxContainer/HBoxContainer/HealthBar/PlayerHPBar")
	PlayerStats.hpBarAnimation = get_node("../../CanvasLayer/BottomUI/VBoxContainer/HBoxContainer/HealthBar/PlayerHPBar/AnimationPlayer")
	PlayerStats.connect("hp_changed", self, "health_changed")
	PlayerStats.connect("died", self, "begin_dying")
		
	SignalBus.connect("mouseover", self, "set_mouseover")
	SignalBus.connect("mouseOverLock", self, "set_mouseover")

# == STATE MACHINE ==
func _state_logic(delta):
	check_input()
	get_cursor_info()
	move(delta)
	
	match state:
		states.IDLE:
			idle_state(delta)
		states.MOVE:
			move_state(delta)
		states.JUMP:
			jump_state(delta)
		states.CASTING:
			casting_state()
		states.DYING:
			dying_state()

#MOVING FROM ONE STATE TO ANOTHER
func _get_transition(_delta):
	match state:
		states.IDLE:
			if begin_dying():
				return states.DYING
			if check_input() == "left_click" && mouse_over_ui == false:
				return states.CASTING
			if check_input() == "using_skill" && attackManager.check_global_cooldown():
				return states.CASTING
			if check_input() == "jump":
				return states.JUMP	
			if check_input() == "moving":
				return states.MOVE	

		states.MOVE:
			if begin_dying():
				return states.DYING
			if check_input() == "left_click" && mouse_over_ui == false:
				return states.CASTING
			if check_input() == "using_skill" && attackManager.check_global_cooldown():
				return states.CASTING
			if check_input() == "jump":
				return states.JUMP	
			if velocity == Vector2.ZERO:
				return states.IDLE

		states.JUMP:
			if begin_dying():
				return states.DYING
			if jumpFinished == true:
				return states.IDLE

		states.CASTING:
			if begin_dying():
				return states.DYING
			if attackFinished == true && attackManager.attackAnimationTimer.is_stopped():
				return states.IDLE
		
		states.DYING:
			pass
			
func _enter_state(new_state, old_state):
	match new_state:
		states.IDLE:
			animationState.travel("Idle")
		states.MOVE:
			animationState.travel("Run")
		states.JUMP:
			update_input_vector()
			animationState.travel("Jump")				
		states.CASTING:
			update_input_vector()
		states.DYING:
			animationState.travel("death")
	
func _exit_state(old_state, new_state):
	match old_state:
		states.JUMP:
			jumpFinished = false
			reset_collision_masks()
		states.CASTING:
			attackFinished = false
	
# ========================================

func get_cursor_info():
	cursorDirection = (get_global_mouse_position() - position).normalized()
	cursorLocation = get_global_mouse_position()

func check_input():
	if selected_skill != null && selected_skillSlot != "left_click":
		if Input.is_action_pressed(str(selected_skillSlot)):
			return "using_skill"
			
	if Input.is_action_just_pressed("jump"):
		return "jump"
		
	if Input.is_action_just_pressed("left_click"):
		selected_skill = "Basic"
		selected_skillSlot = "left_click"
		return "left_click"
		
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

func casting_state():
	velocity = velocity.move_toward(Vector2.ZERO, ATTACK_FRICTION)	
	if selected_skill != null:
		if Input.is_action_pressed(str(selected_skillSlot)):
			attackManager.start_ability(selected_skill, selected_skillSlot)

func attack_animation_finished():
	attackFinished = true

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
	if PlayerStats.hp == 0:
		dead = true
	
func dying_state():
	velocity = Vector2.ZERO
	
func death_animation_finished():
	PlayerStats.die()
	
# == TAKING DAMAGE ==	
func health_changed(new_hp):
	PlayerStats.hpBarUpdate(new_hp)

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
