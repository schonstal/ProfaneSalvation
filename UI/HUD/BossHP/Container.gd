tool
extends Node2D

export var length = 500.0

onready var left = $Left
onready var right = $Right
onready var bottom = $Bottom

var length_was = 0.0

func _process(delta):
  if length != length_was:
    left.region_rect = Rect2(0, 0, 27, length)
    left.offset.y = -length / 2

    right.region_rect = Rect2(0, 0, 27, length)
    right.offset.y = -length / 2

    bottom.position.y = left.position.y - length
    bottom.position.x = left.position.x

    length_was = length
