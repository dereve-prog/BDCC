extends Reference
class_name NpcSlave

var npc:WeakRef
var slaveType = SlaveType.Slut
var slaveSpecializations = {
	SlaveType.Slut: 0,
}

var activity

var slaveLevel:int = 0
var slaveExperience:int = 0

# When reaches 1, the npc submits willingly
# Increased by punishing when punishments are needed (<=2)
# Increased by rewarding when rewards are needed
var obedience = 0.0
func getObedience() -> float:
	return obedience
func addObedienceRaw(howMuch:float):
	obedience += howMuch
	obedience = clamp(obedience, 0.0, 1.0)
func addObedience(howMuch:float):
	var mult = 1.0
	if(howMuch > 0.0):
		#mult += getDespair()*0.1 # Despair makes obeying a liiiitle easier
		mult += getAwareness()*3.0
		#mult += getSpoiling()*-0.3
		#mult += getTiredEffect()*-0.2
	else:
		pass
		#mult += getTiredEffect()*0.5
	
	addObedienceRaw(howMuch * mult * (1.0 + sign(howMuch) * personalityScore({
		PersonalityStat.Subby:0.8, # Subby people obey better
		})))
	
# When reaches 1, the npc submits unwillingly (gives up)
# Increased by punishing when disobeying? (only if big punishments) (2-3-4)
# Increased by doing things that the npc doesn't like
var brokenspirit = 0.0
func getBrokenSpirit() -> float:
	return brokenspirit
func addBrokenSpiritRaw(howMuch:float):
	brokenspirit += howMuch
	brokenspirit = clamp(brokenspirit, 0.0, 1.0)
func addBrokenSpirit(howMuch:float):
	var mult = 1.0
	if(howMuch > 0.0):
		mult += Util.distanceToHalfEased(getDespair())*6.0
		#mult += getAwareness()*0.5
		#mult += getSpoiling()*0.3
		#mult += getTiredEffect()*0.5
	else:
		#mult += getTiredEffect()*-0.2
		pass
	
	addBrokenSpiritRaw(howMuch * mult * (1.0 + sign(howMuch) * personalityScore({
		PersonalityStat.Coward:0.8, # Cowards are easier to break
		})))
# When reaches 1, the npc submits out of love
# Increased by doing things that the npc likes
# Increased by giving gifts?
var love = 0.0
func getLove() -> float:
	return love
func addLoveRaw(howMuch:float):
	love += howMuch
	love = clamp(love, 0.0, 1.0)
func addLove(howMuch:float):
	var mult = 1.0
	if(howMuch > 0.0):
		#mult += getDespair()*-0.3
		#mult += getAwareness()*-0.3
		#mult += getSpoiling()*0.2
		#mult += getTiredEffect()*-0.2
		mult += getTrust()*3.0
	else:
		#mult += getDespair()*-0.5
		pass
	addLoveRaw(howMuch * mult * (1.0 + sign(howMuch) * personalityScore({
		PersonalityStat.Mean:-0.6, # Kind people fall in love easier
		PersonalityStat.Naive:0.4, # Being naive helps too
		})))

# When reaches 1, the npc becomes a mindless fuckdoll
# Increased by doing bad things (very bad, like making them black out) to them?
# Increased by punishing for no reason
# Decreased by rewarding
var despair = 0.0
func getDespair() -> float:
	return despair
func addDespairRaw(howMuch:float):
	despair += howMuch
	despair = clamp(despair, 0.0, 1.0)
func addDespair(howMuch:float):
	var loveMult = 1.0
	if(getLove() > 0.4 && howMuch < 0.0): # Having feelings makes coping easier
		loveMult += getLove()
	addDespairRaw(howMuch * (1.0 + sign(howMuch) * personalityScore({
		PersonalityStat.Brat:-0.3, # Brats are more easy-going
		PersonalityStat.Naive:0.4, # Being naive makes despair hit harder
		})) * loveMult)

# Slave's understanding of their place
# Increased by explaining them their place (up to a point)
# Increased slowly over time? (only if you visit them)
# Increased by having restraints
# Rules?
# Decreased by being punished for no reason
# 1.0 = I'm a slave
# 0.0 = I'm not a slave!
var awareness = 0.0
func getAwareness() -> float:
	return awareness
func addAwarenessRaw(howMuch:float):
	awareness += howMuch
	awareness = clamp(awareness, 0.0, 1.0)
