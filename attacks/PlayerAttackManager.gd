extends Node2D

#onready var projectileToClick = preload("res://abilities/projectileToClick/projectileToClick.tscn")
onready var projectileToCursorDir = preload("res://abilities/projectileToCursorDir/projectileToCursorDir.tscn")
onready var atCursor = preload("res://abilities/atCursor/atCursor.tscn")

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
	
func use_ability(skillName):
	loadedAbility = load_ability(skillName)
	cursorDirection = get_parent().cursorDirection
	cursorLocation = get_parent().cursorLocation
	globalCooldown.start()
	attack_towards_mouse()	
	attack_animation()
		
	match skillName:
		"projectileToClick":
			spawn_projectile(loadedAbility,cursorLocation)
		"projectileToCursorDir":
			spawn_projectile(loadedAbility,cursorDirection)
		"atCursor":
			spawn_atCursor(atCursor)

func load_ability(skillName):
	var path = "res://abilities/" + skillName + "/" + skillName + ".tscn"
	return load(path)

func attack_animation():
	get_parent().animationState.travel("Attack")
	if attackAnimationTimer.is_stopped():
		attackAnimationTimer.start()
	
func spawn_projectile(scene,mouseBehavior):
	var ability = scene.instance()
	get_tree().get_current_scene().add_child(ability)
	ability.global_position = self.global_position		
	var ability_rotation = self.global_position.direction_to(cursorLocation).angle()
	ability.rotation = ability_rotation
	ability.execute(mouseBehavior)

func spawn_atCursor(scene):
	var ability = scene.instance()
	get_tree().get_current_scene().add_child(ability)
	ability.global_position = cursorLocation
	ability.execute()
