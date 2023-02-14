extends SkillInit_RB2D

func _ready():
	pass

func physics_ball():
	scale_sprite()
	var randomImpulse_x = rand_range(-300,300)
	var randomImpulse_y = rand_range(-300,300)
	apply_central_impulse(Vector2(randomImpulse_x,randomImpulse_y))

		
func destroy():
	if attackedGroup == "Player":
		animationPlayer.play("onhit_player")
	else:
		animationPlayer.play("onhit_enemy")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "onhit_player" or anim_name == "onhit_enemy":
		queue_free()
