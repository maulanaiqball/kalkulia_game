# res://batle/boss.gd
extends CharacterBody2D

@export var max_health: int = 3
var health: int = 3

@onready var fire_point: Node2D = $fire_point  # Node2D/Marker2D

func _ready() -> void:
	add_to_group("boss")
	health = max_health
	_start_shooting()

func apply_damage(amount: int, source: String) -> void:
	if source == "boss":
		return # abaikan peluru sendiri

	health -= amount
	print("Boss kena hit! Sisa nyawa:", health)
	if health <= 0:
		print("Boss kalah! Player menang!")
		queue_free()

func _start_shooting() -> void:
	await get_tree().create_timer(1.0).timeout # jeda awal kecil
	while health > 0:
		_shoot()
		await get_tree().create_timer(3.0).timeout

func _shoot() -> void:
	var bullet_scene: PackedScene = preload("res://batle/bullet.tscn")
	var bullet = bullet_scene.instantiate()
	bullet.global_position = fire_point.global_position
	bullet.setup("boss", _get_direction_to_player(), 1)

	get_tree().current_scene.add_child(bullet)

func _get_direction_to_player() -> Vector2:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player:
		return (player.global_position - fire_point.global_position).normalized()
	return Vector2.LEFT  # fallback
