extends Node2D

export var chapter = 0

var waves = []
var wave_index = 0
#warning-ignore:unused_class_variable
var current_wave

var complete_wave = preload("res://Waves/CompleteWave.tscn")

func _ready():
  EventBus.connect("wave_completed", self, "_on_wave_completed")
  EventBus.connect("chapter_complete", self, "_on_chapter_complete")

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

  var complete_wave_instance = complete_wave.instance()
  Game.scene.current_wave.call_deferred("add_child", complete_wave_instance)
  Game.scene.wave_manager.current_wave = complete_wave_instance.name
