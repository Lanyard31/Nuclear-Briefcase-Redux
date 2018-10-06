extends Node

signal launching
signal shoot

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

var ally1 = []
var ally2 = []
var ally3 = []

var Nations = ["FINLAND", "france"]

#var Nations = ["ALGERIA", "australia", "BURKINA_FASO", "brazil", "CHINA", "chile", "DENMARK", "dominican_republic", "EGYPT", "england", 
#			"FINLAND", "france", "GERMANY", "ghana", "HONDURAS", "hungary", "INDIA", "israel", "JAMAICA", "japan", "KOREA", "kazakhstan", 
#			"LESOTHO", "lithuania", "MADAGASCAR", "mexico", "NEW_ZEALAND", "norway", "OMAN", "PAKISTAN", "panama", "QATAR", "ROMANIA", 
#			"russia", "SAUDI_ARABIA", "switzerland", "THAILAND", "turkey", "UKRAINE", "united_states", "VENEZUELA", "vietnam", "YEMEN", "ZAMBIA", "zimbabwe"]


func _ready():
	#Randomly choose a nation location for the player to spawn at
	randomize()
	var spawncity = Nations[randi() % Nations.size()]
	spawnhere = 'Nations'.plus_file(spawncity)
	get_node(spawnhere)
	spawnherespot = get_node(spawnhere).position
	var p = City.instance()
	add_child(p)
	$PlayerCity.position = spawnherespot
	spawnherecollisionremove = 'Nations'.plus_file(spawncity).plus_file('CollisionShape2D')
	get_node(spawnherecollisionremove).queue_free()
	#use a dictionary
	#concatenate a path target = 'Nations'.plus_file(_target).plus_file('Muzzle')
	#navigate to Nations tree 
	#queuefree a Nation
	#Create PlayerCity node
	
	#
	#traverse Nation List
	#Select random allies
	#Assign them to groups
	#change their color modulation

func _process(delta):
	if Input.is_action_just_pressed("f"):
		if Input.is_action_pressed("shift"):
			fire_missile('FINLAND')
			return
		fire_missile('france')
		
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
	b.start(_position, _direction)
	
	#subtract one from missilecount
	#create a missile at origin position
	#draw a line between origin and target
	#progress between origin and target
	#intercept other missiles if there are collisions
	#explosion anim at target
	#subtract from missile count and population