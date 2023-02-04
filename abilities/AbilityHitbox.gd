extends Area2D

var skillDamage: int
var healAmount: int
var knockbackModifier: float
var knockback_vector = Vector2.ZERO
var destroyOnImpact: bool


func _ready():
	var skillName = get_parent().skillName
	skillDamage = DataImport.skill_data[skillName].SkillDamage
	healAmount = DataImport.skill_data[skillName].HealAmount
	knockbackModifier = DataImport.skill_data[skillName].KnockbackModifier
	destroyOnImpact = DataImport.skill_data[skillName].DestroyedOnImpact

