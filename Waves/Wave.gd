extends Node2D

@export var scene: Resource
var scene_instance = null

func _ready():
  EventBus.connect("wave_completed", Callable(self, "_on_wave_completed"))

func _on_wave_completed(_name):
  pass

func spawn():
  scene_instance = scene.instantiate()
  Game.scene.current_wave.call_deferred("add_child", scene_instance)
  Game.scene.wave_manager.current_wave = scene_instance.name
