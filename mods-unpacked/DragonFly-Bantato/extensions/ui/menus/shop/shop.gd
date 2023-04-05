extends "res://ui/menus/shop/shop.gd"


signal item_banned(item_data)

onready var _banned_container = $"%BannedContainer"
onready var _switch_button = $"%SwitchButton"

# Called when the node enters the scene tree for the first time.
func _ready()->void :
	_banned_container.set_data("BANNED", -1, RunData.banned_shop_items, false, true)
	_shop_items_container.set_ban_costs(_last_reroll_price)
	
	var _error_shop_item_banned = _shop_items_container.connect("shop_item_banned", self, "on_shop_item_banned")
	var _error_items_item_bought = connect("item_banned", _banned_container._elements, "on_item_banned")
	
	_focus_manager.init_banned_container(_banned_container)
			
			
func on_shop_item_banned(shop_item:ShopItem)->void :
	for item in _shop_items:
		if item[0].my_id == shop_item.item_data.my_id:
			_shop_items.erase(item)
			break
			
	#RunData.remove_currency(shop_item.value)
#	RunData.remove_gold(_last_reroll_price)
	RunData.remove_gold(shop_item.ban_cost)
	
	emit_signal("item_banned", shop_item.item_data)
	
	if shop_item.item_data is WeaponData:
		for item in _shop_items:
			if item[0] is WeaponData and item[0].weapon_id == shop_item.item_data.weapon_id:
				_shop_items.erase(item)
				
		var same_weapons = ItemService.get_all_level_weapons(shop_item.item_data)
		same_weapons.sort_custom(ItemService, "sort_weapon_level")
		for weapon in same_weapons:
			RunData.banned_shop_items.push_back([weapon, RunData.current_wave])
		ItemService.ban_weapons(same_weapons)
	else:
		RunData.banned_shop_items.push_back([shop_item.item_data, RunData.current_wave])
		ItemService.ban_item(shop_item.item_data)
	
	#print(RunData.banned_shop_items)
	#var n = RunData.banned_shop_items.size()
	#print(RunData.banned_shop_items[0][0] is ItemParentData)
	#print(RunData.banned_shop_items[n-1][0] is ItemParentData)
	
#	ItemService.ban_item(shop_item.item_data)
	
	_stats_container.update_stats()
	_shop_items_container.reload_shop_items_descriptions()
	_shop_items_container.set_ban_costs(_last_reroll_price)

	var has_new_rerolls = false
	
	if _shop_items.size() == 0:
		
		if _reroll_price == 0:
			_free_rerolls += 1
		
		_free_rerolls += 1
		has_new_rerolls = true
	
	if has_new_rerolls:
		set_reroll_button_price()
	else :
		_reroll_button.set_color_from_currency(RunData.gold)


func set_reroll_button_price()-> void:
	.set_reroll_button_price()
	_shop_items_container.set_ban_costs(_last_reroll_price)
	
	
func _on_SwitchButton_pressed():
	if _items_container.visible:
		_items_container.hide()
		_banned_container.show()
		_switch_button.set_text(tr("SWITCH_TO_ITEMS"))
	else:
		_banned_container.hide()
		_items_container.show()
		_switch_button.set_text(tr("SWITCH_TO_BANNED"))
