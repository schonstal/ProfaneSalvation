extends Node2D

var completed = false

export var complete_time = 1.0
var time = 0.0

signal wave_completed

func _ready():
  EventBus.emit_signal("chapter_complete")

func _process(delta):
  time += delta
  if time > complete_time:
    complete()

func complete():
  if completed:
    return

  completed = true
  EventBus.emit_signal("wave_completed", name)