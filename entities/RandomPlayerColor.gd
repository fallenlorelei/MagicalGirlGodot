extends Sprite

var hair_color_light_shade
var hair_color_main_shade
var hair_color_dark_shade

var outfit_color_light_shade
var outfit_color_main_shade
var outfit_color_dark_shade

var skin_color_light_shade
var skin_color_main_shade
var skin_color_dark_shade

var eye_color_light_shade
var eye_color_main_shade
var eye_color_dark_shade

func _ready():
	pass

func randomize_color():
	randomize()
		
	var hair_color_schemes = [
		"Blue",
		"Green",
		"Pink",
		"Purple"
	]
	var outfit_color_schemes = [
		"Blue",
		"Green",
		"Pink",
		"Purple"
	]
	var skin_color_schemes = [
		"Pale",
		"Light",
		"Tan",
		"Dark"
	]
	var eye_color_schemes = [
		"Blue",
		"Green",
		"Pink",
		"Purple"
	]
	
	var random_hair_color = hair_color_schemes[randi() % hair_color_schemes.size()]
	var random_outfit_color = outfit_color_schemes[randi() % outfit_color_schemes.size()]
	var random_skin_color = skin_color_schemes[randi() % skin_color_schemes.size()]
	var random_eye_color = eye_color_schemes[randi() % eye_color_schemes.size()]
	
	print("Random Hair: ", random_hair_color, " | Random Outfit: ", random_outfit_color, " | Random Skin: ", random_skin_color, " | Random Eyes: ", random_eye_color)
	match random_hair_color:
		"Blue":
			hair_color_light_shade = Color(0.282353, 0.729412, 0.780392)
			hair_color_main_shade = Color(0.152941, 0.392157, 0.631373)
			hair_color_dark_shade = Color(0.113725, 0.176471, 0.411765)
		"Green":
			hair_color_light_shade = Color(0.803922, 0.929412, 0.388235)
			hair_color_main_shade = Color(0.478431, 0.760784, 0.25098)
			hair_color_dark_shade = Color(0.188235, 0.490196, 0.137255)
		"Pink":
			hair_color_light_shade = Color(1, 0.560784, 0.560784)
			hair_color_main_shade = Color(0.890196, 0.321569, 0.462745)
			hair_color_dark_shade = Color(0.65098, 0.192157, 0.27451)
		"Purple":
			hair_color_light_shade = Color(0.576471, 0.309804, 0.741176)
			hair_color_main_shade = Color(0.337255, 0.247059, 0.588235)
			hair_color_dark_shade = Color(0.231373, 0.168627, 0.380392)
	
	match random_outfit_color:
		"Blue":
			outfit_color_light_shade = Color(0.282353, 0.729412, 0.780392)
			outfit_color_main_shade = Color(0.152941, 0.392157, 0.631373)
			outfit_color_dark_shade = Color(0.113725, 0.176471, 0.411765)
		"Green":
			outfit_color_light_shade = Color(0.803922, 0.929412, 0.388235)
			outfit_color_main_shade = Color(0.478431, 0.760784, 0.25098)
			outfit_color_dark_shade = Color(0.188235, 0.490196, 0.137255)
		"Pink":
			outfit_color_light_shade = Color(1, 0.560784, 0.560784)
			outfit_color_main_shade = Color(0.890196, 0.321569, 0.462745)
			outfit_color_dark_shade = Color(0.65098, 0.192157, 0.27451)
		"Purple":
			outfit_color_light_shade = Color(0.576471, 0.309804, 0.741176)
			outfit_color_main_shade = Color(0.337255, 0.247059, 0.588235)
			outfit_color_dark_shade = Color(0.231373, 0.168627, 0.380392)
			
	match random_skin_color:
		"Pale":
			skin_color_light_shade = Color(0.945098, 1, 0.74902)
			skin_color_main_shade = Color(0.921569, 0.713726, 0.580392)
			skin_color_dark_shade = Color(0.870588, 0.607843, 0.443137)
		"Light":
			skin_color_light_shade = Color(0.921569, 0.713726, 0.580392)
			skin_color_main_shade = Color(0.870588, 0.607843, 0.443137)
			skin_color_dark_shade = Color(0.690196, 0.45098, 0.301961)
		"Tan":
			skin_color_light_shade = Color(0.870588, 0.607843, 0.443137)
			skin_color_main_shade = Color(0.690196, 0.45098, 0.301961)
			skin_color_dark_shade = Color(0.388235, 0.215686, 0.101961)
		"Dark":
			skin_color_light_shade = Color(0.690196, 0.45098, 0.301961)
			skin_color_main_shade = Color(0.388235, 0.215686, 0.101961)
			skin_color_dark_shade = Color(0.168627, 0.090196, 0.035294)

	match random_eye_color:
		"Blue":
			eye_color_light_shade = Color(0.282353, 0.729412, 0.780392)
			eye_color_main_shade = Color(0.152941, 0.392157, 0.631373)
			eye_color_dark_shade = Color(0.113725, 0.176471, 0.411765)
		"Green":
			eye_color_light_shade = Color(0.803922, 0.929412, 0.388235)
			eye_color_main_shade = Color(0.478431, 0.760784, 0.25098)
			eye_color_dark_shade = Color(0.188235, 0.490196, 0.137255)
		"Pink":
			eye_color_light_shade = Color(1, 0.560784, 0.560784)
			eye_color_main_shade = Color(0.890196, 0.321569, 0.462745)
			eye_color_dark_shade = Color(0.65098, 0.192157, 0.27451)
		"Purple":
			eye_color_light_shade = Color(0.576471, 0.309804, 0.741176)
			eye_color_main_shade = Color(0.337255, 0.247059, 0.588235)
			eye_color_dark_shade = Color(0.231373, 0.168627, 0.380392)
			
	#Hair 0, 1, 2
	material.set_shader_param("replace_0", hair_color_light_shade)
	material.set_shader_param("replace_1", hair_color_main_shade)
	material.set_shader_param("replace_2", hair_color_dark_shade)
	
	#Outfit 3, 4, 5
	material.set_shader_param("replace_3", outfit_color_light_shade)
	material.set_shader_param("replace_4", outfit_color_main_shade)
	material.set_shader_param("replace_5", outfit_color_dark_shade)
	
	#Outfit 6, 7, 8
	material.set_shader_param("replace_6", skin_color_light_shade)
	material.set_shader_param("replace_7", skin_color_main_shade)
	material.set_shader_param("replace_8", skin_color_dark_shade)

	#Eyes 9, 10, 11
	material.set_shader_param("replace_9", eye_color_light_shade)
	material.set_shader_param("replace_10", eye_color_main_shade)
	material.set_shader_param("replace_11", eye_color_dark_shade)
