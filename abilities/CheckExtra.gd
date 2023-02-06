extends Node

var skillName
var skillElement

func _ready():
	pass

func check_extra():
	for skill in DataImport.skilltree_data:
		if DataImport.skilltree_data[skill].get(skillElement) == skillName + "_extra":
			var skillVariable = skillElement.to_lower() + "_" + skill.left(2) + "_extra"
			if SkillTreeTracker.fullTree.get(skillVariable) == true:
				extra_effect(skillName)

func load_extra_effect(skill_name):
	if skillName != null:
		var path = "res://abilities/" + skillElement + "/" + skill_name + "/" + skill_name + "_extra.tscn"
		return load(path)
		
func extra_effect(extra_skill):
	var loadedEffect = load_extra_effect(extra_skill)
	var extraProjectileAmount = DataImport.skill_data[extra_skill + "_extra"].ProjectileAmount
	for i in extraProjectileAmount:
		var extra_ability = loadedEffect.instance()
		extra_ability.skillName = str(extra_skill + "_extra")
		extra_ability.global_position = get_parent().global_position
		get_tree().get_current_scene().add_child(extra_ability)
	
		match DataImport.skill_data[extra_ability.skillName].SkillType:
				"physics_ball":
					extra_ability.physics_ball()
