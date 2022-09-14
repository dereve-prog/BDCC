extends EventBase

func _init():
	id = "AlexRynardStartPantiesQuestEvent"

func registerTriggers(es):
	es.addTrigger(self, Trigger.TalkingToNPC, "alexrynard")
	
func run(_triggerID, _args):
	if(!getFlag("PortalPantiesModule.Panties_AskedAlex")):
		addButtonUnlessLate("Credits", "Ask if you can help somehow", "startpanties")
	else:
		if(!getFlag("PortalPantiesModule.Panties_GavePantiesToAlex")):
			if(GM.pc.getInventory().hasItemID("plainPanties")):
				addButtonUnlessLate("Give panties", "Give Alex the female panties that he wanted", "givepanties")
			else:
				addDisabledButton("Give panties", "You don't have generic female panties in your inventory")

func getPriority():
	return 0

func onButton(_method, _args):
	if(_method == "startpanties"):
		runScene("AlexRynardStartPantiesQuestScene")
		setFlag("PortalPantiesModule.Panties_AskedAlex", true)
	if(_method == "givepanties"):
		runScene("AlexRynardPantiesQuestGivePanties")
		setFlag("PortalPantiesModule.Panties_GavePantiesToAlex", true)
		GM.pc.getInventory().removeXOfOrDestroy("plainPanties", 1)