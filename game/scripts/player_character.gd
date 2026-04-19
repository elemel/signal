extends RigidBody3D
class_name PlayerCharacter

@export var move_speed := 3.0
@export var move_acceleration := 10.0
@export var jump_speed := 5.0
@export var ping_cooldown := 1.0

@export var mouse_sensitivity := 0.002
@export var echo_material: ShaderMaterial
@export var ray_cast: RayCast3D

@export var ground_spring_stiffness := 100.0
@export var ground_spring_damping := 10.0

@export var camera_turner: Node3D
@export var camera_pivot: Node3D

var main: Main
var pitch := 0.0
var current_ping_cooldown := 0.0
var ping_enabled := false
var sticky_ping_enabled := false


func _ready() -> void:
	main = get_tree().get_first_node_in_group("mains")


func _input(event):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			camera_turner.rotate_y(-event.relative.x * mouse_sensitivity)

			var invert_mouse_scale := -1.0 if main.invert_mouse else 1.0
			pitch -= invert_mouse_scale * event.relative.y * mouse_sensitivity
			pitch = clamp(pitch, deg_to_rad(-90), deg_to_rad(90))

			camera_pivot.rotation.x = pitch

	if event is InputEventMouseButton:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				sticky_ping_enabled = false

			if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
				sticky_ping_enabled = not sticky_ping_enabled
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			sticky_ping_enabled = false


func _physics_process(delta: float) -> void:
	current_ping_cooldown -= delta

	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		ping_enabled = true

	if (ping_enabled and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or sticky_ping_enabled)  and current_ping_cooldown < 0.0:
		current_ping_cooldown = ping_cooldown * randf_range(0.9, 1.1)
		ping()

	var collider := ray_cast.get_collider()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and collider != null:
		apply_central_impulse(Vector3.UP * jump_speed * mass)

	if collider != null and not Input.is_action_pressed("jump"):
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction := (camera_turner.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		var target_ground_distance := 1.25
		var ground_distance := global_position.distance_to(ray_cast.get_collision_point())
		var ground_distance_error := target_ground_distance - ground_distance
		var ground_distance_correction := ground_distance_error * ground_spring_stiffness * delta - linear_velocity.y * ground_spring_damping * delta

		var target_ground_velocity := Vector2(direction.x, direction.z) * move_speed
		var ground_velocity := Vector2(linear_velocity.x, linear_velocity.z)
		var ground_velocity_error := target_ground_velocity - ground_velocity
		var ground_velocity_correction := ground_velocity_error.limit_length(move_acceleration * delta)
		var velocity_correction := Vector3(ground_velocity_correction.x, ground_distance_correction, ground_velocity_correction.y)
		apply_central_impulse(velocity_correction * mass)


func ping() -> void:
	var ping_origin: Vector3 = camera_pivot.global_position
	main.add_ping(ping_origin, linear_velocity)
