extends Control

onready var tooltip = $HPTooltip

func _ready():
	pass
	

func _on_HealthBar_mouse_entered():
	tooltip.show()
	yield(get_tree().create_timer(0.35), "timeout")


func _on_HealthBar_mouse_exited():
	tooltip.hide()
