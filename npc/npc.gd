extends StaticBody2D

@onready var interaction_area: InteractionArea = $interaction_area
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer   # pastikan nama node sama

@export var questions: Array = [
	{
		"text": "Ibu kota Indonesia adalah ...?",
		"choices": ["Bandung", "Jakarta", "Medan"],
		"correct": 1
	},
	{
		"text": "2 + 2 = ...?",
		"choices": ["3", "4", "5"],
		"correct": 1   # "4"
	},
	{
		"text": "Bahasa pemrograman Godot adalah ...?",
		"choices": ["GDScript", "Lua", "Kotlin"],
		"correct": 0
	}
]

@export var only_once: bool = true  # kalau true, kuis NPC ini hanya bisa sekali
@export var reward_amount: int = 5  # jumlah angka yang jadi reward
@export var reward_icon: Texture2D  # icon untuk loot UI

var _finished := false

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	QuizUi.quiz_finished.connect(_on_quiz_finished)

	# Jalankan animasi idle waktu awal
	if anim.has_animation("idle"):
		anim.play("idle")

func _on_interact() -> void:
	if only_once and _finished:
		NotificationUi.show_message("Terima kasih! Kamu sudah menyelesaikan kuis ini.")
		return

	QuizUi.open(questions, self)

func _on_quiz_finished(npc: Node) -> void:
	if npc != self: return
	_finished = true

	# kalau ada animasi success, jalankan
	if anim.has_animation("success"):
		anim.play("success")

	var loot_ui = preload("res://drop_item/LootUI.tscn").instantiate()
	get_tree().root.add_child(loot_ui)

	loot_ui.set_loot_item(reward_icon, self, reward_amount)


func remove_loot_item() -> void:
	print("Reward dari NPC sudah diambil")
	if only_once:
		_finished = true
