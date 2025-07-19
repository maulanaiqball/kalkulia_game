extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var detection_area = $Area2D
var opened = false  # status chest

func _ready():
	detection_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and not opened:
		opened = true
		animation_player.play("chest_open")
		spawn_item()
func spawn_item():
	var item_scene = preload("res://dropped_item/item1.tscn")
	var item = item_scene.instantiate()
	item.global_position = global_position + Vector2(0, -16)
	get_parent().add_child(item)
