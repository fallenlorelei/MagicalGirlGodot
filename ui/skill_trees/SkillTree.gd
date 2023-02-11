extends Control

onready var tooltip = preload("res://ui/skillbar/SkillbarTooltip.tscn")
onready var outlineShader = preload("res://shaders/Outline.gdshader")
onready var skilltreeUnlockEffectSprite = preload("res://assets/sprites/SkillTree_Unlock_Effect_Sprite.tscn")

onready var crystalTextureNode = $"%CrystalTexture"
onready var crystalLabelNode = $"%CrystalLabel"
onready var crystalsRemainingNode = $"%CrystalsRemaining"
onready var elementDescriptionNode = $"%ElementDescription"

onready var tier1Requirements = $"%Tier1_Requirements_Label"
onready var tier2Requirements = $"%Tier2_Requirements_Label"
onready var tier3Requirements = $"%Tier3_Requirements_Label"
onready var tier4Requirements = $"%Tier4_Requirements_Label"
onready var tier5Requirements = $"%Tier5_Requirements_Label"

var treeElement: String
#export(String, "Light", "Dark", "Psychic", "Fire", "Ice", "Earth", "Thunder", "Wind", "Water") var treeElement

var totalInvestedPoints: int setget update_invested_points

func _ready():
	print("total invested: ", SkillTreeTracker.treeInvestment[treeElement])
	
	load_skills()
	load_skill_icons()
	load_skill_costs()
	update_bottom_text()
	update_invested_points(totalInvestedPoints)

	for button in get_tree().get_nodes_in_group("TreeSkillButtons"):
		button.connect("pressed", self, "unlock_skills", [button.get_parent()])
		button.connect("mouse_entered", self, "mouseover", [button.get_parent()])
		button.connect("mouse_entered", self, "tooltip_on", [button.get_parent()])
		button.connect("mouse_exited", self, "mouseexit", [button.get_parent()])
		button.connect("mouse_exited", self, "tooltip_off")
		
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		close_window()
	if Input.is_action_just_pressed("right_click"):
		close_window()

func load_skills():
	for skill in get_tree().get_nodes_in_group("TreeSkills"):
		var skill_node_name = skill.get_name()
		
		#enables skills that have already been unlocked
		if SkillTreeTracker.fullTree[treeElement.to_lower() + "_" + skill_node_name] == true:
			get_node("%" + skill_node_name + "/TextureButton").set_disabled(false)
			set_deco_border(skill_node_name)
			
		#enables skills that meet requirements
		elif SkillTreeTracker.fullTree[treeElement.to_lower() + "_" + DataImport.skilltree_data[skill_node_name].UnlockSkill] == true:
			set_basic_border(skill_node_name)
			
			if SkillTreeTracker.treeInvestment[treeElement] >= DataImport.skilltree_data[skill_node_name].RequiredInvestment:
				enable_unlocked_skills(skill_node_name)
		
		else:
			set_basic_border(skill_node_name)
			set_disabled_icon(skill)


func unlock_skills(skill):
	var skill_node_name = skill.get_name()
	var skillNode = skill
		
	if SkillTreeTracker.fullTree[treeElement.to_lower() + "_" + skill_node_name] == true:
		print("This is already unlocked.")
	else:
		if ElementalCrystalCounter.crystals[treeElement.to_upper()] < DataImport.skilltree_data[skill_node_name].Cost:
			print("Not enough crystals.")
			
		else:
			skill_unlock_effect(skill)
			var crystalElement = treeElement.to_upper()
			var crystalAmount = -DataImport.skilltree_data[skill_node_name].Cost
			ElementalCrystalCounter.update_crystals(crystalElement, crystalAmount)
			SkillTreeTracker.fullTree[treeElement.to_lower() + "_" + skill_node_name] = true
			self.totalInvestedPoints += 1
			skillNode.material = null
			skillNode.get_node("Amount/Label").set_text("")
			update_bottom_text()
			
			var unlocked_skills = []
			for key in DataImport.skilltree_data.keys():
				if DataImport.skilltree_data[key].UnlockSkill == skill_node_name:
					unlocked_skills.append(key)
				if DataImport.skilltree_data[key].UnlockSkill == "investment" and SkillTreeTracker.treeInvestment[treeElement] >= DataImport.skilltree_data[key].RequiredInvestment:
					unlocked_skills.append(key)

			if unlocked_skills != []:
				yield(get_tree().create_timer(.5), "timeout")
				for key in unlocked_skills:
					if get_node("%" + key + "/TextureButton").disabled == true:
						enable_unlocked_skills(key)

