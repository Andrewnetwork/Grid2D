@tool
extends EditorInspectorPlugin

var CollisionMaskEditor = preload("res://addons/grid_2D/collision_mask_editor.gd")


func _can_handle(object):
	# We support all objects in this example.
	return object is GridImage


func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	# We handle properties of type integer.
	if name == "collision_mask":
		# Create an instance of the custom property editor and register
		# it to a specific property path.
		add_property_editor(name, CollisionMaskEditor.new())
		# Inform the editor to remove the default property editor for
		# this property type.
		return true
	else:
		return false
