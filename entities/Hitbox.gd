extends Area2D

var skillDamage = 1
var healAmount = 0

var knockback_vector = Vector2.ZERO
var knockbackModifier = 0

func _ready():
	pass


func _on_Hitbox_area_entered(area):
	area.on_hit(area, self)
