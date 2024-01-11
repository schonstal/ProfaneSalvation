extends Node2D

@onready var summon_circle_small = $SummonCircleSmall
@onready var summon_circle_big = $SummonCircleBig

var theta = 0

@export var angular_velocity = 1.5
@export var fade_duration = 0.5

signal fade_finished

var target_color = Color(1, 1, 1, 1)

func _ready():
  modulate = Color(target_color.r, target_color.g, target_color.b, 0)

func _process(delta):
  theta += delta * angular_velocity * TAU

  summon_circle_small.rotation = theta
  summon_circle_big.rotation = -theta

func fade_in():
  modulate = target_color
  fade_finished.emit()

func fade_out():
  modulate = target_color
  fade_finished.emit()
