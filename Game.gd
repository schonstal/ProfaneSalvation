# Autoload
extends Node

var scene:Node

var high_score = 0

func initialize():
  scene = $'../World'
  # TODO: Load high score

func _ready():
  initialize()
  randomize()

func reset():
  get_tree().reload_current_scene()
