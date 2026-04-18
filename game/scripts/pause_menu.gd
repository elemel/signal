extends CanvasLayer
class_name PauseMenu

@export var pause_menu: CanvasLayer


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

	if event is InputEventMouseButton:
		if event.pressed and get_tree().paused:
			unpause()


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


func unpause() -> void:
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		visible = false
