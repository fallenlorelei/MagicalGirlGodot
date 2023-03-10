extends Node

var treeInvestment = {
	"Light": 0,
	"Dark": 0
}

var fullTree = {
	#Change this so the skills are appended during runtime
	"light_investment": true,
	
	"light_0a_core": true,
	"light_0a_passive1": false,
	"light_0a_passive2": false,
	"light_0a_extra": false,
	
	"light_1a_core": true,
	"light_1a_passive1": false,
	"light_1a_passive2": false,
	"light_1a_passive3": false,
	"light_1a_extra": true,
	"light_1a_extra_passive1": false,
	"light_1a_extra_passive2": false,
	"light_1a_extra_passive3": false,
	
	"light_1b_core": false,
	"light_1b_passive1": false,
	"light_1b_passive2": false,
	"light_1b_passive3": false,
	"light_1b_extra": false,
	"light_1b_extra_passive1": false,
	"light_1b_extra_passive2": false,
	"light_1b_extra_passive3": false,
	
	"light_2a_core": true,
	"light_2a_passive1": false,
	"light_2a_passive2": false,
	"light_2a_passive3": false,
	"light_2a_extra": false,
	"light_2a_extra_passive1": false,
	"light_2a_extra_passive2": false,
	"light_2a_extra_passive3": false,
	
	"light_2b_core": false,
	"light_2b_passive1": false,
	"light_2b_passive2": false,
	"light_2b_passive3": false,
	"light_2b_extra": false,
	"light_2b_extra_passive1": false,
	"light_2b_extra_passive2": false,
	"light_2b_extra_passive3": false,
	
	"light_3a_core": false,
	"light_3a_passive1": false,
	"light_3a_passive2": false,
	"light_3a_passive3": false,
	"light_3a_extra": false,
	"light_3a_extra_passive1": false,
	"light_3a_extra_passive2": false,
	"light_3a_extra_passive3": false,
	
	"light_3b_core": false,
	"light_3b_passive1": false,
	"light_3b_passive2": false,
	"light_3b_passive3": false,
	"light_3b_extra": false,
	"light_3b_extra_passive1": false,
	"light_3b_extra_passive2": false,
	"light_3b_extra_passive3": false,
	
	"light_3c_core": false,
	"light_3c_passive1": false,
	"light_3c_passive2": false,
	"light_3c_passive3": false,
	"light_3c_extra": false,
	"light_3c_extra_passive1": false,
	"light_3c_extra_passive2": false,
	"light_3c_extra_passive3": false,
	
	"light_4a_core": false,
	"light_4a_passive1": false,
	"light_4a_passive2": false,
	"light_4a_passive3": false,
	"light_4a_extra": false,
	"light_4a_extra_passive1": false,
	"light_4a_extra_passive2": false,
	"light_4a_extra_passive3": false,
	
	"light_4b_core": false,
	"light_4b_passive1": false,
	"light_4b_passive2": false,
	"light_4b_passive3": false,
	"light_4b_extra": false,
	"light_4b_extra_passive1": false,
	"light_4b_extra_passive2": false,
	"light_4b_extra_passive3": false,
	
	"light_5a_core": false
}

func get_skill_name(skill, element):
	var skill_name
	match element:
		"Light":
			skill_name = DataImport.skilltree_data[skill].Light
	return skill_name
