extends Control

@export var player: CharacterBody2D
@onready var texture_progress_bar = $"MC bot/TextureProgressBar"
@onready var funny_bar = $"MC bot/FunnyBar"

func _ready():
	if player != null:
		player.on_player_hp_changed.connect(on_player_hp_change)
		texture_progress_bar.value = player.hp



func on_player_hp_change(amount:float) -> void:
	texture_progress_bar.value = amount
