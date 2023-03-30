extends "res://main.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_EndWaveTimer_timeout()->void :
	DebugService.log_data("_on_EndWaveTimer_timeout")
	_end_wave_timer_timedout = true
	_ui_dim_screen.dim()
	_ui_consumables_to_process.modulate = Color.white
	_ui_upgrades_to_process.modulate = Color.white
	_wave_cleared_label.hide()
	_wave_timer_label.hide()
	
	if _landmine_timer:
		_landmine_timer.stop()
	
	if _is_run_lost or is_last_wave() or _is_run_won:
		DebugService.log_data("end run...")
		RunData.run_won = not _is_run_lost
		
		if RunData.is_testing:
			var _error = get_tree().change_scene(MenuData.editor_scene)
		else :
			var _error = get_tree().change_scene("res://ui/menus/run/end_run.tscn")
	else :
		DebugService.log_data("process consumables and upgrades...")
		MusicManager.tween( - 8)
		if _consumables_to_process.size() > 0:
			for consumable in _consumables_to_process:
				var fixed_tier = - 1
				
				if consumable.my_id == "consumable_legendary_item_box":
					fixed_tier = Tier.LEGENDARY
				
				var item_data = ItemService.process_item_box(RunData.current_wave, consumable, fixed_tier)
				_item_box_ui.set_item_data(item_data)
				yield (_item_box_ui, "item_box_processed")
				_ui_consumables_to_process.remove_element(consumable)
		
		if _upgrades_to_process.size() > 0:
			for upgrade_to_process in _upgrades_to_process:
				_upgrades_ui.show_upgrade_options(upgrade_to_process)
				yield (_upgrades_ui, "upgrade_selected")
				_ui_upgrades_to_process.remove_element(upgrade_to_process)
		
		DebugService.log_data("display challenge ui...")
		if _is_chal_ui_displayed:
			yield (_challenge_completed_ui, "finished")
		
		var _error = get_tree().change_scene("res://mods-unpacked/DragonFly-Bantato/extensions/ui/menus/shop/shop.tscn")
