extends StaticBody3D


@export var mat: Material
@onready var mesh = $MeshInstance3D

func _ready() -> void:
	mesh.set_surface_override_material(0,mat)
