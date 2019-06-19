extends Node

onready var player_scene = preload("res://Util/SoundEffect.tscn")

func play(stream):
  var player = player_scene.instance()
  player.stream = stream
  add_child(player)
  player.play()
