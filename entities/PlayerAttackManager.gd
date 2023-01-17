extends Node2D

onready var attackAnimationTimer = $AttackAnimationTimer
onready var globalCooldown = $GlobalCooldown
onready var castingCircleSprite = $CastingCircle
onready var castingCircleAnimation = $CastingCircle/AnimationPlayer

var parentCursorDirection
var parentCursorLocation
var skillName
var skillShortcut
var skillElement
var distance
var outOfBounds = false
var rotatingPosition

func _ready():
	rotatingPosition = 0.0

func _physics_process(_delta):
	parentCursorDirection = get_parent().cursorDirection
	parentCursorLocation = get_parent().cursorLocation
	
	castingCircleSprite.global_position = parentCursorLocation

	if skillName != null:
		get_parent().animationTree.set("parameters/Attack/blend_position", parentCursorDirection)
		get_parent().animationTree.set("parameters/Idle/blend_position", parentCursorDirection)
		get_parent().animationTree.set("parameters/Run/blend_position", parentCursorDirection)
		
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
				rotatingPosition = castingCircleAnimation.current_animation_position
			castingCircleAnimation.play("flashing")
			if canCastOutOfBounds == false:
				outOfBounds = true
		else:
			castingCircleAnimation.play("rotate")
			if castingCircleAnimation.current_animation_position == 0.0:
				castingCircleAnimation.advance(rotatingPosition)
			outOfBounds = false
		
		# Canceling ability
		if Input.is_action_pressed(str(skillShortcut)):
			if Input.is_action_just_pressed("right_click"):
				stop_casting()
		
		if Input.is_action_just_released(str(skillShortcut)) and skillName != null:
			if outOfBounds == true:
				stop_casting()
			else:
				release_ability()

func stop_casting():
	get_parent().state = 0
	var TW = get_tree().create_tween()
	TW.tween_property(castingCircleSprite, "scale", Vector2(0,0), .2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	skillName = null
	

func check_global_cooldown():
	return globalCooldown.is_stopped()

#Func starts from Player.gd
func start_ability(selected_skill, selected_shortcut):
	skillName = selected_skill
	skillShortcut = selected_shortcut
	distance = DataImport.skill_data[skillName].Distance

	if selected_skill != null:
		#Resize casting circle to size of collision
		var radiusSize = DataImport.skill_data[selected_skill].SkillRadius
		if radiusSize != null:
			var sizeto = Vector2(radiusSize,radiusSize)
			var size = castingCircleSprite.texture.get_size()
			var scale_factor = sizeto/size
			
			castingCircleSprite.scale = Vector2(0,0)
			
			#Showing casting circle if relevant
			match DataImport.skill_data[skillName].SkillType:
				"at_cursor":
					var TW = get_tree().create_tween()
					TW.tween_property(castingCircleSprite, "scale", scale_factor * 2, .2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
					castingCircleSprite.show()
				"self_utility":
					pass
				"around_self":
					pass
				"front_arc":
					pass
				"projectile":
					pass


func release_ability():
	skillElement = DataImport.skill_data[skillName].Element
	var loadedAbility = load_ability(skillName)
	var ability = loadedAbility.instance()
	ability.skillName = skillName

	attack_animation()
	globalCooldown.start()
	

	match DataImport.skill_data[skillName].SkillType:
		"at_cursor":			
			ability.global_position = parentCursorLocation
			get_tree().get_current_scene().add_child(ability)
#
#
		"self_utility":
			add_child(ability)
#
#
#
		"around_self":
			ability.global_position = self.global_position
			get_tree().get_current_scene().add_child(ability)



		"front_arc":
			pass
#
#
#
		"projectile":
			ability.cursorDirection = parentCursorDirection
			ability.global_position = self.global_position
			var ability_rotation = self.global_position.direction_to(parentCursorLocation).angle()
			ability.rotation = ability_rotation
			get_tree().get_current_scene().add_child(ability)
			ability.projectile()

	var TW = get_tree().create_tween()
	TW.tween_property(castingCircleSprite, "scale", Vector2(0,0), .2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	skillShortcut = null
	skillName = null

func load_ability(skillName):
	if skillName != null:
		var path = "res://abilities/" + skillElement + "/" + skillName + "/" + skillName + ".tscn"
		return load(path)
		
func load_ability_collision(skillName):
	if skillName != null:
		var path = "res://abilities/" + skillElement + "/" + skillName + "/" + skillName + "/CollisionShape2D.tscn"
		return load(path)


func attack_animation():
	get_parent().state = 5
	get_parent().animationState.travel("Attack")
	if attackAnimationTimer.is_stopped():
		attackAnimationTimer.start()