func addAwareness(howMuch:float):
	if(getAwareness() >= 1.0):
		addObedience(howMuch / 3.0)
	addAwarenessRaw(howMuch * (1.0 + sign(howMuch) * personalityScore({
		PersonalityStat.Subby:0.3, # Subby people understand it easier
		PersonalityStat.Mean:-0.3, # Mean people don't want to understand it
		PersonalityStat.Naive:-0.4, # Naive people think its all just gonna stop soon
		})))

# How much the slave trusts you
# Increased by rewarding/punishing perfectly (treating the slave fairly)
# Decreased by punishing when deserves a reward (betraying!)
# Decreased by doing bad things that they don't like?
var trust = 0.0
func getTrust() -> float:
	return trust
func addTrustRaw(howMuch:float):
	trust += howMuch
	trust = clamp(trust, 0.0, 1.0)
func addTrust(howMuch:float):
	if(getTrust() >= 1.0):
		addLove(howMuch / 3.0)
	addTrustRaw(howMuch * (1.0 + sign(howMuch) * personalityScore({
		PersonalityStat.Naive:0.95, # Naive people trust easier
		PersonalityStat.Impatient:-0.1, # Being patient makes you trust a little more
		})))

# How much have you spoiled your slave
# Increased by rewarding too much
var spoiling = 0.0
func getSpoiling() -> float:
	return spoiling
func addSpoilingRaw(howMuch:float):
	spoiling += howMuch
	spoiling = clamp(spoiling, 0.0, 1.0)
func addSpoiling(howMuch:float):
	addSpoilingRaw(howMuch * (1.0 + sign(howMuch) * personalityScore({
		PersonalityStat.Brat:0.95, # Brats are super easy to spoil
		PersonalityStat.Subby:-0.2, # Doms are easier to spoil too
		})))

var fear = 0.0
func getFear() -> float:
	return fear
func addFearRaw(howMuch:float):
	fear += howMuch
	fear = clamp(fear, 0.0, 1.0)
func addFear(howMuch:float):
	addFearRaw(howMuch * (1.0 + sign(howMuch) * personalityScore({
		PersonalityStat.Coward:0.8, # Doms are easier to spoil too
		})))
func addFearUpToAPoint(howMuch:float, maxPoint:float):
	var isHigherThanMaxPoint = getFear() >= maxPoint
	addFear(howMuch)
	if(!isHigherThanMaxPoint && getFear() > maxPoint):
		fear = maxPoint

# Has the slave gave up trying to escape
# Happens (randomly?) through a random event if brokenspirit or love has reached 1
# If true, brokenspirit no longer decays
var submitted = false
func hasSubmittedToPC():
	return submitted

# Daily vars
var tiredness:float = 0 # The higher this is, the higher the chance of disobeying
func addTired(howMuch:float):
	tiredness += howMuch
	if(tiredness < 0):
		tiredness = 0
# Returns a value between 0.0 and 0.9
# If 0.0 = full of power
# 0.0 - 0.9 = getting tired
func getTiredEffect() -> float:
	if(tiredness <= 1.0):
		return 0.0
	if(tiredness >= 5.0):
		return 0.9
	var progress = Util.remapValue(tiredness, 1.0, 5.0, 0.0, 1.0)
	
	return 0.1 + progress * progress * (3.0 - 2.0 * progress) * 0.9

func getWorkEfficiency() -> float:
	return 1.0 - getTiredEffect()

var rewardBalance:int = 0

var punishmentsToday:int = 0
var rewardsToday:int = 0
var gotBeatenUpToday:bool = false
var checkedOnSlaveToday:bool = false
func markCheckedOnSlaveToday():
	checkedOnSlaveToday = true
var explainedPositionToday = 0

var hasRandomEvent = false
var randomEventWillHappenID = "" # submitBroken, submitLove, escaped, removedOneRestraint

# Housekeeping stuff
var readyForLevelup = false
var levelupTasks = []

signal onSlaveLevelup(npcSlave)

