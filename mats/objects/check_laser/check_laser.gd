extends Area2D
@export_range(1,99999)var need_power:float=1
@export_enum("button","leveler") var type:int
var changed=false
# Called when the node enters the scene tree for the first time.
func _ready():
	if type==1:set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var cur_power:float=0
	for e in areas:
		cur_power+=e.damage
	if cur_power>=need_power:
		$key.act()
	else:
		$key.deact()
var areas=[]
func _on_area_entered(a):
	if a.is_in_group("energy"):
		if type==1:
			$key.activate=true
		else:
			areas.append(a)
func _on_area_exited(a):
	if a.is_in_group("energy"):
		areas.remove_at(fnc.i_search(areas,a))
