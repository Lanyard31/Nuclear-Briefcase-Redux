extends StaticBody2D

export (int) var population
var HPpopfull
var HPpopnew
var setHP
signal progress_update
var dead = false

func _ready():
	randomize()
	population = int(round(population * rand_range(0.5, 2.4)))
	HPpopfull = population
	return HPpopfull
	
	
#func _process(delta):
#	pass

func take_damage(damage):
	if population >= 0:
		population = population - damage
		HPpopnew = population
#		str(_population) = population
#		print(population)
		var printme = "Pop: %sk"
		var printme2 = printme % population
		$Pop_count.set_text(printme2)
		setHP = ((HPpopnew / HPpopfull) * 100)
#		print(HPpopnew / HPpopfull)
		emit_signal('progress_update', setHP)
	if population <= 0:
		if dead == false:
			dead = true
			hide()
		else:
			pass
		
func _update_progress(setHP):
#	print(setHP)
	$HP.value = setHP
