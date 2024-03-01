extends Reference
class_name SlaveActionBase

const Nothing = 0
const Reward = 1
const Punishment = 2
const Talk = 3
const Action = 4

var id = "ERROR"
var actionType = Nothing
var slaveRequired = true
var slaveRankRequired = {}
var slaveMinLevel = 0
var extraSlaves = {
#	"dom": {
#		name = "Dominant",
#		desc = "Person who dominates!",
#		slaveRankRequired = {},
#		slaveMinLevel = 0,
#	}
}
var sceneID = ""
var endsTalkScene = false
var slaveResistChanceMult = 1.0

func getVisibleName():
	return "CHANGE ME"

func getVisibleDesc():
	return "CHANGE MY DESCRIPTION"

func isActionVisible(_slaveID):
	return true

func checkCanDo(_slaveID, _extraSlavesIDs = {}):

	#return [false, "You need a penis"]
	return [true]

func checkCanDoFinal(_slaveID, _extraSlavesIDs = {}):
	var checkCanDoData = checkCanDo(_slaveID, _extraSlavesIDs)
	if(checkCanDoData is bool):
		if(!checkCanDoData):
			return [false, "One of the conditions wasn't met"]
	if(!checkCanDoData[0]):
		return checkCanDoData
	
	if(slaveRequired):
		var fitsMainSlaveData = fitsAsMainSlaveAdvanced(_slaveID)
		if(!fitsMainSlaveData[0]):
			return fitsMainSlaveData
	
	for roleID in extraSlaves:
		if(!_extraSlavesIDs.has(roleID)):
			return [false, "One of the roles isn't selected"]
		var fitsExtraSlaveData = fitsAsExtraSlaveAdvanced(roleID, _extraSlavesIDs[roleID])
		if(!fitsExtraSlaveData[0]):
			return fitsExtraSlaveData
	
	return [true]

func fitsAsMainSlaveAdvanced(_charID):
	
	return [true]

func fitsAsMainSlave(_charID):
	return fitsAsMainSlaveAdvanced(_charID)[0]

func fitsAsExtraSlaveAdvanced(_role, _charID):
	
	return [true]

func fitsAsExtraSlave(_role, _charID):
	return fitsAsExtraSlaveAdvanced(_role, _charID)[0]

func doActionSimple(_slaveID, _extraSlavesIDs = {}):
	return {
		text = "You did something with "+str(_slaveID)+"!",
	}

func reactSceneResult(_slaveID, _extraSlavesIDs = {}, _sceneResult = {}):
	print("REACT SCENE RESULT")
	return

func getSlave(_slaveID) -> NpcSlave:
	return GlobalRegistry.getCharacter(_slaveID).getNpcSlavery()
