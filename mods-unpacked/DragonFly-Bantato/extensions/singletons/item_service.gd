extends "res://singletons/item_service.gd"


var _unbanned_tiers_data:Array


func init_unlocked_pool()->void :
	.init_unlocked_pool()
	_unbanned_tiers_data = _tiers_data.duplicate(true)
	
	
#func ban_item(item:Resource)->void :
#	if item is ItemData:
#		_unbanned_tiers_data[item.tier][TierData.ALL_ITEMS].erase(item)
#		_unbanned_tiers_data[item.tier][TierData.ITEMS].erase(item)
#	elif item is WeaponData:
#		_unbanned_tiers_data[item.tier][TierData.ALL_ITEMS].erase(item)
#		_unbanned_tiers_data[item.tier][TierData.WEAPONS].erase(item)


func ban_item(item:ItemData)->void :
	_unbanned_tiers_data[item.tier][TierData.ALL_ITEMS].erase(item)
	_unbanned_tiers_data[item.tier][TierData.ITEMS].erase(item)
		
		
func ban_list(list:Array)->void :
	for item in list:
		item = item[0]
		if item is ItemData:
			_unbanned_tiers_data[item.tier][TierData.ALL_ITEMS].erase(item)
			_unbanned_tiers_data[item.tier][TierData.ITEMS].erase(item)
		elif item is WeaponData:
			_unbanned_tiers_data[item.tier][TierData.ALL_ITEMS].erase(item)
			_unbanned_tiers_data[item.tier][TierData.WEAPONS].erase(item)
		
		
func get_pool(item_tier:int, type:int)->Array:
	#print(_tiers_data[0][0].size())
	#print(_unbanned_tiers_data[0][0].size())
	return _unbanned_tiers_data[item_tier][type].duplicate()
	
	
func sort_weapon_level(a:WeaponData, b:WeaponData)->bool:
	if a.my_id > b.my_id:
		return false
	return true
	
	
func get_all_level_weapons(item:WeaponData)->Array:
	var same_weapons = []
	for weapon in weapons:
		if weapon.weapon_id == item.weapon_id:
			same_weapons.push_back(weapon)
#	same_weapons.sort_custom(self, "sort_weapon_level")
	return same_weapons
	

func ban_weapon(weapon:WeaponData)->void :
	var same_weapons = get_all_level_weapons(weapon)
	ban_weapons(same_weapons)


func ban_weapons(weapon_list:Array)->void :
	for item in weapon_list:
		_unbanned_tiers_data[item.tier][TierData.ALL_ITEMS].erase(item)
		_unbanned_tiers_data[item.tier][TierData.WEAPONS].erase(item)
		
		
func get_unbanned_num(item:ItemParentData)->int :
	var num = 10000
	if item is ItemData:
		num = _unbanned_tiers_data[item.tier][TierData.ITEMS].size()
	elif item is WeaponData:
		var same_weapons = get_all_level_weapons(item)
		for weapon in same_weapons:
			num = min(num, _unbanned_tiers_data[weapon.tier][TierData.WEAPONS].size())
	return num
	
	
func get_total_num(item:ItemParentData)->int :
	var num = 10000
	if item is ItemData:
		num = _tiers_data[item.tier][TierData.ITEMS].size()
	elif item is WeaponData:
		var same_weapons = get_all_level_weapons(item)
		for weapon in same_weapons:
			num = min(num, _tiers_data[weapon.tier][TierData.WEAPONS].size())
	return num

#func get_unbanned_ratio(item:ItemParentData)->float :
#	var ratio = 1.0
#	if item is ItemData:
#		ratio = 1.0 / _unbanned_tiers_data[item.tier][TierData.ITEMS].size()
#	elif item is WeaponData:
#		var same_weapons = get_all_level_weapons(item)
#		for weapon in same_weapons:
#			ratio = min(ratio, 1.0 / _unbanned_tiers_data[weapon.tier][TierData.WEAPONS].size())
#	return ratio

	
#func get_rand_item_from_wave(wave:int, type:int, shop_items:Array = [], prev_shop_items:Array = [], fixed_tier:int = - 1)->ItemParentData:
#	return get_element(items, "item_dangerous_bunny") as ItemParentData
