@tool
extends Control

@export var radius: float = 30.0 : set = set_crosshair_radius

func _draw():
	draw_circle_crosshair()
	
func draw_circle_crosshair() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE, true, -1.0, true)
	
func update_crosshair() -> void:
	queue_redraw()

func set_crosshair_radius(new_radius: float) -> void:
	radius = new_radius
	update_crosshair()
