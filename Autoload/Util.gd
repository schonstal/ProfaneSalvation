extends Node

func radial_vector(angle, length):
   return Vector2(
      cos(angle),
      sin(angle)
  ) * length
