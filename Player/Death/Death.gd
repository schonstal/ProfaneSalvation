extends Node2D

@onready var audio = $AudioStreamPlayer

func _ready():
  audio.connect("finished", Callable(self, "_on_AudioStreamPlayer_finished"))

  global_position = Game.scene.player.global_position
  scale = Game.scene.player.scale
  rotation_degrees = Game.scene.player.rotation_degrees

func _on_AudioStreamPlayer_finished():
  queue_free()
