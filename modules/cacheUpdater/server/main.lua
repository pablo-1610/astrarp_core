--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraSCache = {}

AstraSCache.caches = {}
AstraSCache.relativesDb = {}

AstraSCache.getCache = function(index)
    return AstraSCache.caches[index] or {}
end

AstraSCache.addCacheRule = function(index, sqlTable, updateFrequency)
    AstraSCache.caches[index] = {}
    AstraSCache.relativesDb[sqlTable] = { index = index, interval = updateFrequency }
    AstraServerUtils.trace(("Ajout d'une règle de cache: ^2%s ^7sur ^3%s"):format(index,sqlTable), AstraPrefixes.sync)
end

AstraSCache.removeCacheRule = function(sql)
    AstraSCache.caches[AstraSCache.relativesDb[sql]] = nil
    Astra.cancelTaskNow(AstraSCache.relativesDb[sql].processId)
    AstraServerUtils.trace(("Retrait d'une règle de cache: ^2%s"):format(AstraSCache.relativesDb[sql].index), AstraPrefixes.sync)
    AstraSCache.relativesDb[sql] = nil
end

Astra.netHandle("esxloaded", function()
    while true do
        for sqlTable, infos in pairs(AstraSCache.relativesDb) do
            if not infos.processId then
                infos.processId = Astra.newRepeatingTask(function()
                    MySQL.Async.fetchAll(("SELECT * FROM %s"):format(sqlTable), {}, function(result)
                        if AstraSCache.caches[infos.index] ~= nil then
                            AstraSCache.caches[infos.index] = result
                        end
                    end)
                end, nil, 0, infos.interval)
            end
        end
        Wait(Astra.second(1))
    end
end)

