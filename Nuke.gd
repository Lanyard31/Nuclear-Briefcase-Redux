extends Area2D

export (int) var speed
export (int) var damage = 1000
export (float) var lifetime
var steer_force = 1
var live
var group = null

var velocity = Vector2()

func _ready():
	randomize()
	damage = round(damage * rand_range(0.8, 1.2))
	return damage

func start(_position, _direction, group):
	if group == true:
		group = false
		self.set_modulate(Color(1.0, 0.6, 0.0))
		live = false
		$Ignition_Timer.start()
		position = _position
		rotation = 0 
	#	rotation = _direction.angle() #probably a change here
		velocity = _direction * speed
		#seek()
	elif group == null:
		self.set_modulate(Color(1.0, 0.0, 0.8))
		live = false
		$Ignition_Timer.start()
		position = _position
		rotation = 0 
	#	rotation = _direction.angle() #probably a change here
		velocity = _direction * speed
		#seek()
	
func _process(delta):
	if $AnimatedSprite.is_visible() == true:
		position += velocity * delta

#func seek():
	#var desired = (target.position - position).normalized() * speed
	#var steer = (desired - velocity).normalized() * steer_force
	#return steer

func explode():
	$AnimatedSprite.hide()
	self.set_modulate(Color(1, 1, 1))
	$explosion.play()

func _on_Nuke_body_entered(body):
	if live == true:
		explode()
		if body.has_method('take_damage'):
			body.take_damage(damage)

func _on_Ignition_Timer_timeout():
	live = true

func _on_explosion_animation_finished():
	queue_free() # replace with function body
