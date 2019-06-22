extends Node2D

export(Resource) var scene
var scene_instance = null

func _on_wave_completed(name):
  if scene_instance != null && name == scene_instance.name:
    scene_instance.queue_free()

func spawn():
  EventBus.connect("wave_completed", self, "_on_wave_completed")
  scene_instance = scene.instance()
  Game.call_deferred("add_child", scene_instance)
