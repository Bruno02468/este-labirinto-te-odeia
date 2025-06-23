# Main.gd
extends Node

var current_scene: Node = null

func _ready():
	load_scene("res://scenes/menu.tscn")

func load_scene(path: String):
	if current_scene:
		current_scene.queue_free()

	await get_tree().process_frame  # <-- Wait a frame to fully clear old scene

	var scene_res = load(path)
	var new_scene = scene_res.instantiate()

	add_child(new_scene)
	current_scene = new_scene
