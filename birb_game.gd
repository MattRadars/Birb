extends Node2D

@export var pipe_scene : PackedScene
@export var player_scene : PackedScene

var game_running : bool
var game_over : bool
var current : bool
var stop : bool = false
var scroll
const SCROLL_SPEED : int = 5
var screen_size : Vector2i
var num_pipes : Array
const PIPE_DELAY : int = 1.5
const PIPE_RANGE : int = 200
const PIPE_LIMIT : int = 10
var player_id
var count = 0
var players = []
var index
var collisionlayer = 2
var player_count
var potential_winner

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = GameManager.scale_factor
	if GameManager.randomized:
		seed(GameManager.randomized)
	player_id = multiplayer.get_unique_id()
	print($MultiplayerSynchronizer.get_multiplayer_authority())
	print(multiplayer.get_unique_id())
	$MultiplayerSynchronizer.set_multiplayer_authority(multiplayer.get_unique_id())
	for i in GameManager.Players:
		var CurrentPlayer = player_scene.instantiate()
		CurrentPlayer.player_id = GameManager.Players[i].id 
		CurrentPlayer.collision_layer = collisionlayer
		add_child(CurrentPlayer)
		if !GameManager.Players[i].id == player_id:
			CurrentPlayer.get_node("PlayerSprite").modulate.a = 0.5
		else: 
			CurrentPlayer.z_index = 5 
		CurrentPlayer.player = GameManager.Players[i].player
		CurrentPlayer.player_id = i
		CurrentPlayer.get_node("PlayerSprite").play(GameManager.Players[i].character)
		CurrentPlayer.global_position = Vector2(400,400) * GameManager.scale_factor
		collisionlayer *= 2
	player_count = GameManager.Players.size()
	generate_pipes()
	$Timer.start()
	

func new_game():
	for pipe in num_pipes:
		remove_child(pipe)
	num_pipes.clear()
	game_running = false
	game_over = false
	scroll = 0
	generate_pipes()
	
func start_game():
	game_running = true
	#$player.flying = true
	#$player.flap()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	count = player_count
	GameManager.score += 1
	$Score.text = "Score: " + str(GameManager.score)
	for i in GameManager.Players:
		if GameManager.Players[i].dead:
			count -= 1
		else:
			potential_winner = GameManager.Players[i].id
	if count == 1:
		update_global_winner.rpc([GameManager.Players[potential_winner].name, GameManager.Players[potential_winner].character])
	if count == 0:
		stop = true
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Ending.tscn")
	if !stop:
		for pipes in num_pipes:
			pipes.position.x -= SCROLL_SPEED
			
		
	

func _on_timer_timeout():
	if !stop:
		generate_pipes()
		if num_pipes.size() > PIPE_LIMIT:
			remove_child(num_pipes.front())
			num_pipes.remove_at(0)


func generate_pipes():
	var pipes = pipe_scene.instantiate()
	if player_count > 1:
		pipes.collision_mask = int(player_count)**2 - 1
	else:
		pipes.collision_mask = player_count + 2
	pipes.position.x = get_window().size.x * PIPE_DELAY
	pipes.position.y = 500 - randi_range(-200, 200)
	add_child(pipes)
	num_pipes.append(pipes)

@rpc("any_peer", "call_local")
func update_global_winner(value):
	GameManager.winner = value
func update_global(value):
	GameManager.randomized = value
