extends EditorProperty

const ProfileResource = preload("profile_resource.gd")
const FileUtils = preload("baking/utils/file_utils.gd")
const ProfilesDir = "res://addons/octahedral_impostors/profiles/"

var profile_option_button := OptionButton.new()
var edited_object = null
var needs_refresh = true


func read_baking_profiles(profile_button: OptionButton) -> Array:
	profile_button.clear()
	var profiles: Array = FileUtils.get_resources_in_dir(ProfilesDir)
	var profile_id = 0
	for prof in profiles:
		if prof is ProfileResource:
			profile_button.add_item(prof.name, profile_id)
			profile_button.set_item_metadata(profile_id, prof)
			profile_id += 1
	return profiles


func _init() -> void:
	set_physics_process(false)
	read_baking_profiles(profile_option_button)

	profile_option_button.item_selected.connect(_on_item_selected)
	add_child(profile_option_button)


func _on_item_selected(_index: int) -> void:
	edited_object = get_edited_object()
	edited_object.profile = profile_option_button.get_selected_metadata()


func update_profile(imp: OctaImpostor) -> void:
	for ob_idx in profile_option_button.get_item_count():
		if profile_option_button.get_item_metadata(ob_idx) == imp.profile:
			profile_option_button.select(ob_idx)
	if imp.profile == null:
		imp.profile = profile_option_button.get_selected_metadata()


func update_property() -> void:
	if not needs_refresh:
		return
	edited_object = get_edited_object()
	update_profile(edited_object)
	needs_refresh = false
