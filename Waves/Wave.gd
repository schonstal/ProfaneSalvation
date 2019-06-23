extends Node2D

export(Resource) var scene
var scene_instance = null

func _ready():
  EventBus.connect("wave_completed", self, "_on_wave_completed")

func _on_wave_completed(name):
  if scene_instance != null && name == scene_instance.name:
    pass

func spawn():
  scene_instance = scene.instance()
  Game.scene.call_deferred("add_child", scene_instance)
