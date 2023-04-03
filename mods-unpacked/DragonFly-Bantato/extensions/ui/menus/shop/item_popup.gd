extends "res://ui/menus/shop/item_popup.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func display_banned_element(element:InventoryElement)->void :
	_last_wave_info_container.hide()
	_item_displayed = element.item
	_panel.set_data(element.item)
	set_synergies_text(element.item)
	_new_element = element
	
	_discard_button.text = tr("MENU_RECYCLE") + " (+" + str(ItemService.get_recycling_value(RunData.current_wave, element.item.value, element.item is WeaponData)) + ")"
	
	if element.item is WeaponData and element.item.dmg_dealt_last_wave != 0:
		_last_wave_info_container.display(Text.text("DAMAGE_DEALT_LAST_WAVE", [str(element.item.dmg_dealt_last_wave)], [Sign.POSITIVE]))
	
#	if element.item is WeaponData and buttons_active:
#		_combine_button.show()
#		if not RunData.can_combine(element.item):
#			_combine_button.hide()
#		_discard_button.show()
#		_cancel_button.show()
#	else :
	_combine_button.hide()
	_discard_button.hide()
	_cancel_button.hide()
	
	var stylebox_color = _panel.get_stylebox("panel").duplicate()
	ItemService.change_panel_stylebox_from_tier(stylebox_color, element.item.tier)
	_panel.add_stylebox_override("panel", stylebox_color)
	
	show()
