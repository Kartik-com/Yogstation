/obj/item/paperplane
	name = "paper plane"
	desc = "Paper, folded in the shape of a plane."
	icon = 'yogstation/icons/obj/bureaucracy.dmi'
	icon_state = "paperplane"
	throw_range = 7
	throw_speed = 1
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 50

	var/hit_probability = 2 //%
	var/obj/item/paper/internalPaper

/obj/item/paperplane/syndicate
	desc = "Paper, masterfully folded in the shape of a plane."
	throwforce = 20 //same as throwing stars, but no chance of embedding.
	hit_probability = 100 //guaranteed to cause eye damage when it hits a mob.

/obj/item/paperplane/Initialize(mapload, obj/item/paper/newPaper)
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	if(newPaper)
		internalPaper = newPaper
		flags_1 = newPaper.flags_1
		color = newPaper.color
		newPaper.forceMove(src)
	else
		internalPaper = new(src)
	update_appearance(UPDATE_ICON)

/obj/item/paperplane/handle_atom_del(atom/A)
	if(A == internalPaper)
		internalPaper = null
		if(!QDELETED(src))
			qdel(src)
	return ..()

/obj/item/paperplane/Destroy()
	QDEL_NULL(internalPaper)
	return ..()

/obj/item/paperplane/suicide_act(mob/living/user)
	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	user.Stun(200)
	user.visible_message(span_suicide("[user] jams [src] in [user.p_their()] nose. It looks like [user.p_theyre()] trying to commit suicide!"))
	user.adjust_blurriness(6)
	if(eyes)
		eyes.applyOrganDamage(rand(6,8))
	sleep(1 SECONDS)
	return (BRUTELOSS)

/obj/item/paperplane/update_overlays()
	. = ..()
	var/list/stamped = internalPaper.stamped
	if(stamped)
		for(var/S in stamped)
			. += "paperplane_[S]"

/obj/item/paperplane/attack_self(mob/user)
	to_chat(user, span_notice("You unfold [src]."))
	var/obj/item/paper/internal_paper_tmp = internalPaper
	internal_paper_tmp.forceMove(loc)
	internalPaper = null
	qdel(src)
	user.put_in_hands(internal_paper_tmp)

/obj/item/paperplane/attackby(obj/item/P, mob/living/carbon/human/user, params)
	..()
	if(istype(P, /obj/item/pen) || istype(P, /obj/item/toy/crayon))
		to_chat(user, span_notice("You should unfold [src] before changing it."))
		return

	else if(istype(P, /obj/item/stamp)) 	//we don't randomize stamps on a paperplane
		internalPaper.attackby(P, user) //spoofed attack to update internal paper.
		update_appearance(UPDATE_ICON)

	else if(P.is_hot())
		if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(10))
			user.visible_message(span_warning("[user] accidentally ignites [user.p_them()]self!"), \
				span_userdanger("You miss [src] and accidentally light yourself on fire!"))
			user.dropItemToGround(P)
			user.adjust_fire_stacks(1)
			user.ignite_mob()
			return

		if(!(in_range(user, src))) //to prevent issues as a result of telepathically lighting a paper
			return
		user.dropItemToGround(src)
		user.visible_message(span_danger("[user] lights [src] ablaze with [P]!"), span_danger("You light [src] on fire!"))
		fire_act()

	add_fingerprint(user)


/obj/item/paperplane/throw_at(atom/target, range, speed, mob/thrower, spin=FALSE, diagonals_first = FALSE, datum/callback/callback, quickstart = TRUE)
	. = ..(target, range, speed, thrower, FALSE, diagonals_first, callback, quickstart = TRUE)

/obj/item/paperplane/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(iscarbon(hit_atom))
		var/mob/living/carbon/C = hit_atom
		if(C.can_catch_item(TRUE))
			var/datum/action/innate/origami/origami_action = locate() in C.actions
			if(origami_action?.active) //if they're a master of origami and have the ability turned on, force throwmode on so they'll automatically catch the plane.
				C.throw_mode_on()

	if(..() || !ishuman(hit_atom))//if the plane is caught or it hits a nonhuman
		return
	var/mob/living/carbon/human/H = hit_atom
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(prob(hit_probability))
		if(H.is_eyes_covered())
			return
		visible_message(span_danger("\The [src] hits [H] in the eye!"))
		H.adjust_blurriness(6)
		eyes.applyOrganDamage(rand(6,8))
		H.Paralyze(40)
		H.emote("scream")

/obj/item/paper/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click [src] to fold it into a paper plane.")

/obj/item/paper/AltClick(mob/living/carbon/user, obj/item/I)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	to_chat(user, span_notice("You fold [src] into the shape of a plane!"))
	user.temporarilyRemoveItemFromInventory(src)
	var/obj/item/paperplane/plane_type = /obj/item/paperplane
	//Origami Master
	var/datum/action/innate/origami/origami_action = locate() in user.actions
	if(origami_action?.active)
		plane_type = /obj/item/paperplane/syndicate

	I = new plane_type(user, src)
	user.put_in_hands(I)
