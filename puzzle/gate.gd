extends StaticBody2D

@onready var interaction_area: InteractionArea = $interaction_area
@onready var sprite: Sprite2D = $Sprite2D

# jumlah minimal angka yang harus dimiliki player
@export var min_numbers: int = 3

var is_open := false

func _ready() -> void:
	# tombol E dari sistem InteractionArea
	interaction_area.interact = Callable(self, "_on_interact")

	# dengarkan sinyal solved dari UI global
	GatePuzzleUi.puzzle_solved.connect(_on_puzzle_solved)

func _on_interact() -> void:
	if is_open:
		return

	# cek jumlah angka yang dimiliki player
	var player_numbers: Array = Inventory_Manager.get_all_numbers()

	if player_numbers.size() < min_numbers:
		NotificationUi.show_message("Kamu butuh minimal %d angka!" % min_numbers)
		return

	# kirim angka yang player miliki ke puzzle UI
	GatePuzzleUi.open(player_numbers, self)

func _on_puzzle_solved(gate: Node) -> void:
	if gate != self or is_open:
		return
	_open_gate()

func _open_gate() -> void:
	is_open = true
	var tween := create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.6)
	tween.tween_callback(Callable(self, "_disable_collision"))

func _disable_collision() -> void:
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true
