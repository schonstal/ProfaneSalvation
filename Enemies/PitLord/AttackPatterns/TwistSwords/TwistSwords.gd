extends Node2D

@onready var pit_lord = $'..'

var wait_timer:Timer

@export var wait_time = 0.25
@export var distance = 50
@export var center = Vector2(1920 / 2, 1080 / 2 - 200)

var offset = 0.0

@export var bullet_scene: Resource = preload("res://Projectiles/PitLordFireball/PitLordFireball.tscn")

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("SpawnTimer")
  wait_timer.wait_time = wait_time
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  wait_timer.connect("timeout", Callable(self, "_on_WaitTimer_timeout"))
  pit_lord.connect("move_completed", Callable(self, "_on_PitLord_move_completed"))

func _on_WaitTimer_timeout():
  var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
  direction = direction.normalized()

  pit_lord.move_to(center + distance * direction, 1)

func _on_PitLord_move_completed():
  wait_timer.start()
