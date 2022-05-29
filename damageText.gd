extends Node2D


onready var text = get_node("text");
onready var anim = get_node("anim");
func _ready():
	pass

func show_text_anim(pos,text,color):
	set_global_position(pos);
	$text.set_text(str(text));
	$text.set_modulate(color);
	$anim.play("textanim");
	yield($anim,"animation_finished");
	queue_free();
	pass
