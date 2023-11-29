extends Area2D
@export_range(0.0,9999999.0) var time_scrtipt:float=0
var timer =0
var timed:bool=false
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_scrtipt!=0.0:
		timer+=delta
	if in0 and Input.is_action_just_pressed("use"):
		$key.activate=true
		if time_scrtipt!=0.0:
			timed=true
	if time_scrtipt!=0.0 and timer>=time_scrtipt:
		$key.activate=true
		timer=0

var in0=false
func _on_body_exited(body):
	in0=false


func _on_body_entered(body):
	in0=true
