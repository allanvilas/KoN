extends Node2D

onready var checkpoints = get_tree().get_nodes_in_group("checkpoints");
var checked = false;
var check_pos = Vector2(0,0);
onready var anim = get_node("AnimatedSprite");

func _ready():
	check_pos = get_global_position();
	check_pos.x = check_pos.x +8;
	pass # Replace with function body.

func chekpoint(body):
	if !checked:
		if body.get_name() == "Player":
			print(body.get_name());
			anim.set_speed_scale(0.6);
			anim.set_animation("initi");
			yield(anim,"animation_finished");
			anim.set_speed_scale(0.8);
			anim.set_animation("particles");
			yield(anim,"animation_finished");
			anim.set_speed_scale(1.2);
			yield(anim,"animation_finished");
			anim.set_speed_scale(1);
			checked = true;
			for check in checkpoints:
				print("check is:"+str(check));
				if !check == self:
					check.checked = false;
					pass
				pass
		pass
	anim.set_speed_scale(1);
	pass

func out_checkpoint(body):
	if body.get_name() == "Player":
		anim.set_speed_scale(0.6);
		pass
	pass
