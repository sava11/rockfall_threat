extends RayCast2D
@export var posx1:int=0
@export var posx2:int=0
@export_range(1,99999999) var step_cell:int=16
func _ready():
	global_position.x+=fnc.rnd.randi_range(posx1,posx2)*step_cell
func _process(delta):
	if is_colliding():
		var p=preload("res://mats/objects/player/player.tscn").instantiate()
		get_parent().add_child.call_deferred(p)
		p.set_deferred("global_position",get_collision_point())
		get_parent().get_node("cam").global_position=get_collision_point()
		p.get_node("rt").remote_path=get_parent().get_node("cam").get_path()
		get_parent().get_node("cam").enabled=true
		queue_free()
