extends SkillInit_KB2D

func _ready():
	start_distance_timer()
	
func _physics_process(delta):
	move_bullet(delta)
	
func move_bullet(delta):
	var _collision_info = move_and_collide(velocity.normalized() * delta * projectileSpeed)
	
# == PROJECTILES ==
func projectile():
	scale_sprite()
	var projectileRotation = Vector2.RIGHT.rotated(rotation)
	knockback_vector = projectileRotation
	starting_pos = position
	

func start_distance_timer():
	skillDistanceTimer.wait_time = skillDistance
	skillDistanceTimer.connect("timeout", self, "destroy")
	skillDistanceTimer.start()

func destroy():
	animationPlayer.play("death")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
