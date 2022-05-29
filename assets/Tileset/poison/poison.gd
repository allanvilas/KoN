extends Sprite


onready var area = get_node("Area2D");



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func on_poison(body):
	
	print(body.get_name());
	pass 


func out_poison(body):
	pass 
