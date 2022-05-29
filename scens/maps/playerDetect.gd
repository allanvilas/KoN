extends Container


onready var anim = get_node("anim")
onready var label = get_node("Label")
var can_click = false;
onready var root = get_parent().get_parent().get_parent();
onready var cam = root.get_node("Camera2D");
onready var map = load("res://scens/maps/fase01.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if can_click && Input.is_action_just_pressed("click"):
		var instance = map.instance();
		cam._set_current(false);
		root.get_parent().add_child(instance);
		
		root.set_visible(false);
		print("play game");
		root.queue_free();
		pass
	else:
		
		pass
	pass


func _on_playerDetect_mouse_entered():
	can_click = true;
	label.set_modulate(Color(1,1,1,1))
	anim.set_animation("selected")
	print()
	pass # Replace with function body.


func _on_playerDetect_mouse_exited():
	can_click = false;
	label.set_modulate(Color(1,1,1,0.2))
	anim.set_animation("unselected")
	pass # Replace with function body.


func _on_Button_pressed():
	
	print("button pressed")
	pass # Replace with function body.
