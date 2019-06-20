extends Node2D

const MAX_COMBO = 10
const TARGET_SCORE = 100000

var camera:Node
var player:Node
var explosions:Node
var sound:Node
var particles:Node
var projectiles:Node

onready var game_over = false

var score = 0
var combo setget set_combo,get_combo
var difficulty setget ,get_difficulty

func _enter_tree():
  camera = $Camera
  player = $Player
  explosions = $Explosions
  sound = $Sound
  particles = $Particles
  projectiles = $Projectiles

  Game.initialize()

func _ready():
  Engine.time_scale = 1
  reset_combo()
  reset_score()

func game_over():
  var game_over_scene = preload("res://UI/GameOver/GameOver.tscn")
  var game_over_node = game_over_scene.instance()
  add_child(game_over_node)

func get_difficulty():
  return min(score / TARGET_SCORE, 1)

func set_combo(value):
  combo = min(value, MAX_COMBO)

func get_combo():
  return combo

func reset_combo():
  combo = 0

func score(points):
  score += points

  if score > Game.high_score:
    Game.high_score = score

func reset_score():
  score = 0

func shake(duration = 0.5, frequency = 60, amplitude = 25):
  if camera != null:
    camera.shake(duration, frequency, amplitude)
