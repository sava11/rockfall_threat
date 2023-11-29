extends Node
enum lvls_ids{test1,test2,test3}
var lvls={
	lvls_ids.test1:"res://mats/lvls/lvl1.tscn",
	lvls_ids.test2:"res://mats/lvls/lvl2.tscn",
	lvls_ids.test3:"res://mats/lvls/lvl3.tscn",
	}
var cur_lvls=[lvls_ids.test1]
var original_path:String=""
func save_data():
	return {
		original_path:{
			"current_path":str(get_path()),
			"file":self.scene_file_path,
			"lvls":cur_lvls,
			}
		}
func load_data(na,n):
	original_path=na
	cur_lvls=n.lvls
	for e in fnc.get_world_node().get_children():
		e.name+="_"
		e.queue_free()
	for e in cur_lvls:
		var lvl=load(lvls[int(e)]).instantiate()
		fnc.get_world_node().add_child(lvl)
		
	pass
func _ready():
	if original_path=="":
		original_path=str(get_path())
	add_to_group("SN")
