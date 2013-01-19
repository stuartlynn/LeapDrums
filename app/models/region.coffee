LeapListener = require("models/LeapListener")

class Region

	
	constructor:(center, dimensions)->
		@center 		 = center 
		@dimensions  = dimensions 
		@currentFingers = []
		@mins  =  []
		@maxes =  []
		@mins 	 = ( centCoord - @dimensions[index]/2.0  for centCoord,index in center )
		@maxes 	 = ( centCoord + @dimensions[index]/2.0  for centCoord,index in center )
		@onEnterCallbacks =  []
		@onExitCallbacks  = []
	
		console.log @mins, @maxes
		LeapListener.onFingers  @process

	process:(data)=>
		# @clearOldFingers data
		@detect data
			
	onEnter:(cb)=>
		@onEnterCallbacks.push cb

	onExit:(cb)=>
		@onExitCallbacks.push cb

	triggerEnter:(finger)=>
		@currentFingers.push finger.id
		cb(finger) for cb in @onEnterCallbacks

	triggerExit:(finger)=>

		@currentFingers = _(@currentFingers ).without(finger.id)
		cb(finger) for cb in @onExitCallbacks

	clearOldFingers:(points)=>
		activeFingerIds = (point.id for poin in points)
		for point in @pointsIn
			@pointsIn[point.id] = false  if activeFingerIds.indexOf(point.id) == -1

	currentFingerIn:(fingerId)=>
		@currentFingers.indexOf(fingerId) > -1

	detect:(points)=>
		# console.log @currentFingers
		if points?
			for point in points

				coordHits = (coord > @mins[dim] and coord < @maxes[dim] for coord, dim in point.tipPosition )
				inside = (coordHits.indexOf(false) == -1)
				outside = (coordHits.indexOf(false) > 0 )
				

				if outside and @currentFingerIn(point.id)
					@triggerExit(point)

				else if inside and !@currentFingerIn(point.id)
					@triggerEnter(point)



module.exports = Region	