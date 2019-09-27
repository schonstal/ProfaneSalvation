extends Node2D

export var angular_velocity = 1.0
var theta = 0

var die_timer:Timer

func _ready():
  die_timer = Timer.new()
  die_timer.set_name("DieTimer")
  die_timer.wait_time = 8.0
  die_timer.one_shot = true
  die_timer.start()
  add_child(die_timer)

  die_timer.connect("timeout", self, "_on_DieTimer_timeout")

func _on_DieTimer_timeout():
  queue_free()

func _process(delta):
  theta += delta * angular_velocity * TAU
  global_rotation = theta

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
