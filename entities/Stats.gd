extends Node

onready var floating_text = preload("res://ui/FloatingText.tscn")

export(int) var hp_max = 100 setget set_hp_max
export(int) var hp = hp_max setget set_hp
export(int) var defense = 0
export(float) var invincibleDuration = .5

var hpPercentage
var hpBar
var playerAlive = true
var parent_group

func _ready():
	pass
	
func set_hp_max(value):
	if value != hp_max:
		hp_max = max(0, value)
#		SignalBus.emit_signal("hp_max_changed", hp_max)
		self.hp = hp
	update_hp_bar(hp, hp_max)

func set_hp(value):
	print(parent_group)
	if value != hp:
		hp = clamp(value, 0, hp_max)
#		SignalBus.emit_signal("hp_changed", hp)
		if hp == 0:
			SignalBus.emit_signal("died")
	update_hp_bar(hp, hp_max)
	if parent_group == "Enemy" and hp == hp_max:
		get_parent().hpBar.hide()
	
func update_hp_bar(hp, hp_max):
	if parent_group == "Player":
		get_parent().update_player_hp_bar(hp, hp_max)
	elif parent_group == "Enemy":
		update_enemy_hp_bar(hp, hp_max)

func receive_damage(base_damage):
	var actual_damage = base_damage
	actual_damage -= defense	
	self.hp -= actual_damage
	set_damage_indicator("Damage", actual_damage)
	return actual_damage

func heal(healAmount):
	set_damage_indicator("Heal", healAmount)
	SignalBus.emit_signal("healed", healAmount)

func set_damage_indicator(skillType, amount):
	var damage_indicator = floating_text.instance()
	damage_indicator.amount = amount
	damage_indicator.skillType = skillType
	get_parent().add_child(damage_indicator)

func update_enemy_hp_bar(hp, hp_max):
	get_parent().hpBar.show()
	get_parent().hpBarUpdate.hpBarUpdate(hp, hp_max)
	
func die():
	playerAlive = false
	queue_free()
