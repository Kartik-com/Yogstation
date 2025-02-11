/obj/effect/forcefield
	name = "FORCEWALL"
	desc = "A space wizard's magic wall."
	icon_state = "m_shield"
	anchored = TRUE
	opacity = 0
	density = TRUE
	CanAtmosPass = ATMOS_PASS_DENSITY
	/// If set, how long the force field lasts after it's created. Set to 0 to have infinite duration forcefields.
	var/initial_duration = 30 SECONDS

/obj/effect/forcefield/Initialize(mapload)
	. = ..()
	if(initial_duration)
		QDEL_IN(src, initial_duration)

/obj/effect/forcefield/singularity_pull()
	return

// The wizard's forcefield, summoned by forcewall
/obj/effect/forcefield/wizard
	/// Flags for what antimagic can just ignore our forcefields
	var/antimagic_flags = MAGIC_RESISTANCE
	/// A weakref to whoever casted our forcefield.
	var/datum/weakref/caster_weakref

/obj/effect/forcefield/wizard/Initialize(mapload, mob/caster, flags = MAGIC_RESISTANCE)
	. = ..()
	if(caster)
		caster_weakref = WEAKREF(caster)
	antimagic_flags = flags

/obj/effect/forcefield/wizard/CanAllowThrough(atom/movable/mover, border_dir)
	if(IS_WEAKREF_OF(mover, caster_weakref))
		return TRUE
	if(isliving(mover))
		var/mob/living/living_mover = mover
		if(living_mover.can_block_magic(antimagic_flags, charge_cost = 0))
			return TRUE

	return ..()

/// Cult forcefields
/obj/effect/forcefield/cult
	name = "glowing wall"
	desc = "An unholy shield that blocks all attacks."
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "cultshield"
	CanAtmosPass = ATMOS_PASS_NO
	initial_duration = 20 SECONDS

/// Mime forcefields (invisible walls)

/obj/effect/forcefield/mime
	name = "invisible wall"
	icon_state = "nothing"
	desc = "You have a bad feeling about this."
	alpha = 0

/obj/effect/forcefield/mime/advanced
	name = "invisible blockade"
	desc = "You're gonna be here awhile."
	initial_duration = 1 MINUTES

/// The cosmic heretics forcefield
/obj/effect/forcefield/cosmic_field
	name = "Cosmic Field"
	desc = "A field that cannot be passed by people marked with a cosmic star."
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "cosmic_carpet"
	anchored = TRUE
	layer = LOW_SIGIL_LAYER
	density = FALSE
	initial_duration = 30 SECONDS
	/// Flags for what antimagic can just ignore our forcefields
	var/antimagic_flags = MAGIC_RESISTANCE

/obj/effect/forcefield/cosmic_field/Initialize(mapload, flags = MAGIC_RESISTANCE)
	. = ..()
	antimagic_flags = flags

/obj/effect/forcefield/cosmic_field/CanAllowThrough(atom/movable/mover, border_dir)
	if(!isliving(mover))
		return ..()
	var/mob/living/living_mover = mover
	if(living_mover.can_block_magic(antimagic_flags, charge_cost = 0))
		return ..()
	if(living_mover.has_status_effect(/datum/status_effect/star_mark))
		return FALSE
	return ..()

/obj/effect/forcefield/cosmic_field/fast
	initial_duration = 5 SECONDS
