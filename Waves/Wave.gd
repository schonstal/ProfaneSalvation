extends Node2D

export(Resource) var scene
var scene_instance = null

func _on_wave_completed():
  Game.wave_manager.wave_completed()
  if scene_instance != null:
    scene_instance.queue_free()

func spawn():
  scene.instance()
  scene.connect("wave_completed", self, "_on_wave_completed")
  Game.call_deferred("add_child", scene)
