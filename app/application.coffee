LeapListener = require('models/LeapListener')
Region 			 = require('models/region')
Drum 				 = require('models/drum')
Scene 			 = require('controllers/scene')

class App extends Spine.Controller
	constructor: ->
		super

		scene = new Scene()
		@append scene
		LeapListener.setup('ws://localhost:6437')
		

		count= 0 

		snare  = new Drum("drums/snare.wav")
		hi 	   = new Drum("drums/hi.wav")

		# beat =0
		# setInterval =>
			
		# 	hi.play() if beat==1 or beat==3
		# 	snare.play() if beat==0 or beat ==4
		# 	beat +=1
		# 	beat =0 if beat==4  
		# , 200


		LeapListener.onFingers (fingers)=>
			count +=1 
			$(".stats").html require('views/stats')({fingers: fingers})  if count%10==0

		hiRegion = new Region([100,100,0],[80,80,80])
			
		hiRegion.onEnter (finger)=>
			console.log "hi play"
			vel = finger.tipVelocity
			vol = Math.sqrt(vel[0]*vel[0] + vel[1]*vel[1] + vel[2]*vel[2] )/3000.0
			hi.play(vol)


		scene.drawRegion(hiRegion, 'orange')

			# total = 0 
			# max = 5000

			# total += vel*vel for vel in finger.tipVelocity 
			# vol = total/10000.0
			# console.log vol
			# hi.play()	
		



		snareRegion = new Region([-100,100,0],[80,80,80])
		snareRegion.onEnter (finger)=> 
			vel = finger.tipVelocity
			vol = Math.sqrt(vel[0]*vel[0] + vel[1]*vel[1] + vel[2]*vel[2] )/3000.0
			snare.play(vol)
		
		scene.drawRegion(snareRegion, 'purple')



		# ws  = new WebSocket('ws://localhost:6437')
		# @context = new webkitAudioContext()

		# @oscillator = []
		# @oscillator[0] = @context.createOscillator()
		# @oscillator[1] = @context.createOscillator()

		# @oscillator[0].connect(@context.destination)
		# @oscillator[1].connect(@context.destination)
		
		# @oscillator.connect(@context.destination)
		# @oscillator[0] = 1
		# @oscillator[1] = 0
		
		# ws.onmessage  = (e)=>
			
		# 	data= JSON.parse(e.data)
		# 	console.log "have #{data.pointables.length} fingers"
		# 	if data.pointables.length ==0 
		# 		console.log "stopping"
		# 		# @oscillator.stop(0)
		# 	else
		# 		for pointer, index in data.pointables 
		# 			console.log index
		# 			if index < 2
		# 				@oscillator[index].start(0)

		# 				@oscillator[index].frequency.value = Math.abs(data.pointables[index].tipPosition[1]*10 )


module.exports = App
