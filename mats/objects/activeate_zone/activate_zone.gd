extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bs!=[]:
		$key.act()
	else:
		$key.deact()

var bs=[]
func _on_body_entered(b):
	bs.append(b)


func _on_body_exited(b):
	bs.remove_at(fnc.i_search(bs,b))
	
