extends Area2D

@export var cooldown: int
@export var textures: Array[Texture2D]
@export var texture: Sprite2D
@onready var timer: Timer = $Timer

var players: Array[Player] = []
var resetting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = cooldown
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	grant_bullet(delta)
		
func grant_bullet(delta):
	if not resetting and players:
		for player in players:
			if player.attack_on_cooldown == true:
				player.attack_on_cooldown = false
				player.ability_anim_sprite.play("Attack")
				reset_timer()
				reset_timer_rpc.rpc()
				break
				
func _on_body_entered(player):
	pass
	#players.append(player)

func _on_body_exited(player):
	var index = 0
	for person in players:
		if person == player:
			players.pop_at(index)
		index += 1
		
func reset_timer():
	resetting = true
	texture.texture = null
	timer.start()  # Start the timer
	await timer.timeout  # Wait for the timer to finish
	resetting = false # Reset the variable after the timer finishes
	texture.texture = pick_texture()

@rpc("any_peer")
func reset_timer_rpc():
	resetting = true
	texture.texture = null
	timer.start()  # Start the timer
	await timer.timeout  # Wait for the timer to finish
	resetting = false # Reset the variable after the timer finishes
	texture.texture = pick_texture()
	
func pick_texture():
	return textures[0]
