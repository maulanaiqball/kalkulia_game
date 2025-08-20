extends CanvasLayer
signal puzzle_solved(gate: Node)

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var slots_container: HBoxContainer = $Panel/VBoxContainer/SlotsContainer
@onready var reset_button: Button = $Panel/VBoxContainer/ButtonsBar/ResetButton
@onready var close_button: Button = $Panel/VBoxContainer/ButtonsBar/CloseButton

@onready var number_popup: PopupPanel = $NumberPopup
@onready var options_container: VBoxContainer = $NumberPopup/ScrollContainer/OptionsContainer

var required_numbers: Array[int] = []   # contoh: [1,3,4]
var pool_counts: Dictionary = {}         # {angka: sisa_boleh_dipakai}
var slots: Array[Button] = []            # tombol slot
var slot_values: Array = []              # nilai pada tiap slot (null/int)
var current_slot_index: int = -1
var target_gate: Node = null             # gate yang sedang aktif puzzle-nya

func _ready() -> void:
	visible = false
	reset_button.pressed.connect(_on_reset_pressed)
	close_button.pressed.connect(_on_close_pressed)

func open(required: Array[int], gate: Node) -> void:
	target_gate = gate
	required_numbers = required.duplicate()
	# pastikan player punya angka2 yang dibutuhkan
	if not Inventory_Manager.has_numbers(required_numbers):
		if Engine.has_singleton("NotificationUi"):
			NotificationUi.show_message("Angka belum lengkap!")
		return

	# siapkan pool dari inventory, dibatasi required
	pool_counts = Inventory_Manager.get_pool_for(required_numbers)

	# bangun slot sesuai jumlah required
	_build_slots(required_numbers.size())
	_clear_slots()

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
		btn.text = "_"
		btn.focus_mode = Control.FOCUS_ALL
		btn.pressed.connect(_on_slot_pressed.bind(i))
		btn.custom_minimum_size = Vector2(64, 48)
		slots_container.add_child(btn)
		slots.append(btn)
		slot_values.append(null)

func _clear_slots() -> void:
	# reset nilai slot & restore pool
	for i in range(slot_values.size()):
		slot_values[i] = null
	for b in slots:
		b.text = "_"

	# pool_counts sudah benar dari open(); tidak perlu diubah disini

func _on_slot_pressed(index: int) -> void:
	current_slot_index = index
	_show_number_popup()

func _show_number_popup() -> void:
	# bersihkan opsi
	for c in options_container.get_children():
		c.queue_free()

	# buat tombol pilihan berdasarkan pool_counts (urutkan tampilannya)
	var keys := pool_counts.keys()
	keys.sort()
	for num in keys:
		var btn := Button.new()
		btn.text = str(num) + " (x" + str(pool_counts[num]) + ")"
		btn.disabled = pool_counts[num] <= 0
		btn.pressed.connect(_on_number_chosen.bind(num))
		options_container.add_child(btn)

	# tambah tombol hapus (clear) slot
	var clear_btn := Button.new()
	clear_btn.text = "Kosongkan Slot"
	clear_btn.pressed.connect(_on_clear_slot)
	options_container.add_child(clear_btn)

	number_popup.popup_centered()

func _on_number_chosen(num: int) -> void:
	if current_slot_index < 0:
		number_popup.hide()
		return

	# kembalikan angka lama ke pool (jika slot sudah terisi)
	var prev = slot_values[current_slot_index]
	if prev != null:
		pool_counts[prev] += 1

	# ambil angka baru dari pool jika tersedia
	if pool_counts.get(num, 0) > 0:
		pool_counts[num] -= 1
		slot_values[current_slot_index] = num
		slots[current_slot_index].text = str(num)

	number_popup.hide()
	current_slot_index = -1

	_try_check_solved()

func _on_clear_slot() -> void:
	if current_slot_index >= 0:
		var prev = slot_values[current_slot_index]
		if prev != null:
			pool_counts[prev] += 1
			slot_values[current_slot_index] = null
			slots[current_slot_index].text = "_"
	number_popup.hide()
	current_slot_index = -1

func _on_reset_pressed() -> void:
	# reset semua slot & kembalikan pool penuh berdasarkan required
	pool_counts = Inventory_Manager.get_pool_for(required_numbers)
	_clear_slots()

func _on_close_pressed() -> void:
	hide()
	# optional: bersihkan state
	required_numbers.clear()
	pool_counts.clear()
	slots.clear()
	slot_values.clear()
	current_slot_index = -1
	target_gate = null

func _try_check_solved() -> void:
	# cek apakah semua slot terisi
	for v in slot_values:
		if v == null:
			return

	# cek apakah urut (ascending) dan cocok dengan multiset required
	var chosen := slot_values.duplicate()
	var chosen_sorted := chosen.duplicate(); chosen_sorted.sort()

	var required_sorted := required_numbers.duplicate(); required_sorted.sort()

	if chosen == required_sorted:
		# benar dan urut
		if Engine.has_singleton("NotificationUi"):
			NotificationUi.show_message("Benar! Gerbang terbuka ✨")
		emit_signal("puzzle_solved", target_gate)
		_on_close_pressed()
	else:
		# pilihan lengkap tapi salah urutan/angka
		if Engine.has_singleton("NotificationUi"):
			NotificationUi.show_message("Urutan/angka salah. Coba lagi!")
