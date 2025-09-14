extends Node2D


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")


func _on_options_pressed() -> void:
	print("options ditekan")


func _on_exit_pressed() -> void:
	get_tree().quit()
