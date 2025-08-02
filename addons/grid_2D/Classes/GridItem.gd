@tool
class_name GridItem
extends Node2D

## Size in grid columns and rows.
@export var size: Vector2i : set = set_size 
## The upper left origin cell. 
@export var grid_position = Vector2i(1,1): set = set_grid_position
@export var snap_to_grid = true : set = set_snap_to_grid
var parent_grid: Grid2D

func set_snap_to_grid(val: bool):
	snap_to_grid = val
	move_to_position(position)
	
func _set(property: StringName, value) -> bool:
	if property == "position":
		print("Intercepted position change:", value)
		return false  # Let Godot continue setting it
	return false

func _notification(what: int):
	if what == NOTIFICATION_TRANSFORM_CHANGED and snap_to_grid:
		move_to_position(position)


func _init(parent_grid_: Grid2D = null):
	parent_grid = parent_grid_

func parent_grid_updated():
	## Called from parent grid when a property is changed. 
	set_grid_position(grid_position)
	set_size(size)
	
func get_aspect_ratio():
	print(size)
	var gcd = _gcd(size.x,size.y)
	print(Vector2i(size.x/gcd,size.y/gcd))
	return Vector2i(size.x/gcd,size.y/gcd)
	
func move_to_position(pos: Vector2):
	## Moves grid item to the cell containing pos. Assumes coordinates local to parent_grid. 
	position = floor(pos / parent_grid.cell_size)*parent_grid.cell_size
func row_move(n_rows: int):
	position.y += n_rows * parent_grid.cell_size.y
func column_move(n_cols):
	position.x += n_cols * parent_grid.cell_size.x
func set_size(item_size: Vector2i):
	size = item_size
func set_grid_position(grid_pos: Vector2i):
	grid_position = grid_pos
	if parent_grid != null:
		position = (Vector2(grid_position.x-1,grid_position.y-1)*parent_grid.cell_size)
func _enter_tree():
	#TODO find grid2d parent, may not be a grid2d if nested.
	parent_grid = get_parent()
	set_grid_position(grid_position)
	# Monitor position changes in editor. 
	set_notify_transform(true)

func get_pixel_size():
	return Vector2(size.x, size.y)*parent_grid.cell_size

# Helper functions
func _gcd(a: int, b: int) -> int:
	return a if b == 0.0 else _gcd(b, a % b)
	
