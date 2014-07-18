function createProc(dir)
	proc = {}
	proc.name = fs.getName(dir)
	proc.coroutine = coroutine.create(loadfile(dir))
	return proc
end
function runProc(proc)
	local function terminateProc(proc)
		proc = nil
		term.redirect(term.native())
		nWindow.setVisible(false)
		nWindow = nil
	end

	x,y = term.getSize()
	nWindow = window.create(term.native(),1,2,x,y-1,true)
	term.redirect(nWindow)
	check, _sFilter, arg1 = coroutine.resume(proc.coroutine)
	while true do
		if coroutine.status(proc.coroutine) == "dead" then
			if not check then term.setBackgroundColor(colors.black) print(_sFilter) sleep(1.2) end
			terminateProc(proc)
			break
		end
		local eventData = { os.pullEventRaw( _sFilter ) }
	    if eventData[1] == "terminate" then
	        terminateProc(proc)
	        break
	    end
	    --if eventData[1] == "mouse_click" then if eventData[4] == 1 then terminateProc(proc) break end end
		check, _sFilter, arg1 = coroutine.resume(proc.coroutine, unpack(eventData))
	end
	terminated = false
	return nil
end