extends Node2D

@onready var touch:TouchScreenButton = %TouchBtn
@onready var init_pos:Marker2D = %InitPos

@export var up_input:String = "move_up"
@export var down_input:String = "move_down"
@export var left_input:String = "move_left"
@export var right_input:String = "move_right"

var radius = 40
var is_pressed := false   # flag joystick ditekan

func _ready() -> void:
	touch.pressed.connect(_on_touch_pressed)
	touch.released.connect(_on_touch_released)
	# pastikan stick ada di posisi awal saat start
	touch.global_position = init_pos.global_position

func _draw() -> void:
	var center = Vector2.ZERO
	var draw_radius = 100
	var start_angle = 0.0 
	var end_angle = 360 
	var color = Color.LIGHT_STEEL_BLUE
	var width = 1
	draw_arc(center, draw_radius, start_angle, end_angle,120, color, width,true)
	draw_circle(touch.position,60,color)
	draw_arc(touch.position, 60, start_angle, end_angle,120, color, width,true)

func _on_touch_pressed() -> void:
	is_pressed = true

func _on_touch_released() -> void:
	is_pressed = false
	# reset posisi stick
	touch.global_position = init_pos.global_position
	# reset semua input
	reset_dir()

func _process(_delta: float) -> void:
	queue_redraw()
	if not is_pressed:
		return   # kalau tidak ditekan, joystick tidak bergerak

	var mouse_pos = get_global_mouse_position()
	var touch_pos = init_pos.global_position
	var distance = touch_pos.distance_to(mouse_pos)
	var mouse_dir = (mouse_pos - touch_pos).normalized()
	if distance > radius:
		mouse_pos = touch_pos + (mouse_dir * radius)

	touch.global_position = mouse_pos

	# cek arah
	var angle = init_pos.get_angle_to(mouse_pos)
	if angle >= -0.5 and angle <= 0.5:
		reset_dir()
		Input.action_press(right_input)
	elif angle >= 0.5 and angle <= 1.0:
		reset_dir()
		Input.action_press(down_input)
		Input.action_press(right_input)
	elif angle >= 1.0 and angle <= 2.1:
		reset_dir()
		Input.action_press(down_input)
	elif angle >= 2.1 and angle <= 2.7:
		reset_dir()
		Input.action_press(down_input)
		Input.action_press(left_input)
	elif angle >= 2.7 and angle <= 3.2:
		reset_dir()
		Input.action_press(left_input)
	elif angle >= -3.2 and angle <= -2.7:
		reset_dir()
		Input.action_press(left_input)
	elif angle >= -2.7 and angle <= -2.1:
		reset_dir()
		Input.action_press(up_input)
		Input.action_press(left_input)
	elif angle >= -2.1 and angle <= -1.0:
		reset_dir()
		Input.action_press(up_input)
	elif angle >= -1.0 and angle <= -0.5:
		reset_dir()
		Input.action_press(up_input)
		Input.action_press(right_input)

#Reset inputs
func reset_dir():
	Input.action_release(up_input)
	Input.action_release(down_input)
	Input.action_release(left_input)
	Input.action_release(right_input)
