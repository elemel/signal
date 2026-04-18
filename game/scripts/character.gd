extends CharacterBody3D


@export var move_speed := 5.0
@export var move_acceleration := 20.0
@export var jump_speed := 7.0

@export var mouse_sensitivity := 0.002

var pitch := 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-90), deg_to_rad(90))

		$CameraPivot.rotation.x = pitch

func _physics_process(delta: float) -> void:
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
