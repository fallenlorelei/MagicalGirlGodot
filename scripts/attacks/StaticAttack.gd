extends Area2D

var attack_cool_down = 250
var duration = 2000
var last_attack_time = 0
var start_time = 0


func _ready():
	start_time = Time.get_ticks_msec()

func _physics_process(delta):
	var current_time = Time.get_ticks_msec()
	if current_time - last_attack_time > attack_cool_down:
		last_attack_time = current_time
	if current_time - start_time > duration:
		queue_free()
	
