extends Object
class_name Interest

const Hates = "Hates"
const ReallyDislikes = "ReallyDislikes"
const Dislikes = "Dislikes"
const SlightlyDislikes = "SlightlyDislikes"
const Neutral = "Neutral"
const KindaLikes = "KindaLikes"
const Likes = "Likes"
const ReallyLikes = "ReallyLikes"
const Loves = "Loves"

static func getVisibleName(interest):
	if(interest == Hates):
		return "hates"
	if(interest == ReallyDislikes):
		return "really dislikes"
	if(interest == Dislikes):
		return "dislikes"
	if(interest == SlightlyDislikes):
		return "slightly dislikes"
	if(interest == Neutral):
		return "is neutral about"
	if(interest == KindaLikes):
		return "kinda likes"
	if(interest == Likes):
		return "likes"
	if(interest == ReallyLikes):
		return "really likes"
	if(interest == Loves):
		return "loves"
	return "error:"+str(interest)

static func getValue(interest):
	if(interest == Hates):
		return -1.0
	if(interest == ReallyDislikes):
		return -0.75
	if(interest == Dislikes):
		return -0.5
	if(interest == SlightlyDislikes):
		return -0.25
	if(interest == Neutral):
		return 0.0
	if(interest == KindaLikes):
		return 0.25
	if(interest == Likes):
		return 0.5
	if(interest == ReallyLikes):
		return 0.75
	if(interest == Loves):
		return 1.0
	
	return 0.0
