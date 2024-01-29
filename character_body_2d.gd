extends CharacterBody2D

class_name Player

signal on_player_hp_changed(amount:float)
signal on_player_death()

const SPEED = 300.0
var time_passed = 0
var spear_ammo = 0
var hp:float
var knockback = null

@export var max_hp:float = 100.0

@onready var weapon_manager = $WeaponManager
@onready var main_sprites = $MainSprites

@onready var weapon_addon = $weapon_addon
@onready var weapons_holder = $Weapons_holder
@onready var animation_player = $AnimationPlayer
@onready var animation_player_2 = $AnimationPlayer2

var cam :Camera2D
var cam_zoomed:bool = false
var dancing:bool = false
var is_blinking:bool = false

func _ready():
	cam = get_tree().get_nodes_in_group("main_camera")[0]
	hp = max_hp
	on_player_hp_changed.emit(hp)

func _physics_process(delta):
	if is_blinking:
		animation_player_2.play("dmg")
		is_blinking = false

	time_passed += delta
	
	if spear_ammo > 0:
		weapons_holder.visible = true
	else:
		weapons_holder.visible = false
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
	
	if knockback:
		velocity = knockback * 3000
		knockback = null

	move_and_slide()

func attack() ->void:
	weapon_manager.fire_weapon()


func death() -> void:
	animation_player.play("death")
	weapon_addon.visible = false
	set_physics_process(false)
	print("dead")

func take_dmg(dmg: float, source: CharacterBody2D) -> void:
	hp -= dmg
	is_blinking = true
	on_player_hp_changed.emit(hp)
	
	var dir = (global_position - source.global_position).normalized()
	knockback = dir
	source.stop_moving()
	
	print("Current hp: ", hp)

func heal(amount: float) ->void:
	hp += amount
	hp = clamp(hp,0,max_hp)
	on_player_hp_changed.emit(hp)
	print("Current hp: ",hp)


func _on_area_2d_area_entered(area):
	if area.is_in_group("consumable"):
		heal(10)
		print(area.name)
		area.queue_free()

