extends Node2D

onready var gameloop = preload("main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Button_button_up():
	var virulence = get_node("CanvasLayer/VIRULENCE").value
	var symptomatism = get_node("CanvasLayer/SYMPTOMATISM").value
	var vaxx_protection = get_node("CanvasLayer/VAXX_PROTECTION").value
	var pctVaxxed = get_node("CanvasLayer/PERCENT_VAXXED").value
	var pctInfected = get_node("CanvasLayer/PERCENT_INFECTED").value
	var count = int(get_node("CanvasLayer/COUNT").text)
	var tov = int(get_node("CanvasLayer/TIME_OF_VIRULENCE").text)
	var tth = int(get_node("CanvasLayer/TIME_TO_HEAL").text)
	var tti = int(get_node("CanvasLayer/TIME_OF_INNOCULATION").text)
	var vaxx_healrate = int(get_node("CanvasLayer/VAXX_HEALING_RATE").text)
	var vaxx_symptoms = int(get_node("CanvasLayer/VAXX_SYMPTOM_FACTOR").text)
	
	var gloop = gameloop.instance()
	gloop.COUNT = count
	gloop.INITIAL_VIRULENCE = virulence
	gloop.TIME_OF_VIRULENCE = tov
	gloop.INITIAL_TIME_TO_HEAL = tth
	gloop.INITIAL_SYMPTOMATISM = symptomatism
	gloop.INNOCULATION_TIME = tti
	gloop.VAXX_HEALING_RATE = vaxx_healrate
	gloop.VAXX_SYMPTOM_FACTOR = vaxx_symptoms
	gloop.VAXX_PROTECTION = vaxx_protection
	gloop.PERCENT_INFECTED = pctInfected
	gloop.PERCENT_VACCINATED = pctVaxxed
	gloop.z_as_relative = false
	gloop.z_index=1000
	remove_child(get_node("CanvasLayer"))
	add_child(gloop)
	
	gloop.init()
	
func _unhandled_key_input(event):
	if event.is_action("ui_cancel"):
		get_tree().quit()
