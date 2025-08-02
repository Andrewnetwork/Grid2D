class_name GridLines
extends Node2D

var parent_grid: Grid2D

func _init(parent_grid_: Grid2D):
	parent_grid = parent_grid_
	
func _draw():
	var cell_size = parent_grid.cell_size
	var grid_size = parent_grid.grid_size
	var grid_color = parent_grid.grid_color
	
	# Vertical lines
	for x in range(grid_size.x + 1):
		var start = Vector2(x * cell_size.x, 0)
		var end = Vector2(x * cell_size.x, grid_size.y * cell_size.y)
		draw_line(start, end, grid_color)
	# Horizontal lines
	for y in range(grid_size.y + 1):
		var start = Vector2(0.0, y * cell_size.y)
		var end = Vector2(grid_size.x * cell_size.x, y * cell_size.y)
		draw_line(start, end, grid_color)
