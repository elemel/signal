extends CanvasLayer
class_name GameMenu

@export var main: Main
@export var compass_layer: CanvasLayer

@export var title_label: Label
@export var move_label: Label
@export var jump_label: Label
@export var throw_flare_label: Label
@export var pause_label: Label

@export var start_button: Button
@export var resume_button: Button
@export var continue_button: Button
@export var compass_button: Button
@export var invert_mouse_button: Button
@export var quit_button: Button
@export var exit_button: Button

var compass_enabled := true
var message: String
var exit_enabled := false
var cancel_enabled := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cancel_enabled = OS.has_feature("pc")
	exit_enabled = OS.has_feature("pc")

	if cancel_enabled:
		pause_label.text = "Pause with P or Escape Key"

	pause()


func _unhandled_input(event: InputEvent) -> void:
	var is_pause_action := event.is_action_pressed("pause")
	var is_cancel_action := cancel_enabled and event.is_action_pressed("ui_cancel")

	if is_pause_action or is_cancel_action:
		if get_tree().paused:
			if main.level == null:
				if is_cancel_action:
					get_tree().quit()
			else:
				resume()
				message = ""
		else:
			pause()


func update(grab_focus := true) -> void:
	if message != "":
		title_label.text = message
		move_label.visible = false
		jump_label.visible = false
		throw_flare_label.visible = false
		pause_label.visible = false

		start_button.visible = false
		resume_button.visible = false
		continue_button.visible = true
		compass_button.visible = false
		invert_mouse_button.visible = false
		quit_button.visible = false
		exit_button.visible = false

		if grab_focus:
			continue_button.grab_focus()
	elif main.level == null:
		title_label.text = "Echo Chamber"
		move_label.visible = true
		jump_label.visible = true
		throw_flare_label.visible = true
		pause_label.visible = true

		start_button.visible = true
		resume_button.visible = false
		continue_button.visible = false
		compass_button.visible = true
		invert_mouse_button.visible = true
		quit_button.visible = false
		exit_button.visible = exit_enabled

		if grab_focus:
			start_button.grab_focus()
	else:
		title_label.text = "Paused"
		move_label.visible = true
		jump_label.visible = true
		throw_flare_label.visible = true
		pause_label.visible = true

		start_button.visible = false
		resume_button.visible = true
		continue_button.visible = false
		compass_button.visible = true
		invert_mouse_button.visible = true
		quit_button.visible = true
		exit_button.visible = false

		if grab_focus:
			resume_button.grab_focus()

	if compass_enabled:
		compass_button.text = "Compass: On"
	else:
		compass_button.text = "Compass: Off"

	if main.invert_mouse:
		invert_mouse_button.text = "Invert Mouse Y: On"
	else:
		invert_mouse_button.text = "Invert Mouse Y: Off"


func toggle_pause() -> void:
	if get_tree().paused:
		resume()
	else:
		pause()


func pause() -> void:
	if not get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		visible = true
		compass_layer.visible = false
		update()


func resume() -> void:
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		visible = false
		compass_layer.visible = compass_enabled


func _on_start_pressed() -> void:
	main.start_level("level_1")
	resume()


func _on_resume_pressed() -> void:
	resume()


func _on_continue_pressed() -> void:
	message = ""

	if main.level == null:
		update()
	else:
		resume()


func _on_compass_pressed() -> void:
	compass_enabled = not compass_enabled
	update(false)


func _on_invert_mouse_pressed() -> void:
	main.invert_mouse = not main.invert_mouse
	update(false)


func _on_quit_pressed() -> void:
	main.quit_level()
	message = ""
	update()


func _on_exit_pressed() -> void:
	get_tree().quit()
