---- The SKS family has a fixed 10-round mag: under Revised Mags it reloads loose rounds like a
---- non-mag gun. The bench converts one to take AK mags; rat_mag_converted is saved per gun and its
---- setter restores the Magazine/Platform that Revised Mags reads, so nothing is recomputed on load.
RAT_SKS_INTERNAL_MAG = "RAT_SKS_InternalMag"
RAT_SKS_INTERNAL_SIZE = 10
RAT_SKS_AK_MAG = "AK47Magazine"
RAT_SKS_CONVERT_PARTS = 10

function OnMsg.ClassesGenerate()
    AppendClass.Firearm = {
        properties = {{id = "rat_mag_converted", editor = "bool", default = false, no_edit = true}}
    }
end

function Firearm:Setrat_mag_converted(value)
    self.rat_mag_converted = value
    if self.rat_sks_internal then
        self.Magazine = value and RAT_SKS_AK_MAG or nil
        self.Platform = value and "AK762" or nil
    end
end

local function sks_wrap_set_magazine()
    local orig = Firearm.SetMagazineComponents
    ---- Revised Mags sizes the gun from the inserted mag; the internal one has no mag item behind it
    function Firearm:SetMagazineComponents(id, is_init)
        orig(self, id, is_init)
        if self.rat_sks_internal and id == RAT_SKS_INTERNAL_MAG then
            self:RemoveModifiers(id)
            self:AddModifier(id, "MagazineSize", 1000, RAT_SKS_INTERNAL_SIZE)
        end
    end
end

