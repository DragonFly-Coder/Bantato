extends "res://singletons/progress_data.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func serialize_run_state()->Dictionary:
	
	if not current_run_state.has_run_state:
		return current_run_state
	
	var serialized_run_state = .serialize_run_state()
	
	serialized_run_state.banned_shop_items = []
	
	for banned_item in current_run_state.banned_shop_items:
		serialized_run_state.banned_shop_items.push_back([banned_item[0].my_id, banned_item[1]])
	
	return serialized_run_state
	
	
func deserialize_run_state(state:Dictionary)->Dictionary:
	
	if not state.has_run_state:
		return state
	
	var deserialized_run_state = .deserialize_run_state(state)
	
	deserialized_run_state.banned_shop_items = []
	
	for banned_item in state.banned_shop_items:
		#print(banned_item)
		#print(typeof(banned_item[0]) == TYPE_STRING)
		var item_data = ItemService.get_element(ItemService.items, banned_item[0])
		var weapon_data = ItemService.get_element(ItemService.weapons, banned_item[0])
		
		if item_data != null:
			deserialized_run_state.banned_shop_items.push_back([item_data, banned_item[1]])
		
		if weapon_data != null:
			deserialized_run_state.banned_shop_items.push_back([weapon_data, banned_item[1]])
	
	return deserialized_run_state
