extends Area2D


var healing = false

func _ready():
	pass
	


func _on_body_entered(body):
	if body is Player:
		healing = true
		
