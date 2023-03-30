extends "res://singletons/item_service.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _unbanned_tiers_data:Array


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func init_unlocked_pool()->void :
	.init_unlocked_pool()
	_unbanned_tiers_data = _tiers_data.duplicate(true)
	
	
func ban_item(item:Resource)->void :
	if item is ItemData:
		_unbanned_tiers_data[item.tier][TierData.ALL_ITEMS].erase(item)
		_unbanned_tiers_data[item.tier][TierData.ITEMS].erase(item)
	elif item is WeaponData:
		_unbanned_tiers_data[item.tier][TierData.ALL_ITEMS].erase(item)
		_unbanned_tiers_data[item.tier][TierData.WEAPONS].erase(item)
		
		
func ban_items(items:Array)->void :
	#print(typeof(items[0][0]) == TYPE_STRING)
	#print(items[0][0] is ItemParentData)
	for item in items:
		ban_item(item[0])
		
		
func get_pool(item_tier:int, type:int)->Array:
	#print(_tiers_data[0][0].size())
	#print(_unbanned_tiers_data[0][0].size())
	return _unbanned_tiers_data[item_tier][type].duplicate()


func get_unbanned_shop_items(wave:int, number:int = NB_SHOP_ITEMS, banned_items:Array = [], shop_items:Array = [], locked_items:Array = [])->Array:
	
	var new_items = []
	var nb_weapons_guaranteed = 0
	var nb_weapons_added = 0
	
	var nb_locked_weapons = 0
	var _nb_locked_items = 0
	
	for locked_item in locked_items:
		if locked_item[0] is ItemData:
			_nb_locked_items += 1
		elif locked_item[0] is WeaponData:
			nb_locked_weapons += 1
	
	if RunData.current_wave < MAX_WAVE_TWO_WEAPONS_GUARANTEED:
		nb_weapons_guaranteed = 2
	elif RunData.current_wave < MAX_WAVE_ONE_WEAPON_GUARANTEED:
		nb_weapons_guaranteed = 1
	
	if RunData.effects["minimum_weapons_in_shop"] > nb_weapons_guaranteed:
		nb_weapons_guaranteed = RunData.effects["minimum_weapons_in_shop"]
	
	for i in number:
		
		var type
		
		if RunData.current_wave <= MAX_WAVE_TWO_WEAPONS_GUARANTEED:
			type = TierData.WEAPONS if (nb_weapons_added + nb_locked_weapons < nb_weapons_guaranteed) else TierData.ITEMS
		else :
			type = TierData.WEAPONS if (randf() < CHANCE_WEAPON or nb_weapons_added + nb_locked_weapons < nb_weapons_guaranteed) else TierData.ITEMS
		
		if type == TierData.WEAPONS:
			nb_weapons_added += 1
		
		if RunData.effects["weapon_slot"] <= 0:
			type = TierData.ITEMS
		
		new_items.push_back([get_rand_unbanned_item_from_wave(wave, type, new_items, shop_items, banned_items), wave])
	
	return new_items
	
	
func get_rand_unbanned_item_from_wave(wave:int, type:int, shop_items:Array = [], prev_shop_items:Array = [], banned_items:Array = [], fixed_tier:int = - 1)->ItemParentData:
	var excluded_items = []
	excluded_items.append_array(shop_items)
	excluded_items.append_array(prev_shop_items)
	excluded_items.append_array(banned_items)
	
	var rand_wanted = randf()
	var item_tier = get_tier_from_wave(wave)
	
	if fixed_tier != - 1:
		item_tier = fixed_tier
	
	if type == TierData.WEAPONS:
		item_tier = clamp(item_tier, RunData.effects["min_weapon_tier"], RunData.effects["max_weapon_tier"])
	
	var pool = get_pool(item_tier, type)
	var backup_pool = get_pool(item_tier, type)
	var items_to_remove = []
	

	
	for shop_item in excluded_items:

		pool.erase(shop_item[0])
		backup_pool.erase(shop_item[0])
	
	if type == TierData.WEAPONS:
		
		var bonus_chance_same_weapon_set = max(0, (MAX_WAVE_ONE_WEAPON_GUARANTEED + 1 - RunData.current_wave) * (BONUS_CHANCE_SAME_WEAPON_SET / MAX_WAVE_ONE_WEAPON_GUARANTEED))
		var chance_same_weapon_set = CHANCE_SAME_WEAPON_SET + bonus_chance_same_weapon_set

		
		if RunData.effects["no_melee_weapons"] > 0:
			for item in pool:
				if item.type == WeaponType.MELEE:
					backup_pool.erase(item)
					items_to_remove.push_back(item)
		
		if RunData.effects["no_ranged_weapons"] > 0:
			for item in pool:
				if item.type == WeaponType.RANGED:
					backup_pool.erase(item)
					items_to_remove.push_back(item)
		
		if RunData.weapons.size() > 0:
			if rand_wanted < CHANCE_SAME_WEAPON:

				var player_weapon_ids = []
				var nb_potential_same_weapons = 0
				
				for weapon in RunData.weapons:
					for item in pool:
						if item.weapon_id == weapon.weapon_id:
							nb_potential_same_weapons += 1
					player_weapon_ids.push_back(weapon.weapon_id)
				
				if nb_potential_same_weapons > 0:

					for item in pool:
						if not player_weapon_ids.has(item.weapon_id):

							items_to_remove.push_back(item)
				
			elif rand_wanted < chance_same_weapon_set:

				var player_sets = []
				var nb_potential_same_classes = 0
				
				for weapon in RunData.weapons:
					for set in weapon.sets:
						if not player_sets.has(set.my_id):
							player_sets.push_back(set.my_id)
				
				var weapons_to_potentially_remove = []
				
				for item in pool:
					var item_has_atleast_one_class = false
					for player_set_id in player_sets:
						for weapon_set in item.sets:
							if weapon_set.my_id == player_set_id:
	
								nb_potential_same_classes += 1
								item_has_atleast_one_class = true
								break
					
					if not item_has_atleast_one_class:
						weapons_to_potentially_remove.push_back(item)
				
				if nb_potential_same_classes > 0:

					for item in weapons_to_potentially_remove:
						items_to_remove.push_back(item)
	
	elif type == TierData.ITEMS and randf() < CHANCE_WANTED_ITEM_TAG and RunData.current_character.wanted_tags.size() > 0:

		for item in pool:
			var has_wanted_tag = false
			
			for tag in item.tags:
				if RunData.current_character.wanted_tags.has(tag):
					has_wanted_tag = true
					break
			
			if not has_wanted_tag:
				items_to_remove.push_back(item)
		

	
	var limited_items = {}
	
	for item in RunData.items:
		if item.max_nb == 1:
			backup_pool.erase(item)
			items_to_remove.push_back(item)
		elif item.max_nb != - 1:
			if limited_items.has(item.my_id):
				limited_items[item.my_id][1] += 1
			else :
				limited_items[item.my_id] = [item, 1]
	
	for key in limited_items:
		if limited_items[key][1] >= limited_items[key][0].max_nb:
			backup_pool.erase(limited_items[key][0])
			items_to_remove.push_back(limited_items[key][0])
	
	for item in items_to_remove:
		pool.erase(item)
	

	
	var elt
	
	if pool.size() == 0:
		if backup_pool.size() > 0:

			elt = Utils.get_rand_element(backup_pool)
		else :

			elt = Utils.get_rand_element(_tiers_data[item_tier][type])
	else :
		elt = Utils.get_rand_element(pool)
	
	return elt