func getDebugInfo():
	var result = [
		"Slave Type: "+str(slaveType),
		"Level: "+str(slaveLevel),
		"Experience: "+str(slaveExperience),
		"Obedience: "+str(Util.roundF(getObedience(), 2)),
		"Broken spirit: "+str(Util.roundF(getBrokenSpirit(), 2)),
		"Love: "+str(Util.roundF(getLove(), 2)),
		"Despair: "+str(Util.roundF(getDespair(), 2)),
		"Awareness: "+str(Util.roundF(getAwareness(), 2)),
		"Trust: "+str(Util.roundF(getTrust(), 2)),
		"Spoiling: "+str(Util.roundF(getSpoiling(), 2)),
		"Fear: "+str(Util.roundF(getFear(), 2)),
		"submitted: "+str(submitted),
		"rewardBalance: "+str(rewardBalance),
		"punishmentsToday: "+str(punishmentsToday),
		"rewardsToday: "+str(rewardsToday),
		"tiredness: "+str(Util.roundF(tiredness, 2)),
		"getWorkEfficiency(): "+str(Util.roundF(getWorkEfficiency(), 2)),
		"getResistScoreUnclamped(): "+str(Util.roundF(getResistScoreUnclamped(), 2)),
		"getBratScore(): "+str(Util.roundF(getBratScore(), 2)),
		"isActivelyResisting(): "+str(isActivelyResisting()),
		"isResistingSuperActively(): "+str(isResistingSuperActively()),
	]
	return Util.join(result, "\n")

func onNewDay():
	if(hasRandomEvent && randomEventWillHappenID != ""):
		var oldSlaveEvent = GlobalRegistry.getSlaveEvent(randomEventWillHappenID)
		if(oldSlaveEvent != null):
			oldSlaveEvent.onEventSkipped(self)
	hasRandomEvent = false
	randomEventWillHappenID = ""
	gotBeatenUpToday = false
	
	# Random event should be decided here
	var possibleEventsWithWeights = []
	for eventID in GlobalRegistry.getSlaveEvents():
		var slaveEvent = GlobalRegistry.getSlaveEvent(eventID)
		if(slaveEvent.supportsActivity(getActivityID()) && slaveEvent.canHappen(self) && slaveEvent.shouldHappen(self)):
			possibleEventsWithWeights.append([eventID, slaveEvent.getEventWeight()])
	
	if(possibleEventsWithWeights.size() > 0):
		var pickedRandomEvent = RNG.pickWeightedPairs(possibleEventsWithWeights)
		if(pickedRandomEvent != null):
			hasRandomEvent = true
			randomEventWillHappenID = pickedRandomEvent
		
		
	# If has any punishPoints, do something	
	
	var character = getChar()
	if(character.getInventory().hasRemovableRestraints()):
		var restraintAmount = character.getInventory().getEquppedRemovableRestraints().size()
		if(restraintAmount > 0):
			addAwareness(0.03 * sqrt(restraintAmount))
	
	# If checked on us last day
	if(checkedOnSlaveToday):
		addBrokenSpirit(Util.distanceToHalfEased(getDespair())*(1.0+getAwareness())*0.02)
		addAwareness(0.02)
	
	fear = fear / (2.5+personalityScore({PersonalityStat.Coward:-1.0}))
	if(fear < 0.02):
		fear = 0.0
	
	if(activity == null || !activity.preventsStatsDecay()): # Stats decay happens here
		if(rewardBalance < 0):
			addTrust(-rewardBalance * 0.04)
		if(submitted):
			despair = decayValue(despair, 0.05, personalityScore({
				PersonalityStat.Naive: 1.0,
			}), 0.8)
		else:
			obedience = decayValue(obedience, 0.05, personalityScore({
				PersonalityStat.Subby: -1.0,
			}), 0.8)
			brokenspirit = decayValue(brokenspirit, 0.05, personalityScore({
				PersonalityStat.Coward: -0.7,
				PersonalityStat.Naive: -0.5,
				PersonalityStat.Subby: -1.0,
				}))
			love = decayValue(love, 0.03, personalityScore({
				PersonalityStat.Mean: 1.0,
				PersonalityStat.Impatient: 0.3,
				PersonalityStat.Naive: -0.2,
			}), 3.0)
		spoiling = decayValue(spoiling, 0.05, personalityScore({
			PersonalityStat.Brat: -1.0,
		}), 0.8)
	
	if(activity != null):
		activity.onNewDay()
	
	rewardBalance = 0
	punishmentsToday = 0
	rewardsToday = 0
	tiredness = 0
	checkedOnSlaveToday = false
	explainedPositionToday = 0

