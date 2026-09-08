-- function OnMsg.ClassesGenerate(classdefs) 
-- classdefs.Ordnance_visual_22mm = {
-- __parents = { "OrdnanceVisual" },
-- properties = {
-- }
-- print("class", classdefs.Ordnance_visual_22mm)
-- end
-- function OnMsg.ModsReloaded()
-- local class = g_Classes["Ordnance_visual_22mm"]
-- if not class then 
-- return 
-- end
-- for i, v in ipairs(class.properties) do
-- if v.id == "AttachOffset" then
-- print(v.default)
-- v.default = (0.25, 0, 0.027)
-- break
-- end
-- end
-- end
function place_22mm_FXs()
	local fx_list = rat_22mm_frag_fxs()

	local actor_list = {"_20mm_frag_papovka", "_20mm_frag_M70"}

	for _, actor in ipairs(actor_list) do
		for class, class_fxs in pairs(fx_list) do
			for _, fx in ipairs(class_fxs) do
				fx.Actor = actor
				fx.id = rat_generate_random_id_TOG()
				fx = PlaceObj(class, fx)
				--if not FXRules[fx] then
				AddInRules(fx)
				--	print("GBO-TOG: FX added to rules: ", fx)
				--else
				--	print("GBO-TOG: FX already in rules: ", fx)
				--end
			end
		end
	end
end

function OnMsg.GetCustomFXInheritActorRules(rules)
	place_22mm_FXs()
end

function rat_generate_random_id_TOG()

	return tostring(math.random(1000000000000000, 9999999999999999))
end

function rat_22mm_frag_fxs()
	local fx_list = {
		['ActionFXParticles'] = {
			{
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Comment = "CORE FX",
				Delay = 50,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 200),
				Particles = "Explosion_40mmFrag",
				Scale = 120,
				Source = "ActionPos",
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "6449473450916606685",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Comment = "Explosion Initial FX",
				GameTime = true,
				Moment = "start",
				Particles = "Explosion_InitialBang_Strong",
				Scale = 150,
				Source = "ActionPos",
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "GP-wKnPH",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Comment = "additional explosion fx",
				Delay = 50,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 70,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "4384804400617920201",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Comment = "additional explosion fx",
				Delay = 50,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 60,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "801565293855056834",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Comment = "additional explosion fx",
				Delay = 50,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 50,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "4002479830442457106",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Comment = "additional explosion fx",
				Delay = 50,
				GameTime = true,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Orientation = "Random2D",
				Particles = "Explosion_Fire_splinter",
				Scale = 40,
				Source = "ActionPos",
				Time = 299,
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "2513333587893079608",
			}},

		----
		['ActionFXSound'] = {
			{
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Delay = 300,
				GameTime = true,
				Moment = "start",
				Offset = point(20000, 0, 0),
				OffsetDir = "Random2D",
				Sound = "Grenade_explosion-dirt",
				Source = "ActionPos",
				Target = "Surface:Dirt",
				group = "Explosion - Ordnance - 40mm Frag SFX",
				id = "1297171574834168540",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Delay = 300,
				GameTime = true,
				Moment = "start",
				Offset = point(20000, 0, 0),
				OffsetDir = "Random2D",
				Sound = "Grenade_explosion-mud",
				Source = "ActionPos",
				Target = "Surface:Mud",
				group = "Explosion - Ordnance - 40mm Frag SFX",
				id = "6014387875478975677",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Delay = 300,
				GameTime = true,
				Moment = "start",
				Offset = point(20000, 0, 0),
				OffsetDir = "Random2D",
				Sound = "Grenade_explosion-sand",
				Source = "ActionPos",
				Target = "Surface:Sand",
				group = "Explosion - Ordnance - 40mm Frag SFX",
				id = "2283112313221449896",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Delay = 300,
				GameTime = true,
				Moment = "start",
				Offset = point(20000, 0, 0),
				OffsetDir = "Random2D",
				Sound = "Grenade_explosion-water",
				Source = "ActionPos",
				Target = "Surface:ShallowWater",
				group = "Explosion - Ordnance - 40mm Frag SFX",
				id = "LsmsyN0U",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Delay = 300,
				GameTime = true,
				Moment = "start",
				Offset = point(20000, 0, 0),
				OffsetDir = "Random2D",
				Sound = "Grenade_explosion-water",
				Source = "ActionPos",
				Target = "Surface:Water",
				group = "Explosion - Ordnance - 40mm Frag SFX",
				id = "690275799262925765",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Delay = 600,
				GameTime = true,
				Moment = "start",
				Offset = point(20000, 0, 0),
				OffsetDir = "Random2D",
				Sound = "Grenade_explosion-fragments",
				Source = "ActionPos",
				group = "Explosion - Ordnance - 40mm Frag SFX",
				id = "4028426764168674608",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Delay = 900,
				GameTime = true,
				Moment = "start",
				Offset = point(20000, 0, 0),
				OffsetDir = "Random2D",
				Sound = "Grenade_explosion-fragments",
				Source = "ActionPos",
				group = "Explosion - Ordnance - 40mm Frag SFX",
				id = "1757011272051340462",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Delay = 300,
				GameTime = true,
				Moment = "start",
				Offset = point(20000, 0, 0),
				OffsetDir = "Random2D",
				Sound = "Grenade_explosion-fragments",
				Source = "ActionPos",
				group = "Explosion - Ordnance - 40mm Frag SFX",
				id = "7683731855498364791",
			}, {
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Moment = "start",
				Sound = "MGLGrenadeLauncher_explosion",
				Source = "ActionPos",
				group = "Explosion - Ordnance - 40mm Frag SFX",
				id = "499956284113635620",
			}},
		-----

		['ActionFXLight'] = {
			{
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				CastShadows = true,
				Color = 4293958703,
				Delay = 100,
				FadeIn = 50,
				FadeOut = 400,
				FadeOutColor = 4293958703,
				GameTime = true,
				Intensity = 40,
				Moment = "start",
				Offset = point(0, 0, 1000),
				Radius = 10000,
				Source = "ActionPos",
				StartColor = 4293958703,
				StartIntensity = 60,
				Time = 460,
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "4937797771071966073",
			}},
		['ActionFXWindMod'] = {
			{
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Comment = "explosion impact wind",
				HalfHeight = 100,
				HarmonicConst = 15000,
				HarmonicDamping = 500,
				Moment = "start",
				ObjHalfHeight = 100,
				ObjOuterRange = 10000,
				ObjRange = 600,
				ObjStrength = 50000,
				Offset = point(0, 0, 1000),
				OnTerrainOnly = false,
				OuterRange = 7000,
				Range = 100,
				Source = "ActionPos",
				Strength = 0,
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "5296254961298145908",
			}},
		------------
		['ActionFXDecal'] = {
			{
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				ColorModifier = 4280953386,
				Delay = 100,
				FxId = "decexpl_generic",
				GameTime = true,
				Moment = "start",
				Object = "DecExplosion_01",
				Object2 = "DecExplosion_02",
				Offset = point(0, 0, -400),
				Orientation = "OrientByTerrainWithRandomAngle",
				SortPriority = 3,
				Source = "ActionPos",
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "3496754109276354567",
			}},
		['ActionFXCameraShake'] = {

			{
				Action = "Explosion",
				Actor = "_40mmFragGrenade",
				Delay = 100,
				DetailLevel = 100,
				Duration = 600,
				Frequency = 8,
				GameTime = true,
				Moment = "start",
				ShakeOffset = 30,
				ShakeRadiusInSight = 40000,
				ShakeRadiusOutOfSight = 20000,
				Source = "ActionPos",
				group = "Explosion - Ordnance - 40mm Frag VFX",
				id = "g15Xq8kS",
			}},
	}
	return fx_list
end
