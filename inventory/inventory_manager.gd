extends Node
class_name InventoryManager

# Dictionary: key = angka loot, value = jumlah kemunculan
var items: Dictionary = {}

func add_item(amount: int) -> void:
	if items.has(amount):
		items[amount] += 1   # kalau angka ini sudah ada, tambahkan jumlah chest yang berisi angka itu
	else:
		items[amount] = 1    # kalau angka baru, buat entry baru
	print("Added number:", amount, "| Inventory:", items)

func remove_item(amount: int) -> void:
	if items.has(amount):
		items[amount] -= 1
		if items[amount] <= 0:
			items.erase(amount)
	print("Removed number:", amount, "| Inventory:", items)

func list_items() -> void:
	print("Inventory:", items)
