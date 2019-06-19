extends Area2D

export var speed = 150
export var direction = -1
export var vertical = false

export var damage = 1

const Enemy = preload("res://Enemies/Enemy.gd")

func _ready():
  connect("body_entered", self, "_on_body_enter")

func _physics_process(delta):
  var pos = position.y if vertical else position.x

  pos += speed * delta * direction

  if pos < -100:
    self.queue_free()

  if pos > 1000:
    self.queue_free()

  if vertical:
    position.y = pos
  else:
    position.x = pos

func flip():
  direction = -direction
  $Sprite.flip_h = !$Sprite.flip_h

func _on_body_enter(body):
  if body.get_name() == "Player":
    body.hurt(damage)

  if $'..' is Enemy:
    $'..'.hurt(1000)