function OnMsg.RevisedMagPropsAddedToFirearms()

    ---  SKS: internal mag by default, AK mags once converted
    for _, cls in ipairs{PapovkaSKS_1, Papovka2SKS_1, Type56A_1, Type56B_1, Type56C_1, Type56D_1} do
        REV_SetupWeapon(cls, "AK762", false, RAT_SKS_INTERNAL_MAG, {RAT_SKS_INTERNAL_MAG, "MagNormal", "MagLarge"})
        cls.Platform = false -- no Platform: Revised Mags gives a platform gun a phantom mag
        cls.rat_sks_internal = true
    end
    sks_wrap_set_magazine()

    ---  AK47 Mag
    REV_SetupWeapon(M70_1, "AK762", "AK47Magazine", "MagNormal",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(M70D_1, "AK762", "AK47Magazine", "MagNormal",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(RK62_1, "AK762", "AK47Magazine", "MagNormal",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})
    REV_SetupWeapon(RK95_1, "AK762", "AK47Magazine", "MagNormal",
                    {"MagLarge", "MagSmall_GBOTOG", "MagNormal"})

    --- HKG3: the G3 ships with its 20-round mag; HKG3Magazine is the PSG1's 5-round one
    REV_SetupWeapon(G3A3Green_1, "HKG3", "HKG3MagazineLarge", "MagLarge", {"MagLarge", "MagNormal"})
    REV_SetupWeapon(G3A3_1, "HKG3", "HKG3MagazineLarge", "MagLarge", {"MagLarge", "MagNormal"})

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

---- The SKS's own mag model, as a component of its own: MagSmall_GBOTOG is a 10-round AK mag here.
function RatTOG_SKS_CreateInternalMag()
    if not IsMod_loaded("URkxyfE") or WeaponComponents[RAT_SKS_INTERNAL_MAG] then
        return
    end
    local src = WeaponComponents.MagSmall_GBOTOG
    local visuals = {}
    for _, v in ipairs(src and src.Visuals or empty_table) do
        local cls = g_Classes[v.ApplyTo]
        if cls and cls.rat_sks_internal then
            visuals[#visuals + 1] = v
        end
    end
    ---- a code preset gets its id only through SetId, which is also what registers it in WeaponComponents
    local comp = PlaceObj('WeaponComponent', {
        'Slot', "Magazine",
        'DisplayName', Untranslated("Internal Magazine"),
        'Description', Untranslated("Fixed 10-round magazine, loaded with loose rounds. Converting the rifle to take AK magazines gives up the internal one."),
        'Icon', "Mod/KKh3Yhf/Images/Papovka_mag_def.png",
        'Cost', 0,
        'ModificationDifficulty', src and src.ModificationDifficulty or 0,
        'Visuals', visuals
    })
    comp:SetGroup("Default")
    comp:SetId(RAT_SKS_INTERNAL_MAG)
end

---- An AK762 mag item for a mag component, read off the classes: GBO moves some presets' platform.
function RatTOG_SKS_MagFor(component)
    for _, p in ipairs(Presets.InventoryItemCompositeDef.Default or empty_table) do
        local cls = type(p) == "table" and g_Classes[p.id]
        if cls and cls.Platform == "AK762" and cls.Modification == component then
            return p.id
        end
    end
end

local function sks_holder_sector(holder)
    local squad = holder and holder.Squad and gv_Squads[holder.Squad]
    return squad and squad.CurrentSector or gv_CurrentSectorId
end

---- Internal -> AK mags: the loose rounds go into a new empty mag of the size picked.
function RatTOG_SKS_Convert(weapon, component)
    local mag = PlaceInventoryItem(RatTOG_SKS_MagFor(component) or RAT_SKS_AK_MAG)
    mag.ammo = weapon.ammo
    weapon:SetProperty("rat_mag_converted", true)
    weapon.magazine = mag
    weapon:SetWeaponComponent("Magazine", component)
end

---- AK mags -> internal: whatever mag is inserted goes back to the owner, rounds and all.
function RatTOG_SKS_Revert(weapon, holder)
    local mag = weapon.magazine
    weapon.magazine = nil
    if mag then
        mag.ammo = weapon.ammo
        if not (holder and holder:AddItem("Inventory", mag)) then
            AddToSectorInventory(sks_holder_sector(holder), {mag})
        end
    end
    weapon.ammo = nil
    weapon:RemoveModifiers("ammo")
    weapon:SetProperty("rat_mag_converted", false)
    weapon:SetWeaponComponent("Magazine", RAT_SKS_INTERNAL_MAG)
    ObjModified(holder)
end

function OnMsg.WeaponModifiedSuccessSync(weapon, owner, modAdded, mechanic, modSlot, oldComponent)
    if modSlot ~= "Magazine" or not (weapon and weapon.rat_sks_internal) then
        return
    end
    local placed = weapon.components.Magazine
    if oldComponent == RAT_SKS_INTERNAL_MAG and placed ~= RAT_SKS_INTERNAL_MAG then
        RatTOG_SKS_Convert(weapon, placed)
    elseif oldComponent ~= RAT_SKS_INTERNAL_MAG and placed == RAT_SKS_INTERNAL_MAG then
        RatTOG_SKS_Revert(weapon, owner)
    end
    ObjModified(weapon)
end

---- Saves from before: the old SKS mag folds back into the internal one (its rounds already sit in
---- the gun's ammo); an SKS holding a real AK mag loads as converted, keeping it.
RAT_SKS_LEGACY_MAGS = {MagSmall_GBOTOG = true, RevMag_Tog_MagSmall = true}

local orig_place = PlaceInventoryItem
function PlaceInventoryItem(item_id, instance, ...)
    local obj = orig_place(item_id, instance, ...)
    local comp = obj and obj.rat_sks_internal and instance and not obj.rat_mag_converted and obj.components.Magazine
    if comp and comp ~= RAT_SKS_INTERNAL_MAG then
        if RAT_SKS_LEGACY_MAGS[comp] then
            obj.magazine = nil
            obj:SetWeaponComponent("Magazine", RAT_SKS_INTERNAL_MAG)
        else
            obj:SetProperty("rat_mag_converted", true)
        end
    end
    return obj
end

---- Bench: an internal SKS converts to any AK mag size, a converted one only goes back to internal.
local orig_can_modify = ModifyWeaponDlg.CanModifySlot
function ModifyWeaponDlg:CanModifySlot(slot, partId)
    local weapon = self.context.weapon
    if partId and slot and slot.SlotType == "Magazine" and weapon and weapon.rat_sks_internal then
        local internal = weapon.components.Magazine == RAT_SKS_INTERNAL_MAG
        if internal == (partId == RAT_SKS_INTERNAL_MAG) then
            return false, "blocked", weapon.components.Magazine
        end
    end
    return orig_can_modify(self, slot, partId)
end

---- The conversion kit: a mag well and one empty mag, on top of the part's own bill.
local orig_changes_cost = ModifyWeaponDlg.GetChangesCost
function ModifyWeaponDlg:GetChangesCost(slotFilter, placedComponentOverride)
    local costs, anyChanged, canAfford, perType = orig_changes_cost(self, slotFilter, placedComponentOverride)
    local weapon = self.context.weapon
    if not anyChanged or not (weapon and weapon.rat_sks_internal) or not self.weaponClone or
        (slotFilter and slotFilter ~= "Magazine") or weapon.components.Magazine ~= RAT_SKS_INTERNAL_MAG then
        return costs, anyChanged, canAfford, perType
    end
    local placed = slotFilter and placedComponentOverride or self.weaponClone.components.Magazine
    if not placed or placed == RAT_SKS_INTERNAL_MAG then
        return costs, anyChanged, canAfford, perType
    end
    costs.Parts = (costs.Parts or 0) + RAT_SKS_CONVERT_PARTS
    if CheatEnabled("FreeParts") then
        return costs, anyChanged, canAfford, perType
    end
    canAfford, perType = true, {}
    for typ, cost in pairs(costs) do
        local preset = SectorOperationResouces and SectorOperationResouces[typ]
        local has = preset and preset.current(self.sector) or 0
        perType[typ] = has >= cost
        canAfford = canAfford and has >= cost
    end
    return costs, anyChanged, canAfford, perType
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

---- Revised Mags calls the 20-round HKG3 mag an HK21 one; it is the G3's standard box (HK21, PSG1 take it too).
function RatTOG_RevMag_RenameG3Mag()
    if not IsMod_loaded('URkxyfE') then
        return
    end
    for _, target in ipairs{g_Classes.HKG3MagazineLarge or false, InventoryItemDefs.HKG3MagazineLarge or false} do
        if target then
            target.DisplayName = Untranslated("G3 Magazine")
            target.DisplayNamePlural = Untranslated("G3 Magazines")
            target.Description = Untranslated("Standard 20-round 7.62 NATO box magazine for the G3, also used by the HK21 and PSG1.")
        end
    end
end

---- Revised Mags only loads a mag whose Platform and Caliber both match the gun. The generated mags
---- took the caliber the gun had at build time, so a later caliber change (PP91 9x18, SSG69, Scout)
---- left them unusable. A platform whose guns all share one caliber pulls its mags onto it.
function RatTOG_RevMag_SyncCalibers()
    if not IsMod_loaded('URkxyfE') then
        return
    end
    local cal_of = {}
    ClassDescendantsList("Firearm", function(id, w)
        local plat = w.Platform
        if plat and w.Magazine and w.Caliber and (IsVanillaFirearm(w) or w.is_tog_patched) then
            if cal_of[plat] == nil then
                cal_of[plat] = w.Caliber
            elseif cal_of[plat] ~= w.Caliber then
                cal_of[plat] = false
            end
        end
    end)
    ClassDescendantsList("Mag", function(id, mag)
        local cal = cal_of[mag.Platform or ""]
        local def = InventoryItemDefs[id]
        if cal and def and mag.Caliber ~= cal then
            print("GBO TOG RevMag: " .. id .. " caliber " .. tostring(mag.Caliber) .. " -> " .. cal)
            mag.Caliber = cal
            ---- the store's stats column reads the preset
            def.Caliber = cal
        end
    end)
end

---- The restock walks InventoryItemCompositeDef presets and the store UI reads them, so a mag that is
---- only a class (registered as InventoryItemDefs[id] = class) is never sold. Each gets a preset built
---- from its class; the class stays the item, so saves and the generated definitions are untouched.
RAT_TOG_MAG_PRESET_PROPS = {
    "Icon", "DisplayName", "DisplayNamePlural", "Description", "AdditionalHint", "Cost", "CanAppearInShop",
    "Tier", "RestockWeight", "CanBeConsumed", "CategoryPair", "Platform", "MagazineSize", "Caliber",
    "Modification", "Weight", "ScrapParts", "Repairable", "PocketS_amount", "PocketM_amount",
    "PocketML_amount", "PocketL_amount", "RifleMag_amount", "PistolMag_amount", "PistolHolster_amount",
    "KnifeSheath_amount", "Carabiner_amount"
}

function RatTOG_RevMag_EnsurePresets()
    if not IsMod_loaded('URkxyfE') then
        return
    end
    ClassDescendantsList("Mag", function(id, mag)
        ---- legacy SKS mags fit no slot any more: they stay loadable from saves but are never sold
        if InventoryItemDefs[id] ~= mag or RAT_SKS_LEGACY_MAGS[mag.Modification or ""] then
            return
        end
        local props = {'Group', "Default", 'Id', id, 'object_class', mag.object_class or mag.__parents[1]}
        for _, k in ipairs(RAT_TOG_MAG_PRESET_PROPS) do
            local v = mag[k]
            if v ~= nil then
                props[#props + 1] = k
                props[#props + 1] = v
            end
        end
        InventoryItemDefs[id] = nil
        PlaceObj('InventoryItemCompositeDef', props)
        if not InventoryItemDefs[id] then
            print("GBO TOG RevMag: preset for " .. id .. " did not register")
            InventoryItemDefs[id] = mag
        end
    end)
end
