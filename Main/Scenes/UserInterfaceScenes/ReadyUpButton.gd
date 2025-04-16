extends Control


var is_ready: bool = false
var player_id = 0
signal ready_pressed(id)  # Signal that gets emitted when the button is pressed

func _ready():
	
	if multiplayer.is_server():
		player_id = multiplayer.get_unique_id()
		
		if player_id != multiplayer.get_unique_id():
			self.disabled = true

func _on_pressed():
	is_ready = !is_ready
	if is_ready:
		self.text = "Ready!"
	else:
		self.text = "Ready Up"
		
	ready_pressed.emit(player_id)
