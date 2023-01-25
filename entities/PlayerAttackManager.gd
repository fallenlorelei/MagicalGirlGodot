extends Node2D

onready var attackAnimationTimer = $AttackAnimationTimer
onready var globalCooldown = $GlobalCooldown
onready var castingCircleSprite = $CastingCircle
onready var castingCircleAnimation = $CastingCircle/AnimationPlayer
onready var projectileLine = $ProjectilePreview
onready var frontArcPreview = $FrontArcPreview

var cooldownTracker = CooldownTracker
var parentCursorDirection
var parentCursorLocation
var skillName
var skillShortcut
var skillElement
var distance
var castingCircleRotatingPosition
var parent
			
func _ready():
	parent = get_parent()
	castingCircleRotatingPosition = 0.0

func _physics_process(_delta):
	parentCursorDirection = parent.cursorDirection
	parentCursorLocation = parent.cursorLocation
	if skillName != null:
		set_animation_blend()
		update_visual_cast()
		check_out_of_bounds()
		check_input()

func set_animation_blend():
	parent.animationTree.set("parameters/Attack/blend_position", parentCursorDirection)
	parent.animationTree.set("parameters/Idle/blend_position", parentCursorDirection)
	parent.animationTree.set("parameters/Run/blend_position", parentCursorDirection)

func update_visual_cast():
	match DataImport.skill_data[skillName].SkillType:
		"at_cursor":
			castingCircleSprite.global_position = parentCursorLocation
			
		"around_self":
			castingCircleSprite.global_position = global_position + Vector2(0,6)
		
		"full_view":
			castingCircleSprite.global_position = global_position + Vector2(0,6)
			
		"projectile":	
			projectileLine.set_point_position(0,Vector2(0,0))
			var length = parentCursorDirection * distance
			projectileLine.set_point_position(1,length)
			
		"front_arc":
			frontArcPreview.look_at(parentCursorLocation)

func check_out_of_bounds():
# Only "at cursor" abilities can't be cast out of bounds
	if DataImport.skill_data[skillName].SkillType == "at_cursor":
		if global_position.distance_to(parentCursorLocation) > distance:
			if castingCircleAnimation.current_animation == "rotate":
				castingCircleRotatingPosition = castingCircleAnimation.current_animation_position
			castingCircleAnimation.play("flashing")
			return true
		else:
			castingCircleAnimation.play("rotate")
			if castingCircleAnimation.current_animation_position == 0.0:
				castingCircleAnimation.advance(castingCircleRotatingPosition)
			return false

func check_input():
# CANCELING
	if Input.is_action_pressed(str(skillShortcut)):
		if Input.is_action_just_pressed("right_click"):
			stop_casting()
	
# OUT OF BOUNDS OR RELEASING
	if Input.is_action_just_released(str(skillShortcut)) and skillName != null:
		if check_out_of_bounds():
			stop_casting()
		else:
			release_ability()
	
# AUTOMATIC RELEASE IF LEFT CLICK
	if skillShortcut == "left_click":
		release_ability()

#Func starts from Player.gd
func start_ability(selected_skill, selected_shortcut):
	skillName = selected_skill
	skillShortcut = selected_shortcut
	distance = DataImport.skill_data[skillName].Distance

	if selected_skill != null:
		match DataImport.skill_data[skillName].SkillType:
			"at_cursor":
				show_casting(1, "at_cursor")
			"self_utility":
				pass
			"full_view":
				show_casting(-1, "around_self")
			"around_self":
				show_casting(-1, "around_self")
			"front_arc":
				show_casting(-1, "front_arc")
			"projectile":
				show_casting(-1, "projectile")

# == HOLDING DOWN HOTKEY, SHOWING PREVIEW ==
func show_casting(zindex, type):
	#Resize casting circle to size of collision
	var radiusSize = DataImport.skill_data[skillName].SkillRadius
	match type:
		"at_cursor", "around_self", "full_view":
			var sizeto = Vector2(radiusSize,radiusSize)
			var size = castingCircleSprite.texture.get_size()
			var scale_factor = sizeto/size * 2
			
			castingCircleSprite.scale = Vector2(0,0)
			castingCircleSprite.z_index = zindex
			
			var TW = get_tree().create_tween()
			TW.tween_property(castingCircleSprite, "scale", scale_factor, .2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			castingCircleSprite.show()
			
		"projectile":
			projectileLine.width = radiusSize * 2
			projectileLine.z_index = zindex
			projectileLine.show()
		
		"front_arc":
			var sizeto = Vector2(radiusSize,radiusSize)
			var size = castingCircleSprite.texture.get_size()
			var scale_factor = sizeto/size * 2
			frontArcPreview.scale = scale_factor
			frontArcPreview.z_index = zindex
			frontArcPreview.show()

# == RELEASE ABILITY ==
func release_ability():
	attack_animation()
	globalCooldown.start()
	cooldownTracker.start_cooldown(skillName, skillShortcut)
	
	skillElement = DataImport.skill_data[skillName].Element
	var loadedAbility = load_ability(skillName)
	var ability = loadedAbility.instance()
	ability.skillName = skillName

	match DataImport.skill_data[skillName].SkillType:
		"at_cursor":			
			ability.global_position = parentCursorLocation
			var ability_rotation = self.global_position.direction_to(parentCursorLocation)
			get_tree().get_current_scene().add_child(ability)
			ability.skillSprite.flip_h = ability_rotation.x < 0
			if ability_rotation.x > 0:
				ability.particles.scale = Vector2(1,1)
			else:
				ability.particles.scale = Vector2(-1,1)
			ability.at_cursor()
#
		"self_utility":
			add_child(ability)
#
		"around_self", "full_view":
			ability.global_position = self.global_position
			get_tree().get_current_scene().add_child(ability)
			ability.around_self()


		"front_arc", "projectile":
			ability.cursorDirection = parentCursorDirection
			ability.global_position = self.global_position
			var ability_rotation = self.global_position.direction_to(parentCursorLocation).angle()
			ability.rotation = ability_rotation
			get_tree().get_current_scene().add_child(ability)
			ability.front_arc()

	stop_casting()

func stop_casting():
	var TW = get_tree().create_tween()
	TW.tween_property(castingCircleSprite, "scale", Vector2(0,0), .2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	projectileLine.hide()
	frontArcPreview.hide()
	skillName = null
	parent.selected_skill = null
	parent.selected_skillSlot = null
	parent.attackFinished = true
	
func load_ability(skill_name):
	if skillName != null:
		var path = "res://abilities/" + skillElement + "/" + skill_name + "/" + skill_name + ".tscn"
		return load(path)

func attack_animation():
	parent.animationState.travel("Attack")
	if attackAnimationTimer.is_stopped():
		attackAnimationTimer.start()

func check_global_cooldown():
	return globalCooldown.is_stopped()
