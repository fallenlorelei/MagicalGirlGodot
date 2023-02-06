extends Area2D

var skillDamage: int
var healAmount: int
var knockbackModifier: float
var knockback_vector = Vector2.ZERO
var destroyOnImpact: bool
var startingDamageDelay: float

var targetAttacked: Node2D
var damagedTargets = []

func _ready():
	var skillName = get_parent().skillName
	skillDamage = DataImport.skill_data[skillName].SkillDamage
	healAmount = DataImport.skill_data[skillName].HealAmount
	knockbackModifier = DataImport.skill_data[skillName].KnockbackModifier
	destroyOnImpact = DataImport.skill_data[skillName].DestroyedOnImpact
	startingDamageDelay = DataImport.skill_data[skillName].StartingDamageDelay
	
func _on_AbilityHitbox_area_entered(area):
	targetAttacked = area
	if startingDamageDelay > 0:
		get_parent().damageDelayTimer.start()
	else:
		damage()

func damage():
	var targets = get_overlapping_areas()
	for target in targets:
		# Only deals damage once
		if damagedTargets.has(target):
			continue
		elif target.is_in_group("Player") and healAmount > 0:
			get_parent().attackedGroup = "Player"
			target.heal(healAmount)
		elif target.is_in_group("Enemy") and skillDamage > 0:
			get_parent().attackedGroup = "Enemy"
			target.on_hit(targetAttacked, self)
			damagedTargets.append(target)
		
		if destroyOnImpact == true:
			get_parent().destroy()
