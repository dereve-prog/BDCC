extends Attack

func _init():
	id = "scratchattack"
	category = Category.Physical
	aiCategory = AICategory.Offensive
	
func getVisibleName():
	return "Scratch"
	
func getVisibleDesc():
	return "You scratch the enemy for 5-15 damage. May cause bleeding with 50%"
	
func _doAttack(_attacker, _reciever):
	var attackerName = _attacker.getName()
	var recieverName = _reciever.getName()
	
	if(checkMissed(_attacker, _reciever, DamageType.Physical)):
		return attackerName + " tries to scratch " + recieverName + " but misses and fails completely"
	
	if(checkDodged(_attacker, _reciever, DamageType.Physical)):
		return attackerName + " tries to scratch " + recieverName + " but " + recieverName + " dodges the attack masterfully"
	
	var damage = 0
	damage = doDamage(_attacker, _reciever, DamageType.Physical, RNG.randi_range(5, 15))
	if(RNG.chance(50)):
		_reciever.addEffect(StatusEffect.Bleeding)
	
	var text = attackerName + " scratches " + recieverName + " a few times and does "+str(damage)+" damage!"
	
	return text
	
func _canUse(_attacker, _reciever):
	return true

func getRequirements():
	return [["freearms"]]
