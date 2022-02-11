extends Node
class_name QuestSystem

var quests: Dictionary = {}

func _ready():
	name = "QuestSystem"
	
	registerQuests()

func registerQuests():
	var loadedquests = GlobalRegistry.getQuests()
	for questID in loadedquests:
		var quest = loadedquests[questID]
		
		quests[questID] = quest

func isCompleted(questID):
	assert(quests.has(questID))
	
	return quests[questID].isCompleted()

func getQuests():
	return quests
