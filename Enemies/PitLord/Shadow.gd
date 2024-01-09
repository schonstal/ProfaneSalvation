extends Sprite2D

const DURATION = 0.25
var alpha = 0.5

func initialize(object, sprite):
  texture = sprite.texture
  hframes = sprite.hframes
  vframes = sprite.vframes
  frame = sprite.frame

  global_position = object.global_position
  scale = object.scale
  rotation_degrees = object.rotation_degrees

func _process(delta):
  alpha -= delta / DURATION
  modulate = Color(5.8, 4.8, 7.1, alpha)

  if alpha <= 0:
    queue_free()
