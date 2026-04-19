extends Node3D
class_name Main

@export var echo_material: ShaderMaterial

var invert_mouse := false

var _time := 0.0

var _ping_times: PackedFloat32Array;
var _ping_positions: PackedVector3Array
var _ping_ranges: PackedFloat32Array
var _ping_colors: PackedColorArray
var _ping_index := 0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_ping_times.resize(16)
	_ping_positions.resize(16)
	_ping_ranges.resize(16)
	_ping_colors.resize(16)

	_ping_times.fill(-1000.0)
	_ping_colors.fill(Color.BLACK)

	echo_material.set_shader_parameter("debug", 0.0)
	update_material()


func clear_pings() -> void:
	_ping_times.fill(-1000.0)
	_ping_positions.fill(Vector3.ZERO)
	_ping_ranges.fill(0.0)
	_ping_colors.fill(Color.BLACK)


func add_ping(ping_position: Vector3, ping_range := 10.0, color := Color.WHITE) -> void:
	_ping_times[_ping_index] = _time
	_ping_positions[_ping_index] = ping_position
	_ping_ranges[_ping_index] = ping_range
	_ping_colors[_ping_index] = color

	_ping_index += 1
	_ping_index %= 16

	update_material()


func update_material() -> void:
	echo_material.set_shader_parameter("ping_times", _ping_times)
	echo_material.set_shader_parameter("ping_positions", _ping_positions)
	echo_material.set_shader_parameter("ping_ranges", _ping_ranges)
	echo_material.set_shader_parameter("ping_colors", _ping_colors)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_time += _delta
	echo_material.set_shader_parameter("time", _time)
