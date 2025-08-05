@tool
class_name ToggleGrid
extends Node2D

@export var cell_size := Vector2i(25, 25)
@export var grid_size := Vector2i(5, 5)
@export var grid_color := Color.BLACK
@export var on_color := Color(0,1,0,0.4)
@export var off_color := Color(1,0,0,0.4)
@export var toggle_grid_state : Array[Array]

func _init():
	create()
	
func _unhandled_input(event: InputEvent):
	var mpos = get_local_mouse_position()
	var pixel_size = grid_size*cell_size 
	var bounds_condition = mpos.x > 0 && mpos.y > 0 && mpos.x < pixel_size.x && mpos.y < pixel_size.y
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and bounds_condition:
		var state_idx = Vector2i(mpos)/cell_size
		toggle_grid_state[state_idx.x][state_idx.y] = !toggle_grid_state[state_idx.x][state_idx.y]
		queue_redraw()
func create():
	toggle_grid_state = []
	#Initialize grid state. 
	for ncol in grid_size.x:
		var column : Array[bool] = []
		column.resize(grid_size.y)
		column.fill(false)
		toggle_grid_state.append(column) 
func _draw():
	# Color Cells
	for ncol in grid_size.x:
		for nrow in grid_size.y:
			var pos = Vector2(ncol,nrow)*Vector2(cell_size)
			var color = off_color
			if toggle_grid_state[ncol][nrow]:
				color = on_color
			draw_rect(Rect2(pos,cell_size),color, true)
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
