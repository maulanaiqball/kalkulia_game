extends CanvasLayer
signal puzzle_solved(gate: Node)

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var slots_container: HBoxContainer = $Panel/VBoxContainer/SlotsContainer
@onready var options_bar: HBoxContainer = $Panel/VBoxContainer/OptionsBar
@onready var reset_button: Button = $Panel/VBoxContainer/ButtonsBar/ResetButton
@onready var close_button: Button = $Panel/VBoxContainer/ButtonsBar/CloseButton
@onready var submit_button: Button = $Panel/VBoxContainer/ButtonsBar/SubmitButton

var required_numbers: Array[int] = []
var pool_counts: Dictionary = {}        # {angka: sisa_boleh_dipakai}
var slots: Array[Button] = []           # tombol slot
var slot_values: Array = []             # nilai tiap slot (null/int)
var target_gate: Node = null

func _ready() -> void:
	visible = false
	reset_button.pressed.connect(_on_reset_pressed)
	close_button.pressed.connect(_on_close_pressed)
	submit_button.pressed.connect(_on_submit_pressed)

func open(required: Array[int], gate: Node) -> void:
	target_gate = gate
	required_numbers = required.duplicate()
	pool_counts = Inventory_Manager.get_pool_for(required_numbers)
	_build_slots(required_numbers.size())
	_clear_slots()
	_build_options()

	title_label.text = "Susun angka dari kecil ke besar"
	show()
	panel.grab_focus()

func _build_slots(count: int) -> void:
	# bersihkan
	for c in slots_container.get_children():
		c.queue_free()
	slots.clear()
	slot_values.clear()

	for i in range(count):
		var btn := Button.new()
		btn.focus_mode = Control.FOCUS_NONE
		btn.custom_minimum_size = Vector2(32, 32)

		# background pakai gambar
		var stylebox := StyleBoxTexture.new()
		stylebox.texture = load("res://drop_item/drop_item.png")
		btn.add_theme_stylebox_override("normal", stylebox)
		btn.add_theme_stylebox_override("hover", stylebox)
		btn.add_theme_stylebox_override("pressed", stylebox)

		# slot kosong = gelap
		btn.modulate = Color(1, 1, 1, 0.5)

		slots_container.add_child(btn)
		slots.append(btn)
		slot_values.append(null)

func _build_options() -> void:
	for c in options_bar.get_children():
		c.queue_free()

	var keys := pool_counts.keys()
	keys.shuffle()
	for num in keys:
		var btn := Button.new()
		btn.text = str(num)               
		btn.custom_minimum_size = Vector2(32, 32)

		var stylebox := StyleBoxTexture.new()
		stylebox.texture = load("res://drop_item/drop_item.png")
		btn.add_theme_stylebox_override("normal", stylebox)
		btn.add_theme_stylebox_override("hover", stylebox)
		btn.add_theme_stylebox_override("pressed", stylebox)

		btn.disabled = pool_counts.get(num, 0) <= 0
		btn.pressed.connect(_on_number_chosen.bind(num))
		options_bar.add_child(btn)

func _clear_slots() -> void:
	for i in range(slot_values.size()):
		slot_values[i] = null
	for b in slots:
		b.text = "-"
		b.modulate = Color(1, 1, 1, 0.5)  # kosong = gelap

func _on_number_chosen(num: int) -> void:
	# cari slot kosong pertama (auto isi kiri -> kanan)
	var empty_index := slot_values.find(null)
	if empty_index == -1:
		NotificationUi.show_message("Semua slot sudah terisi!")
		return

	# pastikan stok angka tersedia
	if pool_counts.get(num, 0) <= 0:
		return

	# isi slot
	pool_counts[num] -= 1
	slot_values[empty_index] = num
	var btn := slots[empty_index]
	btn.text = str(num)
	btn.modulate = Color(1, 1, 1, 1.0)  # terisi = normal

	# refresh tampilan opsi (update jumlah & disable)
	_build_options()

func _on_reset_pressed() -> void:
	pool_counts = Inventory_Manager.get_pool_for(required_numbers)
	_clear_slots()
	_build_options()

func _on_close_pressed() -> void:
	hide()
	required_numbers.clear()
	pool_counts.clear()
	slots.clear()
	slot_values.clear()
	target_gate = null
	# bersihkan opsi juga
	for c in options_bar.get_children():
		c.queue_free()

func _on_submit_pressed() -> void:
	# cek semua slot terisi
	for v in slot_values:
		if v == null:
			NotificationUi.show_message("Isi semua slot dulu!")
			return

	# cek ascending
	var chosen := slot_values.duplicate()
	var chosen_sorted := chosen.duplicate(); chosen_sorted.sort()

	var required_sorted := required_numbers.duplicate(); required_sorted.sort()

	if chosen == required_sorted:
		NotificationUi.show_message("Benar! Gerbang terbuka ✨")
		emit_signal("puzzle_solved", target_gate)
		_on_close_pressed()
	else:
		NotificationUi.show_message("Urutan/angka salah. Coba lagi!")
