function OnMsg.RevisedMagPropsAddedToFirearms()

    ---  AK47 Mag
    REV_SetupWeapon(PapovkaSKS_1, "AK762", "SKS_mag", "MagSmall_GBOTOG",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(Papovka2SKS_1, "AK762", "SKS_mag", "MagSmall_GBOTOG",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(Type56A_1, "AK762", "SKS_mag", "MagSmall_GBOTOG",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(Type56B_1, "AK762", "SKS_mag", "MagSmall_GBOTOG",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(Type56C_1, "AK762", "SKS_mag", "MagSmall_GBOTOG",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(Type56D_1, "AK762", "SKS_mag", "MagSmall_GBOTOG",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(M70_1, "AK762", "AK47Magazine", "MagNormal",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(M70D_1, "AK762", "AK47Magazine", "MagNormal",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(RK62_1, "AK762", "AK47Magazine", "MagNormal",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(RK95_1, "AK762", "AK47Magazine", "MagNormal",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})

    --- HKG3
    REV_SetupWeapon(G3A3Green_1, "HKG3", "HKG3Magazine", "MagNormal", {"MagLarge", "MagNormal"})
    REV_SetupWeapon(G3A3_1, "HKG3", "HKG3Magazine", "MagNormal", {"MagLarge", "MagNormal"})

    --- STANAG
    ----- Small mags (10 round) not used for now, due to model incompatibility with vanilla guns
    REV_SetupWeapon(HK33A2_1, "AR15", "STANAGMagazine", "MagLarge", {"MagLarge", "MagNormal"}) -- ,"MagSmall_GBOTOG" })
    REV_SetupWeapon(HK53_1, "AR15", "STANAGMagazine", "MagLarge", {"MagLarge", "MagNormal"}) -- , "MagSmall_GBOTOG" })
    REV_SetupWeapon(TAR21_1, "AR15", "STANAGMagazine", "MagLarge", {"MagLarge", "MagNormal"}) -- , "MagSmall_GBOTOG" })
    ----- HK23 not using STANAG for now due to lack of models/also to not make the drum mag available for all STANAG guns, due to the way Revised Mags implements this
    -- REV_SetupWeapon(HK23ECamo_1, "AR15", "STANAGMagazine", "MagLarge", { "MagLarge", "MagNormal"})--, "MagSmall_GBOTOG" })
    -- REV_SetupWeapon(HK23E_1, "AR15", "STANAGMagazine", "MagLarge", { "MagLarge", "MagNormal"})--, "MagSmall_GBOTOG" })	

    --- AK74 Mag
    REV_SetupWeapon(AN94_1, "AK545", "AK74Magazine", "MagNormalFine",
                    {"MagLargeFine", "MagLarger", "MagNormalFine"})

    --- 9x39 
    REV_SetupWeapon(VSS_1, "VSS939", "VSS_Mag", "MagNormal", {"MagNormal", "MagLarge"})
    REV_SetupWeapon(VSK94_1, "VSS939", "VSK_Mag", "MagLarge", {"MagNormal", "MagLarge"})

    ---- Glock
    REV_SetupWeapon(Glock17_1, "Glock", "GlockMagazine", "MagNormal", {"MagNormal", "MagLarge"})
end

function RatTOG_RevMag_OnClassesGenerateChangeDefaultMags()
    if not IsMod_loaded('URkxyfE') then
        return
    end
    RatTOG_RevMag_ChangeDefaultMag(PapovkaSKS_1, "SKS_mag")
    RatTOG_RevMag_ChangeDefaultMag(Papovka2SKS_1, "SKS_mag")
    RatTOG_RevMag_ChangeDefaultMag(Type56A_1, "SKS_mag")
    RatTOG_RevMag_ChangeDefaultMag(Type56B_1, "SKS_mag")
    RatTOG_RevMag_ChangeDefaultMag(Type56C_1, "SKS_mag")
    RatTOG_RevMag_ChangeDefaultMag(Type56D_1, "SKS_mag")
end

function RatTOG_RevMag_ChangeDefaultMag(wep_class, mag_id)
    if wep_class then
        local compSlots = wep_class.ComponentSlots or {}
        for i, slot in ipairs(compSlots) do
            if slot.SlotType == "Magazine" then
                slot.DefaultComponent = mag_id
                break
            end
        end
    end
end

