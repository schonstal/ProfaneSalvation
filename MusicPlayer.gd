extends AudioStreamPlayer

func _ready():
  var audio_file = "res://Music/bones.ogg"

  if File.new().file_exists(audio_file):
    self.stream = load(audio_file)
    self.play()
  else:
    print("Music file not found.")
