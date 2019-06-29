extends Node2D

export(Resource) var scene
export var spawn_rate = 3.0

onready var timer = $Timer

func _ready():
  $Sprite.visible = false

  EventBus.connect("wave_completed", self, "_on_wave_completed")
  timer.connect("timeout", self, "_on_Timer_timeout")

  timer.wait_time = spawn_rate
  timer.start()

  spawn()

func _on_wave_completed(name):
  queue_free()

func _on_Timer_timeout():
  spawn()

func spawn():
  var scene_instance = scene.instance()
  scene_instance.global_position = global_position
  Game.scene.current_wave.call_deferred("add_child", scene_instance)
