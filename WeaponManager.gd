extends Node2D

@onready var weapon: PackedScene = preload("res://spear.tscn")

var player: Player

func _ready():
	player = get_parent()

func fire_weapon() -> void:
	if player.spear_ammo > 0:
		player.spear_ammo -= 1
		print("Firing weapon!")
