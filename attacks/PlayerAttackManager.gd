extends Node2D

onready var attackAnimationTimer = $AttackAnimationTimer
onready var globalCooldown = $GlobalCooldown

var cursorDirection
var cursorLocation
var skillName
var loadedAbility
var skillElement

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
	
	skillElement = DataImport.skill_data[selected_skill].Element
	
	match DataImport.skill_data[selected_skill].SkillType:
		"at_cursor":
			loadedAbility = load_ability(selected_skill)
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
			loadedAbility = load_ability(selected_skill)
			var ability = loadedAbility.instance()
			ability.skillName = selected_skill
			ability.cursorDirection = cursorDirection
			ability.global_position = self.global_position
			var ability_rotation = self.global_position.direction_to(cursorLocation).angle()
			ability.rotation = ability_rotation
			get_tree().get_current_scene().add_child(ability)
			ability.projectile()



func load_ability(skillName):
	if skillName != null:
		var path = "res://abilities/" + skillElement + "/" + skillName + "/" + skillName + ".tscn"
		return load(path)
	else:
		print("There is no ability assigned to this shortcut.")

func attack_animation():
	get_parent().animationState.travel("Attack")
	if attackAnimationTimer.is_stopped():
		attackAnimationTimer.start()
