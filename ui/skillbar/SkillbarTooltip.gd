extends Popup


onready var skillNameLabel = $"%SkillName"
onready var skillTypeLabel = $"%SkillType"
onready var skillElementLabel = $"%SkillElement"
onready var cooldownDurationLabel = $"%CooldownDuration"
onready var skillDescriptionLabel = $"%SkillDescription"
onready var scrollContainer = $"%ScrollContainer"
onready var skillUpgradesLabel = $"%SkillUpgradesLabel"
onready var background = $Border/Background

var screensize = OS.window_size / 2 * 1.2
var adj_pos = Vector2()	

var origin = ""
var skill_name = ""
var skillSize = ""
var valid = false

func _ready():
	update_tooltip()
	
func _physics_process(_delta):
	var cursor_pos = get_global_mouse_position()
	set_position(cursor_pos)


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_UP:
					scrollContainer.scroll_vertical -= 3
				BUTTON_WHEEL_DOWN:
					scrollContainer.scroll_vertical += 3

func update_tooltip():		
	# == SKILLBAR TOOLTIP ==
	if origin == "Skillbar" or origin == "SkillTree":
		if skill_name != null:
			valid = true	
	if valid:		
		skillNameLabel.set_text(skill_name.capitalize())
		
		skillTypeLabel.set_text(DataImport.skill_data[skill_name].SkillType.capitalize())
		skillElementLabel.set_text(DataImport.skill_data[skill_name].Element.capitalize())
		
		cooldownDurationLabel.set_text(str(DataImport.skill_data[skill_name].CooldownDuration) + " seconds")
		
		var skillD = str(DataImport.skill_data[skill_name].SkillDescription)
		var damageAmount = DataImport.skill_data[skill_name].SkillDamage
		var healAmount = DataImport.skill_data[skill_name].HealAmount
			
		var actual_string = skillD.format(
			{"damage": "[color=#ff8f8f]" + str(damageAmount) + "[/color]",
			"hp": "[color=#7ac240]" + str(healAmount) + "[/color]",
			"element": DataImport.skill_data[skill_name].Element
			
			})
		
		skillDescriptionLabel.bbcode_text = actual_string

		if origin == "SkillTree":
			skillUpgradesLabel.hide()
