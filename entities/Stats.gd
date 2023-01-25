extends Node2D

signal hp_max_changed(new_hp_max)
signal hp_changed(new_hp)
signal healed(healAmount)
signal died

export(int) var hp_max = 100 setget set_hp_max
export(int) var hp = hp_max setget set_hp
export(int) var defense = 0
export(float) var invincibleDuration = .5

var hpPercentage
var hpBar
var hpBarAnimation
var playerAlive = true

func _ready():
	pass
	
func set_hp_max(value):
	if value != hp_max:
		hp_max = max(0, value)
		emit_signal("hp_max_changed", hp_max)
		self.hp = hp

func set_hp(value):
	if value != hp:
		hp = clamp(value, 0, hp_max)
		emit_signal("hp_changed", hp)
		
		if hp == 0:
			emit_signal("died")
		
func receive_damage(base_damage):
	var actual_damage = base_damage
	actual_damage -= defense	
	self.hp -= actual_damage
	return actual_damage

func heal(healAmount):
	emit_signal("healed", healAmount)
	
func hpBarUpdate(current_hp):
	hpBar.show()
	
	hpPercentage = int((float(current_hp) / hp_max) * 100)
	var TW = get_tree().create_tween()
	TW.tween_property(hpBar, "value", float(hpPercentage), .2)
	
	if hpPercentage > 75:
		hpBar.set_tint_progress("7ac240")
	elif hpPercentage <= 75 and hpPercentage >=30:
		TW.tween_property(hpBar, "tint_progress", Color(0.870588, 0.415686, 0.219608), .2)
	else:
		TW.tween_property(hpBar, "tint_progress", Color(0.65098, 0.192157, 0.27451), .2)

	if hpBar.is_in_group("Player"):
		SignalBus.emit_signal("shake_hp_bar")

func die():
	playerAlive = false
	queue_free()
