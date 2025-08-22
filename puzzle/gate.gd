extends StaticBody2D

@onready var interaction_area: InteractionArea = $interaction_area
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D

# jumlah minimal angka yang harus dimiliki player
@export var min_numbers: int = 3

var is_open := false

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	GatePuzzleUi.puzzle_solved.connect(_on_puzzle_solved)

	anim_player.play("gate")

func _on_interact() -> void:
	if is_open:
		return

	var player_numbers: Array = Inventory_Manager.get_all_numbers()

	if player_numbers.size() < min_numbers:
		NotificationUi.show_message("Kamu butuh minimal %d angka!" % min_numbers)
		return

	GatePuzzleUi.open(player_numbers, self)

func _on_puzzle_solved(gate: Node) -> void:
	if gate != self or is_open:
		return
	_open_gate()

func _open_gate() -> void:
	if is_open:
		return
	is_open = true

	anim_player.play("gate_open")

	await anim_player.animation_finished

	if collision:
		collision.disabled = true

	# hapus semua angka player sebelum pindah scene
	Inventory_Manager.clear_all()

	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://world2.tscn")
