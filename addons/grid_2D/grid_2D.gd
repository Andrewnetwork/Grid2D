@tool
extends EditorPlugin

var plugin
var active_toggle_grids: Array[ToggleGrid] = []

func _on_scene_change(scene_root: Node):
	# Traverse tree and add a toggle grid to every Grid2DCollisionMask.
	print("Scene changed")
	if scene_root != null:
		if scene_root is Grid2DCollisionMask:
			# Don't create another toggle grid if one already exists.
			#for child in object.get_children():
				#if child is ToggleGrid:
					#return true
			print("Creating toggle grid.")
			var tg = ToggleGrid.new()
			tg.cell_size = scene_root.parent_grid_item.parent_grid.cell_size
			tg.grid_size = Vector2i(scene_root.n_cols, scene_root.n_rows)
			tg.toggle_grid_state = scene_root.mask
			tg.z_index = 100
			scene_root.add_child(tg)
			active_toggle_grids.append(tg)
		else:
			for child in scene_root.get_children():
				_on_scene_change(child)

func _forward_canvas_gui_input(event: InputEvent) -> bool:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			for tg in active_toggle_grids:
				if is_instance_valid(tg):
					tg._unhandled_input(event)
				# TODO: Remove invalid instances from array. 
			return true
	return false
func _handles(object: Object) -> bool:
	if object is Grid2DCollisionMask:
		return true
	return false
func _enter_tree() -> void:
	plugin = preload("res://addons/grid_2D/grid_2d_inspector_plugin.gd").new()
	add_inspector_plugin(plugin)
	connect("scene_changed", _on_scene_change)

func _exit_tree() -> void:
	remove_inspector_plugin(plugin)
