extends Area2D

#onready var playerStats = PlayerStats
onready var signalBus = SignalBus

onready var skillSprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape2D
onready var particles = $Particles2D

var cursorDirection: Vector2
var knockback_vector = Vector2.ZERO
var attackManager: Node2D

var skillName: String
var skillElement
var treeType
var skillType
var cooldownDuration: float
var skillDamage: int
var healAmount: int
var projectileAmount: int
var aoeDuration: float
var aoeTickDelay: float
var knockbackModifier: float
var skillRadius: float
var skillDistance: float
var projectileSpeed: float
var destroyOnImpact: bool
var hitEffectParticles
var skillDescription

func _ready():
	skillElement = DataImport.skill_data[skillName].Element
	treeType = DataImport.skill_data[skillName].TreeType
	skillType = DataImport.skill_data[skillName].SkillType
	cooldownDuration = DataImport.skill_data[skillName].CooldownDuration
	skillDamage = DataImport.skill_data[skillName].SkillDamage
	healAmount = DataImport.skill_data[skillName].HealAmount
	projectileAmount = DataImport.skill_data[skillName].ProjectileAmount
	aoeDuration = DataImport.skill_data[skillName].AoEDuration
	aoeTickDelay = DataImport.skill_data[skillName].AoETickDelay
	knockbackModifier = DataImport.skill_data[skillName].KnockbackModifier
	skillRadius = DataImport.skill_data[skillName].SkillRadius
	skillDistance = DataImport.skill_data[skillName].Distance
	projectileSpeed = DataImport.skill_data[skillName].ProjectileSpeed
	destroyOnImpact = DataImport.skill_data[skillName].DestroyedOnImpact
	hitEffectParticles = DataImport.skill_data[skillName].HitEffectParticles
	skillDescription = DataImport.skill_data[skillName].SkillDescription
	
	if skillRadius != null:
		collisionShape.get_shape().radius = skillRadius
	
	if healAmount > 0.0:
		start_heal()
		
	particles.emitting = true
	if get_node_or_null("Particles2D2") != null:
		$Particles2D2.emitting = true

	check_extra()
	
# == PROJECTILES ==
func projectile():
	scale_sprite()

	var projectileRotation = Vector2.RIGHT.rotated(rotation)
	knockback_vector = projectileRotation

	var direction = cursorDirection * skillDistance
	var location = global_position + direction

	var TW = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	TW.tween_property(self, "position", location, projectileSpeed)
	TW.tween_property(self, "scale", Vector2.ZERO, .1)
	TW.tween_callback(self, "destroy")

# == AT_CURSORS ==
func at_cursor():
	scale_sprite()

# == AROUND SELF ==
func around_self():
	collisionShape.position.y += 6
	skillSprite.position.y += 6
	scale_sprite()

func around_self_animation_finished():
	tween_shrink()

# == OTHER ==
func start_heal():
#	playerStats.heal(healAmount)
	if skillType == "self_utility":
		yield(get_tree().create_timer(animationPlayer.current_animation_length),"timeout")
		queue_free()

func scale_sprite():		
	var sizeto = Vector2(skillRadius,skillRadius)
	var spriteSize = skillSprite.texture.get_size() / Vector2(skillSprite.hframes, skillSprite.vframes)
	var sprite_scale_factor = sizeto/spriteSize * 2
	skillSprite.scale = sprite_scale_factor

	if particles.material != null:
		particles.process_material.emission_sphere_radius = skillRadius	

func tween_shrink():
	var TW = get_tree().create_tween()
	TW.tween_property(self, "scale", Vector2.ZERO, .5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "destroy")

func tween_fade():
	var TW = get_tree().create_tween()
	TW.tween_property(skillSprite, "modulate", Color(1,1,1,0), .3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "destroy")
	
func _on_Skillsheet_Area2D_body_entered(body):
	if destroyOnImpact == true:
		destroy()
		
func destroy():
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	tween_fade()
	
	
func check_extra():
	for skill in DataImport.skilltree_data:
		if DataImport.skilltree_data[skill].get(skillElement) == skillName + "_extra":
			var skillVariable = skillElement.to_lower() + "_" + skill.left(2) + "_extra"
			if SkillTreeTracker.fullTree.get(skillVariable) == true:
				extra_effect(skillName)

func load_extra_effect(skill_name):
	if skillName != null:
		var path = "res://abilities/" + skillElement + "/" + skill_name + "/" + skill_name + "_extra.tscn"
		return load(path)
		
func extra_effect(extra_skill):
	var loadedEffect = load_extra_effect(extra_skill)
	var extraProjectileAmount = DataImport.skill_data[extra_skill + "_extra"].ProjectileAmount
	for i in extraProjectileAmount:
		var extra_ability = loadedEffect.instance()
		extra_ability.skillName = str(extra_skill + "_extra")
		extra_ability.global_position = self.global_position
		get_tree().get_current_scene().add_child(extra_ability)

