procList = {}
nProc = 0
function createProc(dir)
	proc = {}
	proc.name = fs.getName(dir)
	proc.coroutine = coroutine.create(loadfile(dir))
	return proc
end

function runProc(proc)
	x,y = term.getSize()
	nWindow = window.create(term.native(),1,2,x,y-1,true)
	term.redirect(nWindow)
	while true do
		event,arg1, arg2, arg3, arg4, arg5, arg6 = coroutine.resume(proc.coroutine)
		if coroutine.status(proc.coroutine) == "dead" then
			if not event then print(arg1) sleep(1.2) end
			proc = nil
			term.redirect(term.native())
			nWindow.setVisible(false)
			nWindow = nil
			return "Terminated"
		end
		event, arg1, arg2, arg3, arg4, arg5, arg6 = os.pullEventRaw(event)
		if event == "mouse_click" then
			if arg3 == "-1" then
				--getStatusBar()
				--Terminate for now
				proc = nil term.redirect(term.native()) nWindow.setVisible(false) nWindow = nil return "Terminated"
			end
		end
	end
end