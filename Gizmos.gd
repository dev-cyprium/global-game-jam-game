extends Node2D

func _draw():
	var positions = get_parent().track_positions
	
	draw_line(Vector2(0, 0), Vector2(50, 50), Color("555555"))
	
	for position in positions:
		draw_circle(Vector2(position.x, position.y), 10, Color("414042"))
	
