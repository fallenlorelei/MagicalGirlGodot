extends Node2D

onready var flashTimer = $FlashTimer

var object
var ability
var particle
var particlesSpawned

func _ready():
	var particleType = DataImport.skill_data[ability.name.rstrip("0123456789").trim_prefix("@").trim_suffix("@")].HitEffectParticles
	if particleType != null:
		spawn_particle(particleType)
	if object.sprite.material != null:
		object.sprite.material.set_shader_param("solid_color", Color.white)
		flashTimer.start()

func _physics_process(delta):
	if is_instance_valid(object):
		position = object.position

func spawn_particle(particleType):
	particle = get_node(str(particleType))
	particle.emitting = true
	particlesSpawned = true

func _on_FlashTimer_timeout():
	object.sprite.material.set_shader_param("solid_color", Color(1,1,1,0))
	if particlesSpawned == true:
		if particle.emitting == false:
			queue_free()
