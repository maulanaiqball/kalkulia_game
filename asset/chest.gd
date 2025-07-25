extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var detection_area = $Area2D

var opened = false  # status chest
var chest_opening = false  # status sedang memainkan animasi "chest"

func _ready():
	detection_area.body_entered.connect(_on_body_entered)
	#detection_area.body_exited.connect(_on_body_exited)
	animation_player.animation_finished.connect(_on_animation_finished)
	animation_player.play("chest_close")  # default ketika start

func _on_body_entered(body):
	if body.name == "Player" and not opened and not chest_opening:
		chest_opening = true
		animation_player.play("chest")  # animasi buka sekali

func _on_animation_finished(anim_name: String):
	if anim_name == "chest":
		spawn_item()  # baru keluarkan item setelah animasi selesai
		opened = true
		chest_opening = false
		animation_player.play("chest_open")  # lanjut animasi looping

#func _on_body_exited(body):
	#if body.name == "Player" and not opened:
		#animation_player.play("chest_close")  # kembali menutup jika belum sempat terbuka

func spawn_item():
	var item_scene = preload("res://dropped_item/item1.tscn")
	var item = item_scene.instantiate()
	item.global_position = global_position + Vector2(0, -16)
	get_parent().add_child(item)
