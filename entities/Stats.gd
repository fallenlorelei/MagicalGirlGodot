extends Node

onready var floating_text = preload("res://ui/FloatingText.tscn")

var hp_max = 100 setget set_hp_max
var hp = hp_max setget set_hp
var defense = 0
var invincibleDuration = .5

var hpPercentage
var hpBar
var playerAlive = true
var parent_group

func _ready():
	pass
	
func set_hp_max(value):
	if value != hp_max:
		hp_max = max(0, value)
		self.hp = hp
	update_hp_bar()

func set_hp(value):
	if value != hp:
		hp = clamp(value, 0, hp_max)
		if hp == 0:
			SignalBus.emit_signal("died")
	update_hp_bar()

	
func update_hp_bar():
	if parent_group == "Player":
		get_parent().update_player_hp_bar(hp, hp_max)
	elif parent_group == "Enemy":
		update_enemy_hp_bar()
	if parent_group == "Enemy" and hp == hp_max:
		get_parent().hpBar.hide()

func receive_damage(base_damage):
	var actual_damage = base_damage
	actual_damage -= defense	
	self.hp -= actual_damage
	set_damage_indicator("Damage", actual_damage)
	return actual_damage

func heal(healAmount):
	self.hp += healAmount
	set_damage_indicator("Heal", healAmount)

func set_damage_indicator(skillType, amount):
	var damage_indicator = floating_text.instance()
	damage_indicator.amount = amount
	damage_indicator.skillType = skillType
	var sprite_height = get_parent().sprite.texture.get_height()/2  + get_parent().sprite.position.y
	damage_indicator.position = Vector2(0, -sprite_height)
	get_parent().add_child(damage_indicator)

func update_enemy_hp_bar():
	get_parent().hpBar.show()
	get_parent().hpBarUpdate.hpBarUpdate(hp, hp_max)
	
func die():
	playerAlive = false
	queue_free()
