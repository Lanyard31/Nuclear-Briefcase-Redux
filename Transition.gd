extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.play()
	load("res://main.tscn")



func _on_Transition_animation_finished():
	get_tree().change_scene("res://main.tscn") 
