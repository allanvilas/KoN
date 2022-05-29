extends Node2D

var itemName = "potion";

func _onready():
	
	pass

func restauration(level):
	return rand_range((level*3),(level*5));
	queue_free();
	pass
