extends Control

signal onClosePressed
onready var langList = $VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer2/LanguageList

func _ready():
	var allLangs = TranslationLanguage.getAll()
	var _i = 0
	for langID in allLangs:
		langList.add_item(allLangs[langID])
		if(langID == AutoTranslation.getTargetLanguage()):
			langList.select(_i)
		_i += 1
	$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/EnableTranslationBox.pressed = AutoTranslation.shouldTranslate()
	$VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer3/EnableManualTranslateButton.pressed = AutoTranslation.shouldHaveManualTranslateButton()

func _on_CloseButton_pressed():
	AutoTranslation.saveToFile()
	emit_signal("onClosePressed")


func _on_EnableTranslationBox_toggled(button_pressed):
	AutoTranslation.setShouldTranslate(button_pressed)


func _on_LanguageList_item_selected(index):
	var allLangs = TranslationLanguage.getAll().keys()
	print(allLangs[index])
	AutoTranslation.setTargetLanguage(allLangs[index])

func _on_EnableManualTranslateButton_toggled(button_pressed):
	AutoTranslation.setManualTransalteButton(button_pressed)
