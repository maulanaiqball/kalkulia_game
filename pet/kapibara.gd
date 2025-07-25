extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var step_distance := 10.0
@export var idle_duration := 4.0
@export var move_speed := 10.0

var is_idle := true
var move_direction := Vector2.ZERO
var distance_moved := 0.0

func _ready():
	start_idle()

func _process(delta):
	if is_idle:
		return

	var movement: Vector2 = move_direction * move_speed * delta
	move_and_collide(movement)
	distance_moved += movement.length()

	if distance_moved >= step_distance:
		start_idle()

func start_idle():
	is_idle = true
	animation_player.play("kapibara_idle")
	distance_moved = 0.0
	move_direction = Vector2.ZERO
	await get_tree().create_timer(idle_duration).timeout
	start_walk()

func start_walk():
	is_idle = false
	animation_player.play("kapibara_walk")
	move_direction = get_random_direction()
	update_sprite_direction()

func get_random_direction() -> Vector2:
	var directions = [
		Vector2.LEFT,
		Vector2.RIGHT,
		#Vector2.UP,
		#Vector2.DOWN,
		Vector2(-1, -1),
		Vector2(1, -1),
		Vector2(-1, 1),
		Vector2(1, 1)
	]
	return directions[randi() % directions.size()].normalized()

func update_sprite_direction():
	if move_direction.x < 0:
		sprite.flip_h = true
	elif move_direction.x > 0:
		sprite.flip_h = false
	# jika x = 0, tidak mengubah arah (tetap seperti sebelumnya)
