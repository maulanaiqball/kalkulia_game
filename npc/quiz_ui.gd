extends CanvasLayer
signal quiz_finished(npc: Node)

@onready var panel: Panel = $Panel
@onready var question_label: Label = $Panel/VBoxContainer2/QuestionLabel
@onready var options_box: VBoxContainer = $Panel/VBoxContainer2/Options
@onready var feedback_label: Label = $Panel/VBoxContainer2/FeedbackLabel

var _queue: Array = []
var _current: Dictionary = {}
var _npc_ref: Node = null
var _is_running := false
var _choice_lock := false

func _ready() -> void:
	visible = false
	feedback_label.text = ""

func open(questions: Array, npc: Node) -> void:
	if questions.is_empty():
		NotificationUi.show_message("Tidak ada pertanyaan.")
		return

	_npc_ref = npc
	_queue = questions.duplicate(true)
	_is_running = true
	feedback_label.text = ""
	_build_next_question()

	show()
	panel.grab_focus()

func _build_next_question() -> void:
	for c in options_box.get_children():
		c.queue_free()

	if _queue.is_empty():
		_is_running = false
		feedback_label.text = "Selesai! Semua benar 🎉"
		emit_signal("quiz_finished", _npc_ref)
		await get_tree().create_timer(0.8).timeout
		_on_close_pressed()
		return

	_current = _queue.pop_front()
	feedback_label.text = ""
	_choice_lock = false

	question_label.text = str(_current.get("text", "???"))

	var choices: Array = _current.get("choices", [])
	for i in range(choices.size()):
		var b := Button.new()
		b.text = str(choices[i])
		b.custom_minimum_size = Vector2(200, 32)

		# Set stylebox texture
		var stylebox := StyleBoxTexture.new()
		stylebox.texture = load("res://drop_item/drop_item.png")
		b.add_theme_stylebox_override("normal", stylebox)
		b.add_theme_stylebox_override("hover", stylebox)
		b.add_theme_stylebox_override("pressed", stylebox)

		b.pressed.connect(_on_choice_pressed.bind(i))
		options_box.add_child(b)



func _on_choice_pressed(choice_idx: int) -> void:
	if _choice_lock: return
	_choice_lock = true

	var correct_idx: int = int(_current.get("correct", -1))
	if choice_idx == correct_idx:
		NotificationUi.show_message("Benar!")
		feedback_label.text = "Benar ✓"
		await get_tree().create_timer(0.7).timeout
		_build_next_question()
	else:
		_queue.append(_current)
		NotificationUi.show_message("Salah! Pertanyaan akan diulang.")
		feedback_label.text = "Salah ✗ (diulang nanti)"
		await get_tree().create_timer(0.7).timeout
		_build_next_question()

func _on_close_pressed() -> void:
	hide()
	_queue.clear()
	_current.clear()
	_npc_ref = null
	_is_running = false
	_choice_lock = false
	for c in options_box.get_children():
		c.queue_free()
