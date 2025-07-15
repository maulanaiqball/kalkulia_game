extends CharacterBody2D
class_name PlayerController

@export var move_speed = 20.0
@export var sprint_increase = 1.5

var direction : Vector2
#attacking
var attacking = false
var attack_cooldown = 0.4 # waktu tunggu animasi attack
var attack_timer = 0.0
#roll
var roll = false
var rolling_duration = 0.5 # durasi dalam detik
var rolling_timer = 0.0
var roll_speed = 35.0
var roll_direction = Vector2.ZERO

var sprint_multiplier = 1.0

enum Facing {UP, DOWN, LEFT, RIGHT}
var player_facing : Facing

func get_facing_vector(facing):
	match facing:
		Facing.UP:
			return Vector2(0, -1)
		Facing.DOWN:
			return Vector2(0, 1)
		Facing.LEFT:
			return Vector2(-1, 0)
		Facing.RIGHT:
			return Vector2(1, 0)
		_:
			return Vector2.ZERO


func _physics_process(delta):
	# Update cooldown attack
	if attacking:
		attack_timer -= delta
		if attack_timer <= 0.0:
			attacking = false

	# Deteksi input attack (jangan bisa serang terus-menerus)
	if not attacking and Input.is_action_just_pressed("attack"):
		attacking = true
		attack_timer = attack_cooldown

	# Pergerakan
	if not attacking: # jangan bisa gerak saat menyerang
		handle_movement(delta)
		
	#roll
	# Update status roll
	if roll:
		rolling_timer -= delta
		if rolling_timer <= 0.0:
			roll = false

	# Input roll (hanya bisa roll jika tidak sedang rolling dan tidak menyerang)
	if not roll and not attacking and Input.is_action_just_pressed("roll"):
		roll = true
		rolling_timer = rolling_duration
		roll_direction = get_facing_vector(player_facing)
	
	# Pergerakan
	if not attacking and not roll:
		handle_movement(delta)
	elif roll:
		# Movement saat roll
		velocity = roll_direction.normalized() * roll_speed * delta * 200
		move_and_slide()

func handle_movement(delta):
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
		player_facing = Facing.UP
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
		player_facing = Facing.DOWN
	else:
		direction.y = 0
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		player_facing = Facing.RIGHT
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
		player_facing = Facing.LEFT
	else:
		direction.x = 0

	direction = direction.normalized()
	velocity = direction *  move_speed * delta * 200 * sprint_multiplier
	move_and_slide()
