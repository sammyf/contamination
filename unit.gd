extends RigidBody2D

var life=100.0
var TIME_TO_HEAL = 0.0
var TIME_OF_VIRULENCE = 0.0
var INNOCULATION_TIME = 0.0
var VAXX_SYMPTOM_FACTOR = 1
var VAXX_HEALING_RATE = 1
var MUTABILITY = 0.0
var VIRULENCE = 0.0

var timeToHeal = 0.0
var innoculationTime = 0.0

var infected = false
var symptoms = false
var vaccinated = false
var healed = false
var virulent = false
var timeOfVirulence = 0.0
var vaxxProtection = 0.0
var vaxxHealingRate = 0.0
var vaxxSymptomFactor = 0.0
var symptomatism = 0.0
var vaccineStrength = 0.0

var contacts:Array

enum {				VIRULENT,   VIRULENT_VAXXED, INFECTED,     VAXXED,         HEALED,  INFECTED_VAXXED, HEALED_VAXXED, NOT_VAXXED, DEAD}
var unitColors = [Color(1,0,0), Color(1,0.5,0), Color(1,1,0), Color(0,1,0), Color(1,0,1), Color(0,1,1), Color(0,0,1), Color(1,1,1), Color(0,0,0.4,0.3)]
onready var visual = get_node("visual")

# Called when the node enters the scene tree for the first time.
func _ready():
	life = rand_range(5,100)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#dead
	if life <= 0:
		return
	# innoculated through healing
	if (healed || infected) && (!virulent) :
		innoculationTime -= delta
		if innoculationTime <= 0:
			healed = false
	# vaccinated
	if vaccinated:
		vaccineStrength -= (delta/2)
		# booster is only given after innoculation is over and no infection is present
		if vaccineStrength < 30 && (!healed) && (!infected):
			vaccineStrength = vaxxProtection
	# can the virus be transmitted
	if virulent:
		if timeOfVirulence > 0:
			timeOfVirulence -= delta
		elif timeOfVirulence <= 0:
			virulent = false
	# infected 
	if infected:
		# check whether transmission is still possible
		if symptoms:
			life -= delta
			if life <= 0:
				visual.modulate = unitColors[DEAD]
				collision_layer=2
				collision_mask=2
				set_axis_velocity(Vector2(0,0))
				z_index = -1000
				get_parent().add_death(self)
				queue_free()
				return
		if (!virulent) && (!symptoms) :
			var healFactor = vaxxHealingRate
			timeToHeal -= (delta * healFactor)
			if timeToHeal <= 0:
				get_parent().remove_infected()
				infected = false
				healed = true
	for b in contacts:
		check_transmission(b)
	
	var colorScale=(life/100)
	if colorScale < 0.1:
		colorScale = 0.1
	var c = NOT_VAXXED
	if virulent && vaccinated:
		c=VIRULENT_VAXXED
	elif virulent:
		c=VIRULENT
	elif vaccinated && infected:
		c=INFECTED_VAXXED
	elif healed && vaccinated:
		c=HEALED_VAXXED
	elif infected:
		c=INFECTED
	elif healed:
		c=HEALED
	elif vaccinated:
		c=VAXXED		
	visual.modulate = Color(unitColors[c].r*colorScale, unitColors[c].g*colorScale, unitColors[c].b*colorScale)
	
#	if rand_range(0,1000) < 10:
#		set_axis_velocity(Vector2(0,0))
#		add_force(Vector2(rand_range(-1.0,1.0), rand_range(-1.0,1.0)), Vector2(rand_range(-0.5,0.5), rand_range(-0.5,0.5)))

func is_vaccinated(protection):
	vaxxProtection = protection
	vaccineStrength = vaxxProtection
	vaxxSymptomFactor = VAXX_SYMPTOM_FACTOR
	vaxxHealingRate = VAXX_HEALING_RATE
	vaccinated = true
#
#func is_healed():
#	vaxxProtection = 100
#	vaccinated = true
#
func check_transmission(b):
	if ! b.is_class("RigidBody2D"):
		return
	if b.virulent and (!infected) and (!healed):
		# first check whether an infection can take place
		var infection = rand_range(0,100)
		if b.VIRULENCE > infection:
			var protected = rand_range(0,100)
			if (vaccineStrength-(vaccineStrength/life)) < protected:
				get_infected(b.VIRULENCE, b.TIME_TO_HEAL, b.symptomatism, b.INNOCULATION_TIME, b.TIME_OF_VIRULENCE, b.MUTABILITY)

func get_infected(v, tth, s, inno, tov, m):
	MUTABILITY = m
	TIME_OF_VIRULENCE = tov
	TIME_TO_HEAL = tth
	INNOCULATION_TIME = inno
	VIRULENCE = v
	timeOfVirulence = TIME_OF_VIRULENCE
	timeToHeal = tth+(tth*(1.0/life))+((tth/10.0)-tth/5.0)
	innoculationTime = inno
	symptomatism = s
	var sRange = 100*vaxxSymptomFactor
	if symptomatism > rand_range(0,sRange):
		symptoms = true
	if get_parent() != null:
		get_parent().add_infected()
	infected = true
	virulent = true

func _on_unit_body_entered(body):
	contacts.append(body)

func _on_unit_body_exited(body):
	var idx = contacts.find(body)
	if idx > -1:
		contacts.remove(idx)

