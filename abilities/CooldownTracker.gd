extends Node2D

signal start_cooldown(skillShortcut, cooldownDuration)

var cooldownDuration = 0.0

func _ready():
	pass
	
func start_cooldown(skillName, skillShortcut):
	var cooldownDuration = DataImport.skill_data[skillName].CooldownDuration
	if cooldownDuration > 0:
		SignalBus.emit_signal("start_cooldown", skillShortcut, cooldownDuration)
