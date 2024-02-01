extends CharacterBody2D


var player: Node2D
var speed: float = 300.0
var current_target = null

@export var dmg:float = 10.0
@export var hp:float = 100.0


var trail_scene : PackedScene = preload("res://enemy_trail/trail.tscn")
@export var marker: PackedScene
var camera: Camera2D
@onready var attack = $Attack

var trails = []

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	camera = get_tree().get_first_node_in_group("main_camera")
	attack.start()
	$SlimeSpawn.start()

func _exit_tree():
	for trail in trails:
		%Trails.remove_child(trail)

enum Attacks { LONG_STOMP, CHASE, SPEW }
enum State { JUMP, LANDING, IDLE, CHASE }
var state = State.IDLE

const attack_opts = [Attacks.LONG_STOMP, Attacks.CHASE]
var current_attack = null

@export var landing_vel = 100
@export var jumping_vel = -400
@export var chase_speed = 250

func _physics_process(delta):
	
	if hp <=0:
		death()
	
	var current_target_pos = null
	if current_target != null:
		current_target_pos = current_target.global_position
	
	match state:
		State.JUMP:
			$Particles.emitting = true
			var camera_top_boundary = (
				camera.global_position.y - get_viewport().size.y / 2
			)
			if global_position.y + 64 < camera_top_boundary:
				state = State.LANDING 
			move_and_slide()
		State.LANDING:
			velocity.y = landing_vel
			global_position.x = current_target_pos.x
			
			if global_position.y + 64 >= current_target_pos.y:
				current_target.queue_free()
				current_target_pos = null
				current_target = null
				attack.start()
				state = State.IDLE
				$Particles.emitting = false
				camera.applay_shake()
			
			move_and_slide()
	
	if current_target_pos and state == State.CHASE:
		global_position = global_position.move_toward(current_target_pos, 
			delta * chase_speed)
	
	if current_target_pos and state == State.IDLE:
		state = State.JUMP
		velocity.y = jumping_vel

func _on_timer_timeout():
	current_attack = attack_opts.pick_random()
	current_attack = attack_opts[1]
	do_attack(current_attack)
	
func do_attack(atk_type):
	match atk_type:
		Attacks.LONG_STOMP:
			$AnimationPlayer.play("jump")
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.play("RESET")
			var inst = marker.instantiate()
			inst.global_position = player.global_position
			current_target = inst
			get_tree().root.add_child(inst)
		Attacks.CHASE:
			$Chase.start()
			state = State.CHASE
			var trail = trail_scene.instantiate() as Line2D
			#trail.width = 10
			#trail.default_color = Color.LAWN_GREEN
			%Trails.add_child(trail)
			trails.append(trail)
			current_target = player

func _on_chase_timeout():
	attack.start()
	current_target = null
	state = State.IDLE

func death() -> void:
	pass

func take_dmg(taken_dmg: float) -> void:
	hp -= taken_dmg
	print("Current hp: ", hp)

func stop_moving() -> void:
	current_target = null
	state = State.IDLE

func _on_hurtbox_area_entered(area):
	print(area.name)
	
	if area.is_in_group("weapons"):
		take_dmg(area.dmg)
	if area.is_in_group("player"):
		print("dmg")
		area.get_parent().take_dmg(dmg, self)

func _on_slime_spawn_timeout():
	if state == State.CHASE:
		trails[-1].add_point(global_position)
	
