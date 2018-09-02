extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const MAX_SPEED = 400
const ACCELERATION = 70
const WEIGHT = 0.2
const JUMP_HEIGHT = -550

var motion = Vector2()

func _ready():
	$AnimatedSprite.play("idle")
	#add exceptions to make sure raycast doesnt report collisions with player
	$Ray/Right.add_exception(self)
	$Ray/Left.add_exception(self)

func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
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
	
	var wall_right = false
	var wall_left = false
	if is_on_wall():
		# is_colliding() returns true if the raycast is touching a collider (the raycasts are 50 px each direction in this case)
		if $Ray/Right.is_colliding():
			# theres probably a better way to test if the colliders a wall
			if "TileMap" in $Ray/Right.get_collider().name:
				#set a flag to true
				wall_right = true
		elif $Ray/Left.is_colliding():
			if "TileMap" in $Ray/Left.get_collider().name:
				wall_left = true
		
		#check flags
		if wall_right:
			# Walljump code here
			print("on right wall")
		if wall_left:
			# Walljump code here
			print("on left wall")
	
	
	motion = move_and_slide(motion, UP)
