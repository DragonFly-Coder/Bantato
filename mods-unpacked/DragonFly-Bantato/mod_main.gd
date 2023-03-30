extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const BANTATO_LOG = "DragonFly-Bantato"


func _init(modLoader = ModLoader):
	ModLoaderUtils.log_info("Init", BANTATO_LOG)
	modLoader.install_script_extension("res://mods-unpacked/DragonFly-Bantato/extensions/singletons/run_data.gd")
	modLoader.install_script_extension("res://mods-unpacked/DragonFly-Bantato/extensions/singletons/progress_data.gd")
	modLoader.install_script_extension("res://mods-unpacked/DragonFly-Bantato/extensions/main.gd")
	modLoader.install_script_extension("res://mods-unpacked/DragonFly-Bantato/extensions/singletons/item_service.gd")
	modLoader.install_script_extension("res://mods-unpacked/DragonFly-Bantato/extensions/singletons/menu_data.gd")
	
	modLoader.install_script_extension("res://mods-unpacked/DragonFly-Bantato/extensions/ui/menus/shop/shop_item.gd")
	modLoader.install_script_extension("res://mods-unpacked/DragonFly-Bantato/extensions/ui/menus/shop/shop_items_container.gd")
	#modLoader.install_script_extension("res://mods-unpacked/DragonFly-Bantato/extensions/ui/menus/shop/shop.gd") # can't do that
	modLoader.install_script_extension("res://mods-unpacked/DragonFly-Bantato/extensions/singletons/debug_service.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	# pass # Replace with function body.
	ModLoaderUtils.log_info("Ready", BANTATO_LOG)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
