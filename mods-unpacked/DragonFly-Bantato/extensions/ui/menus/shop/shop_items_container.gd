extends "res://ui/menus/shop/shop_items_container.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var ban_base_cost: = 1
var min_unbanned_num: = 5
signal shop_item_banned(shop_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func connect_shop_items()->void :
	.connect_shop_items()
	for shop_item in _shop_items:
		var _error_ban = shop_item.connect("ban_button_pressed", self, "on_shop_item_ban_button_pressed")
		


func on_shop_item_ban_button_pressed(shop_item:ShopItem)->void :
	
#	if RunData.get_currency() < shop_item.value or _is_delay_active:
#		return
	
#	if RunData.gold < ban_cost:
	if RunData.gold < shop_item.ban_cost or ItemService.get_unbanned_num(shop_item.item_data) < min_unbanned_num:
		return
		
	
	emit_signal("shop_item_banned", shop_item)
	
	if shop_item.item_data is ItemData:
		shop_item.deactivate()
	elif shop_item.item_data is WeaponData:
		for item in _shop_items:
			if item.item_data is WeaponData and item.item_data.weapon_id == shop_item.item_data.weapon_id:
				item.deactivate()
	
	update_buttons_color()
	
	_is_delay_active = true
	_buy_delay_timer.start()
	
	
func disable_shop_ban_buttons_focus()->void :
	for shop_item in _shop_items:
		shop_item.disable_ban_focus()
		
		
func enable_shop_ban_buttons_focus()->void :
	for shop_item in _shop_items:
		shop_item.enable_ban_focus()
		

func set_ban_costs(base:int)->void :
#	ban_base_cost = base
	for i in _shop_items.size():
		_shop_items[i].set_ban_cost(base)


#func set_shop_items(items_data:Array)->void :
#	.set_shop_items(items_data)
#	if ban_cost > 0:
#		set_ban_costs(ban_cost)
