using Godot;
using System;
using System.ComponentModel;

public partial class CameraController : Node3D
{
	[Export] private float _rotationSpeed = 1.0f;

	public override void _UnhandledInput(InputEvent @event)
	{
	}
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
