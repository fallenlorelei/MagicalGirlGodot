extends Node

var skill_data
var skilltree_data

func _ready():
	read_skillsheet()
	read_skilltreedata()

func read_skillsheet():
	var skill_data_file = File.new()
	skill_data_file.open("res://data/skillsheet.json", File.READ)
	var skill_data_json = JSON.parse(skill_data_file.get_as_text())
	skill_data_file.close()
	skill_data = skill_data_json.result

func read_skilltreedata():
	var skilltree_data_file = File.new()
	skilltree_data_file.open("res://data/skilltreedata.json", File.READ)
	var skilltree_data_json = JSON.parse(skilltree_data_file.get_as_text())
	skilltree_data_file.close()
	skilltree_data = skilltree_data_json.result
