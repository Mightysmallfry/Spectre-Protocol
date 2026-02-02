extends Node3D
class_name Building

@export var Meshes : Array[MeshInstance3D]
@export var Raycasts : Array[RayCast3D]

@onready var Area : Area3D = $Mesh/Area3D
@onready var greenMat = preload("res://assets/Materials/Placement/PlacementGreenMat.tres")
@onready var redMat = preload("res://assets/Materials/Placement/PlacementRedMat.tres")


func check_placement() -> bool: 
	for ray in Raycasts:
		if !ray.is_colliding():
			placement_red()
			return false
	if Area.get_overlapping_areas():
		placement_red()
		return false
	
		
	placement_green()
	return true

func placed() -> void:
	for mesh in Meshes:
		mesh.material_override = null;


func placement_green() -> void:
	for mesh in Meshes:
		mesh.material_override = greenMat
	
func placement_red() -> void:
	for mesh in Meshes:
		mesh.material_override = redMat
