extends Node2D

export(Array, Resource) var patterns = []

var active_pattern = null
var previous_index = -1

onready var pit_lord = $'..'

func _ready():
  spawn_pattern()
  EventBus.connect("boss_pattern_complete", self, "_on_boss_pattern_complete")

func spawn_pattern():
  if active_pattern != null:
    active_pattern.queue_free()

  active_pattern = random_pattern().instance()
  # active_pattern.global_position = pit_lord.global_position
  pit_lord.call_deferred("add_child", active_pattern)

  pit_lord.connect("move_completed", self, "_on_PitLord_move_completed")

func random_pattern():
  var new_index = previous_index

  if patterns.size() > 1:
    while new_index == previous_index:
      new_index = randi() % patterns.size()
  else:
    new_index = 0

  previous_index = new_index
  return patterns[new_index]

func _on_boss_pattern_complete():
  spawn_pattern()
