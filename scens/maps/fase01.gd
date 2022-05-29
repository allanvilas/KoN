extends Node2D


onready var player = preload("res://scens/character/player/Player.tscn");

onready var start_pos = get_node("tilemaps/points/StartPoint").get_position();

func _ready():
	player = player.instance();
	add_child(player);
	player.set_position(start_pos);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
