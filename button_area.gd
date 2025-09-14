extends Area2D

@export_file("*.tscn") var target_scene: String   # bisa diatur langsung di Inspector
@onready var sprite: Sprite2D = $Sprite2D

# Warna untuk efek
var color_normal: Color = Color(1, 1, 1)       # putih normal
var color_hover: Color = Color(0.8, 0.8, 1)    # kebiruan saat hover
var color_pressed: Color = Color(0.6, 0.6, 1)  # lebih gelap saat ditekan

func _ready() -> void:
	sprite.modulate = color_normal
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

# Hover effect
func _on_mouse_entered() -> void:
	sprite.modulate = color_hover

func _on_mouse_exited() -> void:
	sprite.modulate = color_normal

# Klik / touch
func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			sprite.modulate = color_pressed
		else:
			sprite.modulate = color_hover
			_do_action()

	if event is InputEventScreenTouch:
		if event.pressed:
			sprite.modulate = color_pressed
		else:
			sprite.modulate = color_normal
			_do_action()

func _do_action() -> void:
	if target_scene == "":
		push_error("Target scene belum diatur!")
		return
	print("Pindah ke scene:", target_scene)
	var err := get_tree().change_scene_to_file(target_scene)
	if err != OK:
		push_error("Gagal pindah scene! Pastikan path benar.")
