extends Node

signal launching
signal shoot
signal redshoot

export (PackedScene) var Nuke
export (PackedScene) var City

var population = 100
var missilecount = 100
var can_shoot = true
var position
var _position
var _direction
var target
var speed = 4
var spawncity
var spawnhere
var spawnherespot = Vector2()
var spawnherecollisionremove

var ally_assigner
var ally1
var ally2
var ally3
var Nationsnumber
var newally
var x
var y = 0
var ally1members
var ally2members
var ally3members
var member
var group = null

var Nations = ["FINLAND", "france", "ALGERIA", "australia", "BURKINA_FASO", "brazil", "russia"]

#var Nations = ["ALGERIA", "australia", "BURKINA_FASO", "brazil", "CHINA", "chile", "DENMARK", "dominican_republic", "EGYPT", "england", 
#			"FINLAND", "france", "GERMANY", "ghana", "HONDURAS", "hungary", "INDIA", "israel", "JAMAICA", "japan", "KOREA", "kazakhstan", 
#			"LESOTHO", "lithuania", "MADAGASCAR", "mexico", "NEW_ZEALAND", "norway", "OMAN", "PAKISTAN", "panama", "QATAR", "ROMANIA", 
#			"russia", "SAUDI_ARABIA", "switzerland", "THAILAND", "turkey", "UKRAINE", "united_states", "VENEZUELA", "vietnam", "YEMEN", "ZAMBIA", "zimbabwe"]


func _ready():
	#Randomly choose a nation location for the player to spawn at, disable NPCity there
	randomize()
	var spawncity = Nations[randi() % Nations.size()]
	print("Player Spawned:", spawncity) 
	spawnhere = 'Nations'.plus_file(spawncity)
	get_node(spawnhere).set_modulate(Color(0.7, 0.7, 1))
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
	ally_assigner = 'Nations'.plus_file('ZAMBIA')
	ally_assigner = get_node(ally_assigner)
	ally_assigner.add_to_group('ally2')
	
	ally_assigner = 'Nations'.plus_file('zimbabwe')
	ally_assigner = get_node(ally_assigner)
	ally_assigner.add_to_group('ally3')
	
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
			#print(x)
			if x == 0:
				ally_assigner.add_to_group('ally1')
			elif x == 1:
				ally_assigner.add_to_group('ally2')
			elif x == 2:
				ally_assigner.add_to_group('ally3')
		
	var ally1members = get_tree().get_nodes_in_group("ally1")
	#print("Ally Group 1:", ally1members)
	var ally2members = get_tree().get_nodes_in_group("ally2")
	#print("Ally Group 2:", ally2members)
	var ally3members = get_tree().get_nodes_in_group("ally3")
	#print("Ally Group 3:", ally3members)
		
	for member in ally1members: #blue
		member.set_modulate(Color(0.1, 0.1, 1.0))
	for member in ally2members: #red
		member.set_modulate(Color(0.8, 0.4, 0.2))
	for member in ally3members: #yellow
		member.set_modulate(Color(1.0, 1.0, 0.1)) 
		
		
	#add_to_group(ally1)
	#traverse Nation List
	#Select random allies
	#Assign them to groups
	#change their color modulation

func _process(delta):
	group = null
	NPCfire()
	if Input.is_action_just_pressed("a"):
		if Input.is_action_pressed("shift"):
			fire_missile('ALGERIA')
			return
		fire_missile('australia')
	if Input.is_action_just_pressed("b"):
		if Input.is_action_pressed("shift"):
			fire_missile('brazil')
			return
		fire_missile('BURKINA_FASO')
	if Input.is_action_just_pressed("f"):
		if Input.is_action_pressed("shift"):
			fire_missile('FINLAND')
			return
		fire_missile('france')
	
func NPCfire(): #target acquisition
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		var ally1members = get_tree().get_nodes_in_group("ally1")
		var ally2members = get_tree().get_nodes_in_group("ally2")
		var ally3members = get_tree().get_nodes_in_group("ally3")
		for member in ally1members: #blue
			if member.is_in_group("player"):
				pass
			else:
				x = rand_range(0.001, 1)
				if x >= 0.5:
					var target = ally2members[randi() % ally2members.size()]
					fire_NPCNuke(member, target)
				elif x <= 0.5:
					var target = ally3members[randi() % ally3members.size()]
					fire_NPCNuke(member, target)
						#attack ally2members
						#attack ally3members
		for member in ally2members: #red
			group = true
			x = rand_range(0.001, 1)
			if x >= 0.5:
				var target = ally1members[randi() % ally1members.size()]
				fire_NPCNuke_red(member, target, group)
			elif x <= 0.5:
				var target = ally3members[randi() % (ally3members.size())]
				fire_NPCNuke_red(member, target, group)
		for member in ally3members: #yellow
			group = true
			x = rand_range(0.001, 1)
			if x >= 0.5:
				var target = ally1members[randi() % ally1members.size()]
				fire_NPCNuke_red(member, target, group)
			elif x <= 0.5:
				var target = ally2members[randi() % ally2members.size()]
				fire_NPCNuke_red(member, target, group)

func fire_NPCNuke(_member, _target): #firing code for allies
	target = _target
	member = _member
#	target = _target
#	print(target)
#	target = get_node(target)
#	target = ($Nations/france/Muzzle)
#	print(target)
#	var dir = (target.position).normalized() * speed
	$firemissile.play()
	var dir = (target.global_position - (member.global_position)).normalized() * speed
	if dir == Vector2(0, 0):
		#Insert code here for Playercity to take Damage, or show fail screen "You Nuked Yourself"
		return #this is broken because you don't have a turret
	emit_signal('shoot', Nuke, member.global_position, dir)
	return
	
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

	
func fire_missile(_target):
	target = 'Nations'.plus_file(_target).plus_file('Muzzle')
#	target = _target
#	print(target)
	target = get_node(target)
#	target = ($Nations/france/Muzzle)
#	print(target)
#	var dir = (target.position).normalized() * speed
	$firemissile.play()
	var dir = (target.global_position - ($PlayerCity/Muzzle.global_position)).normalized() * speed
	if dir == Vector2(0, 0):
		#Insert code here for Playercity to take Damage, or show fail screen "You Nuked Yourself"
		return #this is broken because you don't have a turret
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
	#subtract one from missilecount
	#create a missile at origin position
	#draw a line between origin and target
	#progress between origin and target
	#intercept other missiles if there are collisions
	#explosion anim at target
	#subtract from missile count and population

func _on_GunTimer_timeout():
	can_shoot = true
	$GunTimer.wait_time = rand_range(0.2, 1)
	pass # replace with function body
