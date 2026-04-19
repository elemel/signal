extends CanvasLayer

@export var horizon_line: Line2D

@export var north_line: Line2D
@export var east_line: Line2D
@export var south_line: Line2D
@export var west_line: Line2D

func _process(_delta):
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return
		
	var screen_size = get_viewport().get_visible_rect().size
	var center = 0.5 * screen_size
	
	# --- Vertical Movement (Pitch) ---
	# Get the camera's X rotation (up/down) from the parent controller
	var pitch = camera.get_parent().rotation_degrees.x
	
	# Map the pitch to screen pixels based on Vertical FOV
	var v_fov = camera.fov 
	var v_offset = (pitch / v_fov) * screen_size.y
	horizon_line.position.y = center.y + v_offset

	# --- Horizontal Movement (Yaw / North) ---
	# Get the camera's Y rotation (left/right). 
	# fmod ensures the value stays within a predictable -180 to 180 range.
	var yaw = fmod(camera.get_parent().get_parent().rotation_degrees.y, 360.0)

	if yaw > 180.0:
		yaw -= 360.0

	if yaw < -180.0:
		yaw += 360.0
	
	# Calculate Horizontal FOV based on screen aspect ratio
	var aspect = screen_size.x / screen_size.y
	var h_fov = v_fov * aspect
	
	# Calculate X offset. We negate yaw so the line moves opposite 
	# to the camera rotation, keeping it fixed at 'North' in world space.
	var x_offset = (yaw / h_fov) * screen_size.x
	north_line.position.x = center.x + x_offset
	
	# Only show the North line if it's within the current horizontal view
	north_line.visible = abs(x_offset) < (0.5 * screen_size.x)
