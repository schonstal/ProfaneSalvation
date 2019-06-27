# Autoload
extends Node

var scene:Node

var high_score = 0
var target_scene

func initialize():
  scene = $'../World'
  # TODO: Load high score

func _ready():
  initialize()
  randomize()
  Overlay.connect("fade_complete", self, "_on_Overlay_fade_complete")

func reset():
  Game.change_scene("res://Scenes/Gameplay.tscn")

func change_scene(scene):
  target_scene = scene
  Overlay.fade(Color(0, 0, 0, 0), Color(0, 0, 0, 1), 0.3)

func _on_Overlay_fade_complete():
  if target_scene != null:
    get_tree().change_scene(target_scene)
    target_scene = null
    Overlay.fade(Color(0, 0, 0, 1), Color(0, 0, 0, 0), 0.3)
