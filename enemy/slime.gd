extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var detection_area = $DetectionArea

@export var step_distance = 16.0
@export var idle_duration = 2.0
@export var move_speed = 10.0
@export var chase_speed = 20.0

# Tambahkan semua arah termasuk diagonal
var directions = [
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.UP,
	Vector2(1, 1),   # kanan bawah
	Vector2(-1, 1),  # kiri bawah
	Vector2(1, -1),  # kanan atas
	Vector2(-1, -1)  # kiri atas
]

var is_moving = false
var target_position : Vector2

var player : Node2D = null
var chasing = false

func _ready():
	animation_player.play("slime_idle")
	timer.start(idle_duration)
	detection_area.body_entered.connect(_on_DetectionArea_body_entered)
	detection_area.body_exited.connect(_on_DetectionArea_body_exited)


func _physics_process(_delta):
	if chasing and player:
		var to_player = player.global_position - global_position

		if to_player.length() < 10:
			velocity = Vector2.ZERO
			animation_player.play("slime_idle")
		else:
			var dir = to_player.normalized()
			sprite.flip_h = dir.x < 0
			velocity = dir * chase_speed
			animation_player.play("slime_jump")

	else:
		if is_moving:
			var move_vector = target_position - global_position
			if move_vector.length() < 1.0:
				global_position = target_position
				is_moving = false
				animation_player.play("slime_idle")
				timer.start(idle_duration)
			else:
				velocity = move_vector.normalized() * move_speed
				move_and_slide()
		else:
			velocity = Vector2.ZERO

	move_and_slide()

func _on_timer_timeout() -> void:
	if chasing:
		return

	var direction = directions[randi_range(0, directions.size() - 1)]
	target_position = global_position + direction.normalized() * step_distance

	if direction.x != 0:
		sprite.flip_h = direction.x < 0

	is_moving = true
	animation_player.play("slime_jump")

func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		player = body
		chasing = true
		timer.stop()

func _on_DetectionArea_body_exited(body):
	if body == player:
		chasing = false
		player = null
		timer.start(idle_duration)
