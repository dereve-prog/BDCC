extends Attack

func _init():
	id = "simplekickattack"
	category = Category.Physical
	aiCategory = AICategory.Offensive
	
func getVisibleName():
	return "Kick"
	
func getVisibleDesc():
	return "Kick them for 10-15 damage. May knock the opponent down with a low chance"
	
func _doAttack(_attacker, _reciever):
	var attackerName = _attacker.getName()
	var recieverName = _reciever.getName()
	
	if(checkMissed(_attacker, _reciever, DamageType.Physical)):
		return attackerName + " tries to kick " + recieverName + " but misses"
	
	if(checkDodged(_attacker, _reciever, DamageType.Physical)):
		return attackerName + " tries to kick " + recieverName + " but " + recieverName + " dodges the attack"
	
	var damage = doDamage(_attacker, _reciever, DamageType.Physical, RNG.randi_range(10, 15))
	#_reciever.addEffect(StatusEffect.Bleeding)

	var texts = [
		attackerName + " kicks " + recieverName + " and does "+str(damage)+" damage!"
	]
	var text = RNG.pick(texts)
	if(RNG.chance(20) && !_reciever.hasEffect(StatusEffect.Collapsed)):
		text += "\n"+recieverName+" loses "+_reciever.hisHer()+" balance and collapses onto the floor"
		_reciever.addEffect(StatusEffect.Collapsed)
	
	return text
	
func _canUse(_attacker, _reciever):
	return true

func getRequirements():
	return [["freelegs"]]

func getAnticipationText(_attacker, _reciever):
	return _attacker.getName() + " lunges forward and tries to sparta-kick you"

func getAttackAnimation():
	return TheStage.Kick
