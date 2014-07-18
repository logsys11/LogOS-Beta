procList = {}
nProc = 0
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
	sFilter, arg1 = coroutine.resume(proc.coroutine)
	while true do
		if coroutine.status(proc.coroutine) == "dead" then
			if not sFilter then term.setBackgroundColor(colors.black) print(arg1) sleep(1.2) end
			terminateProc(proc)
			break
		end
		
		local eventData = { os.pullEventRaw( sFilter ) }
	    if eventData[1] == "terminate" then
	        terminateProc(proc)
	        break
	    end
	    if eventData[1] == "mouse_click" and eventData[4] == "-1" then terminateProc(proc) break end
		event, arg1 = coroutine.resume(proc.coroutine, unpack(eventData))
	end
	return nil
end