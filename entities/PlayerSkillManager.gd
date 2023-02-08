extends Node2D

var parent

var rainbowDashing: bool


func _ready():
	parent = get_parent()
	SignalBus.connect("curved_dash", self, "curved_dash")

func _physics_process(delta):
	pass
		
func heal(healAmount):
	parent.playerStats.heal(healAmount)
	var TW = create_tween()
	TW.tween_property(parent.sprite, "modulate", Color(0.549451, 0.978881, 1), .2)
	TW.tween_property(parent.sprite, "modulate", Color(1, 1, 1), 1)

func curved_dash(objectPos):
	parent.global_position = objectPos
	
#func shadowmeld(location, projectileSpeed):
#	var shadowmeldCoverSprite = load("res://abilities/Dark/ShadowMeldCoverSprite.tscn")
#	var shadowmeldCover = shadowmeldCoverSprite.instance()
#	parent.turn_off_collision_masks()
#	parent.add_child(shadowmeldCover)
#	shadowmeldCover.play("animate")
#
#	var TW = get_tree().create_tween()
#	TW.tween_property(parent.sprite, "modulate", Color(0.231373, 0.168627, 0.380392, .7), .1)
#	TW.tween_property(parent, "position", location, projectileSpeed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
#	TW.tween_property(parent.sprite, "modulate", Color(1, 1, 1), 0.5)
#	TW.tween_callback(parent, "reset_collision_masks")
