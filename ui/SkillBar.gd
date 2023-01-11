extends Control

signal mouseover

onready var shortcuts_path = "Background/HBoxContainer/"
onready var skill1 = $Background/HBoxContainer/Skill1/TextureButton
onready var skill2 = $Background/HBoxContainer/Skill2/TextureButton
onready var skill3 = $Background/HBoxContainer/Skill3/TextureButton
onready var skill4 = $Background/HBoxContainer/Skill4/TextureButton

var mouse_over_ui

# Skills are hardcoded for testing purpose.
# Otherwise, should pull from save file.

var loaded_skills = {
	"Skill1": "Basic",
	"Skill2": "Smite",
	"Skill3": "Healing_Light",
	"Skill4": null,
	"Skill5": null,
	"Skill6": null
}

func _ready():
	load_shortcuts()
	for shortcut in get_tree().get_nodes_in_group("AbilityShortcut"):
		shortcut.connect("pressed", self, "SelectShortcut", [shortcut.get_parent().get_name()])

func load_shortcuts():
	for shortcut in loaded_skills.keys():
		if loaded_skills[shortcut] != null:
			var skill_icon = load("res://assets/skill_icons/" + loaded_skills[shortcut] + "_icon.png")
			get_node(shortcuts_path + shortcut + "/TextureButton").set_normal_texture(skill_icon)

func SelectShortcut(shortcut):
	get_parent().get_parent().get_node("YSort/Player").selected_skill = loaded_skills[shortcut]


# Sends signal so player isn't left-click attacking when dragging abilities
func _on_TextureButton_mouse_entered():
	mouse_over_ui = true
	emit_signal("mouseover")

func _on_TextureButton_mouse_exited():
	mouse_over_ui = false
	emit_signal("mouseover")