func decayValue(theValue:float, howMuch:float, statModifier:float = 0.0, statEffect:float = 0.5) -> float:
	return max(0.0, theValue - max(0.0, howMuch * (1.0 + clamp(statModifier, -1.0, 1.0)*statEffect)))

func getRewardBalanceString():
	if(rewardBalance == 0):
		return "Doesn't deserve rewards or punishments"
	if(rewardBalance > 0):
		var rewardTexts = ["Deserves a small reward", "Deserves a normal reward", "Deserves a big reward", "Deserves the best reward"]
		return rewardTexts[Util.mini(rewardBalance-1, rewardTexts.size()-1)]
	else:
		var punishText = ["Deserves a small punishment", "Deserves a normal punishment", "Deserves a big punishment", "Deserves the biggest punishment"]
		return punishText[Util.mini(-rewardBalance-1, punishText.size()-1)]
		
# 1 = small punishment
# 2 = normal punishment
# 3 = big punishment
# 4 = NOW YOU FUCKED UP
func deservesPunishment(howBig:int):
	if(rewardBalance == -howBig): # 2 small punishments do stack but nothing else
		rewardBalance = Util.maxi(-4, rewardBalance - 1)
		return
	rewardBalance = Util.mini(rewardBalance, -howBig)
	
	if(rewardBalance < -4):
		rewardBalance = -4

# 1 = deserves some praise
# 2 = a headpat
# 3 = a treat
# 4 = You are the best!
func deservesReward(howBig:int):
	if(rewardBalance == howBig):
		rewardBalance = Util.mini(4, howBig + 1)
		return
	if(rewardBalance < 0):
		rewardBalance += howBig
		return
	rewardBalance = Util.maxi(rewardBalance, howBig)
	if(rewardBalance > 4):
		rewardBalance = 4

func handlePunishment(_howBig:int):
	punishmentsToday += 1
	
	var diff = -rewardBalance - _howBig
	var diffAbs = Util.maxi(diff, -diff)
	
	#if(getWorkEfficiency() <= 0.1): # We are very tired
		# Who cares
	#	rewardBalance = 0
	#	return
	
	if(_howBig >= 3): # Big punishments always add despair
		addDespair(0.02*_howBig)
	addFearUpToAPoint(0.04 * _howBig * _howBig, 0.25 + 0.2*_howBig)
	
	if(diff >= 2): # Punishing not enough
		addAwareness(-0.01 * diffAbs)
	if(diff <= -2): # punishing way too much (or punishing when we should be rewarding)
		addTrust(-0.02*diffAbs)
		addDespair(0.05*diffAbs)
		addSpoiling(-0.02 * diffAbs * diffAbs)
		addBrokenSpirit(0.02*diffAbs)
		
	if(diff == 0): # The punishment fits the crime just right
		addAwareness(0.02 * _howBig)
		addTrust(-0.02)
		addSpoiling(-0.02 * _howBig)
		addDespair(-0.01)
		addObedience(0.02 * _howBig)
	elif(diffAbs <= 1 && rewardBalance != 0): # The punishment more or less fits the crime
		addAwareness(0.01 * _howBig)
		addTrust(-0.01)
		addObedience(0.007 * _howBig)
		addSpoiling(-0.01 * _howBig)
	
	if(punishmentsToday >= 2): # Did too many punishments
		addDespair(0.01*diffAbs)
		addTired(1)
		if(rewardsToday == 0): # But never rewarded!
			addSpoiling(-0.01 * _howBig)
		else: #Gave some rewards at least
			pass
	
	rewardBalance = 0

func handleReward(_howBig:int):
	rewardsToday += 1
	
	var diff = rewardBalance - _howBig
	var diffAbs = Util.maxi(diff, -diff)
	
	#if(getWorkEfficiency() <= 0.1): # We are very tired
		# Who cares
	#	rewardBalance = 0
	#	return
	addFear(-0.02 * _howBig * _howBig)
	
	if(diff >= 2): # Reward not big enough
		addTrust(-0.03)
		addAwareness(-0.02)
		addDespair(0.01)
	if(diff <= -2): # Reward too big (Or got rewarded when should be punished)
		addSpoiling(0.04 * diffAbs)
		addTrust(0.03)
	if(diff <= -1 && rewardBalance != 0): # Rewarding when should be punishing
		addLove(0.01 * diffAbs)
		addDespair(-0.02 * diffAbs)
	
	if(diff == 0): # Reward fits just right
		addTrust(0.03 * _howBig)
		addAwareness(0.02)
		addDespair(-0.02 * _howBig)
		addObedience(0.01)
	elif(diffAbs <= 1 && rewardBalance != 0): # The reward more or less fits
		addTrust(0.02 * _howBig)
		addAwareness(0.01)
		addObedience(0.005)
		addDespair(-0.01)
	else: # Rewarding for no good reason
		pass
	
	if(rewardsToday >= 2): # Did too many rewards
		addSpoiling(0.01 * _howBig)
		if(rewardsToday == 0): # But never punished
			addDespair(-0.02 * _howBig)
		else: #Gave some punishments too
			addDespair(-0.01 * _howBig)
	
	rewardBalance = 0

