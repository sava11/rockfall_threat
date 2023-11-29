extends Area2D
@export var m_he:float=1: set = s_m_h
@export var m_def:float=1: set = s_m_d
@export var m_def1:Dictionary={
	"phys":1,
	"fire":1,
	"electro":1,
	"water":1
	}:set=set_max_multiple_defence
var c_def1:Dictionary=m_def1
var def=m_def: set = set_def
var he=m_he: set = set_he
@export var tspeed:float=1.0
@onready var t=$Timer
var invi=false: set = set_invi
var step=0
signal invi_started
signal invi_ended

signal no_he
signal h_ch(v)
signal m_h_ch(v)

signal no_def
signal d_ch(v)
signal m_d_ch(v)

signal no_def_for(v)
signal max_def_chaged(v)
signal def_chaged(v)
func set_max_multiple_defence(d:Dictionary):
	var all_changed_values:PackedStringArray=[]
	for e in d.keys():
		if m_def1[e]!=d[e]:
			m_def1[e]=d[e]
			all_changed_values.append(e)
	emit_signal("max_def_chaged",all_changed_values)
func set_multiple_defence(d:Dictionary):
	var all_changed_values:PackedStringArray=[]
	var zero_values:PackedStringArray=[]
	for e in d.keys():
		if m_def1[e]!=d[e]:
			m_def1[e]=d[e]
			if m_def1[e]<=0:
				m_def1[e]=0
				zero_values.append(e)
			all_changed_values.append(e)
	if !zero_values.is_empty():
		emit_signal("no_def_for",zero_values)
	emit_signal("def_chaged",all_changed_values)
	
func s_m_h(v):
	m_he=v
	self.he=min(he,m_he)
	emit_signal("m_h_ch",m_he)
func s_m_d(v):
	m_def=v
	self.he=min(he,m_he)
	emit_signal("m_d_ch",m_he)
func set_def(value):
	def=value
	emit_signal("d_ch",he)
	if def<=1:
		emit_signal("no_def")
		def=1
func set_he(value):
	
	he=value
	emit_signal("h_ch",he)
	if he<=0:
		emit_signal("no_he")
		he=0
func _ready():
	if !is_connected("area_exited",Callable(self,"_on_area_exited")):
		connect("area_exited",Callable(self,"_on_area_exited"))
	self.he=m_he
	self.def=m_def
	$Timer.wait_time=tspeed

func set_invi(v):
	invi=v
	if invi==true:
		emit_signal("invi_started")
	else:
		emit_signal("invi_ended")

func start_invi(dir):
	self.invi=true
	t.start(dir)
func _on_Timer_timeout():
	self.invi=false
func _on_hurt_box_invi_ended():
	set_deferred("monitorable",true)
	set_deferred("monitoring",true)
func _on_hurt_box_invi_started():
	set_deferred("monitorable",false)
	set_deferred("monitoring",false)
func _process(delta):
	step=delta
	for area in temp:
		var dmg=area.damage
		if fnc._with_chance(area.crit_chance):
			dmg+=area.crit_damage
		set_he(he-dmg/float(def)*delta)
		
var temp=[]
func _on_area_entered(area):
	if area.by_time:
		temp.append(area)
	else:
		var dmg=area.damage
		if fnc._with_chance(area.crit_chance):
			dmg+=area.crit_damage
			if area.crit_chance>1:
				dmg*=area.crit_chance
		set_he(he-float(dmg)/float(def))


func _on_area_exited(area):
	if area.by_time and temp.has(area):
		temp.remove_at(fnc.i_search(temp,area))
