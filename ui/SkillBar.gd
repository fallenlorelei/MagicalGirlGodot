extends Control

onready var shortcuts_path = "Background/HBoxContainer/"

# Skills are hardcoded for testing purpose.
# Otherwise, should pull from save file.

var loaded_skills = {
	"Skill1": "Basic",
	"Skill2": "Smite",
	"Skill3": "Starry_Eyed",
	"Skill4": "Prismatica"
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