func setChar(theChar):
	npc = weakref(theChar)

func setMainSlaveType(theSlaveType):
	slaveType = theSlaveType

func getMainSlaveType():
	return slaveType

func getChar():
	if(npc == null):
		return null
	return npc.get_ref()

func handleSexEvent(_sexEvent:SexEvent):
	var theChar = getChar()
	for task in levelupTasks:
		task.onSexEvent(theChar, _sexEvent)

func levelupCurrentSpecialization():
	if(!slaveSpecializations.has(slaveType)):
		slaveSpecializations[slaveType] = 0
	
	slaveSpecializations[slaveType] += 1
	if(slaveSpecializations[slaveType] > 15):
		slaveSpecializations[slaveType] = 15

# F- F  F+ D- D  D+ C- C  B- B  A- A  S- S  S+ S++
# 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
static func rankToLetter(theRank:int):
	var scoreToText = ["F-", "F", "F+", "D-", "D", "D+", "C-", "C", "B-", "B", "A-", "A", "S-", "S", "S+", "S++"]

	theRank = Util.mini(Util.maxi(int(theRank), 0), 15)
	return scoreToText[theRank]

func getCurrentSpecializationLevel() -> int:
	if(!slaveSpecializations.has(slaveType)):
		return 0
	return slaveSpecializations[slaveType]

func getSlaveSkill(theSlaveType):
	if(!slaveSpecializations.has(theSlaveType)):
		return 0
	return slaveSpecializations[theSlaveType]

func getOverallObeyMood() -> float:
	return max(getLove(), max(getBrokenSpirit(), getObedience())) - getSpoiling() - getResistScoreUnclamped()

func doTrain():
	var currentSlaveType:SlaveTypeBase = GlobalRegistry.getSlaveType(slaveType)
	
	var texts = []
	texts.append(currentSlaveType.getTrainText(getChar(), getCurrentSpecializationLevel()))
	
	var isSuccess = true
	var actuallyAddedSkill = false
	if(isResistingSuperActively()):
		isSuccess = false
		texts.append( currentSlaveType.getFailedTrainTextResist(getChar()) )
		deservesPunishment(2)
	else:
		var workEffect = getWorkEfficiency()
		var obeyMood = getOverallObeyMood()
		
		if(workEffect < 0.5 && RNG.chance(80.0*(1.0-workEffect))):
			isSuccess = false
			texts.append( currentSlaveType.getFailedTrainTextWeak(getChar()) )
			addDespair(0.01)
			#addBrokenSpirit(0.02)
			if(rewardBalance >= 2):
				addLove(-0.01)
		else:
			var workRoll = obeyMood + workEffect + RNG.randf_range(-1.0, 1.0) + float(slaveLevel)/10.0
			if(workRoll < 0.0):
				isSuccess = false
				texts.append( currentSlaveType.getFailedTrainTextBad(getChar()) )
				deservesPunishment(1)
				addSpoiling(-0.04)
			elif(workRoll <= 1.0):
				isSuccess = true
				texts.append( currentSlaveType.getFailedTrainTextSomeSuccess(getChar()) )
				deservesReward(1)
				if(RNG.chance(10)):
					levelupCurrentSpecialization()
					actuallyAddedSkill = true
				addObedience(0.005)
				addFear(-0.03)
			else:
				isSuccess = true
				texts.append( currentSlaveType.getFailedTrainTextGreatSuccess(getChar()) )
				deservesReward(2)
				if(RNG.chance(30)):
					levelupCurrentSpecialization()
					actuallyAddedSkill = true
				addObedience(0.01)
				addLove(0.01)
				addFear(-0.1)
			
	
	var result = {
		success = isSuccess,
		texts = texts,
	}
	
	if(isSuccess && actuallyAddedSkill):
		addExperience(25)
	elif(isSuccess):
		addExperience(10)
	tiredness += 1
	
	return result

