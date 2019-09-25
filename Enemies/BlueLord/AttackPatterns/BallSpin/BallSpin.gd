extends Node2D

onready var blue_lord = $'..'

var wait_timer:Timer

export var wait_time = 2.0
export var distance = 50
export var center = Vector2(1920 / 2, 1080 / 2 - 200)

var offset = 0.0

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = wait_time
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")

func _on_WaitTimer_timeout():
  move()
  wait_timer.start()

func move():
  var direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
  direction = direction.normalized()

  blue_lord.move_to(center + distance * direction, 1)
