extends Node2D
class_name InteractionManager

@onready var player = get_tree().get_first_node_in_group("player")
@onready var lable = $Label

const base_text = "[E] "

var active_area = []
var can_interact = true

func register_area(area: InteractionArea):
	active_area.push_back(area)

func unregister_area(area: InteractionArea):
	var index = active_area.find(area)
	if index != -1 :
		active_area.remove_at(index)

func _process(_delta):
	if active_area.size() > 0 && can_interact :
		active_area.sort_custom(_short_by_distance_to_player)
		lable.text = base_text + active_area[0].action_name
		lable.global_position = active_area[0].global_position
		lable.global_position.y -= 36
		lable.global_position.x -= lable.size.x / 2
		lable.show()
	else :
		lable.hide()

func _short_by_distance_to_player(area1, area2) :
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event):
	if event.is_action_pressed("interact"):
		if active_area.size() > 0:
			can_interact = false
			lable.hide()
			
			await active_area[0].interact.call()
			
			can_interact = true
