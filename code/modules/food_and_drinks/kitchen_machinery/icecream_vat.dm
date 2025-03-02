#define ICECREAM_VANILLA 1
#define ICECREAM_CHOCOLATE 2
#define ICECREAM_STRAWBERRY 3
#define ICECREAM_BLUE 4
#define ICECREAM_LEMON 5
#define ICECREAM_CARAMEL 6
#define ICECREAM_BANANA 7
#define ICECREAM_ORANGE 8
#define ICECREAM_PEACH 9
#define ICECREAM_CHERRY_CHOCOLATE 10
#define CONE_WAFFLE 11
#define CONE_CHOC 12

/obj/machinery/icecream_vat
	name = "ice cream vat"
	desc = "Ding-aling ding dong. Get your Nanotrasen-approved ice cream!"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "icecream_vat"
	density = TRUE
	anchored = FALSE
	use_power = NO_POWER_USE
	layer = BELOW_OBJ_LAYER
	max_integrity = 300
	var/list/product_types = list()
	var/dispense_flavour = ICECREAM_VANILLA
	var/flavour_name = "vanilla"
	var/static/list/icecream_vat_reagents = list(
		/datum/reagent/consumable/milk = 6,
		/datum/reagent/consumable/flour = 6,
		/datum/reagent/consumable/sugar = 6,
		/datum/reagent/consumable/ice = 6,
		/datum/reagent/consumable/coco = 6,
		/datum/reagent/consumable/vanilla = 5,
		/datum/reagent/consumable/berryjuice = 5,
		/datum/reagent/consumable/ethanol/singulo = 5,
		/datum/reagent/consumable/lemonjuice = 5,
		/datum/reagent/consumable/caramel = 5,
		/datum/reagent/consumable/banana = 5,
		/datum/reagent/consumable/orangejuice = 5,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/peachjuice = 5,
		/datum/reagent/consumable/cherryjelly = 5)

/obj/machinery/icecream_vat/proc/get_ingredient_list(type)
	switch(type)
		if(ICECREAM_CHOCOLATE)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/coco)
		if(ICECREAM_STRAWBERRY)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/berryjuice)
		if(ICECREAM_BLUE)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/ethanol/singulo)
		if(ICECREAM_LEMON)
			return list(/datum/reagent/consumable/ice, /datum/reagent/consumable/lemonjuice)
		if(ICECREAM_CARAMEL)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/caramel)
		if(ICECREAM_BANANA)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/banana)
		if(ICECREAM_ORANGE)
			return list(/datum/reagent/consumable/cream, /datum/reagent/consumable/ice, /datum/reagent/consumable/orangejuice)
		if(ICECREAM_PEACH)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/peachjuice)
		if(ICECREAM_CHERRY_CHOCOLATE)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/coco, /datum/reagent/consumable/cherryjelly)
		if(CONE_WAFFLE)
			return list(/datum/reagent/consumable/flour, /datum/reagent/consumable/sugar)
		if(CONE_CHOC)
			return list(/datum/reagent/consumable/flour, /datum/reagent/consumable/sugar, /datum/reagent/consumable/coco)
		else //ICECREAM_VANILLA
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/vanilla)


/obj/machinery/icecream_vat/proc/get_flavour_name(flavour_type)
	switch(flavour_type)
		if(ICECREAM_CHOCOLATE)
			return "chocolate"
		if(ICECREAM_STRAWBERRY)
			return "strawberry"
		if(ICECREAM_BLUE)
			return "blue"
		if(ICECREAM_LEMON)
			return "lemon sorbet"
		if(ICECREAM_CARAMEL)
			return "caramel"
		if(ICECREAM_BANANA)
			return "banana"
		if(ICECREAM_ORANGE)
			return "orangesicle"
		if(ICECREAM_PEACH)
			return "peach"
		if(ICECREAM_CHERRY_CHOCOLATE)
			return "cherry chocolate"
		if(CONE_WAFFLE)
			return "waffle"
		if(CONE_CHOC)
			return "chocolate"
		else //ICECREAM_VANILLA
			return "vanilla"


