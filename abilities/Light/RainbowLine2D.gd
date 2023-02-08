extends Node2D

#x,y is starting position
var p_A = Vector2(0, 100)

#x is ending position
var p_B = Vector2(250, p_A.y)

#y is how high it goes up
var p_postA = Vector2(p_A.x, -60)
var p_preB = p_postA

onready var line = $RainbowLine
onready var rectA = $ColorRect
onready var rectpostA = $ColorRect2
onready var rectpreB = $ColorRect3
onready var rectB = $ColorRect4

func _ready():
#	setLinePointsToBezierCurve(line, p_A, p_postA, p_preB, p_B)
	rectA.rect_position = p_A
	rectpostA.rect_position = p_postA
	rectpreB.rect_position = p_preB
	rectB.rect_position = p_B
	
func setLinePointsToBezierCurve(line: Line2D, a: Vector2, postA: Vector2, preB: Vector2, b: Vector2):
	var curve := Curve2D.new()
	curve.add_point(a, Vector2.ZERO, postA)
	curve.add_point(b, preB, Vector2.ZERO)
	line.points = curve.get_baked_points()

func _physics_process(delta):
	p_B = get_global_mouse_position()
	setLinePointsToBezierCurve(line, p_A, p_postA, p_preB, p_B)
