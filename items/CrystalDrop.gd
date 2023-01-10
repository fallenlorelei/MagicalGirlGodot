extends Area2D

onready var animatedCrystal = $AnimatedSpriteCrystal
onready var pickupCollision = $ItemPickUpCollision
onready var crystalCounter = ElementalCrystalCounter

var crystalType
var distance = 20
var distanceX = rand_range(-distance, distance)
var distanceY = rand_range(-distance, distance)
var new_distance = Vector2(distanceX, distanceY)
var pickingUp = false

var playerPosition = Vector2.ZERO
	
func _ready():
	animatedCrystal.play(str(crystalType))
	
	# Crystal drops and bounces
	var TW = create_tween()
	TW.tween_property(animatedCrystal, "position", new_distance, .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	update_pos()

func _physics_process(delta):
	playerPosition = get_node("../Player").get_position()
#	pass	
	
# Updates position of the collision when crystal drops
func update_pos():
	pickupCollision.position = new_distance


func _on_CrystalDrop_area_entered(area):
	# Removing collision kinda stops duplicates
	set_deferred("monitorable", false)
	set_collision_layer_bit(7, false)
		
	var element = animatedCrystal.get_animation()
	
	# Crystal moves to player
	# I want to edit so that the crystals follow the player when they move	
	var player = area
#	var playerPosition = player.get_node("Position2D").global_position
		
	var TW = create_tween()
	TW.tween_property(self, "position", playerPosition, .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	TW.tween_property(self, "scale", Vector2(0,0), .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "queue_free")
	
	# Also stops duplicates
	if pickingUp == false:
		crystalCounter.update_crystals(element, 1)
		pickingUp = true
