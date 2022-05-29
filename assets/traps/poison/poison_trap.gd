extends Node2D

#parts
onready var font = get_node("font");
onready var flow = get_node("flow");
onready var formation = get_node("formation");
onready var drop = get_node("drop");
onready var drop_colision = get_node("drop/coli");
onready var splash = get_node("splash");

export var flow_lenght = 1;
export(float, 0,5,0.1) var anim_speed = 1.0;
export var drop_speed = 1;
export var rand_speed = false;
export(float, 0,100,2.5) var damage = 5;

var droped = false;
var can_drop = false;
func _ready():
	drop_speed = Vector2(0,(drop_speed * anim_speed));
	formation.set_speed_scale(anim_speed);
	flow_lenght = (flow_lenght * 16);
	flow.set_size((flow.get_size()+Vector2(0,flow_lenght)));
	font.set_position(font.get_position() - Vector2(0,flow_lenght));
	pass

func _process(delta):
	
	if !droped:
		if rand_speed && !droped:
			anim_speed = rand_range(1,4);
			drop_speed = Vector2(0,anim_speed);
			formation.set_speed_scale(anim_speed);
			pass
		droped = true;
		formation.play("formation");
		yield(formation,"animation_finished");
		formation.stop();
		drop.set_visible(true);
		drop.set_position(formation.get_position()+Vector2(-1,-4));
		can_drop = true;
		pass
		
	if can_drop && drop_colision.is_colliding():
		can_drop = false;
		
		if drop_colision.get_collider().get_name() == "Player":
			splash.set_position(drop.get_position()+Vector2(0,6));
			splash.set_flip_v(true);
			drop_colision.get_collider().damage_received(damage);
			pass
		else:
			splash.set_position(drop.get_position()+Vector2(0,-9));
			splash.set_flip_v(false);
			pass
		splash.set_visible(true);
		drop.set_visible(false);
		drop.set_position(formation.get_position()+Vector2(-1,-4));
		splash.play("splash");
		yield(splash,"animation_finished");
		splash.set_visible(false);
		droped = false;
		pass
		
	if can_drop && !drop_colision.is_colliding():
		drop.set_position(drop.get_position()+drop_speed);
		pass
	pass
