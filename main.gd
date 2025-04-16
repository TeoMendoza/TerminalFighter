extends Node2D

@onready var http_request = %HTTPRequest
signal player_character_received()

const arena_scene: PackedScene = preload("res://Main/Scenes/Arenas/BaseArena.tscn")
const ready_up_menu_scene: PackedScene = preload("res://Main/Scenes/UserInterfaceScenes/ReadyUpMenu.tscn")
const ninja_scene = preload("res://Ninja/Scenes/Ninja.tscn")
const sumo_scene = preload("res://Sumo/Scenes/Sumo.tscn")
const PORT = 12345
const MAX_PLAYERS = 2

var ServerIP
var ready_up_menu: Control
var players_spawn_node: Node2D
var player1_character: String = ""
var player2_character: String = ""

func _ready():
	# Spawn the lobby menu
	ready_up_menu = ready_up_menu_scene.instantiate()
	add_child(ready_up_menu)
	ready_up_menu.ready_pressed.connect(_on_ready_pressed)

# Signal that comes from lobby menu when a player looks for a match
func _on_ready_pressed(selected_character):
	# Looks for a host to join
	var success = await join_game(selected_character)
	if not success:
		# If no host is available, the player becomes a host themselves
		host_game(selected_character)
		
# Creates host server
func host_game(selected_character: String):
	player1_character = selected_character
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(PORT, MAX_PLAYERS)
	
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(add_player_to_game)
	multiplayer.peer_disconnected.connect(player_left_game)

# Joins server
func join_game(selected_character) -> bool:
	var url = "http://10.150.143.100:12345/look_for_host"
	# Step 1: Send request
	var err = http_request.request(url, [], HTTPClient.METHOD_POST)
	if err != OK:
		print("Request failed to send:", err)
		return false

	# Step 2: Wait for response signal
	var response = await http_request.request_completed

	# Step 3: Parse response
	var result = response[0]               # Should be OK (0)
	var response_code = response[1]        # HTTP status (should be 200)
	var body = response[3]

	if result != OK:
		print("Request failed with error:", result)
		return false

	var json = JSON.parse_string(body.get_string_from_utf8())
	if json == null:
		print("Failed to parse JSON")
		return false

	if json.has("status") and json["status"] == "Found host":
		ServerIP = json["host_ip"]
		print("Found host at:", ServerIP)

		var client_peer = ENetMultiplayerPeer.new()
		client_peer.create_client(ServerIP, PORT)
		multiplayer.multiplayer_peer = client_peer
		multiplayer.server_disconnected.connect(host_left_game)

		await get_tree().create_timer(1.0).timeout

		if client_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
			rpc("send_host_player2_character_rpc", selected_character)
			return true
		else:
			print("Connection to host failed")
			return false
	else:
		print("No host found, now hosting")
		return false

# Runs on host-side when someone joins the server
func add_player_to_game(id: int):
	# Waits for the player character to be received, if not included timing issues can cause it to break
	if player2_character == "":
		await player_character_received
		
	# Calls func to create match
	spawn_arena(id)

func player_left_game(id: int):
	multiplayer.peer_connected.disconnect(add_player_to_game)
	multiplayer.peer_disconnected.disconnect(player_left_game)
	#multiplayer.server_disconnected.disconnect(host_left_game)
	multiplayer.multiplayer_peer = null
	var arena_to_delete = get_node("BaseArena")
	arena_to_delete.queue_free()
	
	ready_up_menu = ready_up_menu_scene.instantiate()
	add_child(ready_up_menu)
	ready_up_menu.ready_pressed.connect(_on_ready_pressed)

func host_left_game():
	multiplayer.server_disconnected.disconnect(host_left_game)
	multiplayer.multiplayer_peer = null
	#var arena_to_delete = get_node("BaseArena")
	#arena_to_delete.queue_free()
	
	ready_up_menu = ready_up_menu_scene.instantiate()
	add_child(ready_up_menu)
	ready_up_menu.ready_pressed.connect(_on_ready_pressed)

func spawn_arena(player_id):
	# Creates arena and despawns lobby menu, multiplayer spawner spawns it for clients aswell
	var arena = arena_scene.instantiate()
	add_child(arena)
	players_spawn_node = arena
	ready_up_menu.queue_free()
	
	spawn_host_player(arena, 1)
	spawn_client_player(arena, player_id)

# Spawns host player, multiplayer spawner spawns it for clients aswell
func spawn_host_player(arena, host_id):
	var player_to_add
	if player1_character == "Ninja":
		player_to_add = ninja_scene.instantiate()
	elif player1_character == "Sumo":
		player_to_add = sumo_scene.instantiate()
		
	var player_body = player_to_add.get_node("CharacterBody2D")
	player_body.player_id = host_id
	player_body.name = str(host_id)
	
	# Spawns host on the left side of arena
	player_body.global_position = Vector2(80, 650)
	arena.add_child(player_to_add, true)
	# Connects player death signal
	player_body.player_death.connect(_on_player_death)

# Spawns client player, multiplayer spawner spawns it for clients aswell
func spawn_client_player(arena, id):
	var player_to_add
	if player2_character == "Ninja":
		player_to_add = ninja_scene.instantiate()
	elif player2_character == "Sumo":
		player_to_add = sumo_scene.instantiate()
	var player_body = player_to_add.get_node("CharacterBody2D")
	player_body.player_id = id
	player_body.name = str(id)
	
	# Spawns host on the right side of arena
	player_body.global_position = Vector2(1200, 650)
	arena.add_child(player_to_add, true)
	player_body.host = false
	
	rpc("sync_player_information_for_client", id)

# Disconnects all signals so that when a new match is joined, reconnecting doesn't cause issues.
func _on_player_death():
	if multiplayer.is_server():
		multiplayer.peer_connected.disconnect(add_player_to_game)
		multiplayer.peer_disconnected.disconnect(player_left_game)
		#multiplayer.server_disconnected.disconnect(host_left_game)
	else:
		multiplayer.server_disconnected.disconnect(host_left_game)
		
	multiplayer.multiplayer_peer = null
	
	# Deletes arena and respawns the lobby menu
	var arena_to_delete = get_node("BaseArena")
	arena_to_delete.queue_free()
	player1_character = ""
	player2_character = ""
	ready_up_menu = ready_up_menu_scene.instantiate()
	add_child(ready_up_menu)
	ready_up_menu.ready_pressed.connect(_on_ready_pressed)

# Sends selected character with signal to the host
@rpc("any_peer")
func send_host_player2_character_rpc(selected_character):
	player2_character = selected_character
	player_character_received.emit()
	
# Syncs character data for client, since it doesn't sync until the full node has been created and the synchronizer starts working
@rpc("any_peer", "reliable")
func sync_player_information_for_client(client_id):
	ready_up_menu.queue_free()
	# Host is always first player, since we add them first on the host side, and the multiplayer spawner repeats the process order
	var players = get_tree().get_nodes_in_group("Player")
	var player1 = players[0]
	player1.global_position = Vector2(80, 680)
	player1.player_id = 1
	player1.name = str(1)
	
	var player2 = players[1]
	player2.global_position = Vector2(1200, 680)
	player2.player_id = client_id
	player2.name = str(client_id)
	player2.player_death.connect(_on_player_death)
	player2.host = false
