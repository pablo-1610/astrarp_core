---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local playersJobsCache = {}

AstraSJobsManager = {}
AstraSJobsManager.list = {}

---getJob
---@public
---@return Job
AstraSJobsManager.getJob = function(job)
    return AstraSJobsManager.list[job]
end

Astra.netHandleBasic("playerDropped", function(reason)
    playersJobsCache[source] = nil
end)

--[[
Astra.netHandle("esxloaded", function()
    MySQL.Async.fetchAll("SELECT * FROM jobs WHERE useCutomSystem = 1", {}, function(result)
        for _,job in pairs(result) do
            if not AstraSharedCustomJobs[job.name] then
                print(Astra.prefix(AstraPrefixes.jobs,("Impossible de charger le job %s"):format(job.label)))
            else
                local society = ("society_%s"):format(job.name)
                TriggerEvent('esx_society:registerSociety', job.name, job.label, society, society, society, {type = 'private'})
                print(Astra.prefix(AstraPrefixes.jobs,("Chargement du job ^1%s ^7!"):format(job.name)))
                Job(job.name, job.label)
                AstraSharedCustomJobs[job.name].onThisJobInit(AstraSJobsManager.list[job.name])
            end
        end
    end)
end)
--]]

Astra.netRegisterAndHandle("jobInitiated", function(job)
    local source = source
    playersJobsCache[source] = {name = job.name, grade = job.grade_name, isCustom = AstraSJobsManager.getJob(job.name) ~= nil}
    if not AstraSJobsManager.getJob(job.name) then
        return
    end
    ---@type Job
    local astraJob = AstraSJobsManager.getJob(job.name)
    astraJob:subscribe(source, job.grade_name)
end)

Astra.netRegisterAndHandle("jobUpdated", function(newJob)
    local source = source
    local previousCache = playersJobsCache[source]
    local newCache = {name = newJob.name, grade = newJob.grade_name, isCustom = AstraSJobsManager.getJob(newJob.name) ~= nil}

    if previousCache.name ~= newJob.name then
        -- Changement de job
        ---@type Job
        if previousCache.isCustom then
            local previousJob = AstraSJobsManager.getJob(previousCache.name)
            previousJob:unsubscribe(source, previousCache.grade)
        end
        if newCache.isCustom then
            local newAstraJob = AstraSJobsManager.getJob(newCache.name)
            newAstraJob:subscribe(source, newCache.grade)
        end
    else
        if newCache.isCustom then
            if previousCache.grade ~= newCache.grade then
                local astraJob = AstraSJobsManager.getJob(newCache.name)
                if previousCache.grade == "boss" then
                    astraJob:alterBossAccess(source, false)
                elseif newCache.grade == "boss" then
                    astraJob:alterBossAccess(source, true)
                end
            end
        end
    end

    playersJobsCache[source] = newCache
end)