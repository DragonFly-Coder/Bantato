extends "res://ui/menus/shop/shop.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal item_banned(item_data)

onready var _banned_container = $"%BannedContainer"
onready var _switch_button = $"%SwitchButton"

# Called when the node enters the scene tree for the first time.
func _ready()->void :
	_banned_container.set_data("BANNED", -1, RunData.banned_shop_items, true, true)
	_shop_items_container.set_ban_costs(_last_reroll_price)
	
	var _error_shop_item_banned = _shop_items_container.connect("shop_item_banned", self, "on_shop_item_banned")
	var _error_items_item_bought = connect("item_banned", _banned_container._elements, "on_item_banned")
	
	_focus_manager.init_banned_container(_banned_container)


func fill_shop_unbanned_items_when_locked(locked_items:Array, banned_items:Array)->void :
	unlock_all_shop_items_visually()
	
	var prev_items = _shop_items
	
	_shop_items = []
	
	for i in locked_items.size():
		_shop_items.push_back(locked_items[i])
	
	if prev_items.size() == 0:
		prev_items.append_array(locked_items)
	
	var other_items = ItemService.NB_SHOP_ITEMS - locked_items.size()
	
	if other_items > 0:
		var items_to_add = ItemService.get_unbanned_shop_items(RunData.current_wave, other_items, banned_items, prev_items, locked_items)
		
		for item in items_to_add:
			_shop_items.push_back(item)
			
			
func on_shop_item_banned(shop_item:ShopItem)->void :
	for item in _shop_items:
		if item[0].my_id == shop_item.item_data.my_id:
			_shop_items.erase(item)
			break
			
	#RunData.remove_currency(shop_item.value)
	RunData.remove_gold(_last_reroll_price)
	
#	var nb_coupons = RunData.get_nb_item("item_coupon")
	
#	if nb_coupons > 0:
#		var coupon_value = get_coupon_value()
#		var coupon_effect = nb_coupons * (coupon_value / 100.0)
#		var base_value = ItemService.get_value(shop_item.wave_value, shop_item.item_data.value, false, shop_item.item_data is WeaponData)
#		RunData.tracked_item_effects["item_coupon"] += (base_value * coupon_effect) as int
	
	emit_signal("item_banned", shop_item.item_data)
	
	RunData.banned_shop_items.push_back([shop_item.item_data, RunData.current_wave])
	
	#print(RunData.banned_shop_items)
	#var n = RunData.banned_shop_items.size()
	#print(RunData.banned_shop_items[0][0] is ItemParentData)
	#print(RunData.banned_shop_items[n-1][0] is ItemParentData)
	
	ItemService.ban_item(shop_item.item_data)
	
	_stats_container.update_stats()
	_shop_items_container.reload_shop_items_descriptions()

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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
