extends CharacterBody2D

const SPEED = 300.0
var time_passed = 0
var spear_ammo = 0
@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	time_passed += delta
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		

	var direction_x = Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down")
	
	
	if direction_x or direction_y:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	
	if Input.is_action_just_pressed("spear"):
		animated_sprite_2d.play("attack")
	
	if direction_x < 0:
		animated_sprite_2d.flip_h = true
	if direction_x > 0:
		animated_sprite_2d.flip_h = false
	
	velocity = Vector2(direction_x, direction_y).normalized() * SPEED

	move_and_slide()
