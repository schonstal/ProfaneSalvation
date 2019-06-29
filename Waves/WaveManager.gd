extends Node2D

var waves = []
var wave_index = 0
var current_wave

func _ready():
  EventBus.connect("wave_completed", self, "_on_wave_completed")
  load_chapter(Game.chapter)

func _on_wave_completed(name):
  wave_index += 1

  if wave_index < waves.size():
    waves[wave_index].spawn()
  else:
    wave_index = 0
    load_chapter(Game.chapter)

func load_chapter(chapter):
  waves = get_children()[chapter].get_children()
  waves[0].spawn()
