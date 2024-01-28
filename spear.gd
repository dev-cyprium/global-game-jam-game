extends Area2D

var dmg = 10

	
func _on_body_entered(body):
	if body.is_in_group('player'):
		body.spear_ammo = body.spear_ammo + 1
	queue_free()
