extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var wander_timer = $WanderTimer
@onready var area = $Area2D

var is_chasing = false
var is_returning = false
var target_player = null
var speed = 50
var wander_direction = Vector2.ZERO

var spawn_point = Vector2.ZERO
var movement_bounds = Rect2()  # batas area gerak slime

func _ready():
	randomize()
	spawn_point = global_position

	movement_bounds = Rect2(global_position - Vector2(100, 100), Vector2(200, 200))
	pick_new_wander_direction()
	wander_timer.start()

	area.body_entered.connect(_on_area_body_entered)
	area.body_exited.connect(_on_area_body_exited)
	#update()  # buat debug rectangle

func _physics_process(delta):
	if is_chasing and target_player:
		chase_player(delta)
	elif is_returning:
		return_to_patrol(delta)
	else:
		wander(delta)

func chase_player(delta):
	var direction = (target_player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	anim.play("walk")

func return_to_patrol(delta):
	var direction = (spawn_point - global_position)
	if direction.length() < 5:
		is_returning = false
		pick_new_wander_direction()
		return

	velocity = direction.normalized() * speed
	move_and_slide()
	anim.play("walk")

func wander(delta):
	var next_pos = global_position + wander_direction * speed * 0.5 * delta

	if not movement_bounds.has_point(next_pos):
		pick_new_wander_direction()
		return

	velocity = wander_direction * speed * 0.5
	move_and_slide()
	anim.play("idle")

func _on_area_body_entered(body):
	if body.name == "Player":
		is_chasing = true
		is_returning = false
		target_player = body

func _on_area_body_exited(body):
	if body.name == "Player":
		is_chasing = false
		target_player = null
		is_returning = true  # mulai balik ke kandang

func _on_WanderTimer_timeout():
	if not is_chasing and not is_returning:
		pick_new_wander_direction()

func pick_new_wander_direction():
	var angle = randf_range(0, TAU)
	wander_direction = Vector2(cos(angle), sin(angle)).normalized()
	wander_timer.start(randf_range(1.5, 3.0))
