extends Control

@onready var music_button: Area2D = $button
@onready var label: Label = $button/Sprite2D/Label 

func _ready():
	# Set label sesuai status musik saat ini
	_update_label()

	# Sambungkan input event dari Area2D
	music_button.input_event.connect(_on_music_button_pressed)

func _on_music_button_pressed(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Toggle musik
		AudioManager.toggle_music()
		_update_label()

func _update_label():
	if AudioManager.is_music_on:
		label.text = "Music: ON"
	else:
		label.text = "Music: OFF"
