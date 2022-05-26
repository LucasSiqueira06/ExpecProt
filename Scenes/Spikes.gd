extends Area2D

signal pinch

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Spikes_body_entered(body):
	if(body.name == "PlataformPlayer"):
		emit_signal("pinch");
