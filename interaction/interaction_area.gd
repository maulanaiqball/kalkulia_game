extends Area2D
class_name InteractionArea

@export var action_name := "interact"

var interact: Callable = func() :
	pass

func _on_body_entered(_body: Node2D) -> void:
	interaction_manager.register_area(self)

func _on_body_exited(_body: Node2D) -> void:
	interaction_manager.unregister_area(self)
