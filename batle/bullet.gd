extends Area2D

@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.ZERO
@export var lifetime: float = 3.0
@export var damage: int = 1
var shooter: String = ""

func setup(_shooter: String, _direction: Vector2, _damage: int = 1) -> void:
	shooter = _shooter
	direction = _direction.normalized()
	damage = _damage
	set_meta("shooter", shooter)

func _ready() -> void:
	# auto hancur setelah lifetime habis
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area == null or not is_instance_valid(area):
		return
	
	# jangan hajar diri sendiri
	if area.has_meta("shooter") and area.get_meta("shooter") == shooter:
		return

	if area.has_method("apply_damage"):
		area.apply_damage(damage, shooter)

	_destroy()

func _on_body_entered(body: Node) -> void:
	if body == null or not is_instance_valid(body):
		return

	if body.has_meta("shooter") and body.get_meta("shooter") == shooter:
		return

	if body.has_method("apply_damage"):
		body.apply_damage(damage, shooter)

	_destroy()

func _destroy() -> void:
	# bisa tambahkan efek partikel atau suara di sini sebelum hilang
	queue_free()
