extends "res://ui/menus/shop/inventory.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_item_banned(item_data:ItemParentData)->void :
	if item_data is WeaponData:
		var same_weapons = ItemService.get_all_level_weapons(item_data)
		same_weapons.sort_custom(ItemService, "sort_weapon_level")
		for weapon in same_weapons:
			add_element(weapon, false)
	else:
		add_element(item_data, false)
	
	
func set_elements(elements:Array, reverse_order:bool = false, replace:bool = true, prioritize_gameplay_elements:bool = false)->void :
	if elements == null or elements.size() == 0:return 
	
	if category != -1:
		.set_elements(elements, reverse_order, replace, prioritize_gameplay_elements)
		
	else:
		if replace:
			clear_elements()
		
		_elements = elements.duplicate()
		
		if reverse_order:
			_reversed_order = true
	
		for element in elements:
			add_element(element[0], false)

#		if prioritize_gameplay_elements:
#			var element_instances = get_children()
#
#			for element_instance in element_instances:
#				if element_instance.item is CharacterData:
#					move_child(element_instance, 0)
