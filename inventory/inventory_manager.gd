extends Node
class_name InventoryManager

# items: { angka: jumlah_kepemilikan }
var items: Dictionary = {}

func add_item(amount: int) -> void:
	if items.has(amount):
		items[amount] += 1
	else:
		items[amount] = 1
	print("Added number:", amount, "| Inventory:", items)

func remove_item(amount: int) -> void:
	if items.has(amount):
		items[amount] -= 1
		if items[amount] <= 0:
			items.erase(amount)
	print("Removed number:", amount, "| Inventory:", items)

func list_items() -> void:
	print("Inventory:", items)

# ---- helper untuk gate ----
# cek apakah player punya semua angka yang dibutuhkan (dengan hitungan/duplikasi)
func has_numbers(required: Array[int]) -> bool:
	var req_counts := _countify(required)
	for num in req_counts.keys():
		if items.get(num, 0) < req_counts[num]:
			return false
	return true

# kembalikan pool (dictionary) angka yg boleh dipakai untuk puzzle (dibatasi oleh required)
func get_pool_for(required: Array[int]) -> Dictionary:
	var req_counts := _countify(required)
	var pool: Dictionary = {}
	for num in req_counts.keys():
		pool[num] = min(items.get(num, 0), req_counts[num])
	return pool

# ✅ fungsi baru: ambil semua angka yg dimiliki player (satu array datar)
func get_all_numbers() -> Array[int]:
	var arr: Array[int] = []
	for num in items.keys():
		for i in range(items[num]):
			arr.append(num)
	return arr

# utility internal
func _countify(arr: Array[int]) -> Dictionary:
	var d := {}
	for n in arr:
		d[n] = d.get(n, 0) + 1
	return d
