extends "res://mats/objects/boxes/hitbox.gd"
var start_pos:Vector2=Vector2.ZERO
var speed:float=50
var move_to:Vector2=Vector2.ZERO
var del_rad:float=1000
@onready var h=$c.shape.height
func _ready():
	global_position=start_pos
	$cp.emission_sphere_radius=$c.shape.radius-1
func _physics_process(delta):
	global_position+=move_to*speed*delta
	$c.shape.height=h+speed*delta/2
	$c.position.x=-h/2+$cp.emission_sphere_radius
	if fnc._sqrt(global_position-start_pos)>=del_rad:
		queue_free()

func _on_body_entered(body):
	queue_free()
