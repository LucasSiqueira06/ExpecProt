extends KinematicBody2D

export var maxHp = 3;
export var currentHp = 3;
export var movementSpeed = 50;

export var attackTime = 0.65;
export var moveTime = 2.0;

export var rightCollisionShapePosition = 0;
export var leftCollisionShapePosition = 0;

var direction = Vector2(1,0);
var isAttacking = false;
var facingRight = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if(not isAttacking):
		move_and_slide(direction * movementSpeed, Vector2.UP);
	updateSprites();
	updateCollisionShapePosition();
	
func updateSprites():
	if(isAttacking):
		$AnimatedSprite.play("Enemy_Attack");
	else:
		if(direction.x != 0):
			$AnimatedSprite.play("Enemy_Move");
		else:
			$AnimatedSprite.play("Enemy_Idle");
	$AnimatedSprite.flip_h = not facingRight;

func updateCollisionShapePosition():
	if(facingRight):
		$CollisionShape2D.position.x = rightCollisionShapePosition;
	else:
		$CollisionShape2D.position.x = leftCollisionShapePosition;

func _on_MovementTimer_timeout():
	attack();
	direction.x *= -1

func attack():
	$MovementTimer.stop();
	isAttacking = true;
	$AttackTimer.start(attackTime);

func _on_AttackTimer_timeout():
	$AttackTimer.stop();
	facingRight = not facingRight;
	isAttacking = false;
	$MovementTimer.start(moveTime);
