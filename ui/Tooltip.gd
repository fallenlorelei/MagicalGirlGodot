extends Popup

#onready var skillbar = get_node("../../CanvasLayer/SkillBar")

onready var skillNameLabel = $Background/MarginContainer/VBoxContainer/SkillName
onready var skillTypeLabel = $Background/MarginContainer/VBoxContainer/SkillType
onready var damageOrHealLabel = $Background/MarginContainer/VBoxContainer/HBoxContainer/DamageOrHeal
onready var amountLabel = $Background/MarginContainer/VBoxContainer/HBoxContainer/DamageHealAmount
onready var skillDescriptionLabel = $Background/MarginContainer/VBoxContainer/SkillDescription

var origin = ""
var skill_slot = ""
var skill_name = ""
var valid = false
var screensize = Vector2(854,480)
var adj_pos = Vector2()

func _ready():
	update_tooltip()

func _physics_process(_delta):
	var cursor_pos = get_global_mouse_position()
#	adj_pos.x = clamp(cursor_pos.x, 0, screensize.x - rect_size.x - rect_pivot_offset.x)
#	adj_pos.y = clamp(cursor_pos.y, 0 , screensize.y - rect_size.y - rect_pivot_offset.y)
	adj_pos.x = clamp(cursor_pos.x, 0, screensize.x - rect_size.x - get_node("Background").rect_position.x)
	adj_pos.y = clamp(cursor_pos.y, 0 , screensize.y - rect_size.y - get_node("Background").rect_position.y)
	set_position(adj_pos)


func update_tooltip():
	# == SKILLBAR TOOLTIP ==
	if origin == "Skillbar" and skill_name != null:
		valid = true	
	if valid:
		skillNameLabel.set_text(skill_name.capitalize())
		
		skillTypeLabel.set_text(DataImport.skill_data[skill_name].SkillType.capitalize())
		
		if DataImport.skill_data[skill_name].CanDamage == true:
			damageOrHealLabel.set_text("Damage Amount: ")
			amountLabel.set_text(str(DataImport.skill_data[skill_name].SkillDamage))
		elif DataImport.skill_data[skill_name].CanHeal == true:
			damageOrHealLabel.set_text("Heal Amount: ")
			amountLabel.set_text(str(DataImport.skill_data[skill_name].HealAmount))
