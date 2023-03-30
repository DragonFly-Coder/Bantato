extends "res://singletons/run_data.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var banned_shop_items = []

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func reset(restart:bool = false)->void :
	.reset(restart)
	banned_shop_items = []
	

func get_state(
		reset:bool = false, 
		shop_items:Array = [], 
		reroll_price:int = 0, 
		last_reroll_price:int = 0, 
		initial_free_rerolls:int = 0, 
		free_rerolls:int = 0
	)->Dictionary:
	var state = .get_state(reset, shop_items, reroll_price, last_reroll_price, initial_free_rerolls, free_rerolls)
	
	if reset:
		return state
	
	state.banned_shop_items = banned_shop_items
	return state
	
	
func resume_from_state(state:Dictionary)->void :
	.resume_from_state(state)
	banned_shop_items = state.banned_shop_items
	ItemService.ban_items(banned_shop_items)
