extends TextureButton

onready var tooltip = preload("res://ui/SkillbarTooltip.tscn")

var tooltip_instance
var skillName
var skillShortcut

func _ready():
	SignalBus.connect("start_cooldown", self, "get_progressbar")

# == DRAG AND DROP ==
func get_drag_data(_pos):
	var skill_slot = get_parent().get_name()
	var skill_name = get_owner().loaded_skills[skill_slot]
	if skill_name != null and cooldownCheck() == false:
		var data = {}
		data["origin_node"] = self
		data["origin_texture"] = texture_normal
		data["origin_skill_name"] = skill_name
		data["origin_skill_slot"] = skill_slot
		
		# Dragging texture
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
	
	if has_node("SkillbarTooltip"):
		get_node("SkillbarTooltip").free()
		
	if target_skill_slot_scene.is_in_group("DraggableSkill"):
		
		var target_skill_slot = get_parent().get_name()
		var target_skill_name = get_owner().loaded_skills[target_skill_slot]

		if get_owner().loaded_skills[target_skill_slot] == null:
			data["target_texture"] = null
			data["target_skill_name"] = null
			data["target_skill_slot"] = null
			
		else:
			data["target_texture"] = texture_normal
			data["target_skill_name"] = target_skill_name
			data["target_skill_slot"] = target_skill_slot
			
		
		return true
	else:
		return false
	
func drop_data(_pos, data):
	if has_node("SkillbarTooltip") and get_node("SkillbarTooltip").valid:
		get_node("SkillbarTooltip").free()
		
	var target_skill_slot = get_parent().get_name()
	var origin_skill_slot = data["origin_node"].get_parent().get_name()
	
	#Update data of origin
	get_owner().loaded_skills[origin_skill_slot] = data["target_skill_name"]
	
	#Update texture of orign
	if data["target_skill_name"] == null:
		data["origin_node"].texture_normal = load("res://assets/ui/Skillbar/skillbar-skillbg.png")
	else:
		data["origin_node"].texture_normal = data["target_texture"]
		
	#Update both data and texture of target
	get_owner().loaded_skills[target_skill_slot] = data["origin_skill_name"]
	texture_normal = data["origin_texture"]
	
	
# == TOOLTIP ==
func _on_TextureButton_mouse_entered():
	tooltip_instance = tooltip.instance()
	var skill_slot = get_parent().get_name()
	var skill_name = get_owner().loaded_skills[skill_slot]
	tooltip_instance.origin = "Skillbar"
	tooltip_instance.skill_slot = skill_slot
	tooltip_instance.skill_name = skill_name
	add_child(tooltip_instance)
	yield(get_tree().create_timer(0.35), "timeout")
	if has_node("SkillbarTooltip") and get_node("SkillbarTooltip").valid:
		get_node("SkillbarTooltip").show()

func _on_TextureButton_mouse_exited():
	if has_node("SkillbarTooltip") and get_node("SkillbarTooltip").valid:
		get_node("SkillbarTooltip").free()

# == COOLDOWNS ==
func get_progressbar(skill_shortcut, cooldown):
	var progressBar = get_owner().get_node("Background/HBoxContainer/" + skill_shortcut + "/TextureButton")
	progressBar.start_cooldown(cooldown)

func cooldownCheck():
	pass
