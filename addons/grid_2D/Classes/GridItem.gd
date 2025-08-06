@tool
class_name GridItem
extends Node2D

signal size_changed()

## Size in grid columns and rows.
@export var size: Vector2i : set = set_size 
## The upper left origin cell. 
@export var grid_position = Vector2i(1,1): set = set_grid_position
@export var snap_to_grid = true : set = set_snap_to_grid

var parent_grid: Grid2D
var collision_mask: Grid2DCollisionMask

func move_to_position(pos: Vector2):
	## Moves grid item to the cell containing pos. Assumes coordinates local to parent_grid. 
	if parent_grid != null:
		var grid_pixel_size = parent_grid.get_pixel_size()
		var item_pixel_size = get_pixel_size() - parent_grid.cell_size
		var max_pos = grid_pixel_size-item_pixel_size
		var new_grid_pos = (Vector2i(pos) / parent_grid.cell_size) + Vector2i.ONE
		
		# Handle out of grid bounds conditions. 
		if pos.x < 0:
			new_grid_pos.x = 1
		elif pos.x > max_pos.x:
			new_grid_pos.x = parent_grid.grid_size.x-size.x+1
		if pos.y < 0:
			new_grid_pos.y = 1
		elif pos.y > max_pos.y:
			new_grid_pos.y =  parent_grid.grid_size.y-size.y+1
			
		#grid_position = new_grid_pos
		move_and_collide(new_grid_pos)
func move_and_collide(grid_pos: Vector2i, test_only:=false):
	if parent_grid != null:
		# Horribly unoptimized. 
		var collision_at_grid_pos := false
		var occupied_cells = get_occupied_cells(grid_pos)
		for grid_item in parent_grid.grid_items:
			if grid_item != self:
				var other_occupied_cells = grid_item.get_occupied_cells()
				for occupied_cell in occupied_cells:
					if other_occupied_cells.has(occupied_cell):
						collision_at_grid_pos = true
						break
				if collision_at_grid_pos:
					break
		print("Collision result: ",collision_at_grid_pos)
		if collision_at_grid_pos:
			grid_position = grid_position
		else:
			grid_position = grid_pos
func get_occupied_cells(offset := -Vector2i.ONE):
	if collision_mask != null:
		if offset == -Vector2i.ONE:
			offset = grid_position
		var cells: Array[Vector2i] = []
		for col in range(size.x):
			for row in range(size.y):
				if !collision_mask.mask[col][row]:
					cells.append(Vector2i(col,row)+offset)
		return cells
	else:
		return []
# Event Handlers
func _grid_size_changed(): 
	set_grid_position(grid_position)
	set_size(size)
# Getters and Setters
func set_snap_to_grid(val: bool):
	snap_to_grid = val
	move_to_position(position)
func get_aspect_ratio():
	var gcd = _gcd(size.x,size.y)
	return Vector2i(size.x/gcd,size.y/gcd)
func set_size(item_size: Vector2i):
	size = item_size
	emit_signal("size_changed")
func set_grid_position(grid_pos: Vector2i):
	grid_position = grid_pos
	if parent_grid != null:
		position = (grid_position-Vector2i.ONE)*parent_grid.cell_size
func get_pixel_size():
	return size*parent_grid.cell_size
# Overridden Methods
func _enter_tree():
	#TODO find grid2d parent, may not be a grid2d if nested.
	var parent = get_parent()
	if parent is Grid2D:
		parent_grid = get_parent()
		set_grid_position(grid_position)
		parent.connect("size_changed", _grid_size_changed)
	else:
		parent_grid = null
		update_configuration_warnings()
	# Monitor position changes in editor. 
	set_notify_transform(true)
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if parent_grid == null:
		warnings.append("No Grid2D parent. Add this as a child to a Grid2D.")
	return warnings
func _notification(what: int):
	if what == NOTIFICATION_TRANSFORM_CHANGED and snap_to_grid:
		move_to_position(position)
func _init(parent_grid_: Grid2D = null):
	parent_grid = parent_grid_
# Helper Functions
func _gcd(a: int, b: int) -> int:
	return a if b == 0.0 else _gcd(b, a % b)
