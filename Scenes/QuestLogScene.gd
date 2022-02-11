extends "res://Scenes/SceneBase.gd"

class MyQuestSorter:
	static func sort_descending(a, b):
		if a.getPriority() > b.getPriority():
			return true
		return false

func _init():
	sceneID = "QuestLogScene"

func _run():
	if(state == ""):
		var quests = GM.QS.getQuests()
		
		var mainQuests = []
		var sideQuests = []
		var completedQuests = []
		
		for questID in quests:
			var quest:QuestBase = quests[questID]
			if(!quest.isVisible()):
				continue
			
			if(quest.isCompleted()):
				completedQuests.append(quest)
				continue
			
			if(quest.isMainQuest()):
				mainQuests.append(quest)
			else:
				sideQuests.append(quest)
		
		mainQuests.sort_custom(MyQuestSorter, "sort_descending")
		sideQuests.sort_custom(MyQuestSorter, "sort_descending")
		completedQuests.sort_custom(MyQuestSorter, "sort_descending")
		
		saynn("Main tasks:")
		
		if(mainQuests.size() == 0):
			saynn("Nothing")
		
		for quest in mainQuests:
			sayn("[b]"+quest.getVisibleName()+"[/b]")
			for line in quest.getProgress():
				sayn("* "+line)
			sayn("")
			
		saynn("Side tasks:")
		
		if(sideQuests.size() == 0):
			saynn("Nothing")
		
		for quest in sideQuests:
			sayn("[b]"+quest.getVisibleName()+"[/b]")
			for line in quest.getProgress():
				sayn("* "+line)
			sayn("")
			
		saynn("Completed tasks:")
		
		if(completedQuests.size() == 0):
			saynn("Nothing")
		
		for quest in completedQuests:
			sayn("[b]"+quest.getVisibleName()+"[/b] (Completed)")
			for line in quest.getProgress():
				sayn("* "+line)
			sayn("")
		
		addButton("Close", "Close the quest log", "endthescene")

func _react(_action: String, _args):
	if(_action == "endthescene"):
		endScene()
		return

func _react_scene_end(_tag, _result):
	setState("")
