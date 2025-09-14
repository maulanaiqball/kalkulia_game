extends Node2D

@onready var joystick_instance:PackedScene = preload("joystick.tscn")
@onready var joystick_spawner: TouchScreenButton = %JoystickSpawner
##The side of the screen where the joystick will appear.
@export_enum(
	"LEFT","RIGHT","BOTH"
) var side = "LEFT"
func _ready() -> void:
	Input.emulate_mouse_from_touch = true
	Input.emulate_touch_from_mouse = true
	match side:
		"BOTH":
			joystick_spawner.shape.size.x = get_viewport().size.x
			joystick_spawner.position.x = get_viewport().size.x / 2
		"LEFT":
			joystick_spawner.shape.size.x = get_viewport().size.x / 2
			joystick_spawner.position.x = get_viewport().size.x / 4
		"RIGHT":
			joystick_spawner.shape.size.x = get_viewport().size.x / 2
			joystick_spawner.position.x = get_viewport().size.x / 1.333
		
	joystick_spawner.shape.size.y = get_viewport().size.y
	joystick_spawner.position.y = get_viewport().size.y /2
		


func _on_joystick_spawner_pressed() -> void:
	var joy = joystick_instance.instantiate()
	joy.position = get_global_mouse_position()
	add_child(joy)


func _on_joystick_spawner_released() -> void:
	if get_child_count() > 0 and get_child(1) != joystick_spawner:
		get_child(1).reset_dir()
		get_child(1).queue_free()
