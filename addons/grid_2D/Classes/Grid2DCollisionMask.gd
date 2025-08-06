@tool
class_name Grid2DCollisionMask
extends Node2D

@export var n_rows := 5
@export var n_cols := 5
@export var mask: Array[Array]

var parent_grid_item: GridItem
var editor_grid: ToggleGrid

func _size_changed():
	#Lazy remake editor grid instead of resizing it.
	update_mask()
	make_editor_grid()
func make_editor_grid():
	if editor_grid != null:
		editor_grid.queue_free()
		
	editor_grid = ToggleGrid.new()
	editor_grid.cell_size = parent_grid_item.parent_grid.cell_size
	editor_grid.grid_size = Vector2i(n_cols, n_rows)
	editor_grid.toggle_grid_state = mask
	editor_grid.z_index = 100
	add_child(editor_grid)
func _enter_tree():
	var parent = get_parent()
	if parent is GridItem:
		parent_grid_item = parent
		parent_grid_item.collision_mask = self
		parent_grid_item.connect("size_changed", _size_changed)
		if mask.is_empty():
			update_mask()
		
		if Engine.is_editor_hint() and editor_grid == null:
			make_editor_grid()
	else:
		parent_grid_item = null
		update_configuration_warnings()
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if parent_grid_item == null:
		warnings.append("No grid item parent. Add as child to a grid item.")
	return warnings
func update_mask():
	var prev_n_cols = n_cols
	var prev_n_rows = n_rows
	n_cols = parent_grid_item.size.x
	n_rows = parent_grid_item.size.y
	var new_mask: Array[Array]
	
	for nncol in range(n_cols):
		var na : Array[bool] = []
		na.resize(n_rows)
		na.fill(false)
		new_mask.append(na)
	
	if !mask.is_empty():
		# Transfer values of the old mask to the new mask. 
		# Ternary operator selects the smalles mask size among the two.
		for col in range(prev_n_cols if prev_n_cols < n_cols else n_cols):
			for row in range(prev_n_rows if prev_n_rows < n_rows else n_rows):
				new_mask[col][row] = mask[col][row]
	
	mask = new_mask
