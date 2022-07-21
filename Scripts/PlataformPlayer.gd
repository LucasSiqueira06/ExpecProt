extends KinematicBody2D

export var jumpForce = 210
export var gravity = 10
export var walkSpeed = 150
export var backfireDistance = 35;
export var startPosition = Vector2(0,0);
export var movementStrength = 0.7;
export var enemiesArray = ["BatEnemy1", "SnakeEnemy1", "DogEnemy1", "DogEnemy2", "Boss"];
export var piezoTime = 0.4;
export var dashDistance = Vector2(3500, 0);
export var deathTime = 1.2;

var isDead = false;
var dashUsed = false;
var direction;
var piezoRight = true;
var movement = Vector2(0,0);

export var attackingTime = 0.5;

var isAttacking = false;
var facingRight = true;
var piezoJump = true;

func _ready():
	restart_movement();
	Serial.connect("attack", self, "_on_attack");
	Serial.connect("leftFeet", self, "_on_left_feet");
	Serial.connect("rightFeet", self, "_on_right_feet");
	Serial.connect("left", self, "_on_left_turn");
	Serial.connect("right", self, "_on_right_turn");	
	Serial.connect("jump", self, "_on_jump");
	Serial.connect("dash", self, "_on_dash");

func restart_movement():
	movement.x = 0;
	movement.y = 0;


func _on_dash():
	if(not is_on_floor() && not dashUsed):
		if(facingRight):
			move_and_slide(dashDistance, Vector2.UP);
		else:
			move_and_slide(-dashDistance, Vector2.UP);
		dashUsed = true;
		

func _on_jump():
	Input.action_press("up");

func _on_attack():
	Input.action_press("attack");
	
func _on_left_feet():
	piezoMove();
	
func _on_right_feet():
	piezoMove();

func piezoMove():
	if(piezoRight):
		Input.action_press("right", movementStrength);
	else:
		Input.action_press("left", movementStrength);
	$PiezoTimer.start(piezoTime);

func _on_PiezoTimer_timeout():
	Input.action_release("right");
	Input.action_release("left");
	
func _on_right_turn():
	piezoRight = true;

func _on_left_turn():
	piezoRight = false;


func _physics_process(delta):
	if(not isDead):
		jumpOrFall();
		horizontalMove();
		updateFacingDirection();
		checkAttack();
		updateSprites();
		updateDash();

func jumpOrFall():
	if(not is_on_floor()):
		movement.y += gravity;
	if(is_on_floor() and Input.is_action_just_pressed("up")):
		movement.y = -jumpForce;

func horizontalMove():
	direction = Input.get_action_strength("right") - Input.get_action_strength("left");
	movement.x = direction * walkSpeed;
	move_and_slide(movement, Vector2.UP);
	
func updateFacingDirection():
	if(movement.x > 0):
		facingRight = true;
	elif(movement.x < 0):
		facingRight = false;

func checkAttack():
	if(Input.is_action_just_pressed("attack") and isAttacking == false):
		isAttacking = true;
		attack();
		
func attack():
	updateSwordColliders(not facingRight, facingRight);
	$AttackTimer.start(attackingTime);
	
func updateSwordColliders(rightCollider, leftCollider):
	$Sword/RightCollisionPolygon2D.disabled = rightCollider;
	$Sword/LeftCollisionPolygon2D.disabled = leftCollider;
	
func _on_AttackTimer_timeout():
	isAttacking = false;
	updateSwordColliders(true, true);

func updateSprites():
	if(not isAttacking):
		if(is_on_floor()):
			if(movement.x != 0):
				$AnimatedSprite.play("Player_Run");
			else:
				$AnimatedSprite.play("Player_Idle");
		else:
			if(dashUsed && movement.x != 0):
				$AnimatedSprite.play("Player_Dash");
			else:
				$AnimatedSprite.play("Player_Jump");
	else:
		$AnimatedSprite.play("Player_Attack");
	$AnimatedSprite.flip_h = not facingRight;


func _on_Area2D_body_entered(body):
	if(contains(body.name) && not isDead):
		doDamage();
		updatePosition(body);
		checkIfDead();

func contains(name):
	for i in enemiesArray.size():
		if(name == enemiesArray[i]):
			return true;
	return false;

func doDamage():
	if(HudSimpleton.currentHp >= 0):
		HudSimpleton.currentHp -= 1;
		
func updatePosition(body):
	if(movement.x != 0):
		if(facingRight):
			position.x -= backfireDistance;
		else:
			position.x += backfireDistance;
	else:
		if(body.direction.x == 1):
			position.x += backfireDistance;
		else:
			position.x -= backfireDistance;

func checkIfDead():
	if(HudSimpleton.currentHp < 0):
		kill();

func _on_DeathArea_death():
	kill();

func kill():
	isDead = true;
	#position = startPosition;
	HudSimpleton.currentHp = HudSimpleton.maxHp;
	$DeathTimer.start(deathTime);
	$AnimatedSprite.play("Player_Death");
	$AnimatedSprite.flip_h = not facingRight;

func _on_DeathTimer_timeout():
	isDead = false;
	get_tree().change_scene("res://Scenes//GameOver.tscn")

func _on_Spikes_pinch():
	doDamage();
	if(facingRight or movement.x == 0):
		position.x -= backfireDistance;
	else:
		position.x += backfireDistance;
	position.y -= backfireDistance;
	checkIfDead();
	
func updateDash():
	if(is_on_floor()):
		dashUsed = false;


