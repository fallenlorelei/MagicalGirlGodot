extends Popup

#onready var skillbar = get_node("../../CanvasLayer/SkillBar")

var origin = ""
var skillslot = ""
var skill_name = ""
var valid = false

func _ready():
	var skill_name
	if origin == "Skillbar":
		valid = true
	
	if valid:
		pass