function RatTOG_RevMag_ApplyMap(map)
    if not IsMod_loaded("URkxyfE") then
        return
    end

    map = map

    for mag_id, visual_table in pairs(map) do
        local mag = WeaponComponents[mag_id]
        if not mag or not mag.Visuals then
            print("RAT MOD REVMAG - error: mag_id `" .. mag_id ..
                      "` is invalid or has no `Visuals` field.")
            goto continue
        end

        for _, visual in ipairs(visual_table) do
            local found = false
            --print("RAT MOD REVMAG - Processing-------------mag_id:    ", mag_id,
            --      "     --------wep:    ", visual.ApplyTo)
            -- Check for existing entry with the same ApplyTo
            for i, existing_visual in ipairs(mag.Visuals) do

                if existing_visual.ApplyTo == visual.ApplyTo then
                    mag.Visuals[i] = visual -- Overwrite existing entry
                    found = true
                    break
                end
            end

            -- If no matching entry was found, insert the new visual
            if not found then
                table.insert(mag.Visuals, visual)
            end

        end

        -- mag:PostLoad()
        ::continue::
    end

    return "true"
end

function GBOTOG_RevMag_CreateMagazine_manual()
    if not IsMod_loaded("URkxyfE") then
        return
    end
    UndefineClass('SKS_mag')
    DefineClass.SKS_mag = {
        __parents = {"RifleMag"},
        __generated_by_class = "ModItemInventoryItemCompositeDef",

        object_class = "RifleMag",
        ScrapParts = 3,
        Repairable = false,
        Icon = "Mod/KKh3Yhf/Images/Papovka_mag_def.png",
        DisplayName = T(617292240809, --[[ModItemInventoryItemCompositeDef SKS_mag DisplayName]]
                        "Small Magazine"),
        DisplayNamePlural = T(830309334617, --[[ModItemInventoryItemCompositeDef SKS_mag DisplayNamePlural]]
                              "Small Magazines"),
        Description = T(620014307820, --[[ModItemInventoryItemCompositeDef SKS_mag Description]]
                        "Ten round 7.62 WP magazine."),
        AdditionalHint = T(905321061767, --[[ModItemInventoryItemCompositeDef SKS_mag AdditionalHint]]
                           "7.62mm"),
        Cost = 299,
        CanAppearInShop = true,
        MaxStock = 6,
        RestockWeight = 90,
        CanBeConsumed = false,
        CategoryPair = "RifleMags",
        PocketM_amount = 1,
        Weight = 100,
        Platform = "AK762",
        MagazineSize = 10,
        Caliber = "762WP",
        Modification = "RevMag_Tog_MagSmall",
        Type = "Rifle",
        MagReloadCosts = 11000,
        MagUnloadCosts = 6000
    }
    UndefineClass('VSK_Mag')
    DefineClass.VSK_Mag = {
        __parents = {"RifleMag"},
        __generated_by_class = "ModItemInventoryItemCompositeDef",

        object_class = "RifleMag",
        ScrapParts = 3,
        Repairable = false,
        Icon = "Mod/KKh3Yhf/Images/VSK94_mag_def.png",
        DisplayName = T(911405037653, --[[ModItemInventoryItemCompositeDef VSK_Mag DisplayName]]
                        "VSK Magazine"),
        DisplayNamePlural = T(835965409178, --[[ModItemInventoryItemCompositeDef VSK_Mag DisplayNamePlural]]
                              "VSK Magazines"),
        Description = T(799482334819, --[[ModItemInventoryItemCompositeDef VSK_Mag Description]]
                        "20 rounds magazine for the 9x39mm, commonly used in the VSK94 and also compatible with the VSS Vintorez."),
        AdditionalHint = T(311257927714, --[[ModItemInventoryItemCompositeDef VSK_Mag AdditionalHint]]
                           "9x39mm"),
        Cost = 349,
        CanAppearInShop = true,
        MaxStock = 6,
        RestockWeight = 90,
        CanBeConsumed = false,
        CategoryPair = "RifleMags",
        Platform = "VSS939",
        MagazineSize = 20,
        Caliber = "9x39",
        Modification = "MagLarge",
        Type = "Rifle",
        MagReloadCosts = 18000,
        MagUnloadCosts = 9000
    }

    UndefineClass('VSS_Mag')
    DefineClass.VSS_Mag = {
        __parents = {"RifleMag"},
        __generated_by_class = "ModItemInventoryItemCompositeDef",

        object_class = "RifleMag",
        ScrapParts = 3,
        Repairable = false,
        Icon = "Mod/KKh3Yhf/Images/VSS_Mag_def_icon.png",
        DisplayName = T(675005996003, --[[ModItemInventoryItemCompositeDef VSS_Mag DisplayName]]
                        "VSS Vintorez Magazine"),
        DisplayNamePlural = T(946026164463, --[[ModItemInventoryItemCompositeDef VSS_Mag DisplayNamePlural]]
                              "VSS Vintorez Magazines"),
        Description = T(622838903311, --[[ModItemInventoryItemCompositeDef VSS_Mag Description]]
                        "10 rounds magazine for the 9x39mm, commonly used in the VSS Vintorez and also compatible with the VSK94."),
        AdditionalHint = T(650628388358, --[[ModItemInventoryItemCompositeDef VSS_Mag AdditionalHint]]
                           "9x39mm"),
        Cost = 349,
        CanAppearInShop = true,
        MaxStock = 6,
        RestockWeight = 90,
        CanBeConsumed = false,
        CategoryPair = "RifleMags",
        PocketM_amount = 1,
        Weight = 100,
        Platform = "VSS939",
        MagazineSize = 10,
        Caliber = "9x39",
        Modification = "MagNormal",
        Type = "Rifle",
        MagReloadCosts = 11000,
        MagUnloadCosts = 6000
    }