func getExperienceRequiredForNextLevel():
	return 100

func generateLevelUpTasks():
	levelupTasks = NpcBreakTaskBase.generateTasksFor(getChar(), slaveType, 2, 1.0)
	for task in levelupTasks:
		var _ok = task.connect("onTaskCompleted", self, "onLevelupTaskCompleted")

func addExperience(howMuch:int):
	slaveExperience += howMuch
	
	var experienceCap = getExperienceRequiredForNextLevel()
	if(slaveExperience >= experienceCap):
		if(!readyForLevelup):
			readyForLevelup = true
			if(GM.main != null):
				GM.main.addMessage("Your slave named "+getChar().getName()+" is ready to be leveled up.")
			generateLevelUpTasks()
		
		slaveExperience = experienceCap

func isReadyToBeLeveledUp():
	return readyForLevelup

func onLevelupTaskCompleted(_theTask):
	if(readyForLevelup && areLevelupTasksCompleted()):
		readyForLevelup = false
		
		doLevelup()

func areLevelupTasksCompleted():
	for task in levelupTasks:
		if(!task.isCompleted()):
			return false
	return true

func checklevelUp():
	if(readyForLevelup && areLevelupTasksCompleted()):
		doLevelup()

func doLevelup():
	readyForLevelup = false
	levelupTasks.clear()
	
	slaveExperience = 0
	slaveLevel += 1

	if(GM.main != null):
		GM.main.addMessage("Your slave named "+getChar().getName()+" has reached slave level "+str(slaveLevel)+"!")
		
	emit_signal("onSlaveLevelup", self)

func getLevelupTaskProgressText():
	var result = []
	
	for task in levelupTasks:
		var taskString = task.getTaskString()
		if(task.isCompleted()):
			result.append("[color=green]"+str(taskString)+"[/color]")
		else:
			result.append("[color=red]"+str(taskString)+"[/color]")
	
	return Util.join(result, "\n")

func fetishScore(fetishes = {}, addscore = 0.0):
	var fetishHolder: FetishHolder = getChar().getFetishHolder()
	
	var maxPossibleValue = 0.0
	var result = addscore
	for fetishID in fetishes:
		var fetishValue = fetishHolder.getFetishValue(fetishID)
		result += fetishValue * fetishes[fetishID]
		maxPossibleValue += 1.0
	
	var forcedObedience = clamp(getChar().getForcedObedienceLevel(), 0.0, 1.0)
	if(forcedObedience > 0.0):
		result = result * (1.0 - forcedObedience) + maxPossibleValue * forcedObedience
	
	return result

# 1 = loves, -1 = hates
func fetishScoreOne(fetishID):
	return fetishScore({fetishID:1.0})

func personalityScore(personalityStats = {}, addscore = 0.0):
	var personality: Personality = getChar().getPersonality()
	
	var result = addscore
	for personalityStatID in personalityStats:
		var personalityValue = personality.getStat(personalityStatID)
		result += personalityValue * personalityStats[personalityStatID]
	
	return result

func personalityScoreOne(personalityStat):
	return personalityScore({personalityStat:1.0})

func hasRandomEventToTrigger():
	return hasRandomEvent

func remap01(value:float, newMinValue:float, newMaxValue:float) -> float:
	return Util.remapValue(value, 0.0, 1.0, newMinValue, newMaxValue)
# 0.0 = No resistance
# 0.5 = Resisting 50% of the time?
# 1.0 = ACTIVELY RESISTING EVERY STEP
func getResistScoreUnclamped():
	var overComeValue = 1.2
	if(submitted):
		overComeValue = 1.0

	overComeValue *= (1.0 - getFear() * (1.0 - getSpoiling()*0.3))

	overComeValue += personalityScore({
		PersonalityStat.Subby: -0.3,
		PersonalityStat.Mean: 0.3,
		PersonalityStat.Coward: -0.2,
		PersonalityStat.Naive: -0.2,
		})
	overComeValue = clamp(overComeValue, 0.2, 3.0)

	overComeValue *= (1.0 - getObedience())
	overComeValue *= (1.0 - getLove())
	overComeValue *= (1.0 - getBrokenSpirit())
	
	var restraintAmount = getChar().getInventory().getEquppedRemovableRestraints().size()
	for _i in range(restraintAmount):
		overComeValue *= 0.9
	
	# Close to breaking, no resistance anymore
	if(despair > 0.9):
		overComeValue = min(0.1, overComeValue)
	elif(despair > 0.6):
		overComeValue = min(0.5, overComeValue)
	
	return max(0.0, overComeValue)
		
