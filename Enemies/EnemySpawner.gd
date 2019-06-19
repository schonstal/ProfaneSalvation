extends Node2D

export var min_score = 0

export var min_time = 1
export var max_time = 5
export var variance = 1

export var group_min = 1
export var group_max = 1

var current_time setget set_current_time,get_current_time
var spawn_timer:Timer
onready var zone = $SpawnZone

export(Resource) var enemy_scene

func _ready():
  spawn_timer = Timer.new()
  spawn_timer.set_name("SpawnTimer")
  add_child(spawn_timer)

  spawn_timer.connect("timeout", self, "_on_Spawn_timer_timeout")
  start_timer()

func _on_Spawn_timer_timeout():
  spawn()
  start_timer()

func start_timer():
  self.current_time = lerp(min_time, max_time, Game.scene.difficulty)
  spawn_timer.start(current_time)

func set_current_time(value):
  current_time = min(value + randf() * variance, max_time)
  current_time = max(current_time, min_time)

func get_current_time():
  return current_time

func spawn():
  var group_size = lerp(group_min, group_max + 1, randf())
  group_size = min(group_size, group_max)
  group_size = max(group_size, group_min)

  for i in range(0, group_size):
    var enemy = enemy_scene.instance()

    if zone != null:
      enemy.position = Vector2(
          zone.position.x + randf() * zone.width,
          zone.position.y + randf() * zone.height)

    add_child(enemy)
