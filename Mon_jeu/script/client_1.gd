extends Area2D  # Important : ton client doit être un Area2D

@onready var speech_bubble = $SpeechBubble
@onready var label = $SpeechBubble/Label

var player_near = false

func _ready():
	# On ne parle pas tout de suite → on attend que customer2 nous appelle
	speech_bubble.visible = false
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		player_near = true

func _on_body_exited(body):
	if body.name == "player":
		player_near = false

func _process(delta):
	if player_near and Input.is_action_just_pressed("ui_accept"):
		var player = get_tree().current_scene.get_node("player")
		
		if player.inventory["café"] > 0:
			player.inventory["café"] -= 1
			player.update_inventory_display()
			player.add_money(1)

			print("Client : Merci pour le café ☕ !")
			speak("Merci !!")

			await get_tree().create_timer(2.0).timeout
			hide_bubble()
		else:
			print("Client : Tu n’as pas de café à me donner.")

func speak(text: String):
	label.text = text
	speech_bubble.visible = true

func hide_bubble():
	speech_bubble.visible = false
