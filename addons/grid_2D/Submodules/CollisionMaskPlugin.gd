@tool
extends Node

var active_toggle_grid : ToggleGrid

func forward_canvas_gui_input(event: InputEvent) -> bool:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if active_toggle_grid != null:
				return active_toggle_grid._unhandled_input(event)
			return false
	return false
func handles(object: Object) -> bool:
	# Run when selected in the editor. 
	if object is Grid2DCollisionMask:
		active_toggle_grid = object.editor_grid 
		return true
	return false
