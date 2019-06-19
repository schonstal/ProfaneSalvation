extends Node

# My body is ready...
onready var body = $'..'
onready var sprite = $'../Sprite'

export var speed = 50

func _ready():
  if randf() > 0.5:
    body.position.x = 480
  body.position.y = randf() * 270

func _process(delta):
  if Game.scene.player.dead:
    body.velocity.x = lerp(body.velocity.x, 0, 0.01)
    body.velocity.y = lerp(body.velocity.y, 0, 0.01)
    return

  body.velocity.x = Game.scene.player.position.x - body.position.x
  body.velocity.y = Game.scene.player.position.y - body.position.y
  body.velocity = body.velocity.normalized() * speed

  if body.velocity.x < 0:
    sprite.flip_h = true
  else:
    sprite.flip_h = false
