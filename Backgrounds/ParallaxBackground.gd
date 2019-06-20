extends ParallaxBackground

export var speed = 1080

func _process(delta):
  var scroll = Vector2(0, delta * speed)
  self.scroll_offset += scroll
