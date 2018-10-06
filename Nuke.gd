extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime
var steer_force = 1

var velocity = Vector2()


func start(_position, _direction):
	position = _position
	rotation = 0 
#	rotation = _direction.angle() #probably a change here
	velocity = _direction * speed
	#seek()
	
func _process(delta):
	position += velocity * delta

#func seek():
	#var desired = (target.position - position).normalized() * speed
	#var steer = (desired - velocity).normalized() * steer_force
	#return steer

func explode():
	queue_free()

func _on_Nuke_body_entered(body):
	explode()
	if body.has_method('take_damage'):
		body.take_damage(damage)