extends RigidBody2D

onready var skillSprite = $Sprite
#onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape2D
#onready var particles = $Particles2D
onready var abilityHitbox = $ExtraAbilityHitbox

var knockback_vector = Vector2.ZERO

var skillName: String
var skillElement
#var treeType
#var skillType
#var projectileAmount: float
#var aoeDuration: float
#var aoeTickDelay: float

var skillRadius: float
#var skillDistance: float
#var projectileSpeed: float
var destroyOnImpact: bool
var hitEffectParticles
var skillDescription

func _ready():
	skillElement = DataImport.skill_data[skillName].Element
#	treeType = DataImport.skill_data[skillName].TreeType
#	skillType = DataImport.skill_data[skillName].SkillType	
#	projectileAmount = DataImport.skill_data[skillName].ProjectileAmount
#	aoeDuration = DataImport.skill_data[skillName].AoEDuration
#	aoeTickDelay = DataImport.skill_data[skillName].AoETickDelay
	skillRadius = DataImport.skill_data[skillName].SkillRadius
#	skillDistance = DataImport.skill_data[skillName].Distance
#	projectileSpeed = DataImport.skill_data[skillName].ProjectileSpeed
	destroyOnImpact = DataImport.skill_data[skillName].DestroyedOnImpact
	hitEffectParticles = DataImport.skill_data[skillName].HitEffectParticles
	skillDescription = DataImport.skill_data[skillName].SkillDescription

	if skillRadius != null:
		collisionShape.get_shape().radius = skillRadius
		
#	particles.emitting = true
#	if get_node_or_null("Particles2D2") != null:
#		$Particles2D2.emitting = true
	scale_sprite()
	
	var randomImpulse_x = rand_range(-300,300)
	var randomImpulse_y = rand_range(-300,300)
	apply_central_impulse(Vector2(randomImpulse_x,randomImpulse_y))


func _on_AbilityHitbox_area_entered(area):
	if area.is_in_group("Player"):
		player_effects()
	if area.is_in_group("Enemy"):
		enemy_effects()

func player_effects():
	if destroyOnImpact == true:
		var TW = get_tree().create_tween().set_ease(Tween.EASE_OUT)
		TW.tween_property(skillSprite, "scale", Vector2(0,0), .3)
		TW.parallel().tween_property(skillSprite, "modulate", Color(1,1,1,0), .3)
		TW.tween_callback(self, "destroy")

func enemy_effects():
	if destroyOnImpact == true:
		var TW = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
		TW.tween_property(skillSprite, "scale", Vector2(.5,.5), .3).set_ease(Tween.EASE_IN)
		TW.tween_property(skillSprite, "scale", Vector2(1.5,1.5), .1).set_ease(Tween.EASE_OUT)
		TW.parallel().tween_property(skillSprite, "modulate", Color(1,1,1,0), .3)
		TW.tween_callback(self, "destroy")

func scale_sprite():		
	var sizeto = Vector2(skillRadius,skillRadius)
	var spriteSize = skillSprite.texture.get_size() / Vector2(skillSprite.hframes, skillSprite.vframes)
	var sprite_scale_factor = sizeto/spriteSize * 2
	skillSprite.scale = sprite_scale_factor
#
#	if particles.material != null:
#		particles.process_material.emission_sphere_radius = skillRadius	
#
func destroy():
	queue_free()