/obj/machinery/icecream_vat/Initialize(mapload)
	. = ..()
	while(product_types.len < 12)
		product_types.Add(5)
	create_reagents(100, NO_REACT | OPENCONTAINER)
	for(var/reagent in icecream_vat_reagents)
		reagents.add_reagent(reagent, icecream_vat_reagents[reagent])

/obj/machinery/icecream_vat/ui_interact(mob/user)
	. = ..()
	var/dat
	dat += "<b>ICE CREAM</b><br><div class='statusDisplay'>"
	dat += "<b>Dispensing: [flavour_name] icecream </b> <br><br>"
	dat += "<b>Vanilla ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_VANILLA]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_VANILLA];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_VANILLA];amount=5'><b>x5</b></a> [product_types[ICECREAM_VANILLA]] scoops left. (Ingredients: milk, ice)<br>"
	dat += "<b>Strawberry ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_STRAWBERRY]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_STRAWBERRY];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_STRAWBERRY];amount=5'><b>x5</b></a> [product_types[ICECREAM_STRAWBERRY]] dollops left. (Ingredients: milk, ice, berry juice)<br>"
	dat += "<b>Chocolate ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_CHOCOLATE]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CHOCOLATE];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CHOCOLATE];amount=5'><b>x5</b></a> [product_types[ICECREAM_CHOCOLATE]] dollops left. (Ingredients: milk, ice, coco powder)<br>"
	dat += "<b>Blue ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_BLUE]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_BLUE];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_BLUE];amount=5'><b>x5</b></a> [product_types[ICECREAM_BLUE]] dollops left. (Ingredients: milk, ice, singulo)<br>"
	dat += "<b>Lemon sorbet ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_LEMON]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_LEMON];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_LEMON];amount=5'><b>x5</b></a> [product_types[ICECREAM_LEMON]] dollops left. (Ingredients: ice, lemon juice)<br>"
	dat += "<b>Caramel ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_CARAMEL]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CARAMEL];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CARAMEL];amount=5'><b>x5</b></a> [product_types[ICECREAM_CARAMEL]] dollops left. (Ingredients: milk, ice, caramel)<br>"
	dat += "<b>Banana ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_BANANA]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_BANANA];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_BANANA];amount=5'><b>x5</b></a> [product_types[ICECREAM_BANANA]] dollops left. (Ingredients: milk, ice, banana juice)<br>"
	dat += "<b>Orangesicle ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_ORANGE]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_ORANGE];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_ORANGE];amount=5'><b>x5</b></a> [product_types[ICECREAM_ORANGE]] dollops left. (Ingredients: cream, ice, orange juice)<br>"
	dat += "<b>Peach ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_PEACH]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_PEACH];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_PEACH];amount=5'><b>x5</b></a> [product_types[ICECREAM_PEACH]] dollops left. (Ingredients: milk, ice, peach juice)<br>"
	dat += "<b>Cherry chocolate ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_CHERRY_CHOCOLATE]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CHERRY_CHOCOLATE];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CHERRY_CHOCOLATE];amount=5'><b>x5</b></a> [product_types[ICECREAM_CHERRY_CHOCOLATE]] dollops left. (Ingredients: milk, ice, coco powder, cherry jelly)<br></div>"
	dat += "<br><b>CONES</b><br><div class='statusDisplay'>"
	dat += "<b>Waffle cones:</b> <a href='?src=[REF(src)];cone=[CONE_WAFFLE]'><b>Dispense</b></a> <a href='?src=[REF(src)];make=[CONE_WAFFLE];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[CONE_WAFFLE];amount=5'><b>x5</b></a> [product_types[CONE_WAFFLE]] cones left. (Ingredients: flour, sugar)<br>"
	dat += "<b>Chocolate cones:</b> <a href='?src=[REF(src)];cone=[CONE_CHOC]'><b>Dispense</b></a> <a href='?src=[REF(src)];make=[CONE_CHOC];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[CONE_CHOC];amount=5'><b>x5</b></a> [product_types[CONE_CHOC]] cones left. (Ingredients: flour, sugar, coco powder)<br></div>"
	dat += "<br>"
	dat += "<b>VAT CONTENT</b><br>"
	for(var/datum/reagent/R in reagents.reagent_list)
		dat += "[R.name]: [R.volume]"
		dat += "<A href='?src=[REF(src)];disposeI=[R.type]'>Purge</A><BR>"
	dat += "<a href='?src=[REF(src)];refresh=1'>Refresh</a> <a href='?src=[REF(src)];close=1'>Close</a>"

	var/datum/browser/popup = new(user, "icecreamvat","Icecream Vat", 700, 500, src)
	popup.set_content(dat)
	popup.open()

