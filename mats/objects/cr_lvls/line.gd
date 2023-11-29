extends Polygon2D
var col=CollisionPolygon2D.new()
func _ready():
	col.polygon=polygon
	col.position=position
	get_parent().add_child.call_deferred(col)
