extends Area2D
@export() var scene_to_load:gm.lvls_ids
@export() var scene_to_delete:gm.lvls_ids
@onready var A=$a

var original_path:String=""
func save_data():
	return {
		original_path:{
			"current_path":str(get_path()),
			"file":self.scene_file_path,
			"monitoring":{
				"s":monitoring,
				"a":A.monitoring,
				},
			"monitorable":{
				"s":monitorable,
				"a":A.monitorable,
				}
			}
		}
func load_data(na,n):
	original_path=na
	monitoring=n.monitoring.s
	A.monitoring=n.monitoring.a
	monitorable=n.monitorable.s
	A.monitorable=n.monitorable.a
func set_on(n):
	set_deferred("monitoring",n)
	set_deferred("monitorable",n)
	$a.set_deferred("monitoring",n)
	$a.set_deferred("monitorable",n)
func _ready():
	if original_path=="":
		original_path=str(get_path())
	$a/c.shape.size.x=$c.shape.size.x/4
	$a/c.shape.size.y=$c.shape.size.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(b):
	bs.append(b)
	if fnc.i_search(gm.cur_lvls,scene_to_load)==-1 and A.bs==[]:
		gm.cur_lvls.append(scene_to_load)
		var lvl=load(gm.lvls[scene_to_load]).instantiate()
		fnc.get_world_node().add_child.call_deferred(lvl)
		for e in lvl.get_children():
			if e.is_in_group("load_lvl"):
				e.set_on(false)
	
var bs=[]
func _on_body_exited(b):
	bs.remove_at(fnc.i_search(bs,b))
	if fnc.i_search(gm.cur_lvls,scene_to_load)!=-1 and A.bs==[]:
		gm.cur_lvls.remove_at(fnc.i_search(gm.cur_lvls,scene_to_load))
		for e in fnc.get_world_node().get_children():
			if e.scene_file_path==gm.lvls[scene_to_load]:
				e.queue_free()
	
