extends Node2D

#instance itens
onready var potion = preload("res://assets/scenes/Potion/potion.tscn").instance(PackedScene.GEN_EDIT_STATE_MAIN);
onready var coin = preload("res://assets/Itens/coin/coin.tscn");
onready var anim = get_node("anim");

var coins_stack 
var potions_stack  

var destroyed = false;

var attack_count = 0.0;
var limit_to_break = 6.0;
var set_frame = 0.0;
var frame = 0;
var coinsCount = 1;

func _ready():
	
	coinsCount = round(rand_range(0.5,5));
	coins_stack = get_parent().get_parent().get_node("coins");
	potions_stack  = get_parent().get_parent().get_node("potions");
	
	pass 

func applyDamage():
	frame = ceil(lerp(0,4,inverse_lerp(0,limit_to_break,attack_count)));
	attack_count += 1.0;
	if !destroyed:
		if attack_count >= limit_to_break:
			anim.set_animation("crashing");
			anim.play();
			potions_stack.add_child(potion);
			potion.set_position(self.get_position()-Vector2(0,10));
			for i in coinsCount:
				print("coins:= " +str(coinsCount));
				yield(get_tree().create_timer(0.3),"timeout");
				var coininstace = coin.instance(PackedScene.GEN_EDIT_STATE_MAIN);
				coins_stack.add_child(coininstace);
				coininstace.set_position(self.get_position()-Vector2(round(rand_range(-8,8)),round(rand_range(2,25))));
				pass
			destroyed = true;
			pass
		else:
			#print(frame);
			anim.set_frame(frame);
			pass
		pass
	pass
