extends CharacterBody2D


var player: Node2D
var speed: float = 300.0
var current_target = null

@export var marker: PackedScene
var camera: Camera2D

@onready var attack = $Attack

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	camera = get_tree().get_first_node_in_group("main_camera")
	attack.start()


enum Attacks { LONG_STOMP, SPEW }
enum State { JUMP, LANDING, IDLE }
var state = State.IDLE

const attack_opts = [Attacks.LONG_STOMP, Attacks.SPEW]

@export var landing_vel = 100
@export var jumping_vel = -400

func _physics_process(_delta):
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
			
			move_and_slide()
	
	if current_target_pos and state == State.IDLE:
		state = State.JUMP
		velocity.y = jumping_vel

func _on_timer_timeout():
	var picked_attack = Attacks.LONG_STOMP
	do_attack(picked_attack)
	
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
