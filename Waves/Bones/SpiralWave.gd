extends Node2D

var child_count = 0
var dead_children = 0

signal wave_completed

func _ready():
  child_count = get_child_count()

  for child in get_children():
    child.connect("died", self, "_on_Child_died")

func _on_Child_died():
  dead_children += 1
  if dead_children >= child_count:
    print("we done boys")
