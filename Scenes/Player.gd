extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const MAX_SPEED = 400
const ACCELERATION = 70
const WEIGHT = 0.2
const JUMP_HEIGHT = -550

var facing_right = false
var facing_left = false

var motion = Vector2()

func _ready():
	$AnimatedSprite.play("idle")
	facing_right = true

func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		# if your press right your facing right and not left
		facing_right = true
		facing_left = false
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		facing_right = false
		facing_left = true
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")
	else:
		motion.x = lerp(motion.x, 0, WEIGHT)
		$AnimatedSprite.play("idle")
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
	else:
		if motion.y < 0:
			$AnimatedSprite.play("jumpUp")
		else:
			$AnimatedSprite.play("jumpDown")
	
	# if you're on a wall and facing right, you're probably on a wall to the players right
	# this isnt ideal, for a frame or two when you leave a left wall and are holding right
	# this code will think you're on a right wall, probably should use raycasts
	if is_on_wall():
		if facing_right:
			# Walljump code here
			print("on right wall")
		elif facing_left:
			print("on left wall")
	
	motion = move_and_slide(motion, UP)