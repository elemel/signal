extends Area3D
class_name Goal

@export var level: Level
@export var next_level_name: String

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		var next_level_path := "res://scenes/levels/" + next_level_name + ".tscn"
		var next_level_scene := load(next_level_path) as PackedScene
		var next_level := next_level_scene.instantiate()
		level.get_parent().add_child(next_level)
		level.queue_free()
