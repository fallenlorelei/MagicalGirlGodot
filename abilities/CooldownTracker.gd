extends Node2D

signal start_cooldown(skillShortcut, cooldownDuration)

#var skillName
#var skillShortcut
var hasCooldown = false
var cooldownDuration = 0.0

func _ready():
	pass
	
func start_cooldown(skillName, skillShortcut):
#	hasCooldown = DataImport.skill_data[skillName].HasCooldown
	cooldownDuration = DataImport.skill_data[skillName].CooldownDuration
	if cooldownDuration > 0:
		emit_signal("start_cooldown", skillShortcut, cooldownDuration)
