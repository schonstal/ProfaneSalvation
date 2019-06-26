extends Node2D

onready var summon_circle_small = $SummonCircleSmall
onready var summon_circle_big = $SummonCircleBig

var theta = 0

export var angular_velocity = 1.5

func _ready():
  pass

func _process(delta):
  theta += delta * angular_velocity * TAU

  summon_circle_small.rotation = theta
  summon_circle_big.rotation = -theta
