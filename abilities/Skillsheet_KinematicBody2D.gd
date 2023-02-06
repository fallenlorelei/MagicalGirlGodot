extends SkillInit_KB2D

onready var skillDistanceTimer = $SkillDistanceTimer

var starting_pos: Vector2
var velocity = Vector2.ZERO

func _ready():		
	start_timer()

func _physics_process(delta):
	move_bullet(delta)
	
# == PROJECTILES ==
func projectile():
	scale_sprite()
	var projectileRotation = Vector2.RIGHT.rotated(rotation)
	knockback_vector = projectileRotation

	starting_pos = position
	
func move_bullet(delta):
	var _collision_info = move_and_collide(velocity.normalized() * delta * projectileSpeed)

func start_timer():
	skillDistanceTimer.wait_time = skillDistance
	skillDistanceTimer.connect("timeout", self, "destroy")
	skillDistanceTimer.start()
	
# == OTHER ==
func scale_sprite():		
	var sizeto = Vector2(skillRadius,skillRadius)
	var spriteSize = skillSprite.texture.get_size() / Vector2(skillSprite.hframes, skillSprite.vframes)
	var sprite_scale_factor = sizeto/spriteSize * 2
	skillSprite.scale = sprite_scale_factor

	if particles.material != null:
		particles.process_material.emission_sphere_radius = skillRadius	


func _on_AbilityHitbox_area_entered(area):
	targetAttacked = area
	if area.is_in_group("Player") and healAmount > 0:
		area.heal(healAmount)
	elif area.is_in_group("Enemy"):
		area.get_parent().on_hit(targetAttacked, self)
		
	if destroyOnImpact == true:
		destroy()

func destroy():
	animationPlayer.play("death")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
