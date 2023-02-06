extends SkillInit_Area2D

onready var damageDelayTimer = $StartingDelay

func _ready():
	if startingDamageDelay > 0:
		damageDelayTimer.wait_time = startingDamageDelay
		damageDelayTimer.connect("timeout", self, "damage")

# == AT_CURSORS ==
func at_cursor():
	scale_sprite()

# == AROUND SELF ==
func around_self():
	collisionShape.position.y += 6
	skillSprite.position.y += 6
	scale_particles()
	
# == OTHER ==
func scale_sprite():
	if skillSprite.texture != null:
		var sizeto = Vector2(skillRadius,skillRadius)
		var spriteSize = skillSprite.texture.get_size() / Vector2(skillSprite.hframes, skillSprite.vframes)
		var sprite_scale_factor = sizeto/spriteSize * 2
		skillSprite.scale = sprite_scale_factor
	scale_particles()

func scale_particles():
	if particles.material != null:
		particles.process_material.emission_sphere_radius = skillRadius	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start":
		destroy()
		
func destroy():
	queue_free()
	

func _on_Skillsheet_Area2D_area_entered(area):
	targetAttacked = area
	if startingDamageDelay > 0:
		damageDelayTimer.start()
	else:
		damage()

func damage():
	var targets = get_overlapping_areas()
	for target in targets:
		if target.is_in_group("Player") and healAmount > 0:
			target.heal(healAmount)
		if target.is_in_group("Enemy"):
			target.get_parent().on_hit(targetAttacked, self)
