extends Node2D

onready var blue_lord = $'..'

var wait_timer:Timer
var activate_timer:Timer

export var wait_time = 2.0
export var activate_time = 5.0
export var distance = 50
export var center = Vector2(1920 / 2, 1080 / 2 - 200)

var offset = 0.0

onready var purple_spiral = $PurpleSpiral

func _ready():
  wait_timer = Timer.new()
  wait_timer.set_name("WaitTimer")
  wait_timer.wait_time = wait_time
  wait_timer.one_shot = true
  wait_timer.start()
  add_child(wait_timer)

  activate_timer = Timer.new()
  activate_timer.set_name("WaitTimer")
  activate_timer.wait_time = activate_time
  activate_timer.one_shot = true
  activate_timer.start()
  add_child(activate_timer)

  wait_timer.connect("timeout", self, "_on_WaitTimer_timeout")
  activate_timer.connect("timeout", self, "_on_ActivateTimer_timeout")
  blue_lord.connect("move_completed", self, "_on_BlueLord_move_completed")

func _on_WaitTimer_timeout():
  var direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
  direction = direction.normalized()

  blue_lord.move_to(center + distance * direction, 1)

func _on_ActivateTimer_timeout():
  purple_spiral.active = true

func _on_BlueLord_move_completed():
  blue_lord.start_attack()
  wait_timer.start()
