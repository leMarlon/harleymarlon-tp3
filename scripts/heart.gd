extends Area2D

class_name heart_item
var is_idle = true

func _ready():
	_basic_movement()

func _basic_movement():
	if is_idle:
		$AnimatedSprite2D.play("idle")
		
		
@onready var heartsound = $sound

func _on_body_entered(body: Node):
	if body is Player:
		if body.health >= 100:
			print("Player already at max health. Heart not used.")
			return
		
		heartsound.play()
		body.health += 15
		if body.health > 100:
			body.health = 100

		print("Player healed by using a HP item. Health:", body.health)

		$AnimatedSprite2D.play("used")

		await get_tree().create_timer(0.583).timeout
		queue_free()
