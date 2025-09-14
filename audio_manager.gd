extends Node

@onready var bgm: AudioStreamPlayer = AudioStreamPlayer.new()

var is_music_on: bool = true

func _ready():
	# Pasang BGM
	bgm.stream = preload("res://music_and_sounds/샛별프로젝트-Sugar Cookie.mp3") # ganti dengan file musikmu
	bgm.autoplay = true
	add_child(bgm)

func toggle_music():
	is_music_on = !is_music_on
	if is_music_on:
		bgm.play()
	else:
		bgm.stop()

func set_music(state: bool):
	is_music_on = state
	if is_music_on and not bgm.playing:
		bgm.play()
	elif not is_music_on and bgm.playing:
		bgm.stop()
