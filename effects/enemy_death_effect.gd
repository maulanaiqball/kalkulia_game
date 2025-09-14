extends Node2D

@export var animation_name: String = "default"    # nama animasi
@export var fallback_lifetime: float = 1.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx: AudioStreamPlayer2D = $Sfx

func _ready() -> void:
	if anim and anim.sprite_frames and anim.sprite_frames.has_animation(animation_name):
		print("Playing anim:", animation_name, 
			  " length:", anim.sprite_frames.get_frame_count(animation_name), 
			  " fps:", anim.sprite_frames.get_animation_speed(animation_name))
		
		if sfx and sfx.stream:
			sfx.play()
		
		anim.play(animation_name)
		await anim.animation_finished
		print("Animation finished:", animation_name)
		queue_free()
	else:
		print("Animation not found:", animation_name)
		await get_tree().create_timer(fallback_lifetime).timeout
		queue_free()
