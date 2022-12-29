extends AnimatedSprite

export(String, "BLUE","GREEN","PINK","PURPLE","RED") var ElementalCrystals



func _ready():
	random_element()

func random_element():
	var elementalCrystal = ElementalCrystals.keys()[randi() % ElementalCrystals.size()]
	print(elementalCrystal)
	self.play(str(elementalCrystal))
	
