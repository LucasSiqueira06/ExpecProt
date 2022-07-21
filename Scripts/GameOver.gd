extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Serial.connect("attack", self, "_on_continue");
	Serial.connect("jump", self, "_on_jump");

func _on_continue():
	get_tree().change_scene("res://Scenes//PlataformForestLevel.tscn")


