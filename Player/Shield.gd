extends Node2D

onready var sprite = $Sprite
onready var animation = $Sprite/AnimationPlayer
onready var area = $Area2D
onready var collision = $Area2D/CollisionShape2D
onready var buffer = $InputBuffer

var deflecting = false
var deflect_attempt = false

func _ready():
  area.connect("area_entered", self, "_on_Area2D_area_entered")
  animation.connect("animation_finished", self, "_on_SpriteAnimationPlayer_finished")
  buffer.connect("timeout", self, "_on_InputBuffer_timeout")

  collision.disabled = true

func _process(delta):
  if !deflecting && deflect_attempt:
    animation.stop()
    animation.play("Deflect")
    collision.disabled = false
    deflecting = true

func deflect():
  deflect_attempt = true
  buffer.start()

func _on_Area2D_area_entered(area):
  if area.has_method("deflect"):
    area.deflect()

func _on_SpriteAnimationPlayer_finished(name):
  if name == "Deflect":
    collision.disabled = true
    animation.play("DeflectRecover")
  else:
    deflecting = false

func _on_InputBuffer_timeout():
  deflect_attempt = false
