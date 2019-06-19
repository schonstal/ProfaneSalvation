extends Node2D

export(Resource) var enemy_scene

export var horizontal = false
export var width = 8
export var hole_width_min = 3
export var hole_width_max = 4
export var offset = 500

var hole_count = 3

var slots = []
var size = 270

func _ready():
  if horizontal:
    size = 480

  var length = (size - 32) / width
  for i in range(0, length):
    slots.append(true)

  for i in range(0, hole_count):
    var index = randi() % length
    var hole_length = randi() % hole_width_max + hole_width_min
    for j in range(0, hole_length):
      if index + j < length:
        slots[index + j] = false

  for i in range(0, length):
    if slots[i]:
      var enemy = enemy_scene.instance()

      if horizontal:
        enemy.position = Vector2(16 + i * width, offset)
      else:
        enemy.position = Vector2(offset, 18 + i * width)

      add_child(enemy)
