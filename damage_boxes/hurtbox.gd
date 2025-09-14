class_name Hurtbox extends Area2D

signal hurt(hitbox: Hitbox)

@onready var hurt_sfx: AudioStreamPlayer2D = get_node_or_null("HurtSfx")

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area_2d: Area2D) -> void:
	if area_2d is not Hitbox:
		return
	
	hurt.emit(area_2d)
	
	if hurt_sfx and hurt_sfx.stream:
		hurt_sfx.play()
