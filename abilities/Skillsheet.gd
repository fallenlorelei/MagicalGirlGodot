extends Area2D

onready var playerStats = PlayerStats
onready var skillSprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape2D
onready var particles = $Particles2D

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
var isUltimate = false

var knockback_vector = Vector2.ZERO

func _ready():
	skillType = DataImport.skill_data[skillName].SkillType
	castTime = DataImport.skill_data[skillName].CastTime
	cooldownDuration = DataImport.skill_data[skillName].CooldownDuration
	skillDamage = DataImport.skill_data[skillName].SkillDamage
	healAmount = DataImport.skill_data[skillName].HealAmount
	knockbackModifier = DataImport.skill_data[skillName].KnockbackModifier
	skillRadius = DataImport.skill_data[skillName].SkillRadius
	distance = DataImport.skill_data[skillName].Distance
	projectileSpeed = DataImport.skill_data[skillName].ProjectileSpeed
	destroyOnImpact = DataImport.skill_data[skillName].DestroyedOnImpact
	aoeDamageDelayTime = DataImport.skill_data[skillName].AoEDamageDelayTime
	destroyDelayTime = DataImport.skill_data[skillName].DestroyDelayTime
	isUltimate = DataImport.skill_data[skillName].Ultimate

	if skillRadius != null and isUltimate == false:
		collisionShape.get_shape().radius = skillRadius
	
	if healAmount > 0.0:
		start_heal()
	
	if knockbackModifier > 0.0:
		canKnockback = true
	
	if castTime > 0.0:
		hasCastTime = true
		
	if cooldownDuration > 0.0:
		hasCooldown = true
		
	particles.emitting = true
	if get_node_or_null("Particles2D2") != null:
		$Particles2D2.emitting = true
	
# == PROJECTILES ==
func projectile():
	scale_sprite()
	
	var projectileRotation = Vector2.RIGHT.rotated(rotation)
	knockback_vector = projectileRotation
	
	var direction = cursorDirection * distance
	var location = global_position + direction
	
	var TW = get_tree().create_tween()
	TW.tween_property(self, "position", location, .5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_property(self, "scale", Vector2.ZERO, .1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "destroy")

# == AT_CURSORS ==
func at_cursor():
	scale_sprite()
	
func at_cursor_starting_animation_finished():
	animationPlayer.play("end")

func at_cursor_ending_animation_finished():
	var TW = get_tree().create_tween()
	TW.tween_property(self, "scale", Vector2.ZERO, .5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "destroy")
	pass

# == AROUND SELF ==
func around_self():
	collisionShape.position.y += 6
	skillSprite.position.y += 6
	scale_sprite()

# == FRONT ARC ==
func front_arc():
	scale_sprite()
	
	if cursorDirection.y < 0:
		skillSprite.z_index = -1
	else:
		skillSprite.z_index = 1
		
	var frontArcRotation = Vector2.RIGHT.rotated(rotation)	
	knockback_vector = frontArcRotation
	
func front_arc_animation_finished():
	destroy()
	
# == SELF_UTILITY ==
func start_heal():
	playerStats.heal(healAmount)
	if skillType == "self_utility":
		yield(get_tree().create_timer(animationPlayer.current_animation_length),"timeout")
		queue_free()

# == OTHER ==
func _on_Skillsheet_body_entered(_body):
	if destroyOnImpact == true:
		destroy()

func scale_sprite():
	if skillType == "full_view":
		var sizeto = OS.window_size / 2
		var spriteSize = skillSprite.texture.get_size() / Vector2(skillSprite.hframes, skillSprite.vframes)
		var sprite_scale_factor = sizeto/spriteSize
		skillSprite.scale = sprite_scale_factor
		particles.process_material.set_emission_shape(2)
		particles.process_material.emission_box_extents.x = OS.window_size.x / 2
		particles.process_material.emission_box_extents.y = OS.window_size.y / 2
		
	else:
		var sizeto = Vector2(skillRadius,skillRadius)
		var spriteSize = skillSprite.texture.get_size() / Vector2(skillSprite.hframes, skillSprite.vframes)
		var sprite_scale_factor = sizeto/spriteSize * 2
		skillSprite.scale = sprite_scale_factor
	
		if particles.material != null:
	#		var particleSize = particles.texture.get_size() / Vector2(particles.material.particles_anim_h_frames, particles.material.particles_anim_v_frames)
	#		var particle_scale_factor = sizeto/particleSize
	#		particles.process_material.scale = particle_scale_factor.x
			particles.process_material.emission_sphere_radius = skillRadius	
	
func destroy():
	var TW = get_tree().create_tween()
	TW.tween_property(self, "scale", Vector2.ZERO, .1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "queue_free")
