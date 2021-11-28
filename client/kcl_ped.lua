-- kcl_ped.lua

-- [Ped Accueil]
Citizen.CreateThread(function()
  RequestAnimDict("mini@strip_club@idles@bouncer@base")
  while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
      Wait(1)
  end
  local hash = GetHashKey("ig_benny")
  while not HasModelLoaded(hash) do
  RequestModel(hash)
    Wait(20)
  end
  ped = CreatePed("PED_TYPE_CIVMALE", "ig_benny", -206.16, -1328.7, 29.91, 265.38,false, true)
  SetBlockingOfNonTemporaryEvents(ped, true)
  FreezeEntityPosition(ped, true)
  TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
  end)
  
-- kbennys by ! Kamion#1323