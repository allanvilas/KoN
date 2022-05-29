extends Node2D

onready var anim = get_node("anim")

onready var lifeProgress = get_node("life")
onready var lifeLabel = get_node("lifevalue")

var life = 30;
var max_life = 30;
var level = 0;
var upgrade_cost = 100;
var damage = 2;
var coldown = 2.0;
var activated = false;
var active_cost = 50;
var enemies = [];

# "level" = [leve,life,cost,damage,coldown]
var stats = {
	"1":[1,30,100,2.3,2],
	"2":[2,60,200,4.6,1.9],
	"3":[3,90,300,6.9,1.8],
	"4":[4,120,400,9.2,1.7],
	"5":[5,150,500,11.5,1.6],
	"6":[6,180,600,13.8,1.5],
	"7":[7,210,700,16.1,1.4]
	}

func _ready():
	pass # Replace with function body.
	
func activeUpgrade(player):
	if activated:
		if (player.coins - upgrade_cost) < 0:
			player.coins = (player.coins - active_cost);
			level+=1;
			pass
		else:
			print("Sem moedas suficientes!");
			pass
		pass
	else:
		#atctive
		if (player.coins - active_cost) < 0:
			player.coins = (player.coins - active_cost);
			activated = true;
			pass
		pass
	pass

func applyDamage():
	if activated && !(enemies == []):
		enemies[0].damage_received(damage);
		pass
	pass

func onDamageRange(body):
	if !enemies.has(body):
		enemies.append(body);
		enemies.sort();
		pass
	pass # Replace with function body.
func outDamageRange(body):
	if enemies.has(body):
		enemies.erase(body);
		pass	
	pass # Replace with function body.
