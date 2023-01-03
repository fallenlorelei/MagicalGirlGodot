extends Area2D

onready var animatedCrystal = $AnimatedSpriteCrystal
onready var pickupCollision = $ItemPickUpCollision
onready var player = get_node("../MagicalGirl")

var crystalType
var distance = 20
var distanceX = rand_range(-distance, distance)
var distanceY = rand_range(-distance, distance)
var new_distance = Vector2(distanceX, distanceY)
var playerPosition

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
	var TW = create_tween()
	playerPosition = to_local(player.position)
	TW.tween_property(animatedCrystal, "position", playerPosition, .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	TW.tween_property(animatedCrystal, "scale", Vector2(0,0), .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT_IN)
	TW.tween_callback(self, "queue_free")
	

# Updates position of the collision
func update_pos():
	pickupCollision.position = new_distance
