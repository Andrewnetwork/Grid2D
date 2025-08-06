@tool
class_name Grid2D
extends Node2D

@export var cell_size := Vector2i(25, 25): set = change_cell_size
@export var grid_size := Vector2i(20, 15): set = change_grid_size
@export var grid_overlay := false: set = change_grid_overlay
@export var grid_color := Color.BLACK : set = change_grid_color
@export var background_color := Color.WHITE : set = change_bg_color

var grid_items : Array[GridItem]
var grid_boundaries : Array[StaticBody2D]
var grid_lines: GridLines
var occupied_matrix: Array[Array]

func _init():
	grid_lines = GridLines.new(self)
	initialize_occupied_matrix()
	connect("child_entered_tree", child_entered_tree)

func is_cell_occupied(pos: Vector2i):
	return occupied_matrix[pos.x][pos.y]
	
func initialize_occupied_matrix():
	# Initialize
	for ncol in range(grid_size.x):
		var na = []
		na.resize(grid_size.y)
		na.fill(null)
		occupied_matrix.append(na)
	
func create_static_body_boundaries():
	# If grid boundaries exist, remove them. 
	if !grid_boundaries.is_empty():
		for boundary in grid_boundaries:
			remove_child(boundary)
		grid_boundaries.clear()
	
	#[pos, normal]
	var boundary_positions = [[Vector2(0,grid_size.y*cell_size.y), Vector2.UP], 
		[Vector2(0,0), Vector2.DOWN], [Vector2(0,0), Vector2.RIGHT], 
		[Vector2(grid_size.x*cell_size.x,0), Vector2.LEFT]]
	
	for boundary_position in boundary_positions:
		var static_body = StaticBody2D.new()
		var world_boundary = CollisionShape2D.new()
		var world_boundary_shape = WorldBoundaryShape2D.new()
		static_body.position = boundary_position[0]
		world_boundary_shape.normal = boundary_position[1]
		world_boundary.shape = world_boundary_shape
		static_body.add_child(world_boundary)
		grid_boundaries.append(static_body)
		add_child(static_body)

func enable_static_body_boundary():
	create_static_body_boundaries()

func add_item(grid_item: Node2D, center_cell: Vector2 ):
	grid_item.position = Vector2(center_cell.y*cell_size.y-cell_size.y/2.0, center_cell.x*cell_size.x+cell_size.x/2.0)
	add_child(grid_item)
func move_item(grid_item: Node2D, new_center_cell: Vector2):
	grid_item.position = Vector2(new_center_cell.y*cell_size.y-cell_size.y/2.0, new_center_cell.x*cell_size.x+cell_size.x/2.0)

func child_entered_tree(node: Node):
	if node is GridItem:
		grid_items.append(node)
		
func update_property():
	for child in grid_items:
		child.parent_grid_updated()
	if !grid_boundaries.is_empty(): 
		enable_static_body_boundary()
	grid_lines.queue_redraw()
	queue_redraw()
	
func change_cell_size(new_cell_size: Vector2):
	cell_size = new_cell_size
	update_property()
func change_grid_size(new_grid_size: Vector2):
	grid_size = new_grid_size
	update_property()
func change_bg_color(bg_color):
	background_color = bg_color
	update_property()
func change_grid_color(grid_new_color):
	grid_color = grid_new_color
	update_property()
func change_grid_overlay(overlay_bool):
	grid_overlay = overlay_bool
	update_property()
func get_pixel_size():
	return grid_size*cell_size
func _draw():
	# Background
	draw_rect(Rect2(Vector2(0.0, 0.0), 
		Vector2(cell_size.x * grid_size.x, cell_size.y * grid_size.y) ),
			background_color)
