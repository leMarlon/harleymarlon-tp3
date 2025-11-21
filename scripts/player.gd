extends CharacterBody2D

class_name Player

const speed = 140
var current_dir = "none"
@onready var deathsound = $death
@onready var slashsound = $slash
@onready var hurtsound = $hurt
@onready var togglesound = $toggle_sound


var oldman_in_range = false
var learntoplay_inrange = false
var rockinrange = false

var ismoving = false
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var is_hit = false
var attack_ip = false

var dialogue_open = false



func _ready():
	$AnimatedSprite2D.play("down_idle")
	if global.current_scene == "world":
		$Camera2D.make_current()
		$Camera2D.zoom = Vector2(3, 3)
	elif global.current_scene == "cliff_side":
		$cliffside_camera2D.make_current()
		$cliffside_camera2D.zoom = Vector2(3,3)
	
	_set_camera_limits()
	
	
func _physics_process(delta):
	
	
			
	if dialogue_open:
		play_anim(0)              # keep facing-based idle
		velocity = Vector2.ZERO
		move_and_slide()
	else:
		player_movement(delta)
	attack()
	enemy_attack()
	update_health()
	if global.breakboulder == true:
		boulder_break()
	if dialogue_open == false:
		if Input.is_action_just_pressed("use"):
			if learntoplay_inrange == true:
				var b2 = DialogueManager.show_example_dialogue_balloon(load("res://dialogues/learn_to_play.dialogue"), "start")
				dialogue_open = true
				b2.tree_exited.connect(_on_dialogue_closed)
			if oldman_in_range == true:
				var b = DialogueManager.show_example_dialogue_balloon(load("res://dialogues/main.dialogue"), "main")
				dialogue_open = true
				b.tree_exited.connect(_on_dialogue_closed)
			if rockinrange == true:
				var b3 = DialogueManager.show_example_dialogue_balloon(
						load("res://dialogues/rock.dialogue"),
						"start",
						[self]  
					)				
				dialogue_open = true
				b3.tree_exited.connect(_on_dialogue_closed)
	
		
	if health <= 0 and player_alive:
		die()
		
		
func player_movement(delta):
	velocity = Vector2.ZERO
	if attack_ip or is_hit or not player_alive:
		return
		
	var was_moving = ismoving
	

	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		ismoving = true
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		ismoving = true
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		ismoving = true
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		ismoving = true
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		ismoving = false
		velocity.x = 0
		velocity.y = 0
	move_and_slide()
		
	if ismoving and not was_moving:
		print("The player started walking.")
	elif not ismoving and was_moving:
		pass
		
		

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if is_hit:
		return
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
				anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_up")
		elif movement == 0:
			if attack_ip == false:
				anim.play("up_idle")
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_down")
		elif movement == 0:
			if attack_ip == false:
				anim.play("down_idle")

func player():
	pass






func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true
	
		

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if not player_alive:
		return

	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false
		hurtsound.play()
		$attack_cooldown.start()
		print("The player has been hit, Player health : ", health)
		
		var dir = current_dir
		is_hit = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("hurt_side")
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("hurt_side")
		elif dir == "up":
			$AnimatedSprite2D.play("hurt_up")
		elif dir == "down":
			$AnimatedSprite2D.play("hurt_down")

		
		$hurt_timer.start()
		
			

		


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
func attack():
	if not player_alive:
		return
		

	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_slash")
			slashsound.play()
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_slash")
			slashsound.play()
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("downslash")
			slashsound.play()
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("upslash")
			slashsound.play()
			$deal_attack_timer.start()


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
	play_anim(0)


func _set_camera_limits():
	var tilemap = get_tree().get_first_node_in_group("world_map")
	if tilemap and tilemap is TileMap:
		var used_rect = tilemap.get_used_rect()
		var cell_size = tilemap.tile_set.tile_size

		$Camera2D.limit_left = int(used_rect.position.x * cell_size.x)
		$Camera2D.limit_top = int(used_rect.position.y * cell_size.y)
		$Camera2D.limit_right = int((used_rect.position.x + used_rect.size.x) * cell_size.x)
		$Camera2D.limit_bottom = int((used_rect.position.y + used_rect.size.y) * cell_size.y)
		
		$cliffside_camera2D.limit_left = int(used_rect.position.x * cell_size.x)
		$cliffside_camera2D.limit_top = int(used_rect.position.y * cell_size.y)
		$cliffside_camera2D.limit_right = int((used_rect.position.x + used_rect.size.x) * cell_size.x)
		$cliffside_camera2D.limit_bottom = int((used_rect.position.y + used_rect.size.y) * cell_size.y)
	



func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		
		
func _on_regin_timer_timeout():
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100


func die():
	if not player_alive:
		return

	player_alive = false
	health = 0
	velocity = Vector2.ZERO
	global.player_current_attack = false
	attack_ip = false
	
	var world = get_tree().get_current_scene()
	if world.has_node("AudioStreamPlayer"):
		world.get_node("AudioStreamPlayer").stop()

	print("Player has died.")

	if $attack_cooldown:
		$attack_cooldown.stop()
	if $deal_attack_timer:
		$deal_attack_timer.stop()
	if $regin_timer:
		$regin_timer.stop()

	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("death")
	
	deathsound.play()
	await deathsound.finished
	
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func _on_hurt_timer_timeout() -> void:
	is_hit = false


func _on_detection_area_body_entered(node):
	_process_enter(node)

func _on_detection_area_area_entered(node):
	_process_enter(node)


func _on_detection_area_body_exited(node):
	_process_exit(node)

func _on_detection_area_area_exited(node):
	_process_exit(node)


func _process_enter(node):
	if node.has_method("old_man"):
		oldman_in_range = true
	elif node.has_method("learn"):
		learntoplay_inrange = true
	elif node.has_method("rock"):
		rockinrange = true




func _process_exit(node):
	if node.has_method("old_man"):
		oldman_in_range = false
	elif node.has_method("learn"):
		learntoplay_inrange = false
	elif node.has_method("rock"):
		rockinrange = false
		
func current_camera():
	if global.current_scene == "world":
		$Camera2D.enabled = true
		$cliffside_camera2D.enabled = false
	elif global.current_scene == "clff_side":
		$Camera2D.enabled = false
		$cliffside_camera2D.enabled = true
		
func _on_dialogue_closed() -> void:
	dialogue_open = false


func _on_chest_pickaxe_obtained() -> void:
	global.obtained_pickaxe = true
	$pickaxe_text.visible = true
	$pickaxe_timer.start()
	togglesound.play()

func boulder_break():
	
	var rock = get_parent().get_node_or_null("rock")
	if rock:
		print("hehe")
		rock.queue_free()
	


func _on_pickaxe_timer_timeout() -> void:
	$pickaxe_text.visible = false
