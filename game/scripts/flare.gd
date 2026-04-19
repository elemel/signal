extends RigidBody3D
class_name Flare

@export var timeout := 10.0
@export var mesh_instance: MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout = randf_range(5.0, 15.0)
	mesh_instance.material_override = mesh_instance.mesh.surface_get_material(0).duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timeout -= delta

	if timeout < 1.0:
		var material := mesh_instance.material_override as StandardMaterial3D
		material.emission_energy_multiplier *= max(0.0, timeout)
		collision_mask = 0

	if timeout < 0.0:
		queue_free()