func getResistScore():
	return clamp(getResistScoreUnclamped(), 0.0, 1.0)

func isActivelyResisting():
	# Temporary got shown their place
	if(gotBeatenUpToday):
		return false
	return getResistScoreUnclamped() >= 0.5 || getBratScore() >= 0.5

func isResistingSuperActively():
	# Temporary got shown their place
	if(gotBeatenUpToday):
		return false
	return getResistScoreUnclamped() > 1.0

func afterBeatenUp():
	#gotBeatenUpToday = true
	#addBrokenSpirit(0.04)
	#addObedience(0.02)
	addFear(0.5)

func getBratScore():
	#var theValue = personalityScore({
	#	PersonalityStat.Brat: 0.1,
	#})
	return clamp(getSpoiling(), 0.0, 1.0 - getFear())

func getOwnerName():
	return "owner"

func getLevel():
	return slaveLevel

func getSlaveTypeName():
	var slaveTypeObj:SlaveTypeBase = GlobalRegistry.getSlaveType(getMainSlaveType())
	if(slaveTypeObj == null):
		return "slave"
	return slaveTypeObj.getVisibleName()

func getCurrentSkillName():
	return getSlaveTypeName()

func getMaxSkillsAmount():
	return Util.maxi(1, 1+int(float(slaveLevel) / 5))

func canLearnNewSkill():
	var skillAmount = slaveSpecializations.size()
	
	if(skillAmount < getMaxSkillsAmount()):
		return true
	return false

func canLearnNewSkillAndHasAvailable():
	if(!canLearnNewSkill()):
		return false
	
	var allSkills = GlobalRegistry.getSlaveTypes()
	for theSkillID in allSkills:
		if(!slaveSpecializations.has(theSkillID)):
			return true
	return false

func setMainSkill(theSlaveType):
	slaveType = theSlaveType

func hasSkill(theSlaveType):
	if(!slaveSpecializations.has(theSlaveType)):
		return false
	return true

func learnNewSkill(theSlaveType):
	if(!slaveSpecializations.has(theSlaveType)):
		slaveSpecializations[theSlaveType] = 0

