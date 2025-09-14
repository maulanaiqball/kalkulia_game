# res://batle/battle_arena.gd
extends Node2D

@onready var quiz_ui: CanvasLayer = $QuizUI
@onready var question_label: Label = $QuizUI/Panel/QuestionLabel
@onready var options_box: HBoxContainer = $QuizUI/Panel/OptionsBox

# daftar pertanyaan
var questions: Array = [
	{
		"question": "🍎🍎\nBerapa jumlah apel di atas?",
		"choices": ["1", "2", "3"],
		"answer": 1
	},
	{
		"question": "Yang mana 4 buah jeruk?",
		"choices": ["🍊🍊", "🍊🍊🍊🍊", "🍊🍊🍊"],
		"answer": 1
	},
	{
		"question": "Ada 3 bintang ⭐⭐⭐\nBerapa jumlah bintang?",
		"choices": ["2", "3", "4"],
		"answer": 1
	},
	{
		"question": "Angka berapa setelah 8?",
		"choices": ["7", "8", "9"],
		"answer": 2
	},
	{
		"question": "Pilih gambar yang jumlahnya 2 🐶",
		"choices": ["🐶", "🐶🐶", "🐶🐶🐶"],
		"answer": 1
	},
	{
		"question": "1 + 3 = ?",
		"choices": ["3", "4", "5"],
		"answer": 1
	},
	{
		"question": "5 - 2 = ?",
		"choices": ["2", "3", "4"],
		"answer": 1
	},
	{
		"question": "2 + 6 = ?",
		"choices": ["7", "8", "9"],
		"answer": 2
	},
	{
		"question": "4 - 1 = ?",
		"choices": ["2", "3", "4"],
		"answer": 1
	},
	{
		"question": "3 + 5 = ?",
		"choices": ["7", "8", "9"],
		"answer": 1
	},
	{
		"question": "Lengkapi urutan: 1, 2, __, 4, 5",
		"choices": ["2", "3", "6"],
		"answer": 1
	},
	{
		"question": "Polanya: 🔺⚫🔺⚫ …\nGambar selanjutnya?",
		"choices": ["🔺", "⚫", "🔵"],
		"answer": 0
	},
	{
		"question": "Mana angka yang lebih besar?",
		"choices": ["5", "9", "7"],
		"answer": 1
	},
	{
		"question": "Urutan angka: 6, 7, __, 9",
		"choices": ["8", "7", "10"],
		"answer": 0
	},
	{
		"question": "Mana yang lebih kecil?",
		"choices": ["4", "6", "9"],
		"answer": 0
	},
	{
		"question": "Seret 3 apel 🍎🍎🍎 ke keranjang dengan angka 3",
		"choices": ["2", "3", "4"],
		"answer": 1
	},
	{
		"question": "Cocokkan angka 5 dengan gambar berikut",
		"choices": ["🍌🍌🍌", "🍌🍌🍌🍌🍌", "🍌🍌🍌🍌"], 
		"answer": 1
	},
	{
		"question": "Tambahkan 2 bola ⚽ ke kotak yang sudah ada 1 bola ⚽. Total bola?",
		"choices": ["2", "3", "4"],
		"answer": 1
	},
	{
		"question": "Hapus 1 dari 4 balon 🎈🎈🎈🎈. Sisa balon?",
		"choices": ["2", "3", "4"],
		"answer": 1
	},
	{
		"question": "Pilih angka yang menunjukkan jumlah bintang ⭐⭐⭐⭐",
		"choices": ["3", "4", "5"],
		"answer": 1
	}
]


var current_index: int = 0

func _ready() -> void:
	quiz_ui.visible = false
	show_quiz()

	# Sembunyikan VirtualControls
	var vc = get_node_or_null("/root/VirtualControls")
	if vc:
		vc.visible = false


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
