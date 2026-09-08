function OnMsg.UnitStanceChanged(unit)
    rat_change_bipod(unit)
end

function OnMsg.UnitSwappedWeapon(unit)
    rat_change_bipod(unit)
end

function rat_change_bipod(unit)
    local activeWeapon = unit:GetActiveWeapons()
    local inactiveSlot = unit.current_weapon == "Handheld A" and "Handheld B" or "Handheld A"

    local weapons = unit:GetEquippedWeapons(unit.current_weapon) or {}
    local altWeapons = unit:GetEquippedWeapons(inactiveSlot) or {}

    local weaponsTable = {
        {"RPD_1", "RPD_bipod_unfld_1", "RPD_bipod_fld_1"},
        {"PKM_1", "PKM_Bipod_Unfold_1", "PKM_Bipod_Fold_1"},
        {{"HK23E_1", "HK23ECamo_1"}, "hk23e_bipod_unfld_1", "hk23e_bipod_fld_1"},
        {{"HK33A2_1", "G3A3Green_1", "G3A3_1"}, "hk33_bipod_unfld_1", "hk33_bipod_fld_1"},
        {"AR10std", "U100_bipod_unfld_1", "U100_bipod_fld_1"}
    }

	local function has_bipod(weapon)
		return weapon:HasComponent("AccuracyBonusProne") or weapon:HasComponent("RecoilControlWhenProne")
	end

    -- Process active weapons
    for _, weaponInfo in ipairs(weaponsTable) do
        local weaponClass = weaponInfo[1]
        local bipodComponent = (unit.stance == "Prone") and weaponInfo[2] or weaponInfo[3]

        if type(weaponClass) == "table" then
            for _, class in ipairs(weaponClass) do
                if IsKindOf(activeWeapon, class) and has_bipod(activeWeapon) then
                    activeWeapon:SetWeaponComponent("Bipod", bipodComponent)
                    ObjModified(activeWeapon)
                    break
                end
            end
        else
            if IsKindOf(activeWeapon, weaponClass) and
                has_bipod(activeWeapon) then
                activeWeapon:SetWeaponComponent("Bipod", bipodComponent)
                ObjModified(activeWeapon)
                break
            end
        end
    end

    -- Process alt weapons
    for _, altWeapon in ipairs(altWeapons) do
        for _, weaponInfo in ipairs(weaponsTable) do
            local weaponClass = weaponInfo[1]
            local bipodComponent = weaponInfo[3]

            if type(weaponClass) == "table" then
                for _, class in ipairs(weaponClass) do
                    if IsKindOf(altWeapon, class) and has_bipod(altWeapon) then
                        altWeapon:SetWeaponComponent("Bipod", bipodComponent)
                        ObjModified(altWeapon)
                        -- print("Alt weapon processed with bipod.")
                        break
                    end
                end
            else
                if IsKindOf(altWeapon, weaponClass) and
                    has_bipod(altWeapon) then
                    altWeapon:SetWeaponComponent("Bipod", bipodComponent)
                    ObjModified(altWeapon)
                    -- print("Alt weapon processed with bipod.")
                    break
                end
            end
        end
    end
end

-- print("weapon",weapon)
-- if weapon and IsKindOf(weapon, "RPD_1") then
-- if unit.stance == "Prone" then
-- weapon:SetWeaponComponent("Bipod","RPD_bipod_unfld_1")
-- ObjModified(weapon)
-- else
-- weapon:SetWeaponComponent("Bipod","RPD_bipod_fld_1")
-- ObjModified(weapon)
-- end
-- end

-- if weapon and IsKindOf(weapon, "PKM_1") then
-- if unit.stance == "Prone" then
-- weapon:SetWeaponComponent("Bipod","PKM_Bipod_Unfold_1")
-- ObjModified(weapon)
-- else
-- weapon:SetWeaponComponent("Bipod","PKM_Bipod_Fold_1")
-- ObjModified(weapon)
-- end
-- end

-- if weapon and IsKindOfClasses(weapon, "HK23E_1","HK23ECamo_1") then
-- if unit.stance == "Prone" then
-- weapon:SetWeaponComponent("Bipod","hk23e_bipod_unfld_1")
-- ObjModified(weapon)
-- else
-- weapon:SetWeaponComponent("Bipod","hk23e_bipod_fld_1")
-- ObjModified(weapon)
-- end
-- end

-- local weaponsTable = {
-- {classes = {"RPD_1"}, proneBipod = "RPD_bipod_unfld_1", notProneBipod = "RPD_bipod_fld_1"},
-- {classes = {"PKM_1"}, proneBipod = "PKM_Bipod_Unfold_1", notProneBipod = "PKM_Bipod_Fold_1"},
-- {classes = {"HK23E_1", "HK23ECamo_1"}, proneBipod = "hk23e_bipod_unfld_1", notProneBipod = "hk23e_bipod_fld_1"}
-- }

-- for _, weaponInfo in ipairs(weaponsTable) do
-- if weapon and IsKindOfClasses(weapon, unpack(weaponInfo.classes)) then
-- local bipodComponent = (unit.stance == "Prone") and weaponInfo.proneBipod or weaponInfo.notProneBipod
-- weapon:SetWeaponComponent("Bipod", bipodComponent)
-- ObjModified(weapon)
-- end
-- end
