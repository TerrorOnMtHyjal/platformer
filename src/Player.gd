extends KinematicBody2D

var motion = Vector2(0,0)
var times_jumped = 0
var lives = 3

const SPEED = 1000
const GRAVITY = 100
const UP = Vector2(0, -1)
const JUMP_SPEED = 1500
const WORLD_LIMIT = 10000

signal animate

func _physics_process(delta):
	apply_gravity()
	detect_game_over()
	detect_and_apply_movement_input()
	detect_and_apply_jump_input()
	animate()
	move_and_slide(motion, UP)


func detect_and_apply_movement_input():
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		motion.x = -SPEED
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		motion.x = SPEED
	else:
		motion.x = 0


func detect_and_apply_jump_input():
	if Input.is_action_just_pressed("jump") and times_jumped < 2:
		motion.y -= JUMP_SPEED
		times_jumped += 1
		
		$AudioStreamPlayer.stream = load("res://assets/SFX/jump1.ogg")
		$AudioStreamPlayer.pitch_scale = 1;
		if times_jumped > 1:
			$AudioStreamPlayer.pitch_scale = 0.8;
		$AudioStreamPlayer.play()


func apply_gravity():
	if is_on_floor():
		times_jumped = 0
		motion.y = 0
		return
	elif is_on_ceiling():
		motion.y = 1
		return
		
	motion.y += GRAVITY
	
	
func animate():
	emit_signal("animate", motion)

func detect_game_over():
	if position.y > WORLD_LIMIT:
		end_game()
	elif lives <= 0:
		end_game()

	
func end_game():
	get_tree().change_scene("res://Levels/GameOver.tscn")
	

func hurt():
	position.y -= 1
	yield(get_tree(), "idle_frame")
	motion.y -= JUMP_SPEED
	lives -= 1
	$AudioStreamPlayer.stream = load("res://assets/SFX/pain.ogg")
	$AudioStreamPlayer.play()