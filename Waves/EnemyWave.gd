extends Node2D

var child_count = 0
var dead_children = 0
var completed = false

export var complete_time = 2.0
var time = 0.0

signal wave_completed

func _ready():
  child_count = get_child_count()

  for child in get_children():
    child.connect("died", self, "_on_Child_died")

func _process(delta):
  time += delta
  if time > complete_time:
    complete()

func _on_Child_died():
  dead_children += 1
  if dead_children >= child_count:
    complete()
    queue_free()

func complete():
  if completed:
    return

  completed = true
  EventBus.emit_signal("wave_completed", name)
