extends Control

onready var shortcuts_path = "Border/HBoxContainer/"

var mouse_over_ui

# Skills are hardcoded for testing purpose.
# Otherwise, should pull from save file.

var loaded_skills = {
	"left_click": "Light_Bow",
	"ability1": "Starburst",
	"ability2": null,
	"ability3": null,
	"ability4": null,
	"ability5": null,
	"ability6": null
}

func _ready():
	load_shortcuts()
	for shortcut in get_tree().get_nodes_in_group("AbilityShortcut"):
		shortcut.connect("pressed", self, "SelectShortcut", [shortcut.get_parent().get_name()])

func _physics_process(_delta):
	#For some reason the shortcut isn't working unless I do this
	#Bandaid
	if Input.is_action_just_pressed("left_click"):
		get_node(shortcuts_path + "/left_click/TextureButton").emit_signal("pressed")
		
func load_shortcuts():
	for shortcut in loaded_skills.keys():
		if loaded_skills[shortcut] != null:
			var skill_element = DataImport.skill_data[loaded_skills[shortcut]].Element
			var skill_icon = load("res://abilities/" + skill_element + "/" + loaded_skills[shortcut] + "/" + loaded_skills[shortcut] + "_icon.png")
			get_node(shortcuts_path + shortcut + "/TextureButton").set_normal_texture(skill_icon)

# == FIND PLAYER AND SEND SELECTED SKILL ==
func SelectShortcut(shortcut):
	var cooldownCheck = get_node(shortcuts_path + shortcut + "/TextureButton")
	if cooldownCheck.onCooldown == false:
		get_parent().get_parent().get_node("../../YSort/Player").selected_skillSlot = shortcut
		get_parent().get_parent().get_node("../../YSort/Player").selectedSkill = loaded_skills[shortcut]
	else:
		print("This skill is on cooldown.")
	
# Sends signal so player isn't left-click attacking when dragging abilities
func _on_TextureButton_mouse_entered():
	mouse_over_ui = true
	SignalBus.emit_signal("mouseover", true)

func _on_TextureButton_mouse_exited():
	mouse_over_ui = false
	SignalBus.emit_signal("mouseover", false)
