extends Area2D

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
	
	# Crystal drops from enemy and bounces
	var TW = create_tween()
	TW.tween_property(self, "position", global_position + new_distance, .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func _physics_process(_delta):
	if pickingUp == true:
		areaPosition = player.global_position

		var TW = create_tween()
		TW.tween_property(self, "position", areaPosition, .3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
		TW.tween_property(self, "scale", Vector2(0,0), .3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		TW.tween_callback(self, "queue_free")
	

func _on_CrystalDrop_area_entered(area):
	player = area

	if pickingUp == false:
		ElementalCrystalCounter.update_crystals(crystalType, 1)
		pickingUp = true
