extends "res://ui/menus/global/focus_manager.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _banned_container:InventoryContainer


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init_banned_container(banned_container:InventoryContainer = null)->void :
	_banned_container = banned_container
	
	if banned_container:
		var inventory = _banned_container._elements
		var _error_focus_lost = inventory.connect("focus_lost", self, "on_focus_lost")
		var _error_hover = inventory.connect("element_hovered", self, "on_banned_element_hovered")
		var _error_unhover = inventory.connect("element_unhovered", self, "on_element_unhovered")
		var _error_focus = inventory.connect("element_focused", self, "on_banned_element_focused")
		var _error_unfocus = inventory.connect("element_unfocused", self, "on_element_unfocused")
		var _error_pressed = inventory.connect("element_pressed", self, "on_banned_element_pressed")
	

func on_banned_element_hovered(element:InventoryElement)->void :
	if _element_pressed != null:
		return 
	element.grab_focus()
	_element_hovered = element
	_element_focused = element
	if _item_popup:
		_item_popup.display_banned_element(element)
		

func on_banned_element_focused(element:InventoryElement)->void :
	emit_signal("element_focused", element)
	if _element_pressed != null:
		return 
	
	_element_focused = element
	if _item_popup:
		_item_popup.display_banned_element(element)
		
		
func on_banned_element_pressed(element:InventoryElement)->void :
	emit_signal("element_pressed", element)
	if element.item is WeaponData and _item_popup and _item_popup.buttons_active:
		_element_hovered = element
		_element_focused = element
		_element_pressed = element
		_item_popup.display_banned_element(element)
		_item_popup.focus()
