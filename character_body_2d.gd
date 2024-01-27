extends CharacterBody2D

const SPEED = 300.0
var time_passed = 0
var spear_ammo = 0

@export var hp:float = 100.0

@onready var weapon_manager = $WeaponManager
@onready var main_sprites = $MainSprites

@onready var weapon_addon = $weapon_addon
@onready var weapons_holder = $Weapons_holder
@onready var animation_player = $AnimationPlayer

var cam :Camera2D
var cam_zoomed:bool = false
var dancing:bool = false

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
	
	if Input.is_action_just_pressed("spear"):
		attack()
		
	
	
	#Animation checks
	
	if direction_x or direction_y:
		animation_player.play("walk")
		
	else:
		animation_player.play("idle")
	
	if Input.is_action_just_pressed("spear"):
		if !dancing:
			dancing = true
		else:
			dancing = false
		
	
	if direction_x < 0:
		main_sprites.flip_h = true
		weapon_addon.flip_h = true
	if direction_x > 0:
		main_sprites.flip_h = false
		weapon_addon.flip_h = false
	
	velocity = Vector2(direction_x, direction_y).normalized() * SPEED

	move_and_slide()

func attack():
	weapon_manager.fire_weapon()


func death():
	animation_player.play("death")
	weapon_addon.visible = false
	set_physics_process(false)
	print("dead")

func take_dmg(dmg):
	hp -= dmg


func _on_animation_player_animation_finished(anim_name):
	pass
		#call change scene
