extends Area2D

onready var animatedCrystal = $AnimatedSpriteCrystal
onready var tween = $Tween
onready var pickupCollision = $ItemPickUpCollision

var crystalType
var distance = 20
var distanceX = rand_range(-distance, distance)
var distanceY = rand_range(-distance, distance)
var new_distance = Vector2(distanceX, distanceY)
	
func _ready():		
	animatedCrystal.play(str(crystalType))
	
	tween.interpolate_property(animatedCrystal, "position",
	Vector2(0, 0), new_distance, .5,
	Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	update_pos()

func _on_CrystalDrop_area_entered(area):
	tween.interpolate_property(animatedCrystal, "position",
	Vector2(0, 0), new_distance, .5,
	Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	

func update_pos():
	pickupCollision.position = new_distance
