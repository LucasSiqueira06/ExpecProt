extends Area2D

export var walkSpeed = 10;
var direction = Vector2();
var facingDirection = 0; 

func _ready():
	pass
	
func _process(delta):
	direction = Vector2();
	checkForDirections();
	updateWalkSprites();
	walk(delta);
	

func checkForDirections():
	if(Input.is_action_just_pressed("right")):
		direction.x += 1;
	if(Input.is_action_just_pressed("left")):
		direction.x -= 1;
	if(Input.is_action_just_pressed("up")):
		direction.y -= 1;
	if(Input.is_action_just_pressed("down")):
		direction.y += 1;

func updateWalkSprites():
	if(direction.length() > 0):
		direction = direction.normalized() * walkSpeed;
		if(direction.y > 0):
			$AnimatedSprite.play("Player_Walk_Down");
			facingDirection = 0;
		elif(direction.y < 0):
			$AnimatedSprite.play("Player_Walk_Up");
			facingDirection = 2;
		if(direction.x > 0):
			$AnimatedSprite.play("Player_Walk_Right");
			facingDirection = 1;
		elif(direction.x < 0):
			$AnimatedSprite.play("Player_Walk_Left");
			facingDirection = 3;
	else:
		updateIdleSprites();

func updateIdleSprites():
	if(facingDirection == 0):
		$AnimatedSprite.play("Player_Idle_Down");
	elif(facingDirection == 1):
		$AnimatedSprite.play("Player_Idle_Right");
	elif(facingDirection == 2):
		$AnimatedSprite.play("Player_Idle_Up");
	else:
		$AnimatedSprite.play("Player_Idle_Left");
	
func walk(delta):
	position += direction * delta
		
