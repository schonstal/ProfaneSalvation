extends Area2D

const UP = Vector2(0, -1)

onready var sprite = $Sprite

export var speed = 600
export var angular_velocity = 0.5
export var target_velocity = Vector2(0, 100)

var velocity = Vector2(-300, -500)

signal died

export(Resource) var collect_sound = preload("res://Items/Halo/Collect.wav")

func _ready():
  connect("body_entered", self, "_on_body_entered")

func _process(delta):
  rotation += PI * 2 * delta * angular_velocity
  if global_position.y > 1200:
    queue_free()

func _physics_process(delta):
  if Game.scene.player.attacking || Game.scene.player.dead:
    velocity.x += (target_velocity.x - velocity.x) * 0.1
    velocity.y += (target_velocity.y - velocity.y) * 0.1
  else:
    var direction = (Game.scene.player.position - global_position).normalized()
    velocity = direction * 800

  position += velocity * delta

func _on_body_entered(body):
  die()

func die():
  Game.scene.sound.play(collect_sound)
  queue_free()
