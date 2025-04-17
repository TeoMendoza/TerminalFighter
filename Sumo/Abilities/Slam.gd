class_name Slam
extends Ability

var slam_height: float
var horizontal_velocity: float
var verticle_velocity: float = 125
const land_slam_duration: float = 0.25

func execute(player):
	if not owner.knocked_back:
		verticle_velocity = 125
		owner.velocity = Vector2(0,0)
		slam_height = owner.global_position.y
		owner.slamming = true
		owner.slam_on_cooldown = true
		owner.is_using_ability = true
		owner.animation_locked = true
		owner.current_animation = "Slam"
		owner.anim_sprite.play("Slam")
		if owner.global_position.y > 500:
			horizontal_velocity = 0
			verticle_velocity = 800
		else:
			var mouse_distance_x = owner.global_position.x - owner.get_global_mouse_position().x
			
			if abs(mouse_distance_x) < 100:
				verticle_velocity = 800
				
			if mouse_distance_x < 0:
				horizontal_velocity = max(-750, mouse_distance_x) * -2
				if owner.last_facing_direction == "Left":
					owner.anim_sprite.flip_h = false
					owner.fart_anim_sprite.position.x = -34
					owner.fart_anim_sprite.flip_h = true
				
			elif mouse_distance_x > 0:
				horizontal_velocity = min(750, mouse_distance_x) * -2
				if owner.last_facing_direction == "Right":
					owner.anim_sprite.flip_h = true
					owner.fart_anim_sprite.position.x = 34
					owner.fart_anim_sprite.flip_h = false
			
		
func process_slam(player, delta):
	var collision = owner.move_and_collide(Vector2(horizontal_velocity, verticle_velocity) * delta)  # Gets collision
	verticle_velocity *= 1.10
	horizontal_velocity *= 0.99
	# If a collision is recorded, and it's not the floor, then it ends the dash
	if collision:
		var collider = collision.get_collider()

		if not collider.is_in_group("Player") and not owner.is_on_floor():
			end_horizontal_momentum()
			
		elif not collider.is_in_group("Player") and owner.is_on_floor():
			end_slam(owner)
			
		elif collider.is_in_group("Player") and owner.is_on_floor(): # Handles getting stuck on opponents head
			var push_dir = sign(owner.position.x - collider.position.x)
			owner.velocity.x = clamp(owner.velocity.x + push_dir * 200, -300, 300)
			
# Gets called from process_dash()
func end_slam(player):
	owner.anim_sprite.play("LandSlam")
	owner.velocity.x = 0
	check_slam_hits()
	await owner.get_tree().create_timer(land_slam_duration).timeout
	owner.slamming = false
	owner.is_using_ability = false
	await owner.get_tree().create_timer(cooldown).timeout
	owner.slam_on_cooldown = false
	owner.ability_anim_sprite.play("Slam")
		
func end_horizontal_momentum():
	owner.velocity.x = 0
	horizontal_velocity = 0

func check_slam_hits():
	slam_height -= owner.global_position.y
	var slam_time = 0.5 + min(0.5, abs(slam_height)/1000)
	var bodies = owner.slam_area.get_overlapping_bodies()
	for body in bodies:
		if body.get_multiplayer_authority() != owner.slam_area.get_multiplayer_authority():
			if body.is_in_group("Ninja"):
				#print("Ninja Slammed")
				body.take_knockback(slam_time, owner.global_position.x)
			elif body.is_in_group("Sumo"):
				#print("Sumo SLammed")
				body.take_knockback(slam_time * 0.75, owner.global_position.x)

func end_slam_if_slammed():
	owner.slamming = false
	owner.is_using_ability = false
	await owner.get_tree().create_timer(cooldown).timeout
	owner.slam_on_cooldown = false
