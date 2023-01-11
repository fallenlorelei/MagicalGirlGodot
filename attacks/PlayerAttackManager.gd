extends Node2D

onready var attackAnimationTimer = $AttackAnimationTimer
onready var globalCooldown = $GlobalCooldown

var cursorDirection
var cursorLocation
var skillName
var loadedAbility

func _ready():
	pass

func _physics_process(_delta):
	pass

func check_global_cooldown():
	return globalCooldown.is_stopped()

func attack_towards_mouse():
	get_parent().animationTree.set("parameters/Attack/blend_position", cursorDirection)
	get_parent().animationTree.set("parameters/Idle/blend_position", cursorDirection)
	get_parent().animationTree.set("parameters/Run/blend_position", cursorDirection)
	
func use_ability(selected_skill):
	cursorDirection = get_parent().cursorDirection
	cursorLocation = get_parent().cursorLocation
	
	globalCooldown.start()
	attack_towards_mouse()	
	attack_animation()
	
	match DataImport.skill_data[selected_skill].SkillType:
		"at_cursor":
			loadedAbility = load_ability("at_cursor")
			var ability = loadedAbility.instance()
			ability.skillName = selected_skill
			ability.global_position = cursorLocation
			get_tree().get_current_scene().add_child(ability)


	#	"self_utility":
	#		pass



	#	"around_self":
	#		pass



	#	"front_arc":
	#		pass



		"projectile":
			loadedAbility = load_ability("projectile")
			var ability = loadedAbility.instance()
			ability.skillName = selected_skill
			ability.cursorDirection = cursorDirection
			ability.global_position = self.global_position
			var ability_rotation = self.global_position.direction_to(cursorLocation).angle()
			ability.rotation = ability_rotation
			get_tree().get_current_scene().add_child(ability)
			ability.projectile()


#	match skillName:
#		"projectileToClick":
#			spawn_projectile(loadedAbility,cursorLocation)
#		"projectileToCursorDir":
#			spawn_projectile(loadedAbility,cursorDirection)
#		"atCursor":
#			spawn_atCursor(loadedAbility)
#
func load_ability(skillType):
	if skillType != null:
		var path = "res://abilities/" + skillType + "/" + skillType + ".tscn"
		return load(path)
	else:
		print("This ability doesn't exist.")

func attack_animation():
	get_parent().animationState.travel("Attack")
	if attackAnimationTimer.is_stopped():
		attackAnimationTimer.start()
#
#func spawn_projectile(scene,mouseBehavior):
#	var ability = scene.instance()
#	get_tree().get_current_scene().add_child(ability)
#	ability.global_position = self.global_position		
#	var ability_rotation = self.global_position.direction_to(cursorLocation).angle()
#	ability.rotation = ability_rotation
#	ability.execute(mouseBehavior)
#
#func spawn_atCursor(scene):
#	var ability = scene.instance()
#	get_tree().get_current_scene().add_child(ability)
#	ability.global_position = cursorLocation
#	ability.execute()
