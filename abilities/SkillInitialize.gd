class_name SkillInitialize extends Resource

onready var signalBus = SignalBus

var cursorDirection: Vector2
var knockback_vector = Vector2.ZERO
var attackManager: Node2D

var skillName: String
var skillElement: String
var treeType: String
var skillType: String
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