/obj/machinery/icecream_vat/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/reagent_containers/food/snacks/icecream))
		var/obj/item/reagent_containers/food/snacks/icecream/I = O
		if(!I.ice_creamed)
			if(product_types[dispense_flavour] > 0)
				visible_message("[icon2html(src, viewers(src))] [span_info("[user] scoops delicious [flavour_name] ice cream into [I].")]")
				product_types[dispense_flavour] -= 1
				I.add_ice_cream(flavour_name)
				if(I.reagents.total_volume < 10)
					I.reagents.add_reagent(/datum/reagent/consumable/sugar, 10 - I.reagents.total_volume)
			else
				to_chat(user, span_warning("There is not enough ice cream left!"))
		else
			to_chat(user, span_notice("[O] already has ice cream in it."))
		return 1
	else if(O.is_drainable())
		return
	else
		return ..()

/obj/machinery/icecream_vat/proc/make(mob/user, make_type, amount)
	for(var/R in get_ingredient_list(make_type))
		if(reagents.has_reagent(R, amount))
			continue
		amount = 0
		break
	if(amount)
		for(var/R in get_ingredient_list(make_type))
			reagents.remove_reagent(R, amount)
		product_types[make_type] += amount
		var/flavour = get_flavour_name(make_type)
		if(make_type > 4)
			src.visible_message(span_info("[user] cooks up some [flavour] cones."))
		else
			src.visible_message(span_info("[user] whips up some [flavour] icecream."))
	else
		to_chat(user, span_warning("You don't have the ingredients to make this!"))

/obj/machinery/icecream_vat/Topic(href, href_list)
	if(..())
		return
	if(href_list["select"])
		dispense_flavour = text2num(href_list["select"])
		flavour_name = get_flavour_name(dispense_flavour)
		src.visible_message(span_notice("[usr] sets [src] to dispense [flavour_name] flavoured ice cream."))

	if(href_list["cone"])
		var/dispense_cone = text2num(href_list["cone"])
		var/cone_name = get_flavour_name(dispense_cone)
		if(product_types[dispense_cone] >= 1)
			product_types[dispense_cone] -= 1
			var/obj/item/reagent_containers/food/snacks/icecream/I = new(src.loc)
			I.set_cone_type(cone_name)
			src.visible_message(span_info("[usr] dispenses a crunchy [cone_name] cone from [src]."))
		else
			to_chat(usr, span_warning("There are no [cone_name] cones left!"))

	if(href_list["make"])
		var/amount = (text2num(href_list["amount"]))
		var/C = text2num(href_list["make"])
		make(usr, C, amount)

	if(href_list["disposeI"])
		reagents.del_reagent(href_list["disposeI"])

	updateDialog()

	if(href_list["refresh"])
		updateDialog()

	if(href_list["close"])
		usr.unset_machine()
		usr << browse(null,"window=icecreamvat")
	return

/obj/item/reagent_containers/food/snacks/icecream
	name = "ice cream cone"
	desc = "Delicious waffle cone, but no ice cream."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "icecream_cone_waffle" //default for admin-spawned cones, href_list["cone"] should overwrite this all the time
	var/ice_creamed = 0
	var/cone_type
	bitesize = 3
	foodtype = GRAIN
	tastes = list("cold" = 6, "creamy" = 4)

/obj/item/reagent_containers/food/snacks/icecream/Initialize(mapload)
	. = ..()
	create_reagents(20)
	reagents.add_reagent(/datum/reagent/consumable/nutriment, 4)

/obj/item/reagent_containers/food/snacks/icecream/proc/set_cone_type(cone_name)
	cone_type = cone_name
	icon_state = "icecream_cone_[cone_name]"
	switch (cone_type)
		if ("waffle")
			reagents.add_reagent(/datum/reagent/consumable/nutriment, 1)
		if ("chocolate")
			reagents.add_reagent(/datum/reagent/consumable/coco, 1) // chocolate ain't as nutritious kids

	desc = "Delicious [cone_name] cone, but no ice cream."


