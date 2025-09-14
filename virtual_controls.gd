extends CanvasLayer

signal joystick_moved(direction: Vector2)

@onready var joystick = $Joystick
@onready var attack_btn: TouchScreenButton = $AttackBtn
@onready var roll_btn: TouchScreenButton = $RollBtn
@onready var interact_btn: TouchScreenButton = $Interact

func _ready() -> void:
	# Attack
	attack_btn.pressed.connect(func():
		print("[DEBUG] Attack pressed")
		Input.action_press("attack")
	)
	attack_btn.released.connect(func():
		Input.action_release("attack")
	)

	# Roll
	roll_btn.pressed.connect(func():
		print("[DEBUG] Roll pressed")
		Input.action_press("roll")
	)
	roll_btn.released.connect(func():
		Input.action_release("roll")
	)

	# Interact
	interact_btn.pressed.connect(func():
		print("[DEBUG] Interact pressed")
		Input.action_press("interact")

		if interaction_manager != null:
			print("[DEBUG] VirtualControl: Trigger interact() lewat autoload")
			interaction_manager.handle_interact()
		else:
			push_error("interaction_manager autoload belum ada!")
	)
	interact_btn.released.connect(func():
		Input.action_release("interact")
	)

	# Joystick
	if joystick.has_signal("joystick_moved"):
		joystick.connect("joystick_moved", Callable(self, "_on_joystick_moved"))

func _on_joystick_moved(direction: Vector2) -> void:
	print("[DEBUG] Joystick moved:", direction)
	emit_signal("joystick_moved", direction)
