extends Node2D

var parent

func _ready():
	parent = get_parent()
	PlayerStats.connect("healed", self, "heal")
	SignalBus.connect("begin_shadowmeld", self, "shadowmeld")

func heal(healAmount):
	PlayerStats.hp += healAmount
	var TW = create_tween()
	TW.tween_property(parent.sprite, "modulate", Color(0.549451, 0.978881, 1), .2)
	TW.tween_property(parent.sprite, "modulate", Color(1, 1, 1), 1)

func shadowmeld(location, projectileSpeed):
	var shadowmeldCoverSprite = load("res://abilities/Dark/ShadowMeldCoverSprite.tscn")
	var shadowmeldCover = shadowmeldCoverSprite.instance()
	parent.turn_off_collision_masks()
	parent.add_child(shadowmeldCover)
	shadowmeldCover.play("animate")
	
	var TW = get_tree().create_tween()
	TW.tween_property(parent.sprite, "modulate", Color(0.231373, 0.168627, 0.380392, .7), .1)
	TW.tween_property(parent, "position", location, projectileSpeed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_property(parent.sprite, "modulate", Color(1, 1, 1), 0.5)
	TW.tween_callback(parent, "reset_collision_masks")
