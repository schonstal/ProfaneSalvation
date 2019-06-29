extends Node2D

export(Resource) var scene
var scene_instance = null

func _ready():
  EventBus.connect("wave_completed", self, "_on_wave_completed")

func _on_wave_completed(name):
  pass

func spawn():
  scene_instance = scene.instance()
  Game.scene.current_wave.call_deferred("add_child", scene_instance)
  Game.scene.wave_manager.current_wave = scene_instance.name
