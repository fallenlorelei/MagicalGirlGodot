extends Position2D

onready var label = $Label

var amount = 0
var skillType = ""
var max_size = Vector2(1,1)

func _ready():
	label.set_text(str(amount))
	match skillType:
		"Heal":
			label.set("custom_colors/font_color",Color("7ac240"))
		"Damage":
			label.set("custom_colors/font_color",Color("de6a38"))
		"CriticalDamage":
			label.set("custom_colors/font_color",Color("a63146"))
			max_size = Vector2(1.5,1.5)

	var TW = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	TW.tween_property(self, "scale", max_size, .2)
	TW.parallel().tween_property(self, "position", random_vector(), .3)
	TW.tween_property(self, "scale", Vector2(.1,.1), .7).set_delay(.3)
	TW.tween_callback(self, "destroy")
	

func random_vector():
	var random_range_x = 10
	var random_range_y = -30
	var random_x = rand_range(-random_range_x ,random_range_x )
	var random_y = rand_range(0, random_range_y)
	var random_vector = Vector2(random_x, random_y)
	return random_vector
	
func destroy():
	queue_free()
