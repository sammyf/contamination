extends Node2D

const VERSION = '1.1\nBand-Maid rocks btw, no matter what Beato said.'

const KEY_TIMEOUT = 0.3
var keyDelay = 0.0

var COUNT = 4000
var INITIAL_VIRULENCE = 70
var TIME_OF_VIRULENCE  = 5
var INITIAL_TIME_TO_HEAL = 20 #seconds
var INNOCULATION_TIME = 60 # seconds until healed are not safe anymore
var INITIAL_SYMPTOMATISM = 50 # chances to develop symptoms
var MUTABILITY = 5

var VAXX_PROTECTION = 90
var VAXX_HEALING_RATE = 2.0
var VAXX_SYMPTOM_FACTOR = 2.0

var PERCENT_VACCINATED = 20
var PERCENT_INFECTED = 1

var units:Array
var unitScene = preload("res://unit.tscn")

var deathCount = 0
var infectCounter = 0
var vaxxCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("CanvasLayer/VERSION").text=VERSION

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	keyDelay -= delta
	
	var pct = deathCount*100/COUNT
	var infectPop = infectCounter*100/(units.size())
	var vaxxPop = vaxxCounter*100/(units.size())
	var restPop = 100-vaxxPop
	var restCounter = units.size()-vaxxCounter
	var txt= "Death:"+str(deathCount)+" ( "+str(pct)+"% of initial pop.)\n\n(percents of the remaining pop.)\nInfected:"+str(infectCounter)+" ("+str(infectPop)+"%)\nvaccinated:"+str(vaxxCounter)+" ("+str(vaxxPop)+"%)\n"+"not vaccinated:"+str(restCounter)+" ("+str(restPop)+"%)"
	get_node("CanvasLayer/counter").text = txt

func init():
	var vaxxCount = int(floor(float(PERCENT_VACCINATED)*float(COUNT))/100.0)
	var infectCount = int(floor(float(PERCENT_INFECTED)*float(COUNT))/100.0)
	var vCount = 0
	var iCount = 0
	
	for i in range(0,COUNT):
		var u = unitScene.instance()
		
		if vCount < vaxxCount:
			vCount += 1
			vaxxCounter += 1
			u.VAXX_HEALING_RATE = VAXX_HEALING_RATE
			u.VAXX_SYMPTOM_FACTOR = VAXX_SYMPTOM_FACTOR
			u.is_vaccinated(VAXX_PROTECTION)
		elif iCount < infectCount:
			iCount += 1
			infectCounter += 1
			u.get_infected(INITIAL_VIRULENCE, INITIAL_TIME_TO_HEAL, INITIAL_SYMPTOMATISM, INNOCULATION_TIME, TIME_OF_VIRULENCE, MUTABILITY)
			
		u.position = Vector2(rand_range(50,1870),rand_range(50,1000))
		u.add_force(Vector2(rand_range(-1.0,1.0), rand_range(-1.0,1.0)), Vector2(rand_range(-5,5), rand_range(-5,5)))
		u.gravity_scale = 0		
		units.append(u)
		add_child(u)
	
func add_death(u):
	deathCount += 1
	infectCounter -= 1
	if u.vaccinated:
		vaxxCounter -= 1
	var uidx = units.find(u)
	if uidx != -1:
		units.remove(uidx)

func add_infected():
	infectCounter +=1

func remove_infected():
	infectCounter -=1

func remove_vaxxer():
	vaxxCounter -=1
	
func _unhandled_input(event):
	if event.is_action("toggle_legend") && keyDelay <= 0:
		get_node("legend").visible = (get_node("legend").visible != true)
		keyDelay = KEY_TIMEOUT
	
