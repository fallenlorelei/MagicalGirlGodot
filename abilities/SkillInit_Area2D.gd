class_name SkillInit_Area2D extends Area2D

onready var signalBus = SignalBus

onready var skillSprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape2D
onready var particles = $Particles2D
onready var checkExtra = $CheckExtra

var cursorDirection: Vector2
var knockback_vector = Vector2.ZERO
var attackManager: Node2D
var targetAttacked: Node2D

var skillName: String
var skillElement: String
var treeType: String
var skillType: String
var cooldownDuration: float
var skillDamage: int
var healAmount: int
var projectileAmount: int
var startingDamageDelay: float
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
	startingDamageDelay = DataImport.skill_data[skillName].StartingDamageDelay
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

	particles.emitting = true
	if get_node_or_null("Particles2D2") != null:
		$Particles2D2.emitting = true

	checkExtra.skillName = skillName
	checkExtra.skillElement = skillElement
	checkExtra.check_extra()
