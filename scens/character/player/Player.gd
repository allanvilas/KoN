extends KinematicBody2D

onready var damageAnimation = preload("res://scens/textAnim.tscn");

onready var on_Vision = get_node("vision/telemetry");
var nodeOnVision = [];

var itensOnVision = [];
var lokingAt = 1;

onready var cam = get_node("cam");
onready var controls = get_node("cam/Control/Control/controls");
onready var game_controls = get_node("cam/Control/rightButtons");
onready var anim = get_node("anim");

#coin
onready var coinAnim = get_node("cam/Control/Coins/coinAnim");
onready var coinLabel = get_node("cam/Control/Coins/coins");

#get check points
onready var checkpoints = get_tree().get_nodes_in_group("checkpoints");

#ui
onready var lifeProgressBar = get_node("cam/Control/HBoxContainer/life");

#temporary stat's
export var level = 1;
export var max_life = 25;
export var life = 0;
export var damage_min = 2;
export var damage_max = 4;
export var defence = 2;
export var agility = 1;
export var inteligence = 1;
export var vigor = 2;
export var combat = 1;

#moviment and jump
var moviment = Vector2(0,0);
export var mov_speed = 60;
export var jump_speed = 3;
var jump_count = 0;
var max_jump = 1;
var can_jump = true;
export var gravity = 12;
export var faling_control = 4;
var on_air = false;

#interacting
var interacting = false;
var other_action = false;

#combat
var attacking = false;
#based on cell's 1 cell = 16 points
var attackDistance = 14;

export var cam_zoom = 0.7;

#values
export var coins = 0;

func _ready():
	#life progress bar configuration
	coinLabel.set_text(str(coins));
	
	life = max_life;
	lifeProgressBar.set_max(max_life);
	lifeProgressBar.set_value(life);
	
	cam.set_zoom(Vector2(cam_zoom,cam_zoom));
	cam._set_current(true);
	pass # Replace with function body.

func _process(delta):
	basic_moviment(delta);
	combat_movment();
	pass
	
func updateCoinValue():
	coinLabel.set_text(str(coins));
	pass
func basic_moviment(delta):
	
	if !other_action:
		#print(other_action);
		anim._set_playing(true);
		if moviment.x < 0:
			lokingAt = -1;
			anim.set_flip_h(true);
			anim.set_animation("run");
		elif moviment.x > 0:
			lokingAt = 1;
			anim.set_flip_h(false);
			anim.set_animation("run");
			pass
		else:
			moviment.x = 0;
			anim.set_animation("idle");	
			pass
		pass
	else:
		moviment.x = 0;
		pass
		
	var left = Input.is_action_pressed("left") ;
	var right = Input.is_action_pressed("right");
	var jump = Input.is_action_just_pressed("jump");
	
	if !is_on_floor() || is_on_ceiling():
		var on_air = true;
		#print(moviment);
		if moviment.y <= faling_control:
			moviment.y += gravity*delta;
			pass
		else:
			moviment.y = faling_control;
			pass
		#print("on air")
		pass
	else:
		var on_air = false;
		moviment.y = 0;
		#print("on land")
		jump_count = 0;
		pass
			
	if jump && !on_air && !(jump_count == max_jump):
		moviment.y -= jump_speed;
		jump_count += 1;
		#print("can jump")
		pass
	else:
		#print("can't jump")
		pass
	
	if (attacking == on_air):
		if left:
			moviment.x = -1;
			pass
		elif right:
			moviment.x = 1;		
			pass
		else:
			moviment.x = 0;
			pass
		pass
		
	move_and_slide(moviment*mov_speed,Vector2(0,-1));
	
	pass

func refresh_status():
	lifeProgressBar.set_value(life);
	pass
	
func damage_received(damage):
	other_action = true;
	life -= damage;
	refresh_status();
	var dmgAnimated = damageAnimation.instance();
	.get_parent().get_parent().add_child(dmgAnimated);
	dmgAnimated.show_text_anim(get_global_position(),str(damage),Color(0.7,0.9,0.2));
	#add_child().show_damage(get_global_position(),damage);
	anim.set_animation("damageTaken");
	yield(anim,"animation_finished");
	other_action = false;
	if life <=0:
		death()
	pass
	pass

