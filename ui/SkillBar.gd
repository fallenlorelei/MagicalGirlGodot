extends Control

onready var shortcuts_path = "Background/HBoxContainer/"

# Should not hardcode the skills here. Should pull from save file (which skills player
# has access to).
var loaded_skills = {
	"Skill1": "projectileToCursorDir",
	"Skill2": "atCursor",
	"Skill3": null,
	"Skill4": null
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
