extends Area2D

onready var skillSprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape2D
onready var frontArcPivot = $PivotArc
onready var frontArcCollisionShape = $PivotArc/CollisionShape2D

var skillName = skillName
var cursorDirection

export var hasCastTime = false
export var castTime = 0.0
export var hasCooldown = false
export var cooldownDuration = 0.0
export var canDamage = true
export var skillDamage = 10.0
export var canHeal = false
export var healAmount = 0.0
export var canKnockback = false
export var knockbackModifier = 0.0
export var skillRadius = 0.0
export var distance = 0.0
export var projectileSpeed = 0.0
export var destroyOnImpact = true
export var aoeDamageDelayTime = 0.0
export var destroyDelayTime = 0.0

var knockback_vector = Vector2.ZERO

func _ready():		
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
		heal()
	
# == PROJECTILES ==
func projectile():
	var projectileRotation = Vector2.RIGHT.rotated(rotation)
	var direction = cursorDirection * distance
	var location = global_position + direction
	knockback_vector = projectileRotation
	
	var TW = get_tree().create_tween()
	TW.tween_property(self, "position", location, .5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "destroy")

# == AT_CURSORS ==
func at_cursor_starting_animation_finished():
	animationPlayer.play("end")

func at_cursor_ending_animation_finished():
	destroy()

func around_self():
	collisionShape.position.y += 6
	skillSprite.position.y += 6

# == FRONT ARC ==
func front_arc():
	frontArcPivot.look_at(get_global_mouse_position())
	frontArcCollisionShape.set_deferred("disabled",false)
	frontArcCollisionShape.get_shape().extents.x = skillRadius/2

func front_arc_animation_finished():
	destroy()
	
# == SELF_UTILITY ==
func heal():
	get_parent().get_parent().heal(healAmount)
	yield(get_tree().create_timer(animationPlayer.current_animation_length),"timeout")
	queue_free()
	
# == OTHER ==
func _on_Skillsheet_area_entered(_area):
	if destroyOnImpact == true:
		destroy()

func destroy():
	queue_free()
