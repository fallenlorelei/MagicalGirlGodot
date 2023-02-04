extends RigidBody2D

onready var crystalSprite = $ElementalCrystalSprite
onready var animatedCrystal = $ElementalCrystalSprite/AnimationPlayer
onready var pickupCollision = $ItemPickUpCollision

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
	var randomImpulse_x = rand_range(-200,200)
	var randomImpulse_y = rand_range(-200,200)
	apply_central_impulse(Vector2(randomImpulse_x,randomImpulse_y))


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
