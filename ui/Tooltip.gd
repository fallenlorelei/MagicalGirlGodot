extends Popup

#onready var skillbar = get_node("../../CanvasLayer/SkillBar")

onready var skillNameLabel = $Background/MarginContainer/VBoxContainer/SkillName
onready var skillTypeLabel = $Background/MarginContainer/VBoxContainer/SkillType
onready var damageOrHealLabel = $Background/MarginContainer/VBoxContainer/HBoxContainer/DamageOrHeal
onready var amountLabel = $Background/MarginContainer/VBoxContainer/HBoxContainer/DamageHealAmount
onready var skillDescriptionLabel = $Background/MarginContainer/VBoxContainer/SkillDescription

var origin = ""
var skillslot = ""
var skill_name = ""
var valid = false

func _ready():
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
