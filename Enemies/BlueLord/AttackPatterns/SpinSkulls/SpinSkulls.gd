extends Node2D

onready var pit_lord = $'..'

var wait_timer:Timer

export var center = Vector2(1920 / 2, 1080 / 2)
export var radius = 400
export var angular_velocity = 0.7
export var spawn_time = 2
export(Resource) var skull_scene = preload("res://Spawn/SkullSpawner.tscn")

var theta = 0

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("SpawnTimer")
  wait_timer.wait_time = spawn_time
  wait_timer.start()
  add_child(wait_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")
  pit_lord.connect("move_completed", self, "_on_PitLord_move_completed")

func _physics_process(delta):
  theta += delta * angular_velocity
  pit_lord.global_position = center + Vector2(cos(theta), sin(theta)) * radius

func _on_WaitTimer_timeout():
  pit_lord.start_attack()

  var scene_instance = skull_scene.instance()
  scene_instance.global_position = pit_lord.global_position
  Game.scene.current_wave.call_deferred("add_child", scene_instance)
