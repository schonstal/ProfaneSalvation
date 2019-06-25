extends Area2D

const UP = Vector2(0, -1)

onready var sprite = $Sprite

export var speed = 600
export var angular_velocity = 0.5
export var velocity = Vector2(0, 500)

signal died

export(Resource) var collect_sound = preload("res://Items/Halo/Collect.wav")

func _ready():
  connect("body_entered", self, "_on_body_entered")

func _process(delta):
  rotation += PI * 2 * delta * angular_velocity

func _physics_process(delta):
  position += velocity * delta

func _on_body_entered(body):
  die()

func die():
  Game.scene.sound.play(collect_sound)
  queue_free()
