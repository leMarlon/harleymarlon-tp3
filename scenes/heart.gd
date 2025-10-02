extends Area2D


class_name heart_item
var is_idle = true

func _ready():
	_basic_movement()
	

func _basic_movement():
	if is_idle == true:
		$AnimatedSprite2D.play("idle")

func _on_body_entered(body):
	if body is Player:
		print("Player healed by using a HP item.")
		$AnimatedSprite2D.play("used")
		await get_tree().create_timer(0.583).timeout
		queue_free()
