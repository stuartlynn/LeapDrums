class LeapListener
	
	@fingerCallbacks : []
	@handCallbacks : []

	@setup:(url)->
		console.log "connecting"
		ws  = new WebSocket(url)
		counter= 0 

		ws.onmessage  = (e)=>	
			data= JSON.parse(e.data)
			counter += 1
			# if data.pointables? and data.pointables.length > 0
			cb(data.pointables) for cb in @fingerCallbacks 

			# if data.hands? and data.hands.lenth > 0
			cb(data.hands) for cb in @handCallbacks

	@onFingers:(cb)->
		@fingerCallbacks.push cb

	@onHands:(cb)->
		@handCallbacks.push cb

module.exports = LeapListener