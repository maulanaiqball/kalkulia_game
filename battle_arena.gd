# res://batle/battle_arena.gd
extends Node2D

@onready var quiz_ui: CanvasLayer = $QuizUI
@onready var question_label: Label = $QuizUI/Panel/QuestionLabel
@onready var options_box: HBoxContainer = $QuizUI/Panel/OptionsBox

# daftar pertanyaan
var questions: Array = [
	{
		"question": "2 + 2 = ?", 
		"choices": ["3", "4", "5"], 
		"answer": 1
	},
	{
		"question": "5 + 5 = ?", 
		"choices": ["1", "2", "10"], 
		"answer": 2
	},
	{
		"question": "5 + 6 = ?", 
		"choices": ["1", "11", "10"], 
		"answer": 1
	}
]

var current_index: int = 0

func _ready() -> void:
	quiz_ui.visible = false
	show_quiz()

func show_quiz() -> void:
	quiz_ui.visible = true

	# ambil soal saat ini
	var q: Dictionary = questions[current_index]
	question_label.text = str(q["question"])

	# bersihkan tombol lama
	for child in options_box.get_children():
		child.queue_free()

	# buat tombol opsi jawaban
	var choices: Array = q["choices"]
	for i in range(choices.size()):
		var b := Button.new()
		b.text = str(choices[i])
		b.custom_minimum_size = Vector2(32, 32)

		# styling tombol
		var sb := StyleBoxTexture.new()
		sb.texture = load("res://drop_item/drop_item.png")
		b.add_theme_stylebox_override("normal", sb)
		b.add_theme_stylebox_override("hover", sb)
		b.add_theme_stylebox_override("pressed", sb)

		# hubungkan event tombol
		b.pressed.connect(_on_choice_pressed.bind(i))
		options_box.add_child(b)

func _on_choice_pressed(idx: int) -> void:
	var q: Dictionary = questions[current_index]
	var correct: int = int(q["answer"])

	if idx == correct:
		# kalau benar → player serang boss
		var player = get_tree().get_first_node_in_group("player")
		var boss = get_tree().get_first_node_in_group("boss")
		if player and boss:
			if player.has_method("shoot"):
				player.shoot(boss)
	else:
		# kalau salah → kasih feedback di sini
		print("Jawaban salah!")

	# lanjut ke soal berikutnya
	current_index += 1
	if current_index >= questions.size():
		quiz_ui.visible = false  # selesai
	else:
		show_quiz()
