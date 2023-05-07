local QBCore = exports['qb-core']:GetCoreObject()


local mode1 = false
local mode2 = false
local mode3 = false
local mode4 = true
local sex = GetVehiclePedIsIn(PlayerPedId(), false)
local purgeflowrate = 0.9
local beklet = false
local sexlazim = false
CreateThread(function()
    while true do
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if IsControlJustPressed(0, 178) then --delete
            if vehicle ~= 0 then
                local vehiclehash = GetEntityModel(vehicle)
                if vehiclehash == Row.PursuitCar1 or vehiclehash == Row.PursuitCar2 or vehiclehash == Row.PursuitCar3 or vehiclehash == Row.PursuitCar4 or vehiclehash == Row.PursuitCar5 or vehiclehash == Row.PursuitCar6 or vehiclehash == Row.PursuitCar7 then
                    local defaultcarspeed = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveForce')
                    if mode4 then
                        mode4 = false
                        mode1 = true
                            QBCore.Functions.Notify("Araç Modu: Normal", "success")
                            ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 22, false) -- toggle xenon lights
                            SetVehicleXenonLightsColor(GetVehiclePedIsIn(PlayerPedId()), 0) -- change xenon lights color
                            SetVehicleNitroPurgeEnabled(sex, false)
                            SetVehicleNitroPurgeEnabled2(vehicle, true)
                            IsVehicleNitroPurgeEnabled2(vehicle)
                            Wait(1000)
                            SetVehicleNitroPurgeEnabled2(vehicle, false)
                            beklet = false 
                            SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveForce", defaultcarspeed)
                    elseif mode1 then
                        mode1 = false
                        mode4 = true
                            QBCore.Functions.Notify("Araç Modu: Sport", "success")
                            SetVehicleXenonLightsColor(GetVehiclePedIsIn(PlayerPedId()), 8) -- change xenoto max level
                            ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 22, true) -- toggle xenon lights
                            SetVehicleNitroPurgeEnabled2(sex, false)
                            SetVehicleNitroPurgeEnabled(vehicle, true)
                            IsVehicleNitroPurgeEnabled(vehicle)
                            Wait(1000)
                            SetVehicleNitroPurgeEnabled(vehicle, false)
                            beklet = true
                            SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveForce", defaultcarspeed+Row.SportMode)
                      end
                else
                    QBCore.Functions.Notify("You are not in a pursuit car", "error")
                end
            else
                QBCore.Functions.Notify("You are not in a car", "error")
            end
        end
        Wait(0)
    end
end)



CreateThread(function()
    while true do
        Wait(2000)
        if beklet then
            Wait(30000)
        if beklet then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            SetVehicleNitroPurgeEnabled2(sex, false)
            SetVehicleNitroPurgeEnabled(vehicle, true)
            IsVehicleNitroPurgeEnabled(vehicle)
            Wait(1500)
            SetVehicleNitroPurgeEnabled(vehicle, false)
        end
    end
end
end)

CreateThread(function()
  while true do
      Wait(1)
      local ped = PlayerPedId()
      if IsControlJustPressed(0, 75) and IsPedInAnyVehicle(ped, false) and beklet then --delete
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
          QBCore.Functions.Notify("Araç Modu: Normal", "success")
          ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 22, false) -- toggle xenon lights
          SetVehicleXenonLightsColor(GetVehiclePedIsIn(PlayerPedId()), 0) -- change xenon lights color
          SetVehicleNitroPurgeEnabled(sex, false)
          SetVehicleNitroPurgeEnabled2(vehicle, true)
          IsVehicleNitroPurgeEnabled2(vehicle)
          Wait(1000)
          SetVehicleNitroPurgeEnabled2(vehicle, false)
          beklet = false 
          SetVehicleHandlingField(vehicle, "CHandlingData", "fInitialDriveForce", defaultcarspeed)
      end
end
end)



--purge

local vehicles = {}
local particles = {}

local purgecolorr = 210/255
local purgecolorg = 35/255
local purgecolorb = 0/255
function IsVehicleNitroPurgeEnabled(vehicle)
  SetVehicleNitroPurgeColor(vehicle, purgecolorr, purgecolorg, purgecolorb)
  return vehicles[vehicle] == true
