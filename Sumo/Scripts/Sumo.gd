class_name Sumo
extends Player

signal player_death

# Synchronized variables
@export var anim_sprite: AnimatedSprite2D
@export var ability_anim_sprite: AnimatedSprite2D
@export var aim_arrow: Node2D
@export var direction: int
@export var last_facing_direction: String = ""
@export var slamming: bool
@export var slam_on_cooldown: bool
@export var carbed_up: bool
@export var carb_up_on_cooldown: bool
@export var animation_locked: bool = false # used for animations that should not be overriden
@export var synchronizer: MultiplayerSynchronizer
@export var hitbox: CollisionShape2D
@export var slam_area: Area2D
@export var knocked_back: bool = false
@export var knockback_timer: float = 0
@export var knockback_duration: float
@export var knockback_speed: float = 250
@export var knockback_direction: String

const character: String = "Sumo"
enum States {IDLE, MOVING, JUMPING, ABILITY1, FALLING, KNOCKBACK}
var state = States.IDLE
var attack_on_cooldown: bool = false
var alive: bool = true
var current_animation: String = "" # Used to make sure animations dont repeat
var host: bool = true


func spawn_orientation_logic():
	if not host:
		anim_sprite.flip_h = true
		get_node("NinjaUI").scale.x = -1
		
func _init():
	pass
	
# Gets called when the scene is loaded
func _ready():
	await get_tree().process_frame
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_physics_process(false)
		
	# Adds the UI scene associated with Ninja to main scene
	if self.ability_ui_scene:
		self.ability_ui = self.ability_ui_scene.instantiate()
		self.ability_ui.set_player(self)
		add_child(self.ability_ui)
		self.ability_ui.set_multiplayer_authority(player_id)
		
	# Authority setting
	synchronizer.set_multiplayer_authority(player_id)
	aim_arrow.set_multiplayer_authority(player_id)
	anim_sprite.set_multiplayer_authority(player_id)
	ability_anim_sprite.set_multiplayer_authority(player_id)
	ability_anim_sprite.play("Default")
	slam_area.set_multiplayer_authority(player_id)
	spawn_orientation_logic()
	
	# Duplication of abilites is necessary, since abilities need owners for logic
	ability1 = ability1.duplicate()
	ability1.owner = self
	ability2 = ability2.duplicate()
	ability2.owner = self
	passive_ability = passive_ability.duplicate()
	passive_ability.owner = self
	
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		aim_arrow.visible = false
		
func _physics_process(delta):
	if alive:
		if get_multiplayer_authority() == multiplayer.get_unique_id() and not animation_locked and not slamming:
			direction = Input.get_axis("move_left", "move_right")
			if direction == 1:
				last_facing_direction = "Right"
				anim_sprite.flip_h = false
				get_node("NinjaUI").scale.x = 1
			elif direction == -1:
				last_facing_direction = "Left"
				anim_sprite.flip_h = true
				get_node("NinjaUI").scale.x = -1
			else:
				pass
			update_aim_indicator()
		
		# State Machine Functions
		handle_state_transitions()
		perform_state_actions(delta)
		move_and_slide()

# Handles state priority - Abilties, Jumping/Falling, Moving, Idle - Attack/ShortJump is seperate since they aren't states
func handle_state_transitions():
	if (Input.is_action_just_pressed("attack") and get_multiplayer_authority() == multiplayer.get_unique_id()):
		attack_action()
		
	if (Input.is_action_just_released("jump") and get_multiplayer_authority() == multiplayer.get_unique_id()) and velocity.y < 0:
		velocity.y *= 0.75 # Cut jump short for responsive feel
	
	if (Input.is_action_just_pressed("carb_up") and get_multiplayer_authority() == multiplayer.get_unique_id()) and not carb_up_on_cooldown:
		use_ability_2()
		
	if knocked_back:
		state = States.KNOCKBACK
		
	elif (Input.is_action_just_pressed("slam") and get_multiplayer_authority() == multiplayer.get_unique_id()) or slamming:
		#This is how to override trying to use abilities while another is being used, as the state of the ability being used will be kept 
		if not is_using_ability: 
			state = States.ABILITY1
			
	#Velocity check is for state preservation, same for falling
	elif (Input.is_action_just_pressed("jump") and get_multiplayer_authority() == multiplayer.get_unique_id()) or velocity.y < 0:  # Switch back to elif once slam is implemented
		state = States.JUMPING
		
	elif not is_on_floor() and velocity.y >= 0:
		state = States.FALLING
		
	elif direction != 0:
		state = States.MOVING
		
	elif is_on_floor() and state != States.JUMPING:
		state = States.IDLE

