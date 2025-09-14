extends Node

var inventory: Array = []
var max_health: int = 5
var health: int = max_health

func reset_player_data():
	inventory.clear()
	health = max_health
