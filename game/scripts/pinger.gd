extends Node3D

@export var cooldown := 2.0
@export var ping_range := 5.0
@export var color := Color.WHITE

var main: Main
var current_cooldown := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().get_first_node_in_group("mains")
	current_cooldown = cooldown * randf()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	current_cooldown -= delta

	if current_cooldown < 0.0:
		current_cooldown = cooldown * randf_range(0.9, 1.1)
		ping()


func ping() -> void:
	main.add_ping(global_position, ping_range, color)
