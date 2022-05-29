extends Node2D


var canDoDamage = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func damagePerSec(time,damage,player):
	if canDoDamage:
		player.damage_received(damage);
		yield(get_tree().create_timer(time),"timeout");
		damagePerSec(time,damage,player);
		pass
	pass


func onDamagePerSecondArea(body):
	if body.get_name() == "Player":
		canDoDamage = true;
		damagePerSec(0.2,1,body);
		print("casting damage per sec");
		pass
	pass

func OutDamagePerSecondArea(body):
	if body.get_name() == "Player":
		canDoDamage = false;
		print("out damage per sec area");
		pass
	pass
