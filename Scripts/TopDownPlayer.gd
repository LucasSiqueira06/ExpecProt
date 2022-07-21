extends KinematicBody2D

export var walkSpeed = 40;
var direction = Vector2();
var facingDirection = 0; 
var piezoTime = 0.5;

func _ready():
	#restart_movement();
	Serial.connect("leftFeet", self, "_on_left_feet");
	Serial.connect("rightFeet", self, "_on_right_feet");
	Serial.connect("left", self, "_on_left_turn");
	Serial.connect("right", self, "_on_right_turn");
	Serial.connect("up", self, "_on_up_turn");
	Serial.connect("down", self, "_on_down_turn");
	
func _on_down_turn():
	facingDirection = 0;
func _on_right_turn():
	facingDirection = 1;
func _on_up_turn():
	facingDirection = 2;
func _on_left_turn():
	facingDirection = 3;

func _on_left_feet():
	piezoMove();
	
func _on_right_feet():
	piezoMove();

func piezoMove():
	if(facingDirection == 0):
		Input.action_press("down");
	elif(facingDirection == 1):
		Input.action_press("right");
	elif(facingDirection == 2):
		Input.action_press("up");
	else:
		Input.action_press("left");
	$PiezoTimer.start(piezoTime);

func _on_PiezoTimer_timeout():
	Input.action_release("right");
	Input.action_release("left");
	Input.action_release("up");
	Input.action_release("down");
	
func _physics_process(delta):
	direction = Vector2();
	checkForDirections();
	updateWalkSprites();
	move_and_slide(direction, Vector2.UP)
	
func checkForDirections():
	if(Input.is_action_pressed("right")):
		direction.x += 1;
	if(Input.is_action_pressed("left")):
		direction.x -= 1;
	if(Input.is_action_pressed("up")):
		direction.y -= 1;
	if(Input.is_action_pressed("down")):
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
	if(direction.x == 0 && direction.y == 0):
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
	
