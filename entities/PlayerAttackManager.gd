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
var outOfBounds = false
var castingCircleRotatingPosition
var parent
			
func _ready():
	parent = get_parent()
	castingCircleRotatingPosition = 0.0

func _physics_process(_delta):
	parentCursorDirection = parent.cursorDirection
	parentCursorLocation = parent.cursorLocation
	
#	var cursorLocation = get_local_mouse_position()
#	var cursorDirection = (get_global_mouse_position() - position).normalized()

	if skillName != null:
		parent.animationTree.set("parameters/Attack/blend_position", parentCursorDirection)
		parent.animationTree.set("parameters/Idle/blend_position", parentCursorDirection)
		parent.animationTree.set("parameters/Run/blend_position", parentCursorDirection)
		
		# MOVING CAST PREVIEWS
		if DataImport.skill_data[skillName].SkillType == "at_cursor":
			castingCircleSprite.global_position = parentCursorLocation
			
		if DataImport.skill_data[skillName].SkillType == "around_self":
			castingCircleSprite.global_position = global_position + Vector2(0,6)
		
		if DataImport.skill_data[skillName].SkillType == "full_view":
			castingCircleSprite.global_position = global_position + Vector2(0,6)
			
		if DataImport.skill_data[skillName].SkillType == "projectile":	
			projectileLine.set_point_position(0,Vector2(0,0))
			var length = parentCursorDirection * distance
			projectileLine.set_point_position(1,length)
			
		if DataImport.skill_data[skillName].SkillType == "front_arc":
			frontArcPreview.look_at(parentCursorLocation)
		
		# Some abilities can still be cast if they are out of bounds
		var canCastOutOfBounds
		if DataImport.skill_data[skillName].SkillType == "at_cursor":
			canCastOutOfBounds = false
		else:
			canCastOutOfBounds = true

		# Checking "distance" of skill. Flashes circle if out of bounds.
		# Extra coding so switching back to "rotate" is seamless
		if distance != null and global_position.distance_to(parentCursorLocation) > distance:
			if castingCircleAnimation.current_animation == "rotate":
				castingCircleRotatingPosition = castingCircleAnimation.current_animation_position
			castingCircleAnimation.play("flashing")
			if canCastOutOfBounds == false:
				outOfBounds = true
		else:
			castingCircleAnimation.play("rotate")
			if castingCircleAnimation.current_animation_position == 0.0:
				castingCircleAnimation.advance(castingCircleRotatingPosition)
			outOfBounds = false
		
		# CANCELING
		if Input.is_action_pressed(str(skillShortcut)):
			if Input.is_action_just_pressed("right_click"):
				stop_casting()
		
		# CANCELING OR RELEASING
		if Input.is_action_just_released(str(skillShortcut)) and skillName != null:
			if outOfBounds == true:
				stop_casting()
			else:
				release_ability()
		
		# RELEASE IF LEFT CLICK
		if skillShortcut == "left_click" and parent.mouse_over_ui == false:
			release_ability()

func check_global_cooldown():
	return globalCooldown.is_stopped()

#Func starts from Player.gd
func start_ability(selected_skill, selected_shortcut):
	skillName = selected_skill
	skillShortcut = selected_shortcut
	distance = DataImport.skill_data[skillName].Distance

	if selected_skill != null:

		#Showing casting circle if relevant
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
	
	if type == "at_cursor" or type == "around_self" or type == "full_view":
		var sizeto = Vector2(radiusSize,radiusSize)
		var size = castingCircleSprite.texture.get_size()
		var scale_factor = sizeto/size * 2
		
		castingCircleSprite.scale = Vector2(0,0)
		castingCircleSprite.z_index = zindex
		
		var TW = get_tree().create_tween()
		TW.tween_property(castingCircleSprite, "scale", scale_factor, .2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		castingCircleSprite.show()
	
	if type == "projectile":
		projectileLine.width = radiusSize * 2
		projectileLine.z_index = zindex
		projectileLine.show()
	
	if type == "front_arc":
		var sizeto = Vector2(radiusSize,radiusSize)
		var size = castingCircleSprite.texture.get_size()
		var scale_factor = sizeto/size * 2
		frontArcPreview.scale = scale_factor
		frontArcPreview.z_index = zindex
		frontArcPreview.show()

# == RELEASE ABILITY ==
func release_ability():
	skillElement = DataImport.skill_data[skillName].Element
	var loadedAbility = load_ability(skillName)
	var ability = loadedAbility.instance()
	ability.skillName = skillName

	attack_animation()
	globalCooldown.start()
	cooldownTracker.start_cooldown(skillName, skillShortcut)

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
		"around_self":
			ability.global_position = self.global_position
			get_tree().get_current_scene().add_child(ability)
			ability.around_self()

		"full_view":
			ability.global_position = self.global_position
			get_tree().get_current_scene().add_child(ability)
			ability.around_self()

		"front_arc":
			ability.cursorDirection = parentCursorDirection
			ability.global_position = self.global_position
			var ability_rotation = self.global_position.direction_to(parentCursorLocation).angle()
			ability.rotation = ability_rotation
			get_tree().get_current_scene().add_child(ability)
			ability.front_arc()
#
		"projectile":
			ability.cursorDirection = parentCursorDirection
			ability.global_position = self.global_position
			var ability_rotation = self.global_position.direction_to(parentCursorLocation).angle()
			ability.rotation = ability_rotation
			get_tree().get_current_scene().add_child(ability)
			ability.projectile()

	stop_casting()

func stop_casting():
	parent.state = 0
	var TW = get_tree().create_tween()
	TW.tween_property(castingCircleSprite, "scale", Vector2(0,0), .2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	projectileLine.hide()
	frontArcPreview.hide()
	skillName = null
	
func load_ability(skillName):
	if skillName != null:
		var path = "res://abilities/" + skillElement + "/" + skillName + "/" + skillName + ".tscn"
		return load(path)


func attack_animation():
	parent.state = 5
	parent.animationState.travel("Attack")
	if attackAnimationTimer.is_stopped():
		attackAnimationTimer.start()