# Adjusts player behavior based off of state
func perform_state_actions(delta):
	# Applies normal gravity, any more/less gravity is applied in specific states
	velocity.y += gravity * delta
	match state:
		# Reset jumps
		States.IDLE:
			if not animation_locked: # Animation priority
				anim_sprite.play("Idle")
				current_animation = "Idle"
			velocity.x = 0
		# Reset jumps, adjust velocity based on direction
		States.MOVING:
			if not animation_locked: # Animation priority
				anim_sprite.play("Run")
				current_animation = "Run"
			velocity.x = speed * direction
			
		States.ABILITY1:
			use_ability_1(delta)
			
		# Makes sure they have jumps left
		States.JUMPING:
			if is_on_floor():
					jump()
					if not animation_locked: # Animations like hurt have priority
						#anim_sprite.stop()
						anim_sprite.play("Jump")
						current_animation = "Jump"
			velocity.x = speed * direction
		# Higher gravity while falling for better gameplay feeling, also still allows player to move
		States.FALLING:
			if not animation_locked:
				#anim_sprite.stop()
				anim_sprite.play("Fall")
				current_animation = "Fall"
			velocity.y += gravity * delta * 3 # This is gravity * 2.5, since regular gravity is applied to each state, so its just adding 1.5 more
			velocity.x = speed * direction
		
		States.KNOCKBACK:
			if knockback_direction == "Right":
				velocity.x = knockback_speed * 1
				if last_facing_direction == "Left":
					anim_sprite.play("KnockbackInner")
				else:
					anim_sprite.play("KnockbackOuter")
					
			else:
				velocity.x = knockback_speed * -1
				if last_facing_direction == "Left":
					anim_sprite.play("KnockbackOuter")
				else:
					anim_sprite.play("KnockbackInner")
				
			velocity.x *= 1 - ((knockback_duration-knockback_timer)/knockback_duration) # Makes the player knockback slow down throughout
			knockback_timer -= delta
			if knockback_timer <= 0:
				animation_locked = false
				knocked_back = false
				
func jump():
	velocity.y = -jump_force

# Bullet Instantiation and handles attack UI element and boolean trigger/adjustment
func attack_action():
	if not is_using_ability and not attack_on_cooldown:
		# Spawns bullet and returns bullet data for rpc
		var bullet_spawn_info = attack.execute(self)
		spawn_attack_object_rpc.rpc(bullet_spawn_info)
		
		# Can't go in the bullet scripts since we have to return the bullet data for the rpc
		await get_tree().create_timer(attack.cooldown).timeout
		#ability_anim_sprite.play("Attack")
		attack_on_cooldown = false	

# Starts the dash or does during-dash logic to detect collisions
func use_ability_1(delta):
	if slamming:
		ability1.process_slam(self, delta)
	elif not slam_on_cooldown and not is_on_floor():
		ability1.execute(self)
		
func  use_ability_2(delta = null):
	ability2.execute(self)
		
# Double Jump, just subtracts one from jumps
func use_passive_ability():
	passive_ability.execute(self)
		
# Updates the aim arrow for player to see where they are shooting
func update_aim_indicator():
	var mouse_pos = get_global_mouse_position()  # Get mouse position in world coordinates
	var direction = (mouse_pos - global_position).normalized()  # Get direction to mouse
	var angle = direction.angle()  # Get angle in radians
	var position = Vector2(45 * cos(angle), 60 * sin(angle))
	aim_arrow.position = Vector2(45 * cos(angle), 60 * sin(angle))
	#update_aim_indicator_rpc.rpc(position, get_multiplayer_authority()) 
	 
# Same as direction, but has base condition to avoid the 0 check
func get_dash_direction():
	return -1 if velocity.x < 0 else 1

func take_damage(damage):
	health -= damage
	if health > 0:
		if get_multiplayer_authority() == multiplayer.get_unique_id(): # Happens on both screens, so plays on host and then gets synced
			#anim_sprite.play("Hurt")
			#current_animation = "Hurt"
			#animation_locked = true
			self.ability_ui.update_hearts(health)
			if health <= 40:
				use_passive_ability()
	else:
		if get_multiplayer_authority() == multiplayer.get_unique_id():
			alive = false
			anim_sprite.play("Death") # Play death animation
			current_animation = "Death"
			animation_locked = true
			self.ability_ui.update_hearts(0)
			await get_tree().create_timer(2).timeout
			player_death.emit()

func _on_animated_sprite_2d_animation_finished():
	if anim_sprite.animation in ["Hurt", "Death", "Attack", "Slam", "LandSlam"]: # Each of these animations means animation is locked, so when they end, it resets the bool
		animation_locked = false
		
func _on_ability_reset_sprite_animation_finished():
	ability_anim_sprite.play("Default") # Resets to empty animation 
	
func take_knockback(knockback_time, slammer_position_x):
	take_knockback_rpc.rpc(knockback_time, slammer_position_x)
	
@rpc("any_peer")
func take_knockback_rpc(knockback_time, slammer_position_x):
	#print("taking knockback")
	if not knocked_back and get_multiplayer_authority() == multiplayer.get_unique_id():
		if slamming:
			ability1.end_slam_if_slammed()
		knocked_back = true
		knockback_timer = knockback_time
		knockback_duration = knockback_time
		animation_locked = true
		if slammer_position_x > global_position.x:
			knockback_direction = "Left"
		else:
			knockback_direction = "Right"
# Not used but keep, I'm not sure if this actually isn't needed entirely yet
@rpc("any_peer")
func update_aim_indicator_rpc(position, authority_id):
	if aim_arrow.get_multiplayer_authority() == authority_id:
		aim_arrow.position = position
		
@rpc("any_peer")
func spawn_attack_object_rpc(bullet_spawn_info):
	var player_direction = bullet_spawn_info[0]
	var spawn_position = bullet_spawn_info[1]
	var bullet = Bullet.new_bullet(self, player_direction, spawn_position, character)
	self.get_tree().current_scene.add_child(bullet)

