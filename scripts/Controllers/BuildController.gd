extends Control
class_name BuildController

@onready var smallBuilding01 : PackedScene = preload("res://Buildings/SmallBuilding01.tscn")
@onready var smallBuilding02 : PackedScene = preload("res://Buildings/SmallBuilding02.tscn")
@onready var smallBuilding03 : PackedScene = preload("res://Buildings/SmallBuilding03.tscn")
@onready var smallBuilding04 : PackedScene = preload("res://Buildings/SmallBuilding04.tscn")

enum BUILDING {
	SMALL_BUILDING_01,
	SMALL_BUILDING_02,
	SMALL_BUILDING_03,
	SMALL_BUILDING_04
}

var Camera : Camera3D
var buildingInstance : Building
var isPlacing : bool = false
var range = 1000

var canPlace : bool = false

@onready var itemList : ItemList = $ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Camera = get_viewport().get_camera_3d()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and canPlace:
		isPlacing = false;
		canPlace = false;
		buildingInstance.placed()
		itemList.deselect_all()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if isPlacing:
		var mousePosition : Vector2 = get_viewport().get_mouse_position();
		var rayOrigin : Vector3 = Camera.project_ray_origin(mousePosition) 
		var rayEnd : Vector3 = rayOrigin + Camera.project_ray_normal(mousePosition) * range
		var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
		var collision = Camera.get_world_3d().direct_space_state.intersect_ray(query)
		
		if collision: 
			buildingInstance.transform.origin = collision.position;
			canPlace = buildingInstance.check_placement()

func _on_item_list_item_selected(index: int) -> void:
	if (isPlacing):
		buildingInstance.queue_free()
	
	
	if (index == BUILDING.SMALL_BUILDING_01):
		buildingInstance = smallBuilding01.instantiate() as Building;
	if (index == BUILDING.SMALL_BUILDING_02):
		buildingInstance = smallBuilding02.instantiate() as Building;
	if (index == BUILDING.SMALL_BUILDING_03):
		buildingInstance = smallBuilding03.instantiate() as Building;
	if (index == BUILDING.SMALL_BUILDING_04):
		buildingInstance = smallBuilding04.instantiate() as Building;
	isPlacing = true;
	get_parent().add_child(buildingInstance)
