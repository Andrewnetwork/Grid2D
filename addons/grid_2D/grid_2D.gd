@tool
extends EditorPlugin

var plugin
var active_toggle_grid : ToggleGrid

func _forward_canvas_gui_input(event: InputEvent) -> bool:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if active_toggle_grid != null:
				return active_toggle_grid._unhandled_input(event)
			return false
	return false
func _handles(object: Object) -> bool:
	# Run when selected in the editor. 
	if object is Grid2DCollisionMask:
		active_toggle_grid = object.editor_grid 
		return true
	return false
func _enter_tree() -> void:
	plugin = preload("res://addons/grid_2D/grid_2d_inspector_plugin.gd").new()
	add_inspector_plugin(plugin)

func _exit_tree() -> void:
	remove_inspector_plugin(plugin)
