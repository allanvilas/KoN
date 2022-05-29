extends Node2D

#http
onready var httpRequest = get_node("Controls/HTTPRequest");

#ui
onready var nameUi = get_node("Controls/Control/name");
onready var controls = get_node("Controls/Control");
onready var startButton = get_node("Controls/Control/startGameButton");
onready var nameEdit = get_node("Controls/Control/name/namedit");

onready var player = preload("res://scens/character/player/Player.tscn");
onready var menu = preload("res://scens/maps/menu.tscn");

var start_point;
var end_point;

var user_name = "";
var user_points = 0;

func _ready():
	var map = menu.instance();
	add_child(map);
	map.set_position(Vector2(1000,0));
	httpRequest.connect("request_completed",self,"_on_HTTPRequest_request_completed");
	pass # Replace with function body.

func start_game():
	
	var map = menu.instance();
	add_child(map);
	var player_instance = player.instance();
	add_child(player_instance);
	map.start(self);
	player_instance.set_global_position(start_point);
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func StartGame():
	nameUi.set_visible(true);
	startButton.set_disabled(true);
	pass 

func get_user_name(new_text):
	user_name = new_text;
	nameEdit.set_editable(false);
	yield(get_tree().create_timer(3),"timeout");
	start_game()
	
	var header = ["Content-Type: application/json"];
	var query = {
		"playerName":str(user_name),
		"points":str(100)
	}
	query = JSON.print(query);
	httpRequest.request("http://localhost/scripts/game/highscore.php",header,false,HTTPClient.METHOD_POST,query);
	controls.set_visible(false);
	pass 

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
