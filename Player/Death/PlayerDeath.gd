extends Node2D

@export var feather_scene: Resource
@export var feather_count = 24

@onready var feathers = $Feathers

func _ready():
  global_position = Game.scene.player.global_position
  scale = Game.scene.player.scale
  rotation_degrees = Game.scene.player.rotation_degrees

  for i in range(0, feather_count):
    var feather = feather_scene.instantiate()
    feathers.call_deferred("add_child", feather)
    feather.position = Vector2(
        cos(PI * 2 * i / feather_count),
        sin(PI * 2 * i / feather_count)
    ) * 40 * randf()
