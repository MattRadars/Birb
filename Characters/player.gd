extends CharacterBody2D

const MAX_VEL : int = 600
const FLAP : int = -400
var flying : bool = false
var falling : bool = false
var PlayerSelect = 0
var player
var player_id
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var user_id

signal hit

func _ready():
	
	user_id = multiplayer.get_unique_id()
	$MultiplayerSynchronizer.set_multiplayer_authority(str(player_id).to_int())
	set_rotation(0)
	

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == user_id:
		if !GameManager.Players[user_id].dead:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			position.x = 400
			velocity.y += gravity * delta
			velocity.x = 0
			
			if velocity.y > MAX_VEL:
				velocity.y = MAX_VEL
		
			if Input.is_action_just_pressed("Jump") and GameManager.Players[user_id].dead == false:
				velocity.y = FLAP
				
			if is_on_ceiling() or is_on_floor() or is_on_wall():
				set_player_dead()
				set_rotation(PI/2)
				$PlayerSprite.stop()
					
			move_and_slide()

func _process(delta):
	if GameManager.Players[user_id].dead:
		position.x -= 5
		position.y += position.y * delta * 1.5

func set_player_dead():
	GameManager.Players[user_id].dead = true
	update_global.rpc(user_id)
	
@rpc("any_peer","call_local")
func update_global(id):
	GameManager.Players[id].dead = true
		
	
	
