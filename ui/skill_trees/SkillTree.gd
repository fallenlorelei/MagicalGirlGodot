extends Control

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		close_window()
	if Input.is_action_just_pressed("right_click"):
		close_window()

func close_window():
	get_tree().paused = false
		
	var crystalCounter = get_tree().get_root().get_node("Tilemap World/CanvasLayer/CrystalCounter")
	var TW = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_property(crystalCounter, "rect_position:x", -140.0, .3)
	TW.parallel().tween_property(self, "rect_scale", Vector2(0,0), .3)
	TW.tween_callback(self, "destroy")
	
func destroy():
	queue_free()

func _on_CloseButton_pressed():
	close_window()
