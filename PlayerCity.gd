extends "res://City.gd"

export (PackedScene) var Player_Collision
export (PackedScene) var gameoverscreen
signal game_over

var gameovercheck = false
var bonuspop

func _ready():
	pass
	#population = (population + bonuspop)
	#global.globalworldpop += bonuspop
	
func _process(delta):
	if population <= 0 and gameovercheck == false:
		emit_signal('game_over')
		gameovercheck = true
		self.show()
		$gameover.show()
		$gameovertimer.start()
		$gameoversound.play()
		print("game_over")

func _on_Collisionstart_timeout():
	var b = Player_Collision.instance()
	add_child(b)

func _on_gameovertimer_timeout():
		get_tree().reload_current_scene()


func _on_onedead_timeout():
	global.globalworldpop -= 1
