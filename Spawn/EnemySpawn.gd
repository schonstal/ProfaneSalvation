extends Node2D

export var flash_time = 0.025
export var spawn_time = 0.3

export(Resource) var enemy_scene

onready var placeholder = $Placeholder
onready var fade_tween = $FadeTween
onready var flash_tween = $FadeTween

var flashed = false
var flash_timer:Timer
var spawn_timer:Timer

func _ready():
  spawn_timer = Timer.new()
  spawn_timer.one_shot = true
  spawn_timer.connect("timeout", self, "_on_Spawn_timer_timeout")
  spawn_timer.set_name("SpawnTimer")
  add_child(spawn_timer)

  spawn_timer.start(spawn_time)

  placeholder.modulate = Color(100, 100, 100, 0.5)

  fade_tween.interpolate_property(
      placeholder,
      "modulate",
      Color(100, 100, 100, 1),
      Color(10, 10, 10, 0.5),
      spawn_time,
      Tween.TRANS_QUART,
      Tween.EASE_IN)

  fade_tween.start()

func _on_Spawn_timer_timeout():
  if enemy_scene != null:
    var enemy = enemy_scene.instance()
    enemy.global_position = global_position
    Game.scene.current_wave.call_deferred('add_child', enemy)

  queue_free()
