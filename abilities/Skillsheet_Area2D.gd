extends SkillInit_Area2D


func _ready():
	pass

# == AT_CURSORS ==
func at_cursor():
	scale_sprite()

# == AROUND SELF ==
func around_self():
	collisionShape.position.y += 6
	skillSprite.position.y += 6
	scale_particles()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start":
		destroy()
		
func destroy():
	queue_free()
