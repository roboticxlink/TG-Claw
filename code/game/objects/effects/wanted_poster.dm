/obj/item/poster/wanted
	icon_state = "rolled_poster"
	var/wanted_name
	var/icon/person_icon
	var/datum/data/record/picked

/obj/item/poster/wanted/Initialize(mapload, icon/person_icon, wanted_name, description)
	. = ..(mapload, new /obj/structure/sign/poster/wanted(src, person_icon, wanted_name, description))
	name = "wanted poster ([wanted_name])"
	desc = "A wanted poster for [wanted_name]."

/obj/item/poster/wanted/ui_interact(mob/user, flag1)
	. = ..()
//	if(is_secured(user))

	var/names = ""
	for(var/datum/data/record/t in GLOB.data_core.general)//Picks from crew manifest.
		names += "<A href='byond://?src=[REF(src)];name=" + t.fields["name"] + "'>" + t.fields["name"] + "</A>"
	var/dat = "<tt>[names]</tt>"
	user << browse(dat, "window=poster")
	onclose(user, "poster")
	return


/obj/item/poster/wanted/Topic(href, href_list)
	..()

	if(!usr.canUseTopic(src, BE_CLOSE))
		usr << browse(null, "window=poster")
		onclose(usr, "poster")
		return

	if (href_list["name"])
		for(var/datum/data/record/E in GLOB.data_core.general)
			if(href_list["name"] == E.fields["name"])
				picked=E
		refresh_poster()



	if(usr)
		attack_self(usr)

	return

/obj/item/poster/wanted/proc/refresh_poster()
	if(picked)
		wanted_name = picked.fields["name"]
		person_icon = picked.fields["photo_front"]
	name = "wanted poster ([wanted_name])"
	desc = "A wanted poster for [wanted_name]."
	return

/obj/structure/sign/poster/wanted
	var/wanted_name

/obj/structure/sign/poster/wanted/Initialize(mapload, icon/person_icon, person_name, description)
	. = ..()
	if(!person_icon)
		return INITIALIZE_HINT_QDEL
	name = "wanted poster ([person_name])"
	wanted_name = person_name
	desc = description

	person_icon = icon(person_icon, dir = SOUTH)//copy the image so we don't mess with the one in the record.
	var/icon/the_icon = icon("icon" = 'icons/obj/poster_wanted.dmi', "icon_state" = "wanted_background")
	var/icon/icon_foreground = icon("icon" = 'icons/obj/poster_wanted.dmi', "icon_state" = "wanted_foreground")
	person_icon.Shift(SOUTH, 7)
	person_icon.Crop(7,4,26,30)
	person_icon.Crop(-5,-2,26,29)
	the_icon.Blend(person_icon, ICON_OVERLAY)
	the_icon.Blend(icon_foreground, ICON_OVERLAY)

	the_icon.Insert(the_icon, "wanted")
	the_icon.Insert(icon('icons/obj/contraband.dmi', "poster_being_set"), "poster_being_set")
	the_icon.Insert(icon('icons/obj/contraband.dmi', "poster_ripped"), "poster_ripped")
	icon = the_icon

/obj/structure/sign/poster/wanted/

/obj/structure/sign/poster/wanted/roll_and_drop(turf/location)
	var/obj/item/poster/P = ..(location)
	P.name = "wanted poster ([wanted_name])"
	P.desc = "A wanted poster for [wanted_name]."
	return P

