extends ParallaxLayer

onready var sprite = $Sprite
export var speed = 2000

func _ready():
  self.motion_mirroring = sprite.texture.get_size().rotated(sprite.global_rotation)

func _process(delta):
  var scroll = Vector2(0, delta * speed)
  self.motion_offset += scroll

