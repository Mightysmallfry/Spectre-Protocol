using Godot;
using System;

public partial class DebugMenu : PanelContainer
{

	public static DebugMenu instance;
	public static StringName MenuInputString = new StringName("debug_menu");

	private VBoxContainer DebugPropertiesDisplay;
	private string _FramesPerSecond;



	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		if (instance == null)
		{
			instance = new DebugMenu();
		}
		Visible = false;

		DebugPropertiesDisplay = GetNode<VBoxContainer>("MarginContainer/DebugProperties");
	}

    public override void _Input(InputEvent @event)
    {
		if (@event.IsActionPressed(MenuInputString))
		{
			Visible = !Visible;
		}

        base._Input(@event);
    }


	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (!Visible) { return; }

		_FramesPerSecond = string.Format("{0.F2}", 1.0 / delta);
		AddProperty("FPS", _FramesPerSecond, 0);
	}


	public void AddProperty(string PropertyName, Variant value, int order)
	{
		Label target = (Label)DebugPropertiesDisplay.FindChild(PropertyName);

		if (target == null)
		{
			target = new Label();
			DebugPropertiesDisplay.AddChild(target);
			target.Name = PropertyName;
			target.Text = target.Name + " : " + (string)value;
		} else
		{	
			target.Text = target.Name + " : " + (string)value;
			DebugPropertiesDisplay.MoveChild(target, order);
		}
	}
}
