@tool
extends EditorPlugin

var CollisionMaskPlugin = preload("res://addons/grid_2D/Submodules/CollisionMaskPlugin.gd").new()

func _forward_canvas_gui_input(event: InputEvent) -> bool:
	return CollisionMaskPlugin.forward_canvas_gui_input(event)
func _handles(object: Object) -> bool:
	# Run when selected in the editor. 
	return CollisionMaskPlugin.handles(object)
func _enter_tree() -> void:
	pass
func _exit_tree() -> void:
	pass
