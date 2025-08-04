@tool
class_name Grid2DCollisionMask
extends Node2D

@export var n_rows: int
@export var n_cols: int
@export var mask: Array[Array] = []

var editor_grid: GridItem
var grid_image: GridImage
var editor_tiles: Array[Array]

func attach(gi: GridImage):
	grid_image = gi
	n_rows = gi.size.y
	n_cols = gi.size.x
	# Initialize multi-dimensional boolean mask and editor tiles matrix. 
	for ncol in range(gi.size.x):
		for nrow in range(gi.size.y):
			var na : Array[bool] = []
			na.resize(n_cols)
			na.fill(false)
			mask.append(na)
			var nt: Array[ColorRect] = []
			editor_tiles.append(nt)
func editor_tile_clicked(event: InputEvent, col: int, row: int):
	if event.is_pressed():
		if mask[col][row]:
			editor_tiles[col][row].color = Color(1,0,0,0.25)
		else:
			editor_tiles[col][row].color = Color(0,1,0,0.25)
		mask[col][row] = !mask[col][row]
		
func make_editor_grid(parent_grid: Grid2D):
	editor_grid = GridItem.new(parent_grid)
	var cell_size = parent_grid.cell_size

	for col in range(n_cols):
		for row in range(n_rows):
			var tile = ColorRect.new()
			if mask[col][row]:
				tile.color = Color(0,1,0,0.25)
			else:
				tile.color = Color(1,0,0,0.25)
			tile.size = cell_size
			tile.position = Vector2i(col,row)*cell_size
			tile.connect("gui_input", func(event): editor_tile_clicked(event, col, row))
			editor_tiles[col].append(tile)
			editor_grid.add_child(tile)
		
			
	parent_grid.add_child(editor_grid)
