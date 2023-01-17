extends Area2D

export(int) var skillDamage = 1
export(bool) var canKnockback = true
export(bool) var destroyOnImpact = true


var knockback_vector = Vector2.ZERO


func _ready():
	pass


func destroy():
	queue_free()

func _on_Hitbox_area_entered(_area):
	if destroyOnImpact == true:
		destroy()

func _on_Hitbox_body_entered(_body):
	destroy()