func getPerfectIdleMessage():
	var db = [
		{stats={obedience=1.0,love=0.0,brokenspirit=1.0}, notblind=true, message="{npc.HeShe} stands perfectly still, eyes locked onto you with unwavering obedience. There's an unsettling lack of emotion in {npc.hisHer} gaze, as if {npc.heShe} exists solely to fulfill your commands."},
		{stats={obedience=0.0,love=0.0,brokenspirit=0.0}, notblind=true, message="{npc.HeShe} glares defiantly at you, a spark of rebellion in {npc.hisHer} eyes. {npc.HisHer} posture exudes resistance, {npc.hisHer} body language challenging your authority at every turn. It's clear that {npc.heShe} despises being under your control."},
		{stats={obedience=0.1,love=1.0,brokenspirit=1.0}, message="{npc.HeShe} gazes at you with adoration, love radiating from {npc.hisHer} every glance. {npc.HisHer} stance is submissive, almost vulnerable, as if {npc.heShe} would do anything to please you and bask in your affection."},
		{stats={obedience=1.0,love=0.1,trust=0.5}, message="{npc.HeShe} stands before you with unwavering obedience, {npc.his} eyes reflecting complete submission. There's a noticeable lack of affection, only a cold compliance."},
		{stats={tiredness=0.9,fear=0.7,brokenspirit=0.0}, message="Standing defiantly, {npc.heShe} glares at you, {npc.his} spirit unbroken despite the evident fatigue. Fear lingers in the air, but {npc.heShe} remains resolute, refusing to succumb to the exhaustion."},
		{stats={love=1.0,trust=0.1,fear=0.8}, message="Despite the overwhelming love in {npc.his} eyes, a sense of unease is palpable. It's clear that trust is lacking, overshadowed by an undercurrent of fear that strains the connection between you and {npc.him}."},
		{stats={obedience=0.9,love=0.3,despair=0.4,tiredness=0.8}, message="With a weariness in {npc.his} eyes, {npc.heShe} obediently awaits your command. The love is there, but despair and exhaustion cast a shadow, making the connection seem more like a duty than a desire."},
		{stats={love=1.0,obedience=1.0,brokenspirit=1.0}, message="{npc.HeShe} looks at you with both love and unwavering obedience. There's no hint of resistance, just a display of complete surrender."},
		{stats={obedience=1.0,love=0.0,trust=0.0}, message="{npc.HeShe} stands in a rigid, submissive posture, eyes downcast, hands clasped behind {npc.his} back. There's an unquestioning obedience in {npc.his} demeanor, yet the lack of trust manifests in the subtle tremble of {npc.his} fingers."},
		{stats={obedience=0.3,love=1.0,fear=0.8}, message="Gazing at you with an intensity bordering on adoration, {npc.heShe} seems to be holding back tears. Love emanates from every pore, but there's an underlying fear, as if {npc.heShe} is afraid of shattering the fragile bond between you."},
		{stats={brokenspirit=0.0,spoiling=0.7,awareness=0.9,fear=0.0}, message="Standing defiantly, {npc.heShe} locks eyes with you, a spark of rebellion gleaming beneath the surface. {npc.HeShe} seems acutely aware of every move you make, as if ready to challenge your dominance at any moment."},
		{stats={obedience=0.3,love=0.8,spoiling=0.7}, message="Leaning slightly, {npc.HeShe} regards you with a mixture of affection and expectation. Love is present, but the subtle tilt of {npc.his} head and the glint in {npc.his} eyes suggest a desire for indulgence, as if {npc.heShe} expects you to cater to {npc.his} whims."},
		{stats={brokenspirit=0.0,awareness=0.6,fear=0.6}, message="Eyes ablaze with defiance, {npc.heShe} stands tall, seemingly unyielding against your commands. There's a heightened awareness in {npc.his} gaze, as if {npc.heShe} is acutely attuned to every nuance of your presence."},
		{stats={obedience=0.7,love=0.2,fear=0.8}, message="Avoiding your gaze, {npc.heShe} fidgets nervously, a mix of obedience and fear evident in {npc.his} demeanor. There's a hesitant submission, and the aura of tension suggests an anticipation of potential consequences for any misstep."},
		#{stats={love=0.0}, message=""},
	]
	
	var mainStats = {
		obedience = obedience, love = love, brokenspirit = brokenspirit,
	}
	var supportStats = {
		awareness = awareness, trust = trust, despair = despair, spoiling = spoiling, tiredness=getTiredEffect(), fear = fear,
	}
	
	var highestScore = -100.0
	var bestMessage = "Your slave stands still."
	
	for dbEntry in db:
		var mainDistance = 0.0
		var supportDistance = 0.0
		var missingStatsDistance = 0.0
		
		var foundMainStats = 0
		var foundSupportStats = 0
		var theStats = dbEntry["stats"]
		for stat in theStats:
			if(mainStats.has(stat)):
				var distance = abs(mainStats[stat] - theStats[stat])
				mainDistance += 1.0 - distance
				foundMainStats += 1
			elif(supportStats.has(stat)):
				var distance = abs(supportStats[stat] - theStats[stat])
				supportDistance += 1.0 - distance
				foundSupportStats += 1
		
		missingStatsDistance = Util.maxi(0, mainStats.size() - foundMainStats) * 2.0 + Util.maxi(0, supportStats.size() - foundSupportStats) * 1.0
		
		var finalScore = mainDistance*2.0/(foundMainStats+1) + supportDistance*1.0/(foundSupportStats+1) - missingStatsDistance*0.1
		
		if(finalScore > highestScore):
			highestScore = finalScore
			bestMessage = dbEntry["message"]
	
	return bestMessage

func isDoingActivity():
	return activity != null

func getActivityID() -> String:
	if(activity == null):
		return ""
	return activity.id

func getActivity():
	return activity

func stopActivity():
	if(activity != null):
		activity.onEnd()
	activity = null

func startActivity(activID, args = []):
	if(isDoingActivity()):
		stopActivity()
	var newActivity = GlobalRegistry.createSlaveActivity(activID)
	if(newActivity == null):
		return
	newActivity.slavery = weakref(self)
	newActivity.onStart(args)
	activity = newActivity
