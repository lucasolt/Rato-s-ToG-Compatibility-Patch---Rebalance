--- Gun Patch
function OnMsg.ClassesGenerate()
    print("RATMOD - Starting TOG patch")
    RatoTOG_Patch()
    print("RATMOD - TOG patch successful")
    --- RevMag
    RatTOG_RevMag_OnClassesGenerateChangeDefaultMags()
end

function OnMsg.ClassesPreprocess()
    --- RevMag
    GBOTOG_RevMag_CreateMagazine()
    GBOTOG_RevMag_CreateMagazine_manual()
end

local function disable_old_ammo()
    if g_Classes['_57x28mm'] then
        g_Classes['_57x28mm'].CanAppearInShop = false
    end
end

function OnMsg.DataLoaded()

    ---- Disable unpatched guns
    disable_unpatched_shop()
    disable_old_ammo()
    --- RevMag
    GBOTOG_RevMag_AddClassesToInventoryItemDefs()
    GBOTOG_RevMag_AddClassesToInventoryItemDefs_manual()
    GBOTOG_RevMag_WeaponComponentVisualPatch_manual()
    GBOTOG_RevMag_WeaponComponentVisualPatch()
end

function OnMsg.ModsReloaded()
    GBOTOG_patch_PresetsClass()
    RatoTOGComponents()
    ---- Disable unpatched guns
    disable_unpatched_shop()
    disable_old_ammo()
    --- RevMag
    GBOTOG_RevMag_WeaponComponentVisualPatch_manual()
    GBOTOG_RevMag_WeaponComponentVisualPatch()
end

---- Disable unpatched guns
--disable_unpatched_shop()
disable_old_ammo()

-- Change Zulib Calibers
function OnMsg.ClassesPostBuilt()
    SharedModEnv["KKh3Yhf"].zzChangeList = {
        ['SteyrScout_1'] = '308Win',
        ['MAC11_1'] = '380ACP',
        ['SSG69_1'] = '308Win',
        ['AN94_1'] = '5_45x39',
        ['UMP_1'] = '45ACP',
        ['VSS_1'] = '9x39',
        ['M76_1'] = '7_92x57',
        ['Groza_1'] = '9x39',
        ['M1Garand_2'] = '30-60',
        ['P90_2'] = '5_7x28',
        ['Gewehr43_1'] = '7_92x57',
        ['M1911_1'] = '45ACP',
        ['STG44R_1'] = '7_92x33',
        ['VSK94_1'] = '9x39',
        ['Delisle_1'] = '45ACP',
        ['PKM_1'] = '7_62x54R',
        ['Mosin_1'] = '7_62x54R',
        ['PP91_1'] = '9x18',
        ['G11_1'] = '4_7x33',
        ['A91_2'] = '5_45x39'
    }
end
