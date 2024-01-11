extends Sprite2D

func _ready():
  EventBus.connect("shield_failure", Callable(self, "_on_shield_fauilure"))

func flash():
  # FIXME
  print("flashed")

func _on_shield_fauilure():
  flash()
