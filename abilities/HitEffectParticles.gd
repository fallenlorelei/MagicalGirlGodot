extends Node2D

onready var flashTimer = $FlashTimer

var objectHit
var abilityUsed
var abilityParent
var particle
var particlesSpawned
var particleType
var shakeStrength

func _ready():
	if abilityUsed.name == "ExtraAbilityHitbox" or abilityUsed.name == "AbilityHitbox":
		particleType = DataImport.skill_data[abilityParent.name.rstrip("0123456789").trim_prefix("@").trim_suffix("@")].HitEffectParticles
		shakeStrength = DataImport.skill_data[abilityParent.name.rstrip("0123456789").trim_prefix("@").trim_suffix("@")].ShakeStrength
	else:
		particleType = DataImport.skill_data[abilityUsed.name.rstrip("0123456789").trim_prefix("@").trim_suffix("@")].HitEffectParticles
		shakeStrength = DataImport.skill_data[abilityUsed.name.rstrip("0123456789").trim_prefix("@").trim_suffix("@")].ShakeStrength
	
	if particleType != null:
		spawn_particle(particleType)
		
	if objectHit.sprite.material != null:
		objectHit.sprite.material.set_shader_param("solid_color", Color.white)
		flashTimer.start()
		
	if objectHit.sprite != null:
		if abilityUsed.skillDamage > 0 and objectHit.is_in_group("Enemy"):
			shake_sprite()

func _physics_process(delta):
	if is_instance_valid(objectHit):
		position = objectHit.position

func spawn_particle(particleType):
	particle = get_node(str(particleType))
	particle.emitting = true
	particlesSpawned = true

func shake_sprite():
	var saved_position = objectHit.position
	var shake_duration = 0.05
	var shake_count = 5
	var TW = get_tree().create_tween()
	for i in shake_count:
		var new_position = saved_position + create_new_random()
		TW.tween_property(objectHit, "position", new_position, shake_duration)
	objectHit.position = saved_position

func create_new_random():
	var shake_range = shakeStrength
	var random_x = rand_range(-shake_range,shake_range)
	var random_y = rand_range(-shake_range,shake_range)
	var random_vector = Vector2(random_x, random_y)
	return random_vector
	
func _on_FlashTimer_timeout():
	objectHit.sprite.material.set_shader_param("solid_color", Color(1,1,1,0))
	if particlesSpawned == true:
		if particle.emitting == false:
			queue_free()
