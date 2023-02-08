extends Area2D

var skillDamage: int
var healAmount: int
var knockbackModifier: float
var knockback_vector = Vector2.ZERO
var destroyOnImpact: bool
var startingDamageDelay: float
var aoeDuration: float
var aoeTickDelay: float

var targetAttacked: Node2D
var hitTargets = []

func _ready():
	var skillName = get_parent().skillName
	skillDamage = DataImport.skill_data[skillName].SkillDamage
	healAmount = DataImport.skill_data[skillName].HealAmount
	knockbackModifier = DataImport.skill_data[skillName].KnockbackModifier
	destroyOnImpact = DataImport.skill_data[skillName].DestroyedOnImpact
	startingDamageDelay = DataImport.skill_data[skillName].StartingDamageDelay
	aoeDuration = DataImport.skill_data[skillName].AoEDuration
	aoeTickDelay = DataImport.skill_data[skillName].AoETickDelay

func _physics_process(delta):
	pass
			
func _on_AbilityHitbox_area_entered(area):
	targetAttacked = area
	if hitTargets.has(targetAttacked):
		pass
	else:
		hitTargets.append(targetAttacked)
		
		if startingDamageDelay > 0:
			get_parent().damageDelayTimer.start()
		else:
			check_ticktimer()

func check_ticktimer():
	#If skill has an aoe duration > 0, then it will start a
	#"tick timer" of ~1 second. When it's done, via signal,
	#it will check this function and keep dealing damage
	#until the full aoe duration timer is done
	if aoeDuration > 0:
		if get_parent().aoeDurationTimer.time_left != 0.0:
			get_parent().aoeTickTimer.start()
			damage()
	else:
		damage()

func damage():
	var targets = get_overlapping_areas()
	for target in targets:
		if target.is_in_group("Player") and healAmount > 0:
			get_parent().attackedGroup = "Player"
			target.heal(healAmount)
		
		elif target.is_in_group("Enemy") and skillDamage > 0:
			get_parent().attackedGroup = "Enemy"
			target.on_hit(targetAttacked, self)
			print(target.get_parent().name, " attacked for ", skillDamage, " damage")

	if destroyOnImpact == true:
		get_parent().destroy()
