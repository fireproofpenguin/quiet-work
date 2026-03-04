class_name GameManager extends Node

func _unhandled_key_input(event) -> void:
	if event.is_action_pressed("debug_quit"):
		get_tree().quit()
	if event.is_action_pressed("debug_reload"):
		get_tree().reload_current_scene()
