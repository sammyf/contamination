extends Node2D

onready var gameloop = preload("main.tscn")

onready var nd_virulence = get_node("CanvasLayer/VIRULENCE")
onready var nd_symptomatism = get_node("CanvasLayer/SYMPTOMATISM")
onready var nd_vaxx_protection = get_node("CanvasLayer/VAXX_PROTECTION")
onready var nd_pctVaxxed = get_node("CanvasLayer/PERCENT_VAXXED")
onready var nd_pctInfected = get_node("CanvasLayer/PERCENT_INFECTED")
onready var nd_count = get_node("CanvasLayer/COUNT")
onready var nd_tov = get_node("CanvasLayer/TIME_OF_VIRULENCE")
onready var nd_tth = get_node("CanvasLayer/TIME_TO_HEAL")
onready var nd_tti = get_node("CanvasLayer/TIME_OF_INNOCULATION")
onready var nd_vaxx_healrate = get_node("CanvasLayer/VAXX_HEALING_RATE")
onready var nd_vaxx_symptoms = get_node("CanvasLayer/VAXX_SYMPTOM_FACTOR")

var defaultName = "contamination.tres"
	
# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Button_button_up():
	var virulence = nd_virulence.value
	var symptomatism = nd_symptomatism.value
	var vaxx_protection = nd_vaxx_protection.value
	var pctVaxxed = nd_pctVaxxed.value
	var pctInfected = nd_pctInfected.value
	var count = int(nd_count.text)
	var tov = int(nd_tov.text)
	var tth = int(nd_tth.text)
	var tti = int(nd_tti.text)
	var vaxx_healrate = float(nd_vaxx_healrate.text)
	var vaxx_symptoms = float(nd_vaxx_symptoms.text)
	
	var defaults:Defaults = Defaults.new()
	defaults.virulence = virulence
	defaults.symptomatism = symptomatism
	defaults.vaxx_protection = vaxx_protection
	defaults.pctVaxxed = pctVaxxed
	defaults.pctInfected = pctInfected
	defaults.count = count
	defaults.tov = tov
	defaults.tth = tth
	defaults.tti = tti
	defaults.vaxx_healrate = vaxx_healrate
	defaults.vaxx_symptoms = vaxx_symptoms
	var rs = ResourceSaver.save(defaultName, defaults)
	
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

func load_data():	
	if ResourceLoader.exists(defaultName):
		var defaults = ResourceLoader.load(defaultName)
		nd_virulence.value=defaults.virulence
		nd_symptomatism.value=defaults.symptomatism
		nd_vaxx_protection.value=defaults.vaxx_protection
		nd_pctVaxxed.value=defaults.pctVaxxed
		nd_pctInfected.value=defaults.pctInfected
		nd_count.text = str(defaults.count)
		nd_tov.text = str(defaults.tov)
		nd_tth.text = str(defaults.tth)
		nd_tti.text = str(defaults.tti)
		nd_vaxx_healrate.text = str(defaults.vaxx_healrate)
		nd_vaxx_symptoms.text = str(defaults.vaxx_symptoms)

