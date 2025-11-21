extends StaticBody2D

signal pickaxe_obtained

func _ready():
	$AnimatedSprite2D.play("closed")


	
func _on_key_chest_opened():
	$AnimatedSprite2D.play("opened")
	emit_signal("pickaxe_obtained")
