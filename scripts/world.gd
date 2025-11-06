extends Node2D


@onready var pause_menu = $CanvasLayer/Control

var paused = false


func _ready():
	get_tree().root.content_scale_factor = 3.0
	pause_menu.hide()
	
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		pauseMenu()
		
func pauseMenu():
	if paused:
		get_tree().paused = false
		pause_menu.hide()
	else:
		pause_menu.show()
		get_tree().paused = true
	paused = !paused
