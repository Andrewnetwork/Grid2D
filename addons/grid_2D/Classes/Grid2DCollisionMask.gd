@tool
class_name Grid2DCollisionMask
extends Node2D

@export var n_rows: int
@export var n_cols: int
@export var mask: Array[Array] = []

var editor_grid: GridItem
var grid_image: GridImage

func attach(gi: GridImage):
	grid_image = gi
	n_rows = gi.size.y
	n_cols = gi.size.x
	for ncol in range(gi.size.x):
		for nrow in range(gi.size.y):
			var na : Array[bool] = []
			mask.append(na)

func make_editor_grid(parent_grid: Grid2D):
	editor_grid = GridItem.new()
	parent_grid.add_child(editor_grid)
	
	var cell_size = parent_grid.cell_size
	
	for col in range(n_cols):
		for row in range(n_rows):
			var tile = GridImage.new()
			editor_grid.add_child(tile)
			tile.make_color_rect(Color(1,0,0,0.5),50,50)
			tile.position = cell_size*Vector2(col, row)
