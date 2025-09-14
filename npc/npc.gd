extends StaticBody2D

@onready var interaction_area: InteractionArea = $interaction_area
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var loot_sfx: AudioStreamPlayer = $LootSfx

@export var only_once: bool = true
@export var reward_amount: int = 5
@export var reward_icon: Texture2D
@export var question_count: int = 5  # Jumlah pertanyaan yang diambil

var _finished := false
var questions: Array = []

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	QuizUi.quiz_finished.connect(_on_quiz_finished)

	if anim.has_animation("idle"):
		anim.play("idle")

	# Ambil pertanyaan dari pertanyaan_quiz.gd
	var quiz_data = get_node("/root/pertanyaan_quiz") # Pastikan node ini ada di autoload
	questions = quiz_data.get_random_questions(question_count)

func _on_interact() -> void:
	if only_once and _finished:
		NotificationUi.show_message("Terima kasih! Kamu sudah menyelesaikan kuis ini.")
		return

	QuizUi.open(questions, self)

func _on_quiz_finished(npc: Node) -> void:
	if npc != self: return
	_finished = true

	if anim.has_animation("success"):
		anim.play("success")

	var loot_ui = preload("res://drop_item/LootUI.tscn").instantiate()
	get_tree().root.add_child(loot_ui)
	loot_ui.set_loot_item(reward_icon, self, reward_amount)

	if loot_sfx.stream:
		loot_sfx.play()

func remove_loot_item() -> void:
	print("Reward dari NPC sudah diambil")
	if only_once:
		_finished = true
