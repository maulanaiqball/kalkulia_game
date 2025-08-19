extends CanvasLayer

@onready var item_icon: TextureRect = $Panel/background/TextureRect
@onready var amount_label: Label = $Panel/background/TextureRect/Label
@onready var collect_button: Button = $Panel/Button

var chest_ref: Node = null
var item_amount: int = 1   

func _ready() -> void:
	collect_button.pressed.connect(_on_collect_pressed)

func set_loot_item(texture: Texture2D, chest: Node, amount: int) -> void:
	item_icon.texture = texture
	chest_ref = chest
	item_amount = amount
	amount_label.text = str(amount)

func _on_collect_pressed() -> void:
	Inventory_Manager.add_item(item_amount)  # simpan angka
	if chest_ref:
		chest_ref.remove_loot_item()
	queue_free()
