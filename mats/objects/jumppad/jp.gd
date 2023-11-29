extends Area2D
@export_range(1,999999) var height:float=208
@export_range(1,999999)var local_gravity:float=980
var power:float=0
var last_h:float=0
signal height_changed()
signal obj_steped()
# Called when the node enters the scene tree for the first time.
func _ready():
	last_h=height
	#pow(power,2)*pow(sin(deg_to_rad(global_rotation_degrees)),2)/2*g
	power=sqrt(2)*sqrt(local_gravity*height)/(sin(deg_to_rad(90)))
	#var t=power*sin(deg_to_rad(global_rotation_degrees+90))/local_gravity
	#print(power," ",t)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if height!=last_h:
		power=sqrt(2)*sqrt(local_gravity*height)/(sin(deg_to_rad(90)))
		emit_signal("height_changed")
		last_h=power
	pass


func _on_body_entered(body):
	if body is CharacterBody2D:
		body.velocity=fnc.move(rotation_degrees-90)*power
		emit_signal("obj_steped")


func _on_body_exited(body):
	pass # Replace with function body.
