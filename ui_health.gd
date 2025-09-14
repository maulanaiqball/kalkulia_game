class_name UIHearts
extends HBoxContainer

@export var stats: Stats
@export var full_heart: Texture2D
@export var empty_heart: Texture2D

var hearts: Array[TextureRect] = []

func _ready():
	if stats:
		_init_hearts()

func _process(_delta: float) -> void:
	if stats:
		_update_hearts()

func _init_hearts() -> void:
	# Bersihkan dulu kalau sudah ada
	for c in get_children():
		c.queue_free()
	hearts.clear()

	# Tambahkan hati sesuai max_health
	for i in range(stats.max_health):
		var heart = TextureRect.new()
		heart.texture = full_heart if i < stats.health else empty_heart
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(heart)
		hearts.append(heart)

func _update_hearts() -> void:
	for i in range(stats.max_health):
		hearts[i].texture = full_heart if i < stats.health else empty_heart
