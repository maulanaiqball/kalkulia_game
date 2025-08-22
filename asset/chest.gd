extends StaticBody2D

@onready var interaction_area: InteractionArea = $interaction_area
@onready var loot_ui_scene = preload("res://drop_item/LootUI.tscn")
@onready var anim_player: AnimationPlayer = $animation

var loot_item_texture: Texture2D = preload("res://drop_item/drop_item.png")
var loot_ui_instance: Node = null
var loot_item_amount: int = 0
var is_empty: bool = false
var is_opened: bool = false   # untuk cek apakah chest sudah terbuka

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	# set animasi awal (tertutup)
	anim_player.play("chest_close")

func _on_interact() -> void:
	if is_empty:
		_show_empty_label()
		return

	if loot_ui_instance == null:
		# mainkan animasi buka hanya sekali
		if not is_opened:
			anim_player.play("chest_animation")
			# setelah animasi selesai, otomatis set ke chest_open
			anim_player.queue("chest_open")
			is_opened = true

		# tunggu 2 detik sebelum munculkan UI
		await get_tree().create_timer(0.5).timeout  

		loot_item_amount = randi_range(1, 10)  
		loot_ui_instance = loot_ui_scene.instantiate()
		get_tree().root.add_child(loot_ui_instance)
		loot_ui_instance.call("set_loot_item", loot_item_texture, self, loot_item_amount)


func remove_loot_item() -> void:
	is_empty = true
	print("Chest is now empty")

func _show_empty_label():
	NotificationUi.show_message("Chest kosong!")
