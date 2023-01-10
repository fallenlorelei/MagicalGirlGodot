extends "res://attacks/Hitbox.gd"

export(float) var distanceModifier = .003
export(int) var knockbackModifier = 130

var length = 200

func _ready():
	pass

func _physics_process(_delta):
	pass
#
func execute(cursorDirection):
	var projectileRotation = Vector2.RIGHT.rotated(rotation)
	var direction = cursorDirection * length
	var location = global_position + direction
	knockback_vector = projectileRotation
	var TW = get_tree().create_tween()
	TW.tween_property(self, "position", location, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "destroy")
