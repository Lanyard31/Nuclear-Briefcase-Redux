extends Node

signal launching
signal shoot
signal redshoot

export (PackedScene) var Nuke
export (PackedScene) var City

var allylimit = 8
var population = 1000
var deadpop = 0
var missilecount = 100
var can_shoot = true
var position
var _position
var _direction
var target
var speed = 2.1
var spawncity
var spawnhere
var spawnherespot = Vector2()
var spawnherecollisionremove
var worldpopulation = 0
var worldpopulationdisplayinit
var worldpopulationdisplay
var poptimerdone = false
var randtimervar = true

var ally_assigner
var ally1
var ally2
var ally3
var Nationsnumber
var newally
var x
var y = 0
var z = 0
var r
var ally1members
var ally2members
var ally3members
var member
var group = null
var playercanshoot = true

var Nations = ["algeria", "AUSTRALIA", "BURKINA_FASO", "brazil", "CHINA", "chile", "DENMARK", "dominican_republic", "EGYPT", "england", 
			"FINLAND", "france", "GERMANY", "ghana", "HONDURAS", "hungary", "INDIA", "israel", "JAMAICA", "japan", "KOREA", "kazakhstan", 
			"LESOTHO", "lithuania", "MADAGASCAR", "mexico", "NEW_ZEALAND", "norway", "OMAN", "PAKISTAN", "panama", "QATAR", "ROMANIA", 
			"russia", "SAUDI_ARABIA", "switzerland", "THAILAND", "turkey", "UKRAINE", "united_states", "VENEZUELA", "vietnam", "YEMEN", "ZAMBIA", "zimbabwe"]


func _ready():
	global.globalworldpop = 1
	global.playerdead = false
	global.howtoplay = 0
	global.ally1global = ""
	global.selfnuked = false
	global.startdelay = false
	global.winstate = false
	
	
	#$GunTimer.wait_time = rand_range(0.5, 3)
	
	worldpopulationdisplayinit = str(global.globalworldpop)
	$pop.text = (worldpopulationdisplayinit + "0k")
	
	$allylist.set_modulate(Color(0.0941176470588235, 0.9098039215686275, 0.7137254901960784))
	
	$Worldmap/AnimationPlayer.play("fuzzy")#Randomly choose a nation location for the player to spawn at, disable NPCity there
	randomize()
	var spawncity = Nations[(randi() % Nations.size() - 2)]
	print("Player Spawned:", spawncity) 
	spawnhere = 'Nations'.plus_file(spawncity)
	get_node(spawnhere).set_modulate(Color(1, 1, 1))
	get_node(spawnhere).emit_signal('cityinitialcancel')
	global.globalworldpop -= get_node(spawnhere).population
	spawnherespot = get_node(spawnhere).position
	var p = City.instance()
	add_child(p)
	$PlayerCity.position = spawnherespot
	$PlayerCity.add_to_group('ally1')
	$PlayerCity.add_to_group('player')
	spawnherecollisionremove = 'Nations'.plus_file(spawncity).plus_file('CollisionShape2D')
	get_node(spawnherecollisionremove).queue_free()
	#use a dictionary
	#concatenate a path target = 'Nations'.plus_file(_target).plus_file('Muzzle')
	#navigate to Nations tree 
	#queuefree a Nation
	#Create PlayerCity node
	
	#Zambia and Zimbabwe make sure ally2 and ally3 have one member to prevent division by zero
	ally_assigner = 'Nations'.plus_file('ZAMBIA')
	ally_assigner = get_node(ally_assigner)
	ally_assigner.add_to_group('ally2')
	
	ally_assigner = 'Nations'.plus_file('zimbabwe')
	ally_assigner = get_node(ally_assigner)
	ally_assigner.add_to_group('ally3')
	
	#we assign the rest of the allies
	for i in Nations:
		y += 1
		if y >= (Nations.size() + 1):
			return
		elif i == spawncity:
			pass
		else:
			ally_assigner = 'Nations'.plus_file(i)
			ally_assigner = get_node(ally_assigner)
			x = (randi() % 3)
			var allygroup1check = get_tree().get_nodes_in_group("ally1")
#			print(allygroup1check.size())
			#print(x)
			if x == 0:
				#HERE LIMIT ALLY NUMBER
				if allygroup1check.size() <= (allylimit):
					var forally1global = ally_assigner.get_name()
					global.ally1global = (global.ally1global + str(forally1global) + str("\n"))
					ally_assigner.add_to_group('ally1')
			elif x == 1:
				ally_assigner.add_to_group('ally2')
			elif x == 2:
				ally_assigner.add_to_group('ally3')
		
		#skippedcatcher
	for i in Nations:
		if i == spawncity:
			pass
		else:
			ally_assigner = 'Nations'.plus_file(i)