end



function SetVehicleNitroPurgeColor(vehicle, r, g, b)
  if particles[vehicle] and #particles[vehicle] > 0 then
    for _, particleId in ipairs(particles[vehicle]) do
      SetParticleFxLoopedColour(particleId, r, g, b)
    end
  end
end


function SetVehicleNitroPurgeEnabled(vehicle, enabled)
  if IsVehicleNitroPurgeEnabled(vehicle) == enabled then
    return
  end

  if enabled then
    local bone = GetEntityBoneIndexByName(vehicle, 'bonnet')
    local pos = GetWorldPositionOfEntityBone(vehicle, bone)
    local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
    local ptfxs = {}

    for i=0,9 do
      local leftPurge = CreateVehiclePurgeSpray(vehicle, off.x - 0.5, off.y + 0.05, off.z, 40.0, -20.0, 0.0, 0.5)
      local rightPurge = CreateVehiclePurgeSpray(vehicle, off.x + 0.5, off.y + 0.05, off.z, 40.0, 20.0, 0.0, 0.5)

      table.insert(ptfxs, leftPurge)
      table.insert(ptfxs, rightPurge)
    end

    vehicles[vehicle] = true
    particles[vehicle] = ptfxs
  else
    if particles[vehicle] and #particles[vehicle] > 0 then
      for _, particleId in ipairs(particles[vehicle]) do
        StopParticleFxLooped(particleId)
      end
    end

    vehicles[vehicle] = nil
    particles[vehicle] = nil
  end
end


  function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale)
    UseParticleFxAssetNextCall('core')
    SetVehicleNitroPurgeColor(vehicle, purgecolorr, purgecolorg, purgecolorb)
    return StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, false, false, false)
end


--- test

AddEventHandler('onResourceStart', function (resource)
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleNitroPurgeEnabled(vehicle, false)
  SetVehicleNitroPurgeEnabled2(vehicle, false)
end)



-- purge 2


local vehicles = {}
local particles = {}

function IsVehicleNitroPurgeEnabled2(vehicle)
    return vehicles[vehicle] == true
end




function SetVehicleNitroPurgeEnabled2(vehicle, enabled)
    if IsVehicleNitroPurgeEnabled2(vehicle) == enabled then
      return
    end
  
    if enabled then
        local bone2 = GetEntityBoneIndexByName(vehicle, 'bonnet')
        local pos2 = GetWorldPositionOfEntityBone(vehicle, bone2)
        local offleft2 = GetOffsetFromEntityGivenWorldCoords(vehicle, pos2.x, pos2.y, pos2.z)
        local bone2 = GetEntityBoneIndexByName(vehicle, 'bonnet')
        local pos2 = GetWorldPositionOfEntityBone(vehicle, bone2)
      local offright2 = GetOffsetFromEntityGivenWorldCoords(vehicle, pos2.x, pos2.y, pos2.z)
      local ptfxs = {}
  
      for i=0,3 do
        local leftPurge = CreateVehiclePurgeSpray2(vehicle, offleft2.x - 0.5, offleft2.y + 0.05, offleft2.z, 40.0, -20.0, 0.0, purgeflowrate)
        local rightPurge = CreateVehiclePurgeSpray2(vehicle, offright2.x + 0.5, offright2.y + 0.05, offright2.z, 40.0, 20.0, 0.0, purgeflowrate)
  
        table.insert(ptfxs, leftPurge)
        table.insert(ptfxs, rightPurge)
      end
  
      vehicles[vehicle] = true
      particles[vehicle] = ptfxs
    else
      if particles[vehicle] and #particles[vehicle] > 0 then
        for _, particleId in ipairs(particles[vehicle]) do
          StopParticleFxLooped(particleId)
        end
      end
  
      vehicles[vehicle] = nil
      particles[vehicle] = nil
      enabled = false
    end
end


function CreateVehiclePurgeSpray2(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale)
    UseParticleFxAssetNextCall('core')
    
    return StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, false, false, false)
end


