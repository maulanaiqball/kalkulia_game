extends Node2D

@export var player_controller : PlayerController
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

var default_animation_speed

func _ready():
	default_animation_speed = animation_player.speed_scale

func _process(_delta):
	sprite_2d.flip_h = false

	# attack animation
	if player_controller.attacking:
		match player_controller.player_facing:
			player_controller.Facing.DOWN:
				animation_player.play("attack_down")
			player_controller.Facing.UP:
				animation_player.play("attack_up")
			player_controller.Facing.RIGHT:
				animation_player.play("attack_right")
			player_controller.Facing.LEFT:
				animation_player.play("attack_left")
		animation_player.speed_scale = default_animation_speed
		
#	roll animation
	elif player_controller.roll:
		match player_controller.player_facing:
			player_controller.Facing.DOWN:
				animation_player.play("roll_down")
			player_controller.Facing.UP:
				animation_player.play("roll_up")
			player_controller.Facing.RIGHT:
				animation_player.play("roll_right")
			player_controller.Facing.LEFT:
				animation_player.play("roll_left")
		animation_player.speed_scale = default_animation_speed
				

	#move animation
	elif player_controller.velocity.length() > 0.0:
		match player_controller.player_facing:
			player_controller.Facing.DOWN:
				animation_player.play("move_down")
			player_controller.Facing.UP:
				animation_player.play("move_up")
			player_controller.Facing.RIGHT:
				animation_player.play("move_right")
			player_controller.Facing.LEFT:
				animation_player.play("move_left")
		animation_player.speed_scale = default_animation_speed

	# idle
	else:
		match player_controller.player_facing:
			player_controller.Facing.DOWN:
				animation_player.play("idle_down")
			player_controller.Facing.UP:
				animation_player.play("idle_up")
			player_controller.Facing.RIGHT:
				animation_player.play("idle_right")
			player_controller.Facing.LEFT:
				animation_player.play("idle_left")
		animation_player.speed_scale = default_animation_speed
