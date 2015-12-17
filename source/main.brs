sub Main()
    deviceInfo = CreateObject("roDeviceInfo")
    print deviceInfo.GetDisplayMode()
    print deviceInfo.GetDisplaySize()
    resolutions = deviceInfo.GetSupportedGraphicsResolutions()
    print resolutions[0]

        showLandingScreen()
	'showChannelSGScreen()
end sub

sub makeRequest(url as string) as object
    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    request.SetUrl(url)
    if (request.AsyncGetToString())
        while (true)
            msg = wait(0, port)
            if (type(msg) = "roUrlEvent")
                return {
                    code: msg.GetResponseCode()
                    body: msg.GetString()
                }
            else if (event = invalid)
                request.AsyncCancel()
                return {
                    code: 500
                }
            endif
        end while
    endif
    return {
        code: 500
    }
end sub

sub showLandingScreen()
    port = CreateObject("roMessagePort")
    screen = CreateObject("roSGScreen")
    screen.setMessagePort(port)
    scene = screen.CreateScene("landingScene")
    screen.show()

    ' add the scene context
    sceneContext = createObject("roSGNode", "sceneContext")
    sceneContext.currentPage = 1
    sceneContext.pageMapping = { "a" : 1, "b" : 2, "c" : 3 }
    scene.sceneContext = sceneContext

    while(true)
	msg = wait(0, m.port)
	msgType = type(msg)

	if msgType = "roSGScreenEvent"
	    if msg.isScreenClosed() then return
        else if msgType = ""
	end if
    end while
end sub

sub showChannelSGScreen()
	m.port = CreateObject("roMessagePort")

	screen = CreateObject("roSGScreen")
	screen.setMessagePort(m.port)
	scene = screen.CreateScene("pageStackScene")
	screen.show()

        ' fetch the story
        '
        ' TODO: check for request failures
        response = makeRequest("http://jsonplaceholder.typicode.com/posts/2")
        if response.code <> 200 then
          errorDialog = CreateObject("roMessageDialog")
          errorDialog.setTitle("something wrong")

          scene.dialog = errorDialog
        end if

        jsonStr = response.body
        if type(jsonStr) = invalid then
          print "crap"
        else
          print "is good"
        end if
        json = ParseJSON(jsonStr)
        print json

        ' add the scene context
        sceneContext = createObject("roSGNode", "sceneContext")
        sceneContext.currentPage = 1
        sceneContext.pageMapping = { "a" : 1, "b" : 2, "c" : 3 }
        scene.sceneContext = sceneContext

	while(true)
		msg = wait(0, m.port)
		msgType = type(msg)

		if msgType = "roSGScreenEvent"

			if msg.isScreenClosed() then return

		end if

	end while
end sub
