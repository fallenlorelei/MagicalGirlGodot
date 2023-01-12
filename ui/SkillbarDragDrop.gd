extends TextureButton

onready var tooltip = preload("res://ui/Tooltip.tscn")

var skill_slot
var skill_name

func _ready():
	pass


func get_drag_data(_pos):
	skill_slot = get_parent().get_name()
	skill_name = get_owner().loaded_skills[skill_slot]
	print("dragging ", skill_slot, ": ", skill_name)
	if skill_name != null:
		var data = {}
		data["origin_node"] = self
		data["origin_texture"] = texture_normal
		data["origin_skill_name"] = skill_name
		data["origin_skill_slot"] = skill_slot
		
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = texture_normal
		drag_texture.rect_size = Vector2(50,50)
		
		# Making a "control node" to trick the texture to being center on the cursor
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		
		set_drag_preview(control)
		
		return data
	
func can_drop_data(_pos, data):
	var target_skill_slot_scene = get_parent()
	if target_skill_slot_scene.is_in_group("DraggableSkill"):
		var target_skill_slot = get_parent().get_name()
		if get_owner().loaded_skills[target_skill_slot] == null:
			data["target_texture"] = null
			data["target_skill_name"] = null
		else:
			data["target_skill_name"] = get_owner().loaded_skills[target_skill_slot]
			data["target_texture"] = texture_normal
		return true
	else:
		return false
	
func drop_data(_pos, data):
	var target_skill_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()
	
	#Update data of origin
	get_owner().loaded_skills[origin_slot] = data["target_skill_name"]
	
	#Update texture of the origin
	if data["target_skill_name"] == null:
		var empty_texture = null
		data["origin_node"].texture_normal = empty_texture
	else:
		data["origin_node"].texture_normal = data["target_texture"]
		
	#Update texture and data of target
	get_owner().loaded_skills[target_skill_slot] = data["origin_skill_name"]
	texture_normal = data["origin_texture"]


func _on_TextureButton_mouse_entered():
	var tooltip_instance = tooltip.instance()
	tooltip_instance.origin = "Skillbar"
	tooltip_instance.skillslot = get_parent().get_name()
	tooltip_instance.skill_name = skill_name
	
	tooltip_instance.rect_position = get_parent().get_global_transform_with_canvas().origin - Vector2(40,80)

	add_child(tooltip_instance)
	yield(get_tree().create_timer(0.35), "timeout")
	if has_node("Tooltip") and get_node("Tooltip").valid:
		get_node("Tooltip").show()

func _on_TextureButton_mouse_exited():
	get_node("Tooltip").free()
