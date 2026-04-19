extends CanvasLayer
class_name PauseMenu

@export var main: Main
@export var compass_layer: CanvasLayer

@export var compass_button: Button
@export var invert_mouse_button: Button

var compass_enabled := true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause()


func _physics_process(_delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and not get_tree().paused:
		pause()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause() -> void:
	if get_tree().paused:
		unpause()
	else:
		pause()


func pause() -> void:
	if not get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		visible = true
		compass_layer.visible = false


func unpause() -> void:
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		visible = false
		compass_layer.visible = compass_enabled


func _on_compass_pressed() -> void:
	compass_enabled = not compass_enabled

	if compass_enabled:
		compass_button.text = "Compass: On"
	else:
		compass_button.text = "Compass: Off"


func _on_invert_mouse_pressed() -> void:
	main.invert_mouse = not main.invert_mouse

	if main.invert_mouse:
		invert_mouse_button.text = "Invert Mouse: On"
	else:
		invert_mouse_button.text = "Invert Mouse: Off"
