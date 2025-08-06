@tool
class_name GridImage
extends GridItem

@export var img: Texture2D: set = set_img

var sprite: Sprite2D
var default_size: Vector2i

func set_img(new_img: Texture2D):
	img = new_img
	if parent_grid != null:
		create_child_sprite()
func _ready():
	create_child_sprite()
func make_color_rect(color: Color, width: int, height: int):
	var nimg = Image.create(width, height, false, Image.FORMAT_RGBA8)
	nimg.fill(color)
	img = ImageTexture.create_from_image(nimg)
	create_child_sprite()
func create_child_sprite():
	if img != null && parent_grid != null:
		if sprite != null:
			remove_child(sprite)
		
		sprite = Sprite2D.new()
		sprite.texture = img
		# Get the size of the image in terms of grid cell size. 
		var img_cell_size = img.get_size()/Vector2(parent_grid.cell_size)
		# Scale the sprite to intended grid size.
		if size == Vector2i.ZERO:
			size = floor(img_cell_size)
			default_size = size

		sprite.scale = Vector2(size.x,size.y)/img_cell_size
		# Offset default centering.
		sprite.centered = false
		add_child(sprite)
func set_size(new_size: Vector2i):
	super(new_size)
	# Overriding the default size. 
	if new_size == Vector2i.ZERO:
		size = default_size
	else:
		size = new_size
	# If the sprite is set, update the scaling.
	if sprite != null:
		var img = sprite.texture
		var img_cell_size = img.get_size()/Vector2(parent_grid.cell_size)
		sprite.scale = Vector2(size)/img_cell_size
