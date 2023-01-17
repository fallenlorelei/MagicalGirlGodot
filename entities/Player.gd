extends "res://entities/EntityBase.gd"

export(int) var JUMP_SPEED = 110

var jump_vector = Vector2.LEFT
#var abilityPressed setget set_attack
var cursorDirection = Vector2()
var cursorLocation = Vector2()
var selected_skill = "skill" setget set_attack
var selected_skillSlot = ""
var mouse_over_ui = false

onready var sprite = $Sprite
onready var hurtbox = $Hurtbox
onready var attackManager = $AttackManager
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var skillbar = get_node("../../CanvasLayer/BottomUI/VBoxContainer/SkillBar")
onready var crystalMouseoverBox = get_node("../../CanvasLayer/CrystalCounter/")


func _ready():
	animationTree.active = true
	hpBar = get_node("../../CanvasLayer/BottomUI/VBoxContainer/HBoxContainer/HealthBar/PlayerHPBar")
	hpBarAnimation = get_node("../../CanvasLayer/BottomUI/VBoxContainer/HBoxContainer/HealthBar/PlayerHPBar/AnimationPlayer")
	# Connecting skillbar to stop left-click attack when dragging abilities
#	skillbar = get_node("../../CanvasLayer/SkillBar")
	skillbar.connect("mouseover", self, "set_mouseover")
	crystalMouseoverBox.connect("mouseOverLock", self, "set_mouseover")

func _physics_process(delta): 
	match state:
		MOVE:
			move_state(delta)
		JUMP:
			jump_state()
		DYING:
			dead_state()
	
	cursorDirection = (get_global_mouse_position() - position).normalized()
	cursorLocation = get_global_mouse_position()
			
#	== USE ABILITIES ==
	if state != JUMP or state != DEAD:
		if Input.is_action_just_pressed("left_click") and mouse_over_ui == false:
			self.selected_skillSlot = "Skill0"
			self.selected_skill = "Basic"

	if Input.is_action_just_pressed("jump") and state != JUMP:
		state = JUMP
	
#	== MOVING ==
func move_state(delta):
	if attackManager.attackAnimationTimer.is_stopped():
		if input_vector != Vector2.ZERO:
			jump_vector = input_vector
			
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
	velocity = velocity.move_toward(Vector2.ZERO, ATTACK_FRICTION)
	
	if attackManager.check_global_cooldown():
		var skillShortcut
		
		if selected_skillSlot == "Skill0":
			skillShortcut = "left_click"
		if selected_skillSlot == "Skill1":
			skillShortcut = "ability1"
		if selected_skillSlot == "Skill2":
			skillShortcut = "ability2"
		if selected_skillSlot == "Skill3":
			skillShortcut = "ability3"
		if selected_skillSlot == "Skill4":
			skillShortcut = "ability4"
		if selected_skillSlot == "Skill5":
			skillShortcut = "ability5"
		if selected_skillSlot == "Skill6":
			skillShortcut = "ability6"
			
		if value != null:
			if Input.is_action_pressed(str(skillShortcut)):
				print("Used ability: ", value)
				attackManager.start_ability(value, skillShortcut)
		
func attack_animation_finished():
	state = MOVE
	move()

func set_mouseover():
	if skillbar.mouse_over_ui == true:
		mouse_over_ui = true
	else:
		mouse_over_ui = false
		
	if crystalMouseoverBox.mouseOverLock == true:
		mouse_over_ui = true
	else:
		mouse_over_ui = false

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
	

# == TAKING DAMAGE ==
func _on_Player_hp_changed(new_hp):
	hpBarUpdate(new_hp)


# == UTILITY ==
func heal(healAmount):
	hp += healAmount
	var TW = create_tween()
	TW.tween_property(sprite, "modulate", Color.green, .2)
	TW.tween_property(sprite, "modulate", Color(1, 1, 1), .2)

#	== DYING ==	
func dead_state():
	velocity = Vector2.ZERO
	animationState.travel("death")
	
func death_animation_finished():
	die()
