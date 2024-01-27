extends CharacterBody2D

const SPEED = 300.0
var time_passed = 0
var spear_ammo = 0

func _physics_process(delta):
	time_passed += delta
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

	var direction_x = Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down")
	velocity = Vector2(direction_x, direction_y).normalized() * SPEED

	move_and_slide()
