extends CanvasLayer

@onready var close_button: Button = $Panel/Button

func _ready() -> void:
	close_button.pressed.connect(_on_close_pressed)

func _on_close_pressed() -> void:
	queue_free() 
