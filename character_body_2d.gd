extends CharacterBody2D

const SPEED = 300.0
var time_passed = 0
var spear_ammo = 0
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var weapon_addon = $weapon_addon
@onready var weapons_holder = $Weapons_holder

var cam :Camera2D
var cam_zoomed:bool = false

func _ready():
	cam = get_tree().get_nodes_in_group("main_camera")[0]


func _physics_process(delta):
	time_passed += delta
	
	if spear_ammo:
		weapons_holder.visible = true
		#make visible spear and addons
		
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("zoom"):
		if cam_zoomed:
			cam.zoom = Vector2(0.5,0.5)
			cam_zoomed = false
		else:
			cam_zoomed = true
			cam.zoom = Vector2.ONE

	var direction_x = Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down")
	
	
	#Animation checks
	if direction_x or direction_y:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	
	if Input.is_action_pressed("spear"):
		animated_sprite_2d.play("attack")
	
	if direction_x < 0:
		animated_sprite_2d.flip_h = true
		weapon_addon.flip_h = true
	if direction_x > 0:
		animated_sprite_2d.flip_h = false
		weapon_addon.flip_h = false
	
	velocity = Vector2(direction_x, direction_y).normalized() * SPEED

	move_and_slide()
