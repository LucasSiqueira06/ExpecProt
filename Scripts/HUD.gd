extends Node2D

var hpArray;

func _ready():
	hpArray = [$Life1, $Life2, $Life3, $Life4, $Life5];

func _process(delta):
	
	for i in hpArray.size():
		if(i < HudSimpleton.currentHp):
			hpArray[i].visible = true;
		else:
			hpArray[i].visible = false;
