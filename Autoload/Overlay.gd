extends Control

signal fade_complete
@onready var rect = $CanvasLayer/ColorRect

func fade(start_color, end_color, duration):
  emit_signal("fade_complete")
