extends RigidBody2D

var itemName = "coin";

onready var anim = get_node("anim");
func _ready():
	anim.set_speed_scale(rand_range(0.6,1.4));
	self.apply_impulse(Vector2(0,0),Vector2(round(rand_range(0.1,0.4)*200),-180));
	yield(anim,"animation_finished");
	aplly_impulse()
	pass # Replace with function body.

func aplly_impulse():
	print("test")
	var valuey = round(rand_range(0.1,0.4)*1000);
	var valuex = round(rand_range(-0.6,0.6)*500);
	self.apply_impulse(Vector2(0,0),Vector2(valuex,valuey));
	yield(anim,"animation_finished");
	aplly_impulse()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
