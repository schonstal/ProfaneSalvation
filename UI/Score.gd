extends Label

func _process(delta):
  self.text = "%d" % Game.scene.score
