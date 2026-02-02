extends Node3D


@onready var CameraRotation : Node3D = $CameraRotationX
@onready var CameraPivot : Node3D = $CameraRotationX/CameraPivot
@onready var Camera : Camera3D = $CameraRotationX/CameraPivot/Camera3D

@export var MoveSpeed : float = 0.6;
var MoveTarget : Vector3;

@export var RotateSpeed : float = 3.0;
var RotateTarget : float;

@export var ZoomSpeed : float = 2.0;
var ZoomTarget : float;
var MIN_ZOOM : float = -20;
var MAX_ZOOM : float = 20;

@export var MouseSensitivity : float = 0.2;
@export var ScrollSpeed : float = 0.2;
var EdgeSize : float = 5.0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MoveTarget = position;
	RotateTarget  = rotation.y
	ZoomTarget = Camera.position.z
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.is_action_pressed("rotate"):
		RotateTarget -= event.relative.x * MouseSensitivity
		CameraRotation.rotation_degrees.x -= event.relative.y * MouseSensitivity
		CameraRotation.rotation_degrees.x = clamp(CameraRotation.rotation_degrees.x, -30, 30)
	
func _physics_process(delta: float) -> void:
	Global.debug_menu.add_property("Camera Position", position, 0)
	Global.debug_menu.add_property("Camera Rotation", CameraRotation.rotation_degrees, 0)
	Global.debug_menu.add_property("Zoom", Camera.position.z, 1)
	
	if Input.is_action_just_pressed("rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	if Input.is_action_just_released("rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

	# Edge Scroll
	var mousePosition : Vector2 = get_viewport().get_mouse_position()
	var viewportSize : Vector2 = get_viewport().get_visible_rect().size
	
	var scrollDirection := Vector3.ZERO
	if mousePosition.x < EdgeSize:
		scrollDirection.x = -1;
	elif mousePosition.x > viewportSize.x - EdgeSize:
		scrollDirection.x = 1;
		
	if mousePosition.y < EdgeSize:
		scrollDirection.z = -1;
	elif mousePosition.y > viewportSize.y - EdgeSize:
		scrollDirection.z = 1;
		
	MoveTarget += transform.basis * scrollDirection * ScrollSpeed; 
	
	# Keyboard movement
	var inputDirection : Vector2 = Input.get_vector("left", "right", "up", "down")
	var movementDirection : Vector3 = (transform.basis * Vector3(inputDirection.x, 0.0, inputDirection.y)).normalized();
	var rotateDirection : float = Input.get_axis("rotate_left", "rotate_right");
	var ZoomDirection = (int (Input.is_action_just_released("camera_zoom_out")) 
						- int(Input.is_action_just_released("camera_zoom_in")))

	MoveTarget += movementDirection * MoveSpeed
	RotateTarget += rotateDirection * RotateSpeed
	ZoomTarget += ZoomDirection * ZoomSpeed
	ZoomTarget = clamp(ZoomTarget, MIN_ZOOM, MAX_ZOOM)
	
	position = lerp(position, MoveTarget, 0.1)
	rotation_degrees.y = lerp(rotation_degrees.y, RotateTarget, 0.1)
	Camera.position.z = lerp(Camera.position.z, ZoomTarget, 0.1)
