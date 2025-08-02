@tool
extends Node2D

func _ready():
	var grid = Grid2D.new()
	grid.grid_overlay = true
	add_child(grid)
	var ni = GridImage.new(grid)
	ni.set_img(load("res://giraffe.jpg"))
	ni.size = ni.get_aspect_ratio()*4
	grid.add_child(ni)
	
	#ni.make_color_rect(Color(0, 1, 0, 0.5), 50,50)
	#$Grid2D.add_child(ni)
