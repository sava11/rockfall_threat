extends Area2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var bs=[]
func _on_body_entered(b):
	bs.append(b)

func _on_body_exited(b):
	bs.remove_at(fnc.i_search(bs,b))
	if fnc.i_search(gm.cur_lvls,get_parent().scene_to_delete)!=-1 and get_parent().bs==[]:
		for e in fnc.get_world_node().get_children():
			if e.scene_file_path==gm.lvls[get_parent().scene_to_delete]:
				e.queue_free()
		gm.cur_lvls.remove_at(fnc.i_search(gm.cur_lvls,get_parent().scene_to_delete))
		for e in get_tree().get_nodes_in_group("load_lvl"):
			if e != get_parent():
				e.set_on(true)
