extends CanvasLayer

@onready var container: VBoxContainer = $VBoxContainer

func show_message(text: String, duration: float = 2.0):
	var label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 3)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	container.add_child(label)

	# Auto remove setelah duration
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.5).set_delay(duration)
	tween.tween_callback(Callable(label, "queue_free"))
