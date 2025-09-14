extends CanvasLayer

@onready var retry_button: Button = $Panel/button_retry


func _ready() -> void:
	visible = false
	layer = 100  # biar di atas semua CanvasLayer lain
	print("Retry button node:", retry_button)
	retry_button.pressed.connect(_on_retry_pressed)
	
	print("Panel mouse filter:", $Panel.mouse_filter)
	print("Retry button mouse filter:", $Panel/button_retry.mouse_filter)
	$Panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_game_over():
	visible = true
	layer = 100   # pastikan paling atas
	print("GameOverUI visible:", visible, " layer:", layer)


func _on_retry_pressed() -> void:
	print("Retry pressed!")  # debug
	Global.reset_player_data()
	get_tree().reload_current_scene()
	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("Klik terdeteksi di GameOverUI di posisi:", event.position)
