extends KinematicBody2D

onready var signalBus = SignalBus

onready var skillSprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var particles = $Particles2D
onready var hitbox = $AbilityHitbox
onready var hitboxCollisionShape = $AbilityHitbox/CollisionShape2D
onready var collisionShape = $CollisionShape2D

var cursorDirection: Vector2
var knockback_vector = Vector2.ZERO
var attackManager: Node2D
var starting_pos: Vector2
var velocity = Vector2.ZERO

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
		hitboxCollisionShape.get_shape().radius = skillRadius
		
	particles.emitting = true
	if get_node_or_null("Particles2D2") != null:
		$Particles2D2.emitting = true
		
	start_timer()

func _physics_process(delta):
	move_bullet(delta)
	
# == PROJECTILES ==
func projectile():
	scale_sprite()

	var projectileRotation = Vector2.RIGHT.rotated(rotation)
	knockback_vector = projectileRotation

	starting_pos = position
	
func move_bullet(delta):
	var _collision_info = move_and_collide(velocity.normalized() * delta * projectileSpeed)
	
func scale_sprite():		
	var sizeto = Vector2(skillRadius,skillRadius)
	var spriteSize = skillSprite.texture.get_size() / Vector2(skillSprite.hframes, skillSprite.vframes)
	var sprite_scale_factor = sizeto/spriteSize * 2
	skillSprite.scale = sprite_scale_factor

	if particles.material != null:
		particles.process_material.emission_sphere_radius = skillRadius	

func start_timer():
	var timer = Timer.new()
	timer.wait_time = skillDistance
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "destroy")
	
func destroy():
	animationPlayer.play("death")
	yield(get_tree().create_timer(animationPlayer.current_animation_length),"timeout")
	queue_free()

func _on_AbilityHitbox_area_entered(area):
	if destroyOnImpact == true:
		destroy()
