extends "res://City.gd"

export (PackedScene) var Player_Collision
export (PackedScene) var gameoverscreen
signal game_over

var gameovercheck = false
var bonuspop

func _ready():
	pass
	#bonuspop = round(0.5 * population)
	#population = (population + bonuspop)
	#global.globalworldpop += bonuspop
	
func _process(delta):
	if population <= 0 and gameovercheck == false and global.winstate == false:
		emit_signal('game_over')
#		$skull.show()
		global.playerdead = true
		gameovercheck = true
#		$Sprite.show()
#		self.show()
#		$gameover.show()
		$gameovertimer.start()
		$gameoversound.play()
		global.playerdead == true
		print("game_over")
	if global.startdelay == true:
		_indicator()
	if global.selfnuked == true:
		$citydeath.play()

func _on_Collisionstart_timeout():
	var b = Player_Collision.instance()
	add_child(b)
	print("playercollision")

func _on_gameovertimer_timeout(): #FAILSTATE
		global.playerdead = false
		global.globalworldpop = 1
		global.ally1global = ""
		global.selfnuked = false
		global.startdelay = false
		global.critical = false
		get_tree().reload_current_scene()


func _on_onedead_timeout():
	global.globalworldpop -= 1

func _indicator():
	$indicator.play()