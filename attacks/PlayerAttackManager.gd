extends Node2D

onready var projectileToClick = preload("res://abilities/projectileToClick/projectileToClick.tscn")
onready var projectileToCursorDir = preload("res://abilities/projectileToCursorDir/projectileToCursorDir.tscn")


onready var attackAnimationTimer = $AttackAnimationTimer

var mouseclick
var clickLocation

func _ready():
	pass

func _physics_process(_delta):
	pass

func attack_towards_mouse():
	get_parent().animationTree.set("parameters/Attack/blend_position", mouseclick)
	get_parent().animationTree.set("parameters/Idle/blend_position", mouseclick)
	get_parent().animationTree.set("parameters/Run/blend_position", mouseclick)
	
	
func begin_attack(abilityPressed):
	mouseclick = get_parent().mouseclick
	clickLocation = get_parent().clickLocation
	attack_towards_mouse()
	
	if abilityPressed == 0:
		attack_animation()
		projectile_toclick()
	
	if abilityPressed == 1:
		attack_animation()
		projectile_tocursordir()

func attack_animation():
	get_parent().animationState.travel("Attack")
	if attackAnimationTimer.is_stopped():
		attackAnimationTimer.start()
	
func projectile_toclick():
#	projectileTimer.start()
	var projectile = projectileToClick.instance()
	get_tree().get_current_scene().add_child(projectile)
	projectile.global_position = self.global_position		
	var projectile_rotation = self.global_position.direction_to(clickLocation).angle()
	projectile.rotation = projectile_rotation
	projectile.execute(clickLocation)
#
func projectile_tocursordir():
#	projectileTimer.start()
	var projectile = projectileToCursorDir.instance()
	get_tree().get_current_scene().add_child(projectile)
	projectile.global_position = self.global_position		
	var projectile_rotation = self.global_position.direction_to(clickLocation).angle()
	projectile.rotation = projectile_rotation
	projectile.execute(mouseclick)
