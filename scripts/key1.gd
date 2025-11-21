extends StaticBody2D

signal chest_opened

var keytaken = false
var in_chest_zone = false
var is_idle = true
var dialogue_open = false



@onready var sound = $sound

func _ready():
	_basic_movement()

func _basic_movement():
	if is_idle:
		$AnimatedSprite2D.play("idle")


func _on_area_2d_body_entered(body: PhysicsBody2D):
	if keytaken == false:
		keytaken = true
		global.found_oldman_item = true
		$AnimatedSprite2D.queue_free()
		sound.play()


func _process(delta):
	if keytaken == true:
		if in_chest_zone == true:
			if Input.is_action_just_pressed("use"):
				print("A chest was opened !")
				emit_signal("chest_opened")
				
				





func _on_chest_zone_body_entered(body: Node2D) -> void:
	in_chest_zone = true
	print(in_chest_zone)


func _on_chest_zone_body_exited(body: Node2D) -> void:
	in_chest_zone = false
	print(in_chest_zone)
	
	
func _on_dialogue_closed() -> void:
	dialogue_open = false
	
