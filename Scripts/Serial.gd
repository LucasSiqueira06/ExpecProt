extends Node

const serial_res = preload("res://bin/gdserial.gdns")
onready var serial_port = serial_res.new()
var is_port_open = false
var text = ""

signal up;
signal down;
signal left;
signal right;
signal attack;
signal rightFeet;
signal leftFeet;
signal jump;
signal dash;

func _ready():
	open()

func _exit_tree():
	close()

func open():
	print(serial_port.open_port("COM3", 9600))
	is_port_open = true;
	
func close():
	is_port_open = false
	serial_port.close_port()

func _process(delta):
	if(is_port_open):
		var t = serial_port.read_text()
		if t.length() > 0:
			for c in t:
				if c == "\n":
					on_text_received(text)
					text = ""
				else:
					text += c

func on_text_received(text):
		 
	if text == "Up":
		emit_signal("up");
	elif text == "Down":
		emit_signal("down");
	elif text == "Left":
		emit_signal("left");
	elif text == "Right":
		emit_signal("right");
	elif text == "Attack":
		emit_signal("attack");
	elif text == "Walk left":
		emit_signal("leftFeet");
	elif text == "Walk Right":
		emit_signal("rightFeet");
	elif text == "Jump":
		emit_signal("jump");
	elif text == "Dash":
		emit_signal("dash");
