extends Popup


onready var skillNameLabel = $"%SkillName"
onready var skillTypeLabel = $"%SkillType"
onready var cooldownDurationLabel = $"%CooldownDuration"
onready var skillDescriptionLabel = $"%SkillDescription"
onready var scrollContainer = $"%ScrollContainer"

var origin = ""
var skill_slot = ""
var skill_name = ""
var skillSize = ""
var valid = false
var screensize = Vector2(854,480)
var adj_pos = Vector2()

func _ready():
	update_tooltip()
	

func _physics_process(_delta):
	var cursor_pos = get_global_mouse_position()
	adj_pos.x = clamp(cursor_pos.x, 0, screensize.x - rect_size.x - get_node("Background").rect_position.x)
	adj_pos.y = clamp(cursor_pos.y, 0 , screensize.y - rect_size.y - get_node("Background").rect_position.y)
	set_position(adj_pos)
	
func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
#		event as InputEventMouseButton
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_UP:
					scrollContainer.scroll_vertical -= 3
				BUTTON_WHEEL_DOWN:
					scrollContainer.scroll_vertical += 3

func update_tooltip():		
	# == SKILLBAR TOOLTIP ==
	if origin == "Skillbar" and skill_name != null:
		valid = true	
	if valid:		
		skillNameLabel.set_text(skill_name.capitalize())
		
		skillTypeLabel.set_text(DataImport.skill_data[skill_name].SkillType.capitalize())
		
		cooldownDurationLabel.set_text(str(DataImport.skill_data[skill_name].CooldownDuration) + " seconds")
		
		var skillD1 = str(DataImport.skill_data[skill_name].SkillDescription1)
		var damageAmount = DataImport.skill_data[skill_name].SkillDamage
		var healAmount = DataImport.skill_data[skill_name].HealAmount
			
		var actual_string = skillD1.format(
			{"damage": "[color=#ff8f8f]" + str(damageAmount) + "[/color]",
			"hp": "[color=#7ac240]" + str(healAmount) + "[/color]",
			"element": DataImport.skill_data[skill_name].Element
			
			})
		
		skillDescriptionLabel.bbcode_text = actual_string
