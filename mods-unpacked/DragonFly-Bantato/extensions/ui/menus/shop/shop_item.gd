extends "res://ui/menus/shop/shop_item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ban_button_pressed(shop_item)

onready var _ban_button = $HBoxContainer2 / BanButton


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func disable_ban_focus()->void :
	_ban_button.focus_mode = FOCUS_NONE
	
	
func enable_ban_focus()->void :
	if active:
		_ban_button.focus_mode = FOCUS_ALL
		
func deactivate()->void :
	.deactivate()
	_ban_button.disable()
	
	
func activate()->void :
	.activate()
	_ban_button.reinitialize_colors()
	_ban_button.activate()


func set_shop_item(p_item_data:ItemParentData, p_wave_value:int = RunData.current_wave)->void :
	.set_shop_item(p_item_data, p_wave_value)
	value = ItemService.get_value(p_wave_value, p_item_data.value, true, p_item_data is WeaponData)

	if RunData.effects["hp_shop"]:
		value = ceil(value / 20.0) as int
		var icon = ItemService.get_stat_icon("stat_max_hp").get_data()
		icon.resize(64, 64)
		var texture = ImageTexture.new()
		texture.create_from_image(icon)
		_ban_button.set_icon(texture)
	
	_ban_button.set_value(value)
	
	
func update_color()->void :
	.update_color()
	_ban_button.set_color_from_currency()
	
	
func _on_BanButton_focus_entered()->void :
	emit_signal("shop_item_focused", self)
	
	
func _on_BanButton_focus_exited()->void :
	emit_signal("shop_item_unfocused", self)
	
	
func _on_BanButton_pressed()->void :
	emit_signal("ban_button_pressed", self)
	
	
func _on_BanButton_mouse_exited()-> void :
	emit_signal("shop_item_unfocused", self)
	
	
func _on_BanButton_mouse_entered()->void :
	emit_signal("shop_item_focused", self)
