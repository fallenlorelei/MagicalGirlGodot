extends Area2D

onready var animatedCrystal = $AnimatedSpriteCrystal
onready var tween = get_node("Tween")

var crystalType
var distance = 20
var distanceX = rand_range(-distance, distance)
var distanceY = rand_range(-distance, distance)
	
func _ready():		
	animatedCrystal.play(str(crystalType))
	
	tween.interpolate_property(animatedCrystal, "position",
	Vector2(0, 0), Vector2(distanceX, distanceY), .5,
	Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()

