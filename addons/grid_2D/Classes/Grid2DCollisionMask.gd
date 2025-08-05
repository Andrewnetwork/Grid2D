@tool
class_name Grid2DCollisionMask
extends Node2D

@export var n_rows := 5
@export var n_cols := 5
@export var mask: Array[Array] = []

var parent_grid_item: GridItem
var editor_grid: ToggleGrid

func _enter_tree():
	var parent = get_parent()
	if parent is GridItem:
		parent_grid_item = parent
		if mask == []:
			init_mask(parent_grid_item.size.x, parent_grid_item.size.y)
		
		if Engine.is_editor_hint():
			editor_grid = ToggleGrid.new()
			editor_grid.cell_size = parent_grid_item.parent_grid.cell_size
			editor_grid.grid_size = Vector2i(n_cols, n_rows)
			editor_grid.toggle_grid_state = mask
			editor_grid.z_index = 100
			add_child(editor_grid)
	else:
		parent_grid_item = null
		update_configuration_warnings()
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if parent_grid_item == null:
		warnings.append("No grid item parent. Add as child to a grid item.")
	return warnings
func init_mask(nrows, ncols):
	n_rows = nrows
	n_cols = ncols
	for ncol in range(ncols):
		var na : Array[bool] = []
		na.resize(nrows)
		na.fill(false)
		mask.append(na)
