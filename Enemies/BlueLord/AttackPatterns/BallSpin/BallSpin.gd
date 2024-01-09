extends Node2D

@onready var blue_lord = $'..'
@onready var patterns = [
    $BlueTwist,
    $PurpleTwist,
    $MetaTwist
  ]

@export var wait_time = 2.0
@export var activate_time = 3.0
@export var distance = 50
@export var center = Vector2(1920 / 2 + 200, 1080 / 2 - 200)

var wait_timer:Timer
var activate_timer:Timer

var offset = 0.0
var index = 0

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

  wait_timer.connect("timeout", Callable(self, "_on_WaitTimer_timeout"))
  activate_timer.connect("timeout", Callable(self, "_on_ActivateTimer_timeout"))
  blue_lord.connect("move_completed", Callable(self, "_on_BlueLord_move_completed"))

func _on_BlueLord_move_completed():
  blue_lord.start_attack()

func _on_WaitTimer_timeout():
  move()
  wait_timer.start()

func _on_ActivateTimer_timeout():
  index += 1

  if index < patterns.size():
    blue_lord.start_attack()
    patterns[index].active = true
    activate_timer.start()

func move():
  var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
  direction = direction.normalized()

  blue_lord.move_to(center + distance * direction, 1)
