class_name BulletAttack
extends Attack

func init():
	pass
	#projectile_scene = preload("res://Ninja/Scenes/Bullet.tscn")
	
# Gathers the data for the scene constructor and then calls the bullet scene constructor
func execute(player):
	var player_direction = player.get_facing_direction()
	var spawn_position = player.get_global_position() + Vector2(15 * player_direction.x, 20 * player_direction.y)
	var bullet = Bullet.new_bullet(player, player_direction, spawn_position, player.character)
	player.get_tree().current_scene.add_child(bullet, true)
	
	# Adjusts sprite direction to allign the attack animation with the direction of shooting
	if player_direction.x >= 0 and player.last_facing_direction == "Left":
		player.anim_sprite.flip_h = false
	elif player_direction.x < 0 and player.last_facing_direction == "Right":
		player.anim_sprite.flip_h = true	
		
	player.anim_sprite.play("Attack")
	player.animation_locked = true
	player.attack_on_cooldown = true
	
	# Information for rpc call for the other player to create the bullet aswell
	return [player_direction, spawn_position]
