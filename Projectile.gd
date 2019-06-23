extends Area2D

export var velocity = Vector2(0, -1000)

export var damage = 1

onready var explosion_scene = preload("res://Enemies/Explosion/Explosion.tscn")

func _ready():
  connect("body_entered", self, "_on_body_enter")

func _physics_process(delta):
  position += velocity * delta

  if position.y < -100:
    self.queue_free()

  if position.y > 1200:
    self.queue_free()

  if position.x < -100:
    self.queue_free()

  if position.x > 2020:
    self.queue_free()

  rotation = velocity.angle()

func _on_body_enter(body):
  body.hurt(damage)
  queue_free()

func deflect():
  var explosion = explosion_scene.instance()
  explosion.global_position = global_position
  Game.scene.explosions.call_deferred("add_child", explosion)
  queue_free()
