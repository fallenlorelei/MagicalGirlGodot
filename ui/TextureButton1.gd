extends TextureButton


func get_drag_data(_pos):
	var data = {}
	data["origin_texture"] = texture_normal
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture_normal
	drag_texture.rect_size = Vector2(100,100)
	
	# Making a "control node" to trick the texture to being center on the cursor
	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	
	set_drag_preview(control)
	
	return data
	
func can_drop_data(_pos, data):
	return true
	
func drop_data(_pos, data):
	texture_normal = data["origin_texture"]
