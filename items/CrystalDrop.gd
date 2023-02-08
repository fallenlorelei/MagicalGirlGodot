extends RigidBody2D

onready var crystalSprite = $ElementalCrystalSprite
onready var animatedCrystal = $ElementalCrystalSprite/AnimationPlayer
onready var pickupCollision = $Area2D/ItemPickUpCollision
onready var crystalParticles = $ElementalCrystalSprite/Particles2D

var crystalType
var distance = 20
var distanceX = rand_range(-distance, distance)
var distanceY = rand_range(-distance, distance)
var new_distance = Vector2(distanceX, distanceY)
var pickingUp = false
var player
var areaPosition

var playerPosition = Vector2.ZERO
	
func _ready():
	crystalSprite.frame = int(ElementalCrystalCounter.crystalAnimationFrame[crystalType])
	var randomScale = rand_range(.4,.7)
	crystalSprite.scale = Vector2(randomScale, randomScale)
	animatedCrystal.advance(rand_range(0.0,1.0))
	animatedCrystal.playback_speed = rand_range(0.6,1)

	var randomImpulse_x = rand_range(-200,200)
	var randomImpulse_y = rand_range(-200,200)
	apply_central_impulse(Vector2(randomImpulse_x,randomImpulse_y))

	match crystalType:
		"LIGHT":
#			crystalParticles.set_modulate(Color("#fcf960"))
			crystalParticles.set_modulate(Color("#f1ffbf"))
		"DARK":
#			crystalParticles.set_modulate(Color("#563f96"))
			crystalParticles.set_modulate(Color("#934fbd"))
		"PSYCHIC":
#			crystalParticles.set_modulate(Color("#934fbd"))
			crystalParticles.set_modulate(Color("#f06ec3"))
		"FIRE":
#			crystalParticles.set_modulate(Color("#a63146"))
			crystalParticles.set_modulate(Color("#ff8f8f"))
		"WATER":
#			crystalParticles.set_modulate(Color("#2764a1"))
			crystalParticles.set_modulate(Color("#48bac7"))
		"ICE":
			crystalParticles.set_modulate(Color("#86f7c8"))
		"THUNDER":
#			crystalParticles.set_modulate(Color("#ffad3b"))
			crystalParticles.set_modulate(Color("#fcf960"))
		"WIND":
			crystalParticles.set_modulate(Color("#7ac240"))
		"EARTH":
#			crystalParticles.set_modulate(Color("#63371a"))
			crystalParticles.set_modulate(Color("#ffad3b"))

func _on_Area2D_area_entered(area):
	if pickingUp == false:
		ElementalCrystalCounter.update_crystals(crystalType, 1)
		pickingUp = true
		
	var TW = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	TW.tween_property(crystalSprite, "scale", Vector2(0,0), .3)
	TW.parallel().tween_property(crystalSprite, "modulate", Color(1,1,1,0), .3)
	TW.tween_callback(self, "destroy")

func destroy():
	queue_free()