func enable_unlocked_skills(skill):
	var skill_node_name = skill
	var skillNode = get_node("%" + skill)
	var textureButton = get_node("%" + skill + "/TextureButton")
	
	skillNode.rect_pivot_offset = Vector2(skillNode.rect_size.x / 2, skillNode.rect_size.y / 2)
	var TW = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	TW.tween_property(skillNode, "rect_scale", Vector2(1.2,1.2), .1)
	TW.tween_property(skillNode, "rect_scale", Vector2(1,1), .2).set_ease(Tween.EASE_OUT)
	
	textureButton.set_disabled(false)
	set_basic_border(skill_node_name)
	skillNode.get_node("TextureButton").set_modulate(Color(.6,.6,.6))
	skillNode.material = ShaderMaterial.new()
	skillNode.material.shader = outlineShader
	skillNode.material.set_shader_param("line_color", Color(0.988235, 0.976471, 0.376471))
	skillNode.material.set_shader_param("line_scale", 0.5)
	
#Border for unlocked skills
func set_deco_border(skill):
	var skill_node_name = skill
	var skillNode = get_node("%" + skill_node_name)
	skillNode.texture = load("res://assets/ui/Box/box_border_modular.png")
	skillNode.set_patch_margin(MARGIN_LEFT, 13)
	skillNode.set_patch_margin(MARGIN_TOP, 13)
	skillNode.set_patch_margin(MARGIN_RIGHT, 13)
	skillNode.set_patch_margin(MARGIN_BOTTOM, 13)

#Border for not unlocked skills
func set_basic_border(skill):
	var skill_node_name = skill
	var skillNode = get_node("%" + skill_node_name)
	skillNode.texture = load("res://assets/ui/Box/box_border_basic.png")
	skillNode.set_patch_margin(MARGIN_LEFT, 5)
	skillNode.set_patch_margin(MARGIN_TOP, 5)
	skillNode.set_patch_margin(MARGIN_RIGHT, 5)
	skillNode.set_patch_margin(MARGIN_BOTTOM, 5)

func load_skill_costs():
	for skill in get_tree().get_nodes_in_group("TreeSkills"):
		var skill_node_name = skill.get_name()
		get_node("%" + skill_node_name + "/Amount/Label").set_text(str(DataImport.skilltree_data[skill_node_name].Cost))
		#removes cost from unlocked skills
		if SkillTreeTracker.fullTree[treeElement.to_lower() + "_" + skill_node_name] == true:
			get_node("%" + skill_node_name + "/Amount/Label").set_text("")


func load_skill_icons():
	for skill in get_tree().get_nodes_in_group("TreeSkills"):
		var skill_node_name = skill.get_name()
		var skill_name = SkillTreeTracker.get_skill_name(skill.get_name(), treeElement)
		var skill_icon = load("res://abilities/" + treeElement + "/" + skill_name + "/" + skill_name + "_icon.png")
		get_node("%" + skill_node_name + "/TextureButton").texture_normal = skill_icon

func set_disabled_icon(skill):
	var skill_name = SkillTreeTracker.get_skill_name(skill.get_name(), treeElement)
	var skill_node_name = skill.get_name()
	var skill_icon = load("res://abilities/" + treeElement + "/" + skill_name + "/" + skill_name + "_disabled_icon.png")
	get_node("%" + skill_node_name + "/TextureButton").texture_disabled = skill_icon

