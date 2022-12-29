extends KinematicBody2D

func _ready():
	pass

export (int) var speed = 200
var this_rotation 

var velocity = Vector2()

func get_input():
    velocity = Vector2()
    look_at(get_viewport().get_mouse_position())
    if Input.is_action_pressed("right"):
        velocity.x += 1
    if Input.is_action_pressed("left"):
        velocity.x -= 1
    if Input.is_action_pressed("down"):
        velocity.y += 1
    if Input.is_action_pressed("up"):
        velocity.y -= 1
    velocity = velocity.normalized() * speed

func _physics_process(_delta):
    get_input()
    velocity = move_and_slide(velocity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pasself.s
