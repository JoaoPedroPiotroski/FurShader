@tool
extends Node3D

@export var leaf_material : ShaderMaterial
@export var wind_noise : FastNoiseLite
@export var wind_speed : float = 1
@export var wind_amplitude : float = 1.0

var time : Vector2

func _process(delta):
	time.x += delta * wind_speed
	time.y -= delta * wind_speed
	var value = wind_noise.get_noise_2d(time.x, time.y)
	value = (value * 2) - 1
	value *= wind_amplitude
	leaf_material.set_shader_parameter("droop_dir", Vector3(value, 0., value))
