extends "res://attacks/Hitbox.gd"

export(float) var distanceModifier = .003
export(int) var knockbackModifier = 130

func _ready():
	pass

func _physics_process(_delta):
	pass
#
func execute(clickLocation):
	var direction = Vector2.RIGHT.rotated(rotation)
	knockback_vector = direction
	var distance = global_position.distance_to(clickLocation)
	var duration = distanceModifier * distance
	var TW = get_tree().create_tween()
	TW.tween_property(self, "position", clickLocation, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "destroy")
	
func destroy():
	queue_free()

func _on_PlayerProjectile_area_entered(_area):
	destroy()

func _on_PlayerProjectile_body_entered(_body):
	destroy()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
