extends Node2D

export var min_score = 0

export var min_time = 1
export var max_time = 5
export var variance = 1

export var scenes = []

var current_time setget set_current_time,get_current_time
var spawn_timer:Timer

func _ready():
  load_scenes()
  spawn_timer = Timer.new()
  spawn_timer.set_name("SpawnTimer")
  add_child(spawn_timer)

  spawn_timer.connect("timeout", self, "_on_Spawn_timer_timeout")
  start_timer()

func _on_Spawn_timer_timeout():
  scenes.shuffle()
  var enemy = scenes[0].instance()
  add_child(enemy)

  start_timer()

func start_timer():
  self.current_time = lerp(min_time, max_time, Game.scene.difficulty)
  spawn_timer.start(current_time)

func set_current_time(value):
  current_time = min(value + randf() * variance, max_time)
  current_time = max(current_time, min_time)

func get_current_time():
  return current_time

func load_scenes():
  var path = "res://Enemies/Waves/"
  var dir = Directory.new()
  var error = dir.open(path)

  if error == OK:
    dir.list_dir_begin()
    var file_name = dir.get_next()

    while (file_name != ""):
      if file_name.match("*.tscn"):
        scenes.append(load("%s%s" % [path, file_name]))

      file_name = dir.get_next()
  else:
    print("An error occurred when trying to access %s. Error: %s" % [path, error])
