extends CanvasLayer

@onready var item_icon: TextureRect = $Panel/background/TextureRect
@onready var amount_label: Label = $Panel/background/TextureRect/Label
@onready var collect_button: Button = $Panel/Button
@onready var click_sound: AudioStreamPlayer = $ClickSound

var chest_ref: Node = null
var item_amount: int = 1   
var already_collected: bool = false   # <- flag anti dobel

func _ready() -> void:
	collect_button.pressed.connect(_on_collect_pressed)

func set_loot_item(texture: Texture2D, chest: Node, amount: int) -> void:
	item_icon.texture = texture
	chest_ref = chest
	item_amount = amount
	amount_label.text = str(amount)

func _on_collect_pressed() -> void:
	# Cegah dobel klik
	if already_collected:
		return
	already_collected = true
	collect_button.disabled = true   # nonaktifkan tombol

	# Mainkan suara klik
	if click_sound:
		click_sound.play()
		await click_sound.finished

	# Logic loot
	Inventory_Manager.add_item(item_amount)
	if chest_ref:
		chest_ref.remove_loot_item()

	# Tutup UI
	queue_free()
