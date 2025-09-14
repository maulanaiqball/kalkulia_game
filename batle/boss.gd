extends CharacterBody2D

@export var max_health: int = 3
var health: int = 3
var is_dead: bool = false   # flag biar tidak kena damage/menembak setelah mati

@onready var fire_point: Node2D = $fire_point
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound

func _ready() -> void:
	add_to_group("boss")
	health = max_health
	anim.play("idle")
	_start_shooting()

func apply_damage(amount: int, source: String) -> void:
	if source == "boss" or is_dead:
		return   # jangan bisa kena damage lagi kalau sudah mati

	# mainkan suara hurt
	if hurt_sound and not is_dead:
		hurt_sound.play()

	health -= amount
	if health < 0:
		health = 0   # pastikan tidak minus

	print("Boss kena hit! Sisa nyawa:", health)

	if health == 0 and not is_dead:
		is_dead = true
		print("Boss kalah! Player menang!")

		# mainkan animasi mati kalau ada
		if anim.has_animation("death"):
			anim.play("death")
			await anim.animation_finished

		_show_winner_popup()
		queue_free()

func _start_shooting() -> void:
	await get_tree().create_timer(1.0).timeout
	while health > 0 and not is_dead:
		_shoot()
		await get_tree().create_timer(3.0).timeout

func _shoot() -> void:
	if is_dead: 
		return   # jangan nembak kalau sudah mati

	anim.play("attack")
	await anim.animation_finished

	var bullet_scene: PackedScene = preload("res://batle/bullet.tscn")
	var bullet = bullet_scene.instantiate()
	bullet.global_position = fire_point.global_position
	bullet.setup("boss", _get_direction_to_player(), 1)
	get_tree().current_scene.add_child(bullet)

	anim.play("idle")

func _get_direction_to_player() -> Vector2:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player:
		return (player.global_position - fire_point.global_position).normalized()
	return Vector2.LEFT

# --- fungsi tambahan untuk popup winner ---
# --- fungsi tambahan untuk popup winner ---
func _show_winner_popup() -> void:
	# tampilkan winner popup
	var popup = get_tree().current_scene.get_node("WinnerPopup")
	if popup:
		popup.visible = true
		print("WinnerPopup berhasil ditampilkan")

		# mainkan suara kalau ada node WinSound di dalam popup
		var win_sound = popup.get_node_or_null("WinSound")
		if win_sound:
			win_sound.play()
	else:
		print("WinnerPopup TIDAK ditemukan! Cek node path.")

	# sembunyikan QuizUI
	var quiz_ui = get_tree().current_scene.get_node("QuizUI")
	if quiz_ui:
		quiz_ui.visible = false
		print("QuizUI dimatikan karena boss mati")
	else:
		print("QuizUI tidak ditemukan, cek nama node di scene")
