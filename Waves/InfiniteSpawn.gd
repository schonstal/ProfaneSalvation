extends Node2D

export(Resource) var scene
export var spawn_rate = 3.0
export var spawn_offset = 1.0

onready var timer = $Timer

func _ready():
  $Sprite.visible = false

  EventBus.connect("wave_completed", self, "_on_wave_completed")
  timer.connect("timeout", self, "_on_Timer_timeout")

  timer.wait_time = spawn_rate

  if spawn_offset <= 0:
    spawn()
    timer.start()
  else:
    timer.start(spawn_offset)


func _on_wave_completed(_name):
  queue_free()

func _on_Timer_timeout():
  spawn()
  timer.start(spawn_rate)

func spawn():
  var scene_instance = scene.instance()
  scene_instance.global_position = global_position
  Game.scene.current_wave.call_deferred("add_child", scene_instance)
