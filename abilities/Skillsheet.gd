extends Area2D

onready var animationPlayer = $AnimationPlayer

var skillName
var cursorDirection

var hasCastTime
var castTime
var cooldown
var cooldownDuration
var canDamage
var skillDamage
var knocksback
var knockbackModifier
var skillRadius
var distance
var projectileSpeed
var destroyOnImpact
var aoeDamageDelayTime
var destroyDelayTime

var knockback_vector = Vector2.ZERO

func _ready():
	hasCastTime = DataImport.skill_data[skillName].HasCastTime
	castTime = DataImport.skill_data[skillName].CastTime
	cooldown = DataImport.skill_data[skillName].Cooldown
	cooldownDuration = DataImport.skill_data[skillName].CooldownDuration
	canDamage = DataImport.skill_data[skillName].CanDamage
	skillDamage = DataImport.skill_data[skillName].SkillDamage
	knocksback = DataImport.skill_data[skillName].Knocksback
	knockbackModifier = DataImport.skill_data[skillName].KnockbackModifier
	skillRadius = DataImport.skill_data[skillName].SkillRadius
	distance = DataImport.skill_data[skillName].Distance
	projectileSpeed = DataImport.skill_data[skillName].ProjectileSpeed
	destroyOnImpact = DataImport.skill_data[skillName].DestroyedOnImpact
	aoeDamageDelayTime = DataImport.skill_data[skillName].AoEDamageDelayTime
	destroyDelayTime = DataImport.skill_data[skillName].DestroyDelayTime

	get_node("CollisionShape2D").get_shape().radius = skillRadius

func projectile():
	var projectileRotation = Vector2.RIGHT.rotated(rotation)
	print(cursorDirection, distance)
	var direction = cursorDirection * distance
	var location = global_position + direction
	knockback_vector = projectileRotation
	
	var TW = get_tree().create_tween()
	TW.tween_property(self, "position", location, .5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "destroy")

func at_cursor_starting_animation_finished():
	animationPlayer.play("end")

func at_cursor_ending_animation_finished():
	destroy()

func _on_Skillsheet_area_entered(area):
	if destroyOnImpact == true:
		destroy()

func destroy():
	queue_free()
