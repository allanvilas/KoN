extends KinematicBody2D

#load damage animation scene
onready var damageAnimation = preload("res://scens/textAnim.tscn");

#ui
onready var lifeProgressBar = get_node("ui/life");

#orientation ray cast's
onready var leftRayCast = get_node("left");
onready var leftMidleCast = get_node("left2");
onready var rightRayCast = get_node("right");
onready var rightMidleCast = get_node("right2");
onready var visionRayCast = get_node("visionPivot/vision");
onready var visionPivot = get_node("visionPivot");

#cast jump
onready var jump_view = get_node("visionPivot/jump");
onready var jump_side = get_node("visionPivot/jump_side");
onready var down = get_node("visionPivot/down");
onready var down_side = get_node("visionPivot/down_side");
var can_down = false;
var jump_colliding = false;

#gravity
export var gravity = 10;

var is_on_vision = false;
var whats_on_vision = null;

#basics animation
onready var anim = get_node("anim");

#moviment vars
var moving = false;
export var moviment = Vector2(0,0);
export var mov_speed = 10;
var orientation = 0;

#cheking distance between player and enemie
var distance = 0;
var seeking = false;

#attack control
var attacking = false;
var finish_attack = true;

#temporary stat's
export var max_life = 10;
export var life = 0;
export var damage = 2;
export var defence = 2;
export var agility = 1;
export var inteligence = 1;
export var vigor = 2;
export var combat = 1;


#deade
var dead = false;
var paused = true;
	
#dificulty
#level 1
#no more delay on seek.
export var dificulty_level = 0;

#getting player node from group
onready var enemies = get_tree().get_nodes_in_group("player");

export var directions = {
		"left":-1,
		"right":1,
		"idle":0,
		"attack":0,
	};
export var randomDirection = ["left","right","idle"]
export var direction = "right";
	
func _ready():
	life = max_life;
	lifeProgressBar.set_max(max_life);
	lifeProgressBar.set_value(life);
	pass 

func _process(delta):
	if !dead && !paused:
		basic_moviment(delta);
		anim_control();
		pass
	pass

func basic_moviment(delta):
		
	if !dead && !paused:
		if !attacking:
			if !leftRayCast.is_colliding() || leftMidleCast.is_colliding():
				direction = "right";
				#print("Changing to right")
				pass
			if !rightRayCast.is_colliding() || rightMidleCast.is_colliding():
				direction = "left";
				#print("Changing to left")
				pass
			pass
			
		var on_close_range = visionRayCast.get_collider();
		
		if is_on_vision && !on_close_range:
			seeking = true;
			if orientation == 1:
				direction = "right";
				pass
			if orientation == -1:
				direction = "left";
				pass
			pass
		else:
			if seeking == true && !on_close_range:
				seeking = false;
				direction = randomDirection[randi()% -2+0];
				pass
			pass
		#print(on_range == enemies[0] && visionRayCast.is_colliding());
		if on_close_range != null:
			if on_close_range.get_name() == "Player" && visionRayCast.is_colliding() && finish_attack == true:
				attacking = true;
				finish_attack = false;
				moving = false;
				direction = "attack";
				moviment.x = 0;
				anim.set_animation("attack");
				if dificulty_level >1:
					yield(get_tree().create_timer(0.5),"timeout");
					pass
				else:
					yield(anim,"animation_finished");
					pass
				#print("damage aplyed");
				if whats_on_vision and distance <= 14:
					if whats_on_vision.has_method("damage_received"):
						whats_on_vision.damage_received(round(rand_range(1,4)));
						pass
				finish_attack = true;
				attacking = false;
				pass
			else:
				pass
			pass
			
		if direction && !attacking:
			moviment.x = directions[direction];
			pass
		
		move_and_slide(moviment*mov_speed,Vector2(0,-1))
		pass
	pass
	
func jumping_and_down(delta):
	
	if !is_on_floor():
		moviment.y += gravity*delta;
		pass
	else:
		moviment.y = 0;
		pass
	
	if jump_side.is_colliding() && !jump_view.is_colliding():
		jump_colliding = true;
		pass
	else:
		jump_colliding = false;
		pass
		
	if down.is_colliding() && !down_side.is_colliding():
		can_down = true;
		pass
	else:
		can_down = false;
		pass
		
	if can_down:
		move_and_slide(Vector2((orientation*100),0)*mov_speed,Vector2(0,-1));
		pass
	if jump_colliding:
		move_and_slide(Vector2((orientation*100),-120)*mov_speed,Vector2(0,-1))
		pass
	pass
		
func anim_control():
	if !direction == "attack":
		if moviment.x < 0:
			anim.set_flip_h(true);
			visionPivot.set_rotation_degrees(180);
			anim.set_animation("walk");
		elif moviment.x > 0:	
			anim.set_flip_h(false);
			visionPivot.set_rotation_degrees(0);
			anim.set_animation("walk");
			pass
		else:
			moviment.x = 0;
			anim.set_animation("idle");	
			pass
		pass

func calculate_orientation():
	if whats_on_vision != null:
		#orientation
		var whats_on_vision_position = whats_on_vision.get_global_position();
		var selfPosition = get_global_position();
		orientation = (round(((selfPosition - whats_on_vision_position).normalized()).x)*-1);
		#print("Direction: "+str(orientation))
		
		#distance
		var mag = (selfPosition - whats_on_vision_position);
		var magnitude = sqrt(mag.x * mag.x + mag.y * mag.y);
		distance = round(magnitude);
		
		#print("distrance are:"+ str(distance));
		#print("same as: " + str(distance/16) + " cell's");
		#print("orientation are: "+ str(orientation));
		yield(get_tree().create_timer(0.5),"timeout");
		if whats_on_vision != null:
			calculate_orientation();
			pass
		else:
			return;
		pass
	pass
	
func refresh_status():
	lifeProgressBar.set_value(life);
	pass

func damage_received(damage):
	life -= damage;
	lifeProgressBar.set_value(life);
	var dmgAnimated = damageAnimation.instance();
	.get_parent().get_parent().add_child(dmgAnimated);
	dmgAnimated.show_text_anim(get_global_position(),str(damage),Color(0.9,0.2,0.2));
	if life <= 0:
		death();
		dmgAnimated.show_text_anim(get_global_position(),str("xp +7"),Color(0.7,0.9,0.9));
		pass
	pass

func on_view(body):
	is_on_vision = true;
	whats_on_vision = body;
	calculate_orientation()
	pass 

func out_of_sigh(body):
	is_on_vision = false;
	whats_on_vision = null;
	pass # Replace with function body.

func death():
	anim.set_animation("dying");
	dead = true;
	$colision.set_disabled(true);
	yield(get_tree().create_timer(60.0),"timeout");
	queue_free();
	pass

func pause():
	if paused == false:
		paused = true;
	else:
		paused = false;
	pass
