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
	event, arg1 = coroutine.resume(proc.coroutine)
	while true do
		if coroutine.status(proc.coroutine) == "dead" then
			if not event then term.setBackgroundColor(colors.black) print(arg1) sleep(1.2) end
			proc = nil
			term.redirect(term.native())
			nWindow.setVisible(false)
			nWindow = nil
			break
		end
		event, arg1, arg2, arg3, arg4, arg5, arg6 = os.pullEvent(event)
		if event == "mouse_click" then
			if arg3 == "-1" then
				--getStatusBar()
				--Terminate for now
				proc = nil term.redirect(term.native()) nWindow.setVisible(false) nWindow = nil break
			end

		end
		event, arg1 = coroutine.resume(proc.coroutine, arg1,arg2,arg3,arg4,arg5,arg6)
	end
	return nil
end