#			print(ally_assigner)
			ally_assigner = get_node(ally_assigner)
#			print(ally_assigner)
			if ally_assigner.is_in_group('ally1') == false:
				if ally_assigner.is_in_group('ally2') == false:
					if ally_assigner.is_in_group('ally3') == false:
						print("caughtone")
						ally_assigner.add_to_group('ally2')
#			else:
#				ally_assigner.add_to_group('ally2')

		
		
#	for i in Nations:
#		z += 1
#		print(z)
#		if z >= (Nations.size() + 1):
#			return
#		elif i == spawncity:
#			pass
#		else:
#			ally_assigner = 'Nations'.plus_file(i)
##			print(ally_assigner)
#			ally_assigner = get_node(ally_assigner)
##			print(ally_assigner)
#			x = (randi() % 2)
#			if x == 0:
#				if ally_assigner.is_in_group('ally1'):
#					if ally_assigner.is_in_group('ally2'):
#						if ally_assigner.is_in_group('ally3'):
#							return
#				else:
#					ally_assigner.add_to_group('ally2')
#			if x == 1:
#				if ally_assigner.is_in_group('ally1'):
#					if ally_assigner.is_in_group('ally2'):
#						if ally_assigner.is_in_group('ally3'):
#							return
#				else:
#					ally_assigner.add_to_group('ally3')
		
	var ally1members = get_tree().get_nodes_in_group("ally1")
	print("Ally Group 1:", ally1members)
	var ally2members = get_tree().get_nodes_in_group("ally2")
	print("Ally Group 2:", ally2members)
	var ally3members = get_tree().get_nodes_in_group("ally3")
	print("Ally Group 3:", ally3members)
		
	for member in ally1members: #blue
		member.set_modulate(Color(0.0941176470588235, 0.9098039215686275, 0.7137254901960784))
		member.set_scale(Vector2(0.01, 0.01))
	for member in ally2members: #red
		member.set_modulate(Color(0.9098039215686275, 0.0941176470588235, 0.5607843137254902))
		member.set_scale(Vector2(0.01, 0.01))
	for member in ally3members: #yellow
		member.set_modulate(Color(0.9372549019607843, 0.2627450980392157, 0.1058823529411765))
		member.set_scale(Vector2(0.01, 0.01))
	$PlayerCity.set_modulate(Color(1, 1, 1))
	#$PlayerCity.set_scale(Vector2(0.1, 0.1))
		
		
	#add_to_group(ally1)
	#traverse Nation List
	#Select random allies
	#Assign them to groups
	#change their color modulation

func _process(delta):
	#gameovercheckdisplay
	if global.playerdead == true:
		if global.selfnuked == false:
			$gameover.show()
	
	#population updater :  IS it here?
	#if global.globalworldpop <= 0:
	#	$pop.hide()
	
	if global.globalworldpop >= 100000:
		worldpopulationdisplay = str(global.globalworldpop)
		$pop.text = (worldpopulationdisplay + "0k")
		$pop.set_modulate(Color(1, 1, 1))
	else:
		$pop.text = ("critical")
		$pop.set_modulate(Color(0.9098039215686275, 0.0941176470588235, 0.5607843137254902))
	
	
#	$GunTimer.wait_time = rand_range(0.5, 3)
#	allygroupchecker()
	group = null
	NPCfire()
	
	if playercanshoot:
		if Input.is_action_just_pressed("a"):
			if Input.is_action_pressed("shift"):
				fire_missile('AUSTRALIA')
				return
			fire_missile('algeria')
		if Input.is_action_just_pressed("b"):
			if Input.is_action_pressed("shift"):
				fire_missile('brazil')
				return
			fire_missile('BURKINA_FASO')
		if Input.is_action_just_pressed("c"):
			if Input.is_action_pressed("shift"):
				fire_missile('CHINA')
				return
			fire_missile('chile')
		if Input.is_action_just_pressed("d"):
			if Input.is_action_pressed("shift"):
				fire_missile('DENMARK')
				return
			fire_missile('dominican_republic')
		if Input.is_action_just_pressed("e"):
			if Input.is_action_pressed("shift"):
				fire_missile('EGYPT')
				return
			fire_missile('england')
		if Input.is_action_just_pressed("f"):
			if Input.is_action_pressed("shift"):
				fire_missile('FINLAND')
				return
			fire_missile('france')
		if Input.is_action_just_pressed("g"):
			if Input.is_action_pressed("shift"):
				fire_missile('GERMANY')
				return
			fire_missile('ghana')
		if Input.is_action_just_pressed("h"):
			if Input.is_action_pressed("shift"):
				fire_missile('HONDURAS')
				return
			fire_missile('hungary')
		if Input.is_action_just_pressed("i"):
			if Input.is_action_pressed("shift"):
				fire_missile('INDIA')
				return
			fire_missile('israel')
		if Input.is_action_just_pressed("j"):
			if Input.is_action_pressed("shift"):
				fire_missile('JAMAICA')
				return
			fire_missile('japan')
		if Input.is_action_just_pressed("k"):
			if Input.is_action_pressed("shift"):
				fire_missile('KOREA')
				return
			fire_missile('kazakhstan')
		if Input.is_action_just_pressed("l"):
			if Input.is_action_pressed("shift"):
				fire_missile('LESOTHO')
				return
			fire_missile('lithuania')
		if Input.is_action_just_pressed("m"):
			if Input.is_action_pressed("shift"):
				fire_missile('MADAGASCAR')
				return
			fire_missile('mexico')
		if Input.is_action_just_pressed("n"):
			if Input.is_action_pressed("shift"):
				fire_missile('NEW_ZEALAND')
				return
			fire_missile('norway')
		if Input.is_action_just_pressed("o"):
			if Input.is_action_pressed("shift"):
				fire_missile('OMAN')
				return
		if Input.is_action_just_pressed("p"):
			if Input.is_action_pressed("shift"):
				fire_missile('PAKISTAN')
				return
			fire_missile('panama')
		if Input.is_action_just_pressed("q"):
			if Input.is_action_pressed("shift"):
				fire_missile('QATAR')
				return
		if Input.is_action_just_pressed("r"):
			if Input.is_action_pressed("shift"):
				fire_missile('ROMANIA')
				return
			fire_missile('russia')
		if Input.is_action_just_pressed("s"):
			if Input.is_action_pressed("shift"):
				fire_missile('SAUDI_ARABIA')
				return
			fire_missile('switzerland')
		if Input.is_action_just_pressed("t"):
			if Input.is_action_pressed("shift"):
				fire_missile('THAILAND')
				return
			fire_missile('turkey')
		if Input.is_action_just_pressed("u"):
			if Input.is_action_pressed("shift"):
				fire_missile('UKRAINE')
				return
			fire_missile('united_states')
		if Input.is_action_just_pressed("v"):
			if Input.is_action_pressed("shift"):
				fire_missile('VENEZUELA')
				return
			fire_missile('vietnam')
		if Input.is_action_just_pressed("y"):
			if Input.is_action_pressed("shift"):
				fire_missile('YEMEN')
				return
		if Input.is_action_just_pressed("z"):
			if Input.is_action_pressed("shift"):
				fire_missile('ZAMBIA')
				return
			fire_missile('zimbabwe')
			
			
		if Input.is_action_just_pressed("backspace"):
			if global.mute == false:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -100) #mute
				global.mute = true
			else:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0) #mute
				global.mute = false
				
				
		if Input.is_action_just_pressed("enter"):
			if global.winstate == true:
				global.winstate = false
				global.globalworldpop = 1 #part of youwin globals
				get_tree().reload_current_scene()
	
func NPCfire(): #target acquisition
	if can_shoot and global.startdelay == true:
		can_shoot = false
		$GunTimer.start()
		$GunTimer2.start()
		var ally1members = get_tree().get_nodes_in_group("ally1")
		var ally2members = get_tree().get_nodes_in_group("ally2")
		var ally3members = get_tree().get_nodes_in_group("ally3")
		for member in ally1members: #blue
			if member.is_in_group("player"):
				pass
			elif member.is_visible() == false:
				pass
			else:
				x = rand_range(0.001, 1)
				if x > 0.5:
					var target = ally2members[randi() % ally2members.size()]
					if target.is_visible() == false:
						target = ally2members[randi() % ally2members.size()]
					if target.is_visible() == false:
						target = ally2members[randi() % ally2members.size()]
					fire_NPCNuke(member, target)
				elif x <= 0.5:
					var target = ally3members[randi() % ally3members.size()]
					if target.is_visible() == false:
						target = ally3members[randi() % ally3members.size()]
					if target.is_visible() == false:
						target = ally3members[randi() % ally3members.size()]
					fire_NPCNuke(member, target)
						#attack ally2members
						#attack ally3members
		for member in ally2members: #red
			group = true
			if member.is_visible() == false:
				pass
			else:
				x = rand_range(0.001, 1)
				if x > 0.4:
					var target = ally1members[randi() % ally1members.size()]
					if target.is_visible() == false:
						target = ally1members[randi() % ally1members.size()]
					if target.is_visible() == false:
						target = ally1members[randi() % ally1members.size()]
					fire_NPCNuke_red(member, target, group)
				elif x <= 0.6:
					var target = ally3members[randi() % ally3members.size()]
					if target.is_visible() == false:
						target = ally3members[randi() % ally3members.size()]
					if target.is_visible() == false:
						target = ally3members[randi() % ally3members.size()]
					fire_NPCNuke_red(member, target, group)
		for member in ally3members: #yellow
			group = true
			if member.is_visible() == false:
				pass
			else:
				x = rand_range(0.001, 1)
				if x > 0.4:
					var target = ally1members[randi() % ally1members.size()]
					if target.is_visible() == false:
						target = ally1members[randi() % ally1members.size()]
					if target.is_visible() == false:
						target = ally1members[randi() % ally1members.size()]
					fire_NPCNuke_red(member, target, group)
				elif x <= 0.6:
					var target = ally2members[randi() % ally2members.size()]
					if target.is_visible() == false:
						target = ally2members[randi() % ally2members.size()]
					if target.is_visible() == false:
						target = ally2members[randi() % ally2members.size()]
					fire_NPCNuke_red(member, target, group)