func combat_movment():
	var first_attack = Input.is_action_just_pressed("firstAttack");
	var second_attack = Input.is_action_just_pressed("secondAttack");
	
	if first_attack && !interacting && !other_action:
		moviment.x = 0;
		other_action = true;
		attacking = true;
		interacting  = true;
		anim.set_animation("firstAttack");
		yield(anim,"animation_finished");
		apply_damage_or_use_iten();
		#print("fristAttack");
		doAttack()
		other_action = false;
		attacking = false;
		interacting  = false;
		pass
	if second_attack && !interacting && !other_action:
		moviment.x = 0;
		other_action = true;
		attacking = true;
		interacting  = true;
		anim.set_animation("secondAttack");
		yield(anim,"animation_finished");
		doAttack();
		other_action = false;
		interacting  = false;
		attacking = false;
		pass
	else:
		#other_action = false;
		pass
	pass

func change_controls_visibility():
	if game_controls.is_visible():
		game_controls.set_visible(false);
		$cam/Control/leftButtons.set_visible(false);
		pass
	else:
		game_controls.set_visible(true);
		$cam/Control/leftButtons.set_visible(true);
		pass
	pass 

func doAttack():
	if nodeOnVision != []:
		for enemie in nodeOnVision:
			if lokingAt == calculateOrientation(enemie):
				if calculateMaginitude(enemie) <= attackDistance:
					enemie.damage_received(calculateDemageByRange(damage_max,damage_min));
				pass
			else:
				#
				pass
			pass
			#return;
		pass
	pass

#calculate the orientation
func calculateOrientation(other):
	var whats_on_vision_position = other.get_global_position();
	var selfPosition = get_global_position();
	return (round(((selfPosition - whats_on_vision_position).normalized()).x)*-1);
	pass

#calculate the disctance from other objetcts
# ref 16px one cell
func calculateMaginitude(other):
	var whats_on_vision_position = other.get_global_position();
	var selfPosition = get_global_position();
	var mag = (selfPosition - whats_on_vision_position);
	var magnitude = round(sqrt(mag.x * mag.x + mag.y * mag.y));
	return magnitude;
	pass
	
func calculateDemageByRange(d_max,d_min):
	var damage = round(rand_range(d_max,d_min));
	return damage;
	pass
	
func OnVisionSight(body):
	if !nodeOnVision.has(body):
		nodeOnVision.append(body);
		pass
	#print("Entered node: "+str(nodeOnVision));
	pass

func outOfVisionSight(body):
	if nodeOnVision.has(body):
		nodeOnVision.erase(body);
		pass
	#print("Exited node: "+str(nodeOnVision));
	pass # Replace with function body.

func item_or_interact_on_vision(area):
	itensOnVision.append(area);
	print(calculateMaginitude(area));
	print(calculateOrientation(area));
	pass
	
func apply_damage_or_use_iten():
	
	if itensOnVision != []:
		
		for iten in itensOnVision:
			var mag = calculateMaginitude(iten);
			var orient = calculateOrientation(iten);
			var obj = iten.get_parent();
			if mag <= 20 && orient == lokingAt:
				if obj.has_method("applyDamage"):
					obj.applyDamage();
					pass
				if obj.has_method("useIten"):
					obj.useIten();
					pass
			pass
		#yield(get_tree().create_timer(0.3),"timeout");
		pass
	pass

func item_or_interact_out_vision(area):
	if nodeOnVision.has(area):
		nodeOnVision.erase(area);
		pass
	pass

func iten_on_colect_range(area):
	var item = area.get_parent();
	if item.has_method("restauration"):
		life += item.restauration(level);
		if life >= max_life:
			life = max_life;
			pass
		pass
		refresh_status();
		item.queue_free();
	pass

func iten_out_colect_range(area):
	pass
	
func death():
	for check in checkpoints:
		if check.checked == true:
			other_action = true;
			self.set_global_position(check.check_pos);
			life = (max_life/2);
			anim.set_animation("damageTaken");
			yield(anim,"animation_finished");
			anim.set_animation("damageTaken");
			yield(anim,"animation_finished");
			other_action = false;
			refresh_status()
			pass
		pass
	pass


func check_map_damage(body):
	print("mapDamage")
	pass 


func map_damage_out(body):
	print("mapDamage")
	pass


func colect_bodyIn(body):
	
	if body.get_name().begins_with("coin") || body.get_name().begins_with("@coin"):
		var item = body.itemName;
		if item == "coin":
			coins += round(rand_range(5.0,10.0)*level);
			updateCoinValue();
			body.queue_free();
			pass
		pass
	pass # Replace with function body.


func colect_bodyOut(body):
	pass # Replace with function body.
