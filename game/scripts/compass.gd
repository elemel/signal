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
	var pitch = camera.get_parent().rotation_degrees.x
	var v_fov = camera.fov 
	var v_offset = (pitch / v_fov) * screen_size.y
	horizon_line.position.y = center.y + v_offset

	# --- Horizontal Movement (Yaw) ---
	var yaw = fmod(camera.get_parent().get_parent().rotation_degrees.y, 360.0)
	
	var aspect = screen_size.x / screen_size.y
	var h_fov = v_fov * aspect

	# Update all compass lines
	# North is 0°, East is -90°, South is -180°, West is -270° (or +90°)
	# We use -90 for East because of how the coordinate system maps to the screen
	update_compass_line(north_line, yaw, 0, h_fov, screen_size, center)
	update_compass_line(east_line, yaw, -90, h_fov, screen_size, center)
	update_compass_line(south_line, yaw, -180, h_fov, screen_size, center)
	update_compass_line(west_line, yaw, -270, h_fov, screen_size, center)


func update_compass_line(line: Line2D, camera_yaw: float, angle_offset: float, h_fov: float, screen_size: Vector2, center: Vector2):
	# Calculate the relative angle for this specific marker
	var relative_yaw = fmod(camera_yaw + angle_offset, 360.0)
	
	# Normalize to -180 to 180 range
	if relative_yaw > 180.0: relative_yaw -= 360.0
	if relative_yaw < -180.0: relative_yaw += 360.0
	
	# Calculate screen position
	var x_offset = (relative_yaw / h_fov) * screen_size.x
	line.position.x = center.x + x_offset
	
	# Only show the line if it's within the screen bounds
	line.visible = abs(x_offset) < (0.5 * screen_size.x)