func fire_NPCNuke(_member, _target): #firing code for allies
	#$Randtimer.start()
	#if randtimervar == false:
	#	randtimervar = true
	#elif randtimervar == true:
	target = _target
	member = _member
	$firemissile.play()
	var dir = (target.global_position - (member.global_position)).normalized() * speed
	if dir == Vector2(0, 0):
		return
	emit_signal('shoot', Nuke, member.global_position, dir)
	return
	
# $randtimer.start()
# if randtimer variable is false
# variable is true
# if variable is true
# rest of code
#
	
func fire_NPCNuke_red(_member, _target, _group): #firing code for enemies
	target = _target
	member = _member
	group = _group
	$firemissile.play()
	var dir = (target.global_position - (member.global_position)).normalized() * speed
	if dir == Vector2(0, 0):
		return 
	emit_signal('redshoot', Nuke, member.global_position, dir, group)
	return

	
func fire_missile(_target): # firing code for player
	target = 'Nations'.plus_file(_target).plus_file('Muzzle')
	target = get_node(target)
	$firemissile.play()
	var dir
	var num = randi() % 1 + 0.5
	if target.is_visible() == false or target == null:
		dir = (num * (target.global_position - ($PlayerCity/Muzzle.global_position)).normalized() * speed)
	else:
		dir = (target.global_position - ($PlayerCity/Muzzle.global_position)).normalized() * speed
	if dir == Vector2(0, 0): #This means you nuked yourself
		$self_nuke.show()
		$selfnukeboom.play()
		global.selfnuked = true
		playercanshoot = false
		$playerloss.play()
		$selfnuketimer.start()
		return
	emit_signal('shoot', Nuke, $PlayerCity/Muzzle.global_position, dir)
	return
#		shoot signal leads to on_missile_fire
	

func _on_missile_fire(Nuke, _position, _direction):
	var b = Nuke.instance()
	add_child(b)
	b.start(_position, _direction, group)
	
func _on_redshoot(Nuke, _position, _direction, group):
	var b = Nuke.instance()
	add_child(b)
	b.start(_position, _direction, group)
	$doomsdaytimer.start()
	
	#subtract one from missilecount
	#create a missile at origin position
	#draw a line between origin and target
	#progress between origin and target
	#intercept other missiles if there are collisions
	#explosion anim at target
	#subtract from missile count and population

func _on_GunTimer_timeout():
	can_shoot = true
	$GunTimer.wait_time = rand_range(0.8, 3)
	$GunTimer2.wait_time = rand_range(1.5, 3.3)
	
func _on_ballettimer_timeout():
	$ballet.play()
	pass
	
func _on_selfnuketimer_timeout():
		global.playerdead == true
		global.playerdead = false
		global.globalworldpop = 1
		global.ally1global = ""
		global.selfnuked = false
		global.startdelay = false
		get_tree().reload_current_scene()
		

func _on_doomsdaytimer_timeout(): # FAILSTATE
	$youwin.show()
	global.playerdead = false
	global.globalworldpop = 1
	global.ally1global = ""
	global.selfnuked = false
	global.startdelay = false
	global.winstate = true
	print("youwin")
	
	
func _on_allytimer_timeout():
	allylist()
	
func allylist():
	#print(global.ally1global)
	$allylist.text = str(global.ally1global)


func _on_startdelay_timeout():
	global.startdelay = true
	$Worldmap/AnimationPlayer.play("mutefade")


func _on_Randtimer_timeout():
	$Randtimer.start()
	randtimervar = true


	# randtimer timeout (autostart)
# new randtime
# randtimer variable is false


func _on_quit_pressed():
	if global.winstate == true:
		get_tree().quit()
