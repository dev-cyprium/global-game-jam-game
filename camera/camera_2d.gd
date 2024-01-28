extends Camera2D

@export var random_stren: float = 30.0
@export var shake_fade: float = 5.0
var rng = RandomNumberGenerator.new()

var shake_stren: float = 0.9


func applay_shake() ->void:
	shake_stren = random_stren

func _physics_process(delta):
	
	if shake_stren >0:
		shake_stren = lerpf(shake_stren,0,shake_fade*delta)
	
	offset = random_offset()

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_stren,shake_stren),rng.randf_range(-shake_stren,shake_stren))
