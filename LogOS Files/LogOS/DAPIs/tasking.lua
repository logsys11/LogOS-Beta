procList = {}
nProc = 0
x,y = term.getSize()
function createProc(dir)
	proc = {}
	nProc = nProc + 1
	--procList[nProc] = {}
	proc.run = loadfile(dir)
	proc.name = fs.getName(dir)
	proc.func = loadstring(run)
	proc.coroutine = coroutine.create(proc.func, ...)
	return proc
end

function runProc(proc)
	nWindow = window.create(term.native(),1,2,x,y-1,true)
	term.redirect(nWindow)
	while true do
		event,arg1, arg2, arg3, arg4, arg5, arg6 = coroutine.resume(proc.coroutine)
		if coroutine.status(proc.coroutine) == "dead" then proc = nil nWindow.setVisible(false) nWindow = nil return "Terminated" end
		event, arg1, arg2, arg3, arg4, arg5, arg6 = os.pullEventRaw(event)
		if event == "mouse_click" then
			if arg3 == "-1" then
				--getStatusBar()
				--Terminate for now
				proc = nil
				return "Terminated"
			end
		end
	end
end