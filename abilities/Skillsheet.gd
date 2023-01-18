extends Area2D

onready var skillSprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape2D

var skillName = skillName
var cursorDirection
var skillType = ""
var player

var hasCastTime = false
var castTime = 0.0
var hasCooldown = false
var cooldownDuration = 0.0
var canDamage = true
var skillDamage = 10.0
var canHeal = false
var healAmount = 0.0
var canKnockback = false
var knockbackModifier = 0.0
var skillRadius = 0.0
var distance = 0.0
var projectileSpeed = 0.0
var destroyOnImpact = true
var aoeDamageDelayTime = 0.0
var destroyDelayTime = 0.0

var knockback_vector = Vector2.ZERO

func _ready():
	skillType = DataImport.skill_data[skillName].SkillType
	hasCastTime = DataImport.skill_data[skillName].HasCastTime
	castTime = DataImport.skill_data[skillName].CastTime
	hasCooldown = DataImport.skill_data[skillName].HasCooldown
	cooldownDuration = DataImport.skill_data[skillName].CooldownDuration
	canDamage = DataImport.skill_data[skillName].CanDamage
	skillDamage = DataImport.skill_data[skillName].SkillDamage
	canHeal = DataImport.skill_data[skillName].CanHeal
	healAmount = DataImport.skill_data[skillName].HealAmount
	canKnockback = DataImport.skill_data[skillName].CanKnockback
	knockbackModifier = DataImport.skill_data[skillName].KnockbackModifier
	skillRadius = DataImport.skill_data[skillName].SkillRadius
	distance = DataImport.skill_data[skillName].Distance
	projectileSpeed = DataImport.skill_data[skillName].ProjectileSpeed
	destroyOnImpact = DataImport.skill_data[skillName].DestroyedOnImpact
	aoeDamageDelayTime = DataImport.skill_data[skillName].AoEDamageDelayTime
	destroyDelayTime = DataImport.skill_data[skillName].DestroyDelayTime

	if skillRadius != null:
		collisionShape.get_shape().radius = skillRadius
	
	if canHeal == true:
		start_heal()
	
# == PROJECTILES ==
func projectile():
	var projectileRotation = Vector2.RIGHT.rotated(rotation)
	knockback_vector = projectileRotation
	
	var direction = cursorDirection * distance
	var location = global_position + direction

	var TW = get_tree().create_tween()
	TW.tween_property(self, "position", location, .5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "destroy")

# == AT_CURSORS ==
func at_cursor_starting_animation_finished():
	animationPlayer.play("end")

func at_cursor_ending_animation_finished():
	destroy()

# == AROUND SELF ==
func around_self():
	collisionShape.position.y += 6
	skillSprite.position.y += 6

# == FRONT ARC ==
func front_arc():
	if cursorDirection.y < 0:
		skillSprite.z_index = -1
	else:
		skillSprite.z_index = 1
		
	var frontArcRotation = Vector2.RIGHT.rotated(rotation)	
	knockback_vector = frontArcRotation
	
	collisionShape.shape.radius = skillRadius
	
#When the shape was a capsule
#	var rotation = get_angle_to(cursorDirection)
#	collisionShape.rotation_degrees = rotation
#	collisionShape.shape.height = skillRadius
#	collisionShape.shape.radius = skillRadius/2

	
func front_arc_animation_finished():
	destroy()
	
# == SELF_UTILITY ==
func start_heal():
	if skillType == "self_utility":
		get_parent().get_parent().heal(healAmount)
		yield(get_tree().create_timer(animationPlayer.current_animation_length),"timeout")
		queue_free()
	else:
#		var player = PlayerStats
#		player.heal(healAmount)
		pass
		
	
	
# == OTHER ==
	
func _on_Skillsheet_area_entered(_area):
	if destroyOnImpact == true:
		destroy()

func destroy():
	queue_free()