end

local map = {

    ['MagNormal'] = {

        -----Glock

        PlaceObj('WeaponComponentVisual', {
            ApplyTo = "Glock17_1",
            Entity = "Glock17_Mag_def",
            Icon = "UI/Icons/Upgrades/glock_mag_normal",
            Slot = "Magazine",
            param_bindings = false
        }), --- VSS
        PlaceObj('WeaponComponentVisual', {
            ApplyTo = "VSS_1",
            Entity = "VSS_Mag_def",
            Icon = "Mod/KKh3Yhf/Images/VSS_Mag_def_icon.png",
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            -- Angle = -10800,			
            ApplyTo = "VSK94_1",
            Entity = "VSS_Mag_def",
            Icon = "Mod/KKh3Yhf/Images/VSS_Mag_def_icon.png",
            Offset = point(0, 3, -6),
            Scale = 77,
            Slot = "Magazine",
            param_bindings = false
        }), --- STANAG
        PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "HK33A2_1",
            Entity = "WeaponAttA_MagazineCAR15_02",
            Icon = "Mod/URkxyfE/magpictures/m4_mag_normal.png",
            Offset = point(4, 0, 0),
            Scale = 85,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "HK53_1",
            Entity = "WeaponAttA_MagazineCAR15_02",
            Icon = "Mod/URkxyfE/magpictures/m4_mag_normal.png",
            Offset = point(4, 0, 0),
            Scale = 85,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            ApplyTo = "TAR21_1",
            Entity = "WeaponAttA_MagazineCAR15_02",
            Icon = "Mod/URkxyfE/magpictures/m4_mag_normal.png",
            Offset = point(-5, 0, 1),
            Slot = "Magazine",
            param_bindings = false
        }), --- HKG3
        PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "G3A3Green_1",
            Entity = "WeaponAttA_MagazinePSG_01",
            Icon = "Mod/URkxyfE/magpictures/g3_normal.png",
            Offset = point(0, 0, -2),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "G3A3_1",
            Entity = "WeaponAttA_MagazinePSG_01",
            Icon = "Mod/URkxyfE/magpictures/g3_normal.png",
            Offset = point(0, 0, -2),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), --- AK47 Mag
        PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "RK62_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(0, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "RK95_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(1, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "M70_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(5, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "M70D_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(5, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Papovka2SKS_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(31, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "PapovkaSKS_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(31, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Type56A_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(25, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Type56B_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(25, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Type56C_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(25, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Type56D_1",
            Entity = "WeaponAttA_MagazineAK47_01",
            Icon = "UI/Icons/Upgrades/AK47_magazine",
            Offset = point(25, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        })
    },

    ["MagLarge"] = {

        --- Glock

        PlaceObj('WeaponComponentVisual', {
            ApplyTo = "Glock17_1",
            Entity = "Glock17_Mag_ext",
            Icon = "UI/Icons/Upgrades/glock_mag_large",
            Slot = "Magazine",
            param_bindings = false
        }), --- VSS
        PlaceObj('WeaponComponentVisual', {
            ApplyTo = 'VSK94_1',
            Entity = "VSK94_Mag_def",
            Icon = "Mod/KKh3Yhf/Images/VSK94_mag_def.png",
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            -- Angle = -10800,			
            ApplyTo = "VSS_1",
            Entity = "VSK94_Mag_def",
            Icon = "Mod/KKh3Yhf/Images/VSK94_mag_def.png",
            Offset = point(0, 0, 10),
            Scale = 121,
            Slot = "Magazine",
            param_bindings = false
        }), --- STANAG
        PlaceObj('WeaponComponentVisual', {
            ApplyTo = "HK33A2_1",
            Entity = "hk33_magazine_30",
            Icon = "UI/Icons/Upgrades/m16_magazine",
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            ApplyTo = "HK53_1",
            Entity = "hk33_magazine_30",
            Icon = "UI/Icons/Upgrades/m16_magazine",
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            ApplyTo = "TAR21_1",
            Entity = "Tar_Mag_def3",
            Icon = "UI/Icons/Upgrades/m16_magazine",
            Slot = "Magazine",
            param_bindings = false
        }), --- HKG3
        PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "G3A3Green_1",
            Entity = "WeaponAttA_MagazineHK21_01",
            Icon = "Mod/URkxyfE/magpictures/g3_expanded.png",
            Offset = point(0, 0, -2),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "G3A3_1",
            Entity = "WeaponAttA_MagazineHK21_01",
            Icon = "Mod/URkxyfE/magpictures/g3_expanded.png",
            Offset = point(0, 0, -2),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), --- AK47 Mag
        PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "RK62_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(0, 0, 21),
            Scale = 88,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "RK95_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(1, 0, 21),
            Scale = 88,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "M70_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(5, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "M70D_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(5, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Papovka2SKS_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(31, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "PapovkaSKS_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(31, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Type56A_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(25, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Type56B_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(25, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Type56C_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(25, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "Type56D_1",
            Entity = "WeaponAttA_MagazineAK47_02",
            Icon = "UI/Icons/Upgrades/expanded_AK47_magazine",
            Offset = point(25, 0, 21),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        })
    },

    ["MagLarger"] = {
        --- HKG3
        PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "G3A3Green_1",
            Entity = "WeaponAttA_MagazineHK21_02",
            Icon = "UI/Icons/Upgrades/hk21_mag_large",
            Offset = point(0, 0, -2),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "G3A3_1",
            Entity = "WeaponAttA_MagazineHK21_02",
            Icon = "UI/Icons/Upgrades/hk21_mag_large",
            Offset = point(0, 0, -2),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        }), ----AK74 Mag
        PlaceObj('WeaponComponentVisual', {
            Angle = -10800,
            ApplyTo = "AN94_1",
            Entity = "WeaponAttA_MagazineRPK74_03",
            Icon = "UI/Icons/Upgrades/RPK74_drum_magazine",
            Offset = point(10, 0, 20),
            Scale = 100,
            Slot = "Magazine",
            param_bindings = false
        })

    },
    ['MagNormalFine'] = {

        --[[PlaceObj('WeaponComponentVisual',{	
					Angle = -10800,					
					ApplyTo = "AN94_1",
					Entity = "WeaponAttA_MagazineAK74_01",
					Icon = "UI/Icons/Upgrades/AK74_Bakelite_magazine",
					Slot = "Magazine",
					param_bindings = false,
				}),]]

        PlaceObj('WeaponComponentVisual', {
            ApplyTo = "AN94_1",
            Entity = "AN94_Mag_def",
            Icon = "Mod/KKh3Yhf/Images/AN94_Mag_def_icon.png",
            Slot = "Magazine",
            param_bindings = false
        })
    },

    ['MagLargeFine'] = {

        --- AK74 Mag

        --[[PlaceObj('WeaponComponentVisual',{	
					Angle = -10800,					
					ApplyTo = "AN94_1",
					Entity = "WeaponAttA_MagazineAK74_02",
					Icon = "UI/Icons/Upgrades/expanded_AK74_bakelite_magazine",
					Slot = "Magazine",
					param_bindings = false,
				}),]]

        PlaceObj('WeaponComponentVisual', {
            ApplyTo = "AN94_1",
            Entity = "AN94_Mag_ext",
            Icon = "Mod/KKh3Yhf/Images/AN94_Mag_ext_icon.png",
            Slot = "Magazine",
            param_bindings = false
        })
    }
}

function GBOTOG_RevMag_WeaponComponentVisualPatch_manual()
    RatTOG_RevMag_ApplyMap(map)
end

function GBOTOG_RevMag_AddClassesToInventoryItemDefs_manual()
    if not IsMod_loaded('URkxyfE') then
        return
    end
    local classes = {"SKS_mag", "VSK_Mag", "VSS_Mag"}
    for _, id in ipairs(classes) do
        InventoryItemDefs[id] = g_Classes[id]
    end
end
