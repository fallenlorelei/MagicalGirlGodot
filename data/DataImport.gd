extends Node

var skill_data
var new_skill_data

func _ready():
	var skill_data_file = File.new()
	skill_data_file.open("res://data/skillsheet2.json", File.READ)
	var skill_data_json = JSON.parse(skill_data_file.get_as_text())
	skill_data_file.close()
	skill_data = skill_data_json.result

#	var new_skill_data_file = File.new()
#	new_skill_data_file.open("res://data/skillsheet2.json", File.READ)
#	var new_skill_data_json = JSON.parse(new_skill_data_file.get_as_text())
#	new_skill_data_file.close()
#	new_skill_data = new_skill_data_json.result
