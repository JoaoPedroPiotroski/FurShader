@tool
extends Node

@export var affected_nodes : Array[MeshInstance3D] 
@export var receiver : Node3D
@export var layers : float = 16
@export var delete_original := true
@export var generate := false :
	set(value):
		_generate_fur()
		print('update')
		generate = false

@export_file("*.tres") var shell_material_path : String
 
func _generate_fur():
	var current_mat = load(shell_material_path)
	for mesh in affected_nodes:
		for layer in range(layers):
			var meshd = mesh.duplicate()
			
			receiver.add_child(meshd)
			meshd.set_owner(get_tree().get_edited_scene_root())
			#meshd.material_overlay = current_mat
			meshd.set("instance_shader_parameters/height",  ((1.0 / layers) * float(layer)))
		if delete_original:
			mesh.queue_free()
