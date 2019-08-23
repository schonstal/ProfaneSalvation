extends Node2D

var waves = []
var wave_index = 0
var current_wave

var complete_wave = preload("res://Waves/CompleteWave.tscn")
var chapter = 1

func _ready():
  EventBus.connect("wave_completed", self, "_on_wave_completed")
  EventBus.connect("chapter_complete", self, "_on_chapter_complete")
  EventBus.connect("new_game", self, "_on_new_game")
  load_chapter(chapter)

func _on_wave_completed(name):
  print(name, " completed")
  wave_index += 1

  if wave_index < waves.size():
    waves[wave_index].spawn()
  else:
    wave_index = 0
    load_chapter(chapter)

func load_chapter(chapter):
  waves = get_children()[chapter].get_children()
  waves[0].spawn()

func _on_chapter_complete():
  chapter += 1

func _on_new_game():
  chapter = 0
