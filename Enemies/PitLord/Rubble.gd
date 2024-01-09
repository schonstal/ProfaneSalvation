extends Sprite2D

var original_position = Vector2()
var theta = 0

@export var float_speed = 1
@export var float_amount = 20

func _ready():
  original_position = position

func _process(delta):
  theta += delta * float_speed
  position.y = original_position.y + sin(theta) * float_amount
