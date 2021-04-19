--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local Jobs = {}
local LastTime = nil

local function RunAt(h, m, cb)
	table.insert(Jobs, {
		h  = h,
		m  = m,
		cb = cb
	})
end

local function GetTime()
	local timestamp = os.time()
	local d = os.date('*t', timestamp).wday
	local h = tonumber(os.date('%H', timestamp))
	local m = tonumber(os.date('%M', timestamp))

	return {d = d, h = h, m = m}
end

local function OnTime(d, h, m)

	for i=1, #Jobs, 1 do
		if Jobs[i].h == h and Jobs[i].m == m then
			Jobs[i].cb(d, h, m)
		end
	end
end

local function Tick()
	local time = GetTime()

	if time.h ~= LastTime.h or time.m ~= LastTime.m then
		OnTime(time.d, time.h, time.m)
		LastTime = time
	end

	Astra.newThread(function()
		Wait(60000)
		Tick()
	end)
end

LastTime = GetTime()
Tick()

Astra.netHandle('registerTask', function(h, m, cb)
	RunAt(h, m, cb)
end)