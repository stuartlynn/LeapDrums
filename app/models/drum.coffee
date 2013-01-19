
class Drum

	constructor : (soundFile)->
		@url = soundFile
		@context = new webkitAudioContext();
		@loadSound()

	play:(volume=1)=>
		source  = @context.createBufferSource()
		source.buffer = @soundBuffer
		gain = @context.createGainNode()
		
		console.log "playing with volune, #{volume}", gain

		source.connect(gain)
		gain.connect(@context.destination)
		gain.gain.value = volume 

		source.start(0)

	loadSound:=>
		request = new XMLHttpRequest()
		request.open('get', @url, true)
		request.responseType = 'arraybuffer'
		request.onload =  =>
			@context.decodeAudioData request.response, (buffer)=>
				@soundBuffer = buffer
		request.send()


module.exports = Drum