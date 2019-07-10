extends Node2D

export var velocity = 100.0
var shoot_duration = 0.5
var fade_duration = 0.25

var distance = 0.0

onready var chain_links = $ChainLinks
onready var chain_blade = $ChainBlade
onready var link_animation = $ChainLinks/AnimationPlayer
onready var blade_animation = $ChainBlade/AnimationPlayer

onready var shoot_tween = $ShootTween
onready var fade_tween = $FadeTween

func _ready():
  link_animation.play("Idle")
  blade_animation.play("Idle")

  shoot_tween.interpolate_property(
      self,
      "distance",
      0,
      500,
      shoot_duration,
      Tween.TRANS_QUAD,
      Tween.EASE_IN)

  shoot_tween.start()

  shoot_tween.connect("tween_completed", self, "_on_ShootTween_tween_completed")
  fade_tween.connect("tween_completed", self, "_on_FadeTween_tween_completed")

func _process(delta):
  chain_links.region_rect = Rect2(0, 0, 104, distance)
  chain_links.offset.y = -distance / 2
  chain_blade.position.y = chain_links.position.y - distance
  chain_blade.position.x = chain_links.position.x

func _on_ShootTween_tween_completed(object, key):
  fade_tween.interpolate_property(
      self,
      "modulate",
      Color(10, 10, 10, 1),
      Color(1, 1, 1, 1),
      fade_duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT)

  fade_tween.start()

func _on_FadeTween_tween_completed(object, key):
  pass
