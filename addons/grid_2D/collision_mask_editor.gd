@tool
extends EditorProperty

# The main control for editing the property.
var button = Button.new()
var collision_mask_panel: PanelContainer
var collision_mask_editor_grid: Grid2D
var edited_object: GridImage
var is_creating = false

func _ready():
	edited_object = get_edited_object() as GridImage
	if edited_object.collision_mask == null:
		button.text = "Create"
		is_creating = false
	else:
		button.text = "Delete"
		create_mask()
		is_creating = true
func _init():
	# Add the control as a direct child of EditorProperty node.
	add_child(button)
	# Make sure the control is able to retain the focus.
	add_focusable(button)
	# Setup the initial state and connect to the signal to track changes.
	button.pressed.connect(_on_button_press)

func _on_button_press():
	if is_creating:
		get_parent_control().remove_child(collision_mask_panel)
		edited_object.collision_mask.queue_free()
		button.text = "Create"
		is_creating = false
	else:
		button.text = "Delete"
		create_mask()
		is_creating = true
	
func create_mask():
	if edited_object.collision_mask == null:
		edited_object.collision_mask = Grid2DCollisionMask.new()
		edited_object.collision_mask.attach(edited_object)
		
	collision_mask_editor_grid = Grid2D.new()
	collision_mask_editor_grid.cell_size = edited_object.parent_grid.cell_size
	collision_mask_editor_grid.grid_overlay = true
	collision_mask_editor_grid.background_color = Color.DIM_GRAY
	collision_mask_editor_grid.grid_color = Color.BLACK
	collision_mask_editor_grid.add_child(edited_object.duplicate())
	collision_mask_editor_grid.change_grid_size(edited_object.size)
	
	collision_mask_panel = PanelContainer.new()
	collision_mask_panel.add_child(collision_mask_editor_grid)
	collision_mask_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	get_parent_control().add_child(collision_mask_panel)
	collision_mask_panel.connect("resized", collision_mask_panel_resized)
	
	edited_object.collision_mask.make_editor_grid(collision_mask_editor_grid)
 
	#emit_changed(get_edited_property(), current_value)
	
func collision_mask_panel_resized():
	collision_mask_panel.custom_minimum_size = collision_mask_editor_grid.get_pixel_size()
	#collision_mask_panel.size.y = collision_mask_panel.size.x
	#
func _update_property():
	pass
	# Read the current value from the property.
	#var new_value = get_edited_object()[get_edited_property()]
	#if (new_value == current_value):
		#return
#
	## Update the control with the new value.
	#updating = true
	#current_value = new_value
	#updating = false
