extends Node2D

var waves = []
var wave_index = 0
var current_wave

func _ready():
  EventBus.connect("wave_completed", self, "_on_wave_completed")
  waves = get_children()
  waves[0].spawn()

func _on_wave_completed(name):
  wave_index += 1

  if wave_index < waves.size():
    waves[wave_index].spawn()
  else:
    EventBus.emit_signal("chapter_complete")
