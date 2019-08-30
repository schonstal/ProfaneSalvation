var position:Vector2

var radius = 0.0
var rotation = 0.0
var count = 0
var index = 0
var speed

var scene

func _init(options):
  self.position = options["position"]
  self.scene = options["scene"]
  self.count = options["count"]

  if options.has("radius"):
    self.radius = options["radius"]

  if options.has("speed"):
    self.speed = options["speed"]

  if options.has("rotation"):
    self.rotation = options["rotation"]

func should_continue():
  return index < count

func _iter_init(arg):
  index = 0
  return should_continue()

func _iter_next(arg):
  index += 1
  return should_continue()

func _iter_get(arg):
  var bullet = scene.instance()
  var angle = TAU * index / count + rotation

  bullet.global_position = position + \
      Vector2(cos(angle), sin(angle)) * \
      radius

  if speed != null:
    bullet.velocity = Vector2(cos(angle), sin(angle)) * speed

  Game.scene.projectiles.call_deferred("add_child", bullet)

  return bullet
