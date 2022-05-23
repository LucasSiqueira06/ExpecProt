extends KinematicBody2D

export var maxHp = 5;
export var currentHp = 5;
export var jumpForce = 210
export var gravity = 10
export var walkSpeed = 150
export var backfireDistance = 30;
export var startPosition = Vector2(0,0);

var direction

var movement = Vector2(0,0)

export var attackingTime = 0.5;

var isAttacking = false;
var facingRight = true;

func _ready():
	pass

func _physics_process(delta):
	jumpOrFall();
	horizontalMove();
	updateFacingDirection();
	checkAttack();
	updateSprites();

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
			$AnimatedSprite.play("Player_Jump");
	else:
		$AnimatedSprite.play("Player_Attack");
	$AnimatedSprite.flip_h = not facingRight;


func _on_Area2D_body_entered(body):
	doDamage();
	updatePosition(body);
	checkIfDead();

func doDamage():
	if(currentHp > 0):
		currentHp -= 1;
	
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
	if(currentHp < 1):
		position = startPosition;
