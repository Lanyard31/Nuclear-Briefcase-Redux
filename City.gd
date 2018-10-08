extends StaticBody2D

export (PackedScene) var Skull

export (int) var population
var HPpopfull
var HPpopnew
var setHP
signal progress_update
var dead = false
signal cityinitial
var worldpop = false
var deadpop
var worldpopulationdisplayinit
signal cityinitialcancel
var ally1bonus = 5 #this is a multiplier
var playerbonuspop = 5.72 #this is a multiplier, best at 5 (or maybe 5.75)

func _ready():
	$popcatch.start()
	
	
	
	#possibly buggy code
#	if self.is_in_group("player"):
#		_on_citydelayer_timeout()
#		self.set_scale(Vector2(1.0, 1.0))
#		if self.has_method("_indicator"):
#			_indicator()
#			return
#	else:
#		$citydelayer.wait_time = rand_range(0.2, 2.3)
#		$citydelayer.start()
	#print(population)
	
#func _process(delta):
#	pass

func take_damage(damage):
	if population >= 0:
		deadpop = damage
		if damage > population:
			deadpop = population
			global.globalworldpop -= deadpop
		else:
			deadpop = damage
			global.globalworldpop -= deadpop
		population = population - damage
		HPpopnew = population
#		str(_population) = population
#		print(population)
		var printme = "%s0k"
		var printme2 = printme % population
		$Pop_count.set_text(printme2)
		setHP = ((HPpopnew / HPpopfull) * 100)
#		print(HPpopnew / HPpopfull)
		emit_signal('progress_update', setHP)
		
	if population <= 0:
		population == 0
#		emit_signal('cityupdate', deadpop)
		$Pop_count.hide()
		if dead == false:
			dead = true
			if self.is_in_group("ally2members"):
				self.remove_from_group("ally2members")
				print("ally2members")
			if self.is_in_group("ally3members"):
				self.remove_from_group("ally3members")
				print("ally3members")
			$Kaboom.play()
			self.set_modulate(Color(1, 1, 1))
			$citydeath.play()
			$CollisionShape2D.queue_free()
		else:
			pass
		
func _update_progress(setHP):
#	print(setHP)
	$HP.value = setHP


func _on_citydeath_animation_finished():
	#Instance a skull?
#	var newskullpos = self.global_position
#	var s = Skull.instance()
#	add_child(s)
	#newskullpos.position = spawnherespot
	hide()




func _on_popcatch_timeout():
	if worldpop == false:
		worldpop = true
	population = int(round(population * rand_range(0.8, 1.2)))
	if self.is_in_group('ally1'):
		population = int(round(population * ally1bonus))
	if self.is_in_group('player'):
		population = int(round(population * playerbonuspop))
		print(population)
	HPpopfull = population
	emit_signal('cityinitial', population)
	#print(population)
	#self.set_scale
	
	$citydelayer.wait_time = rand_range(0.2, 2.3)
	$citydelayer.start()

func _on_cityinitial(population):
	global.globalworldpop += population
#	print(str(global.globalworldpop))


func _on_City_cityinitialcancel():
	global.globalworldpop -= population


func _on_citydelayer_timeout():
	$AnimationPlayer.play("citybuild")
