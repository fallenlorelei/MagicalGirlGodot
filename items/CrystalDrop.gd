extends Area2D

onready var animatedCrystal = $AnimatedSpriteCrystal
onready var pickupCollision = $ItemPickUpCollision
onready var player = get_node("../MagicalGirl")
onready var crystalCounter = ElementalCrystalCounter

var crystalType
var distance = 20
var distanceX = rand_range(-distance, distance)
var distanceY = rand_range(-distance, distance)
var new_distance = Vector2(distanceX, distanceY)
var pickingUp = false

func _physics_process(_delta):
	pass
	
func _ready():	
	animatedCrystal.play(str(crystalType))
	
	player.connect("picking_up_item", self, "pick_up_item")	

	# Crystal drops and bounces
	var TW = create_tween()
	TW.tween_property(animatedCrystal, "position", new_distance, .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	update_pos()

# Crystal moves to player
# I want to edit so that the crystals follow the player when they move
func pick_up_item():
	# Removing collision kinda stops duplicates
	set_deferred("monitorable", false)
	set_collision_layer_bit(7, false)
		
	var element = animatedCrystal.get_animation()
			
	var TW = create_tween()
	var playerPosition = to_local(player.position)
	TW.tween_property(animatedCrystal, "position", playerPosition, .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	TW.tween_property(animatedCrystal, "scale", Vector2(0,0), .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	TW.tween_callback(self, "queue_free")
	
	# Also stops duplicates
	if pickingUp == false:
		crystalCounter.update_crystals(element, 1)
		pickingUp = true

# Updates position of the collision
func update_pos():
	pickupCollision.position = new_distance
