sub Main()
	showChannelSGScreen()
end sub

sub showChannelSGScreen()
	screen = CreateObject("roSGScreen")
	m.port = CreateObject("roMessagePort")
	screen.setMessagePort(m.port)
	scene = screen.CreateScene("pageStackScene")
	screen.show()

        ' fetch the story
        ' TODO: check for request failures
        request = CreateObject("roUrlTransfer")
        request.SetUrl("http://jsonplaceholder.typicode.com/posts/2")
        jsonStr = request.GetToString()
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
