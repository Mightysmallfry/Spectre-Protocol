using Godot;
using System;
using System.ComponentModel;
using System.Numerics;

public partial class CameraController : Node3D
{

	[Export] private Node3D _cameraRotation;
	[Export] private Node3D _cameraPivot;
	[Export] private Node3D _camera;
	[Export] private float _rotationSpeed = 1.0f;


	[Export] private float _moveSpeed = 1.0f;
	private Godot.Vector3 _moveTarget;

	private Node _debugMenu;


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_camera = GetNode<Camera3D>("Camera3D");
		_cameraPivot = GetNode<Node3D>("CameraPivot");
		_cameraRotation = GetNode<Node3D>("CameraRotation");
		_debugMenu = GetNode<Node>("/root/Global");
	

		_moveTarget = Position;
	}


	public override void _UnhandledInput(InputEvent @event)
	{

	}
	

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		// Get Input direction
		Godot.Vector2 inputDirection = Input.GetVector("left", "right", "up", "down");
		Godot.Vector3 movementDirection = (Transform.Basis * new Godot.Vector3(inputDirection.X, 0.0f, inputDirection.Y)).Normalized();

		// Set movement targets
		_moveTarget += movementDirection * _moveSpeed;

		// Lerp to movement targets
		Position = Position.Lerp(_moveTarget, 0.05f);
	}
}
