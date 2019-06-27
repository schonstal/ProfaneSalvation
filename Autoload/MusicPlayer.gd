extends AudioStreamPlayer

var bus_effect:AudioEffectLowPassFilter
var bus_index = 0
var effect_index = 0

func _ready():
  bus_index = AudioServer.get_bus_index("Music")

  bus_effect = AudioEffectLowPassFilter.new()
  bus_effect.cutoff_hz = 22000

  AudioServer.add_bus_effect(bus_index, bus_effect, effect_index)

func play_file(audio_file):
  if File.new().file_exists(audio_file):
    self.stream = load(audio_file)
    self.play()
  else:
    print("Music file not found.")

func disable_filter():
  bus_effect.cutoff_hz = 22000

func enable_filter():
  bus_effect.cutoff_hz = 200
