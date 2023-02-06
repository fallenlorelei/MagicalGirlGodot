extends SkillInit_RB2D

func _ready():
	pass

func physics_ball():
	scale_sprite()
	var randomImpulse_x = rand_range(-300,300)
	var randomImpulse_y = rand_range(-300,300)
	apply_central_impulse(Vector2(randomImpulse_x,randomImpulse_y))
	
	
func scale_sprite():
	var sizeto = Vector2(skillRadius,skillRadius)
	var spriteSize = skillSprite.texture.get_size() / Vector2(skillSprite.hframes, skillSprite.vframes)
	var sprite_scale_factor = sizeto/spriteSize * 2
	skillSprite.scale = sprite_scale_factor

	if particles.process_material.emission_sphere_radius != null:
		particles.process_material.emission_sphere_radius = skillRadius
		
func _on_AbilityHitbox_area_entered(area):
	targetAttacked = area
	if area.is_in_group("Player") and healAmount > 0:
		area.heal(healAmount)
	elif area.is_in_group("Enemy"):
		area.get_parent().on_hit(targetAttacked, self)
	if destroyOnImpact == true:
		destroy(area)
		
func destroy(area):
	if area.is_in_group("Player"):
		animationPlayer.play("onhit_player")
	else:
		animationPlayer.play("onhit_enemy")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "onhit_player" or anim_name == "onhit_enemy":
		queue_free()
