extends Node

onready var hpBar = get_parent()

func _ready():
	pass

func hpBarUpdate(current_hp, max_hp):	
	var hpPercentage = int((float(current_hp) / max_hp) * 100)
	var TW = get_tree().create_tween()
	TW.tween_property(hpBar, "value", float(hpPercentage), .2)
	
	if hpPercentage > 75:
		hpBar.set_tint_progress("7ac240")
	elif hpPercentage <= 75 and hpPercentage >=30:
		TW.tween_property(hpBar, "tint_progress", Color(0.870588, 0.415686, 0.219608), .2)
	else:
		TW.tween_property(hpBar, "tint_progress", Color(0.65098, 0.192157, 0.27451), .2)