/obj/item/reagent_containers/food/snacks/icecream/proc/add_ice_cream(flavour_name)
	name = "[flavour_name] icecream"
	src.add_overlay("icecream_[flavour_name]")
	switch (flavour_name) // adding the actual reagents advertised in the ingredient list
		if ("vanilla")
			desc = "A delicious [cone_type] cone filled with vanilla ice cream. All the other ice creams take content from it."
			foodtype = DAIRY | SUGAR
		if ("chocolate")
			desc = "A delicious [cone_type] cone filled with chocolate ice cream. Surprisingly, made with real cocoa."
			foodtype = DAIRY | CHOCOLATE | SUGAR
			reagents.add_reagent(/datum/reagent/consumable/coco, 2)
		if ("strawberry")
			desc = "A delicious [cone_type] cone filled with strawberry ice cream. Definitely not made with real strawberries."
			foodtype = DAIRY | FRUIT | SUGAR
			reagents.add_reagent(/datum/reagent/consumable/berryjuice, 2)
		if ("blue")
			desc = "A delicious [cone_type] cone filled with blue ice cream. Made with real... blue?"
			foodtype = DAIRY | SUGAR | ALCOHOL
			reagents.add_reagent(/datum/reagent/consumable/ethanol/singulo, 2)
		if ("lemon sorbet")
			desc = "A delicious [cone_type] cone filled with lemon sorbet. Like frozen lemonade in a cone."
			foodtype = SUGAR | FRUIT
			reagents.add_reagent(/datum/reagent/consumable/lemonjuice, 2)
		if ("caramel")
			desc = "A delicious [cone_type] cone filled with caramel ice cream. It is deliciously sweet."
			foodtype = DAIRY | SUGAR | CHOCOLATE
			reagents.add_reagent(/datum/reagent/consumable/caramel, 2)
		if ("banana")
			desc = "A delicious [cone_type] cone filled with banana ice cream. Honk!"
			foodtype = DAIRY | FRUIT | SUGAR
			reagents.add_reagent(/datum/reagent/consumable/banana, 2)
		if ("orangesicle")
			desc = "A delicious [cone_type] cone filled with orange creamsicle. Not quite the same off the stick..."
			foodtype = DAIRY | FRUIT | SUGAR
			reagents.add_reagent(/datum/reagent/consumable/orangejuice, 2)
		if ("peach")
			desc = "A delicious [cone_type] cone filled with limited edition peach flavour. Enjoy it while it lasts!"
			foodtype = DAIRY | FRUIT | SUGAR
			reagents.add_reagent(/datum/reagent/consumable/peachjuice, 2)
		if ("cherry chocolate")
			desc = "A delicious [cone_type] cone filled with cherry chocolate ice cream. It is wonderfully tangy and sweet."
			foodtype = DAIRY | FRUIT | SUGAR | CHOCOLATE
			reagents.add_reagent(/datum/reagent/consumable/cherryjelly, 2)
		if ("mob")
			desc = "A suspicious [cone_type] cone filled with bright red ice cream. That's probably not strawberry..."
			foodtype = DAIRY | MICE | SUGAR
			reagents.add_reagent(/datum/reagent/liquidgibs, 2)
	ice_creamed = 1

/obj/item/reagent_containers/food/snacks/icecream/proc/add_mob_flavor(mob/M)
	add_ice_cream("mob")
	name = "[M.name] icecream"

/obj/machinery/icecream_vat/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/metal(loc, 4)
	qdel(src)


#undef ICECREAM_VANILLA
#undef ICECREAM_CHOCOLATE
#undef ICECREAM_STRAWBERRY
#undef ICECREAM_BLUE
#undef ICECREAM_LEMON
#undef ICECREAM_CARAMEL
#undef ICECREAM_BANANA
#undef ICECREAM_ORANGE
#undef ICECREAM_PEACH
#undef ICECREAM_CHERRY_CHOCOLATE
#undef CONE_WAFFLE
#undef CONE_CHOC