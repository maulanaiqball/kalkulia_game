extends Area2D

@onready var interaction_area: InteractionArea = $interaction_area
#@export var loot_ui_scene: PackedScene

@onready var loot_ui_scene = preload("res://drop_item/LootUI.tscn")
var loot_ui_instance: Node = null

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	if loot_ui_instance == null:
		loot_ui_instance = loot_ui_scene.instantiate()
		get_tree().root.add_child(loot_ui_instance)
