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
