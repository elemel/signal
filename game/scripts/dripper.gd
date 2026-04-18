extends Node3D

@export var drip_a: AudioStreamPlayer3D
@export var drip_b: AudioStreamPlayer3D
@export var cooldown := 5.0
@export var chance := 0.5

var current_cooldown := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_cooldown = cooldown * randf()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	current_cooldown -= delta

	if current_cooldown < 0.0:
		current_cooldown = cooldown * randf_range(0.95, 1.05)

		if randf() < chance:
			if randf() < 0.5:
				drip_a.play()
			else:
				drip_b.play()
