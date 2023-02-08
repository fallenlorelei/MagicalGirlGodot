extends Node2D

onready var rainbowShader = preload("res://shaders/AnimatedRainbow.gdshader")

onready var globalCooldown = $GlobalCooldown
onready var castingCircleSprite = $CastingCircle
onready var castingCircleAnimation = $CastingCircle/AnimationPlayer
onready var projectileLine = $ProjectilePreview
onready var frontArcPreview = $FrontArcPreview
onready var spawnPivot = $SpawnPivot
onready var projectileSpawnPos = $SpawnPivot/ProjectileSpawnPos
onready var rainbowLine = $RainbowLine


var parentCursorDirection
var parentCursorLocation
var skillName
var skillShortcut
var skillElement
var distance
var castingCircleRotatingPosition
var parent
var rainbowPath
var rainbowCurve
var rainbowFollow
var p_A
var p_B
var p_postA
var p_preB

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

#Func starts from Player.gd
func start_ability(selected_skill, selected_shortcut):
	parent.releaseAbility = false
	parent.attackAnimationFinished = false
	parent.cancelled = false
	
	skillName = selected_skill
	skillShortcut = selected_shortcut
	distance = DataImport.skill_data[skillName].Distance
	

	if selected_skill != null:
		match DataImport.skill_data[skillName].SkillType:
			"at_cursor":
				show_casting(1, "at_cursor")
			"around_self":
				show_casting(-1, "around_self")
			"front_arc":
				show_casting(-1, "front_arc")
			"projectile":
				show_casting(-1, "projectile")
			"curved_dash":
				show_casting(0, "curved_dash")
				
func update_visual_cast():
	match DataImport.skill_data[skillName].SkillType:
		"at_cursor":
			castingCircleSprite.global_position = parentCursorLocation
			
		"around_self":
			castingCircleSprite.global_position = global_position + Vector2(0,6)
		
		"full_view":
			castingCircleSprite.global_position = global_position + Vector2(0,6)
			
		"projectile":
			spawnPivot.look_at(parentCursorLocation)
			var speed = DataImport.skill_data[skillName].ProjectileSpeed
			var length = parentCursorDirection * (distance * speed) * 1.4
			projectileLine.set_point_position(0,to_local(projectileSpawnPos.global_position))
			projectileLine.set_point_position(1,length)
			
		"front_arc":
			frontArcPreview.look_at(parentCursorLocation)
		
		"curved_dash":
			spawnPivot.look_at(parentCursorLocation)
			rainbowLine.show()
			rainbowLine.material = ShaderMaterial.new()
			rainbowLine.material.shader = rainbowShader
			rainbowLine.material.set_shader_param("angle", 90)
			

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
			parent.cancelled = true
			stop_casting()
	
# OUT OF BOUNDS OR RELEASING
	if Input.is_action_just_released(str(skillShortcut)) and skillName != null:
		if check_out_of_bounds():
			stop_casting()
		else:
			release_ability()
	
# IF LEFT CLICK, RELEASE AUTOMATICALLY
#	if skillShortcut == "left_click":
#		release_ability()

# == HOLDING DOWN HOTKEY, SHOWING PREVIEW ==
func show_casting(zindex, type):
	#Resize casting circle to size of collision
	var radiusSize = DataImport.skill_data[skillName].SkillRadius
	match type:
		"at_cursor", "around_self":
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
			
		"curved_dash":
			if parentCursorDirection.y < 0:
				rainbowLine.z_index = -1
			else:
				rainbowLine.z_index = 1
			var startingPos = to_local(projectileSpawnPos.global_position)
			#x,y is starting position
			p_A = Vector2(startingPos)
			#x is ending position
			p_B = get_local_mouse_position().limit_length(distance)
			#y is how high it goes up
			p_postA = Vector2(p_A.x, -(distance / PI))
			p_preB = Vector2(p_A.x/2, p_postA.y/2)
			rainbowPath = Path2D.new()
			rainbowCurve = Curve2D.new()
			rainbowFollow = PathFollow2D.new()
			rainbowCurve.add_point(p_A, Vector2.ZERO, p_postA)
			rainbowCurve.add_point(p_B, p_preB, Vector2.ZERO)
			rainbowLine.points = rainbowCurve.get_baked_points()
			
# == RELEASE ABILITY ==
func release_ability():
	parent.releaseAbility = true
	globalCooldown.start()
	CooldownTracker.start_cooldown(skillName, skillShortcut)
	
	skillElement = DataImport.skill_data[skillName].Element
	var loadedAbility = load_ability(skillName)
	var ability = loadedAbility.instance()
	ability.skillName = skillName
	ability.attackManager = self
	
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

		"around_self":
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
			ability.global_position = projectileSpawnPos.global_position
			ability.velocity = parentCursorLocation - ability.position
			var ability_rotation = self.global_position.direction_to(parentCursorLocation).angle()
			ability.rotation = ability_rotation
			get_tree().get_current_scene().add_child(ability)
			ability.projectile()
			
		"curved_dash":
			rainbowPath.set_curve(rainbowCurve)
			rainbowPath.global_position = projectileSpawnPos.global_position
			get_tree().get_current_scene().add_child(rainbowPath)
			rainbowPath.add_child(rainbowFollow)
			rainbowFollow.loop = false
			rainbowFollow.add_child(ability)
			ability.curved_dash(rainbowFollow)

	stop_casting()

func stop_casting():
	var TW = get_tree().create_tween()
	TW.tween_property(castingCircleSprite, "scale", Vector2(0,0), .2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	projectileLine.hide()
	frontArcPreview.hide()
	rainbowLine.hide()
	skillName = null
	parent.selected_skill = null
	parent.selected_skillSlot = null
	
func load_ability(skill_name):
	if skillName != null:
		var path = "res://abilities/" + skillElement + "/" + skill_name + "/" + skill_name + ".tscn"
		return load(path)

func check_global_cooldown():
	return globalCooldown.is_stopped()
