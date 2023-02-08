extends SkillInit_Area2D

var rainbowDashing
var follow

func _ready():
	pass

func _physics_process(delta):
	if rainbowDashing == true:
		SignalBus.emit_signal("curved_dash", self.global_position)
		follow.set_offset(follow.get_offset() + 300 * delta)
		if follow.unit_offset == 1:
			rainbowDashing = false


# == AT_CURSORS ==
func at_cursor():
	scale_sprite()

# == AROUND SELF ==
func around_self():
	collisionShape.position.y += 6
	skillSprite.position.y += 6
	scale_particles()

# == DASH ==
func curved_dash(rainbowFollow):
	z_index = -1
	follow = rainbowFollow
	$Line2D.length = skillDistance/PI
	rainbowDashing = true #Sending to physics_process
	
	yield(get_tree().create_timer(skillDistance/60), "timeout")
	destroy()
	
# == END ==
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start":
		destroy()
		
func destroy():
	rainbowDashing = false
	queue_free()
