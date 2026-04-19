extends CharacterBody3D
class_name PlayerCharacter

@export var move_speed := 5.0
@export var move_acceleration := 20.0
@export var jump_speed := 7.0
@export var ping_cooldown := 0.5

@export var mouse_sensitivity := 0.002
@export var echo_material: ShaderMaterial

var main: Main
var pitch := 0.0
var current_ping_cooldown := 0.0
var ping_enabled := false


func _ready() -> void:
	main = get_tree().get_first_node_in_group("mains")


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		var invert_mouse_scale := -1.0 if main.invert_mouse else 1.0
		pitch -= invert_mouse_scale * event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-90), deg_to_rad(90))

		$CameraPivot.rotation.x = pitch


func _physics_process(delta: float) -> void:
	current_ping_cooldown -= delta

	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		ping_enabled = true

	if ping_enabled and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and current_ping_cooldown < 0.0:
		current_ping_cooldown = ping_cooldown * randf_range(0.9, 1.1)
		ping()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	if is_on_floor():
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		var target_ground_velocity := Vector2(direction.x, direction.z) * move_speed
		var ground_velocity := Vector2(velocity.x, velocity.z)
		ground_velocity = ground_velocity.move_toward(target_ground_velocity, move_acceleration * delta)

		velocity.x = ground_velocity.x
		velocity.z = ground_velocity.y

	move_and_slide()


func ping() -> void:
	var ping_position: Vector3 = $CameraPivot.global_position
	main.add_ping(ping_position)
