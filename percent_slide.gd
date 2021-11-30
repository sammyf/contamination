extends CanvasLayer


onready var slideIdiots = get_node("PERCENT_IDIOTS")
onready var slideInfected = get_node("PERCENT_INFECTED")
onready var slideVaxxed = get_node("PERCENT_VAXXED")
onready var lblIdiots = get_node("lbl_idiots")
onready var lblInfected = get_node("lbl_infected")
onready var lblVaxxed = get_node("lbl_vaxxed")

var doNotPropagate = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PERCENT_IDIOTS_value_changed(value):
	if doNotPropagate>0:
		doNotPropagate -=1
		return

	var pctVaxxed = slideVaxxed.value
	var pctIdiots = slideIdiots.value
	var pctInfected = slideInfected.value

	var oldValue=int(lblIdiots.text)
	var diff = oldValue-value
	if diff < 0 && ((pctInfected + diff) < 0 ):
		pctVaxxed += diff
	elif diff < 0 && ((pctVaxxed + diff) < 0 ):
		pctInfected += diff
	elif diff > 0 && ((pctInfected + diff) > 100 ):
		pctVaxxed += diff
	else:
		pctInfected += diff

	doNotPropagate = 2
	slideInfected.set_value(pctInfected)
	slideVaxxed.set_value(pctVaxxed)
	
	rebase_sliders()

func _on_PERCENT_INFECTED_value_changed(value):
	if doNotPropagate>0:
		doNotPropagate -=1
		return
	var pctVaxxed = slideVaxxed.value
	var pctIdiots = slideIdiots.value
	var pctInfected = slideInfected.value

	var oldValue=int(lblInfected.text)
	var diff = oldValue-value
	if diff < 0 && ((pctIdiots + diff) < 0 ):
		pctVaxxed += diff
	elif diff < 0 && ((pctVaxxed + diff) < 0 ):
		pctIdiots += diff
	elif diff > 0 && ((pctIdiots + diff) > 100 ):
		pctVaxxed += diff
	else:
		pctIdiots += diff

	doNotPropagate = 2
	slideIdiots.set_value(pctIdiots)
	slideVaxxed.set_value(pctVaxxed)
	rebase_sliders()

func _on_PERCENT_VAXXED_value_changed(value):
	if doNotPropagate>0:
		doNotPropagate -=1
		return
	var pctVaxxed = slideVaxxed.value
	var pctIdiots = slideIdiots.value
	var pctInfected = slideInfected.value

	var oldValue=int(lblVaxxed.text)
	var diff = oldValue-value
	if diff < 0 && ((pctIdiots + diff) < 0 ):
		pctInfected += diff
	elif diff < 0 && ((pctInfected + diff) < 0 ):
		pctIdiots += diff
	elif diff > 0 && ((pctIdiots + diff) > 100 ):
		pctInfected += diff
	else:
		pctIdiots += diff

	doNotPropagate = 2
	slideInfected.set_value(pctInfected)
	slideIdiots.set_value(pctIdiots)
	
	rebase_sliders()

func rebase_sliders():
	var pctVaxxed = slideVaxxed.value
	var pctIdiots = slideIdiots.value
	var pctInfected = slideInfected.value
	
	if pctIdiots == 100:
		pctVaxxed=0
		pctInfected=0
	elif pctInfected == 100:
		pctVaxxed=0
		pctIdiots=0
	elif pctVaxxed == 100:
		pctInfected=0
		pctIdiots=0
		
	slideVaxxed.set_value(pctVaxxed)
	slideInfected.set_value(pctInfected)
	slideIdiots.set_value(pctIdiots)

	lblIdiots.text = str(slideIdiots.value)
	lblInfected.text = str(slideInfected.value)
	lblVaxxed.text = str(slideVaxxed.value)