func update_bottom_text():
	var crystalSpritePath = "res://assets/sprites/elemental_crystals/elecrys_"
	crystalTextureNode.texture = load(crystalSpritePath + treeElement.to_lower() + ".png")
	crystalLabelNode.set_text(str(treeElement.capitalize()))
	crystalsRemainingNode.set_text(str(ElementalCrystalCounter.crystals[treeElement.to_upper()]))

	var elementDescription
	match treeElement:
		"Light":
			elementDescription = "Use Stars and Rainbows to both deal damage and heal."
			
	elementDescriptionNode.set_text(str(elementDescription))

func mouseover(skill):
	var skill_node_name = skill.get_name()
	if SkillTreeTracker.fullTree[treeElement.to_lower() + "_" + skill_node_name] == true:
		pass
	else:
		skill.texture = load("res://assets/ui/Box/box_border_basic_highlight.png")

func mouseexit(skill):
	var skill_node_name = skill.get_name()
	if SkillTreeTracker.fullTree[treeElement.to_lower() + "_" + skill_node_name] == true:
		set_deco_border(skill_node_name)
	else:
		set_basic_border(skill_node_name)

func skill_unlock_effect(skill):
	var skill_node_name = skill.get_name()
	var unlockEffect = skilltreeUnlockEffectSprite.instance()
	var skillNode = get_node("%" + skill_node_name)
	var buttonNode = get_node("%" + skill_node_name + "/TextureButton")
	
	unlockEffect.position = Vector2(skillNode.rect_size.x / 2, skillNode.rect_size.y / 2)
	skillNode.add_child(unlockEffect)
	unlockEffect.play("start")
	
	var TW = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	TW.parallel().tween_property(buttonNode, "modulate", Color(1, 1, 1), .2)
	TW.parallel().tween_property(skillNode, "rect_scale", Vector2(1.2,1.2), .1)
	TW.parallel().tween_property(unlockEffect, "scale", Vector2(1.2,1.2), .1)
	TW.tween_property(skillNode, "rect_scale", Vector2(1,1), .2).set_ease(Tween.EASE_OUT)
	TW.tween_property(unlockEffect, "scale", Vector2(1,1), .2).set_ease(Tween.EASE_OUT)
	
	yield(unlockEffect, "animation_finished")
	unlockEffect.queue_free()

func close_window():
	get_tree().paused = false
	var crystalCounter = get_tree().get_root().get_node("Station/CanvasLayer/CrystalCounter")
	var TW = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	TW.tween_property(crystalCounter, "rect_position:x", crystalCounter.posClosedx, .3)
	TW.parallel().tween_property(self, "rect_scale", Vector2(0,0), .3)
	TW.tween_callback(self, "destroy")
	
func destroy():
	queue_free()

func _on_CloseButton_pressed():
	close_window()
	
func update_invested_points(value):
	SkillTreeTracker.treeInvestment[treeElement] += value
	var tierText = str(SkillTreeTracker.treeInvestment[treeElement])
	var tier1RequiredAmount = str(3)
	var tier2RequiredAmount = str(6)
	var tier3RequiredAmount = str(12)
	var tier4RequiredAmount = str(24)
	var tier5RequiredAmount = str(50)
	tier1Requirements.set_text(tierText + " / " + tier1RequiredAmount)
	tier2Requirements.set_text(tierText + " / " + tier2RequiredAmount)
	tier3Requirements.set_text(tierText + " / " + tier3RequiredAmount)
	tier4Requirements.set_text(tierText + " / " + tier4RequiredAmount)
	tier5Requirements.set_text(tierText + " / " + tier5RequiredAmount)


func tooltip_on(skill):
	var skill_node_name = skill.get_name()
	var skill_name = SkillTreeTracker.get_skill_name(skill.get_name(), treeElement)
	var tooltip_instance = tooltip.instance()
	tooltip_instance.origin = "SkillTree"
	tooltip_instance.skill_name = skill_name
	add_child(tooltip_instance)
	yield(get_tree().create_timer(0.35), "timeout")
	if has_node("SkillbarTooltip") and get_node("SkillbarTooltip").valid:
		get_node("SkillbarTooltip").show()

func tooltip_off():
	if has_node("SkillbarTooltip") and get_node("SkillbarTooltip").valid:
		get_node("SkillbarTooltip").free()
