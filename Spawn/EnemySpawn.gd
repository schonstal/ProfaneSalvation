extends Node2D

export var flash_time = 0.1

export(Resource) var enemy_scene

onready var placeholder = $Placeholder

var flashed = false
var flash_timer:Timer

func _ready():
  flash_timer = Timer.new()
  flash_timer.one_shot = true
  flash_timer.connect("timeout", self, "_on_Flash_timer_timeout")
  flash_timer.set_name("FlashTimer")
  add_child(flash_timer)

  flash_timer.start(flash_time)

  placeholder.modulate = Color(100, 100, 100, 1)

func _on_Flash_timer_timeout():
  if flashed:
    placeholder.modulate = Color(1, 1, 1, 0)
    flashed = false
  else:
    placeholder.modulate = Color(100, 100, 100, 1)
    flashed = true

  flash_time *= 0.9

  if flash_time > 0.01:
    flash_timer.start(flash_time)
  else:
    if enemy_scene != null:
      var enemy = enemy_scene.instance()
      enemy.global_position = global_position
      Game.scene.current_wave.call_deferred('add_child', enemy)
