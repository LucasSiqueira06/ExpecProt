extends KinematicBody2D

export var jumpForce = 210
export var gravity = 10
export var walkSpeed = 150
var direction

var movement = Vector2(0,0)

func _ready():
	pass

func _physics_process(delta):
	jumpOrFall();
	horizontalMove();
	move_and_slide(movement, Vector2.UP);
	updateSprites();

func jumpOrFall():
	if(not is_on_floor()):
		movement.y += gravity;
	if(is_on_floor() and Input.is_action_just_pressed("jump")):
		movement.y = -jumpForce;

func horizontalMove():
	direction = Input.get_action_strength("right") - Input.get_action_strength("left");
	movement.x = direction * walkSpeed;

func updateSprites():
	if(is_on_floor()):
		if(movement.x > 0):
			$AnimatedSprite.play("Player_Run")
			$AnimatedSprite.flip_h = false
		elif(movement.x < 0 ):
			$AnimatedSprite.play("Player_Run")
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.play("Player_Idle")
	else:
		$AnimatedSprite.play("Player_Jump")
		if(movement.x > 0):
			$AnimatedSprite.flip_h = false
		elif(movement.x < 0):
			$AnimatedSprite.flip_h = true

