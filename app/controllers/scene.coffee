LeapListener = require ('models/LeapListener')

class Scene extends Spine.Controller
	className : 'scene'
	lights: []

	constructor:->
		super 
		@setupThree()
		@animate()
		@setUpFingers()
		# @drawSphere(0,0,0)
		@createLight(500,500,500)
		LeapListener.onFingers @updateFingers
		# box = @drawBox(0,0,0,500,500,500,'red')
		# window.box = box
		# @drawActiveRegion()

	setupThree:=>
		@camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, 10000 )
		@controls = new THREE.TrackballControls( @camera )
		@controls.addEventListener 'change', @render
		
		@camera.position.z = 100
		@camera.position.y = 400

		@scene = new THREE.Scene()

		@renderer = new THREE.WebGLRenderer()
		@renderer.setSize( window.innerWidth, window.innerHeight )
		@scene.add(@camera)
		@el.append( @renderer.domElement )
		window.addEventListener( 'resize', @windowResize, false )

	drawActiveRegion:=>
		box = @drawBox(-200,-200,-200, 200, 200,200)
		box.geometry.faces[0].materialIndex = 0
		box.geometry.faces[3].materialIndex = 0 

	drawSphere:(x,y,z,r=200,color="blue")=>
		geom = new THREE.SphereGeometry( r, 20, 20 )
		material = new THREE.MeshBasicMaterial( { color: color, wireframe: true } )
		mesh = new THREE.Mesh( geom, material )
		mesh.position.x = x
		mesh.position.y = y
		mesh.position.z = z
		@scene.add( mesh )
		mesh

	createLight:(x,y,z)=>
		light = new THREE.PointLight( 0xFFFF00 )
		light.position.set( x, y, z )
		@scene.add( light )
		@lights.push light

	drawBox:(x,y,z,width,height,depth, color)=>
		geom = new THREE.CubeGeometry( width, height, depth )
		material = new THREE.MeshBasicMaterial( { color: color, wireframe: false } )
		mesh = new THREE.Mesh( geom, material )
		mesh.position.x = x
		mesh.position.y = y
		mesh.position.z = z
		@scene.add( mesh )
		mesh

	windowResize:=>
		@camera.aspect = window.innerWidth / window.innerHeight
		@camera.updateProjectionMatrix()
		@renderer.setSize( window.innerWidth, window.innerHeight )
		@controls.handleResize()


	setUpFingers:=>
		@fingers =[]
		for i in [0,1,2,3,4]
			finger = @drawSphere(100*i,0,0,5,['red','green','yellow','blue','purple'][i])
			@fingers.push finger
			@scene.add finger

	updateFingers:(fingers)=>
		window.maxX ||= 0
		window.maxY ||= 0
		window.maxZ ||= 0

		window.minX ||= 0
		window.minY ||= 0
		window.minZ ||= 0

		if fingers?
			for finger,index in fingers
				window.maxX = finger.tipPosition[0] if finger.tipPosition[0] > window.maxX 
				window.maxY = finger.tipPosition[1] if finger.tipPosition[1] > window.maxY 
				window.maxZ = finger.tipPosition[2] if finger.tipPosition[2] > window.maxZ 

				window.minX = finger.tipPosition[0] if finger.tipPosition[0] < window.minX 
				window.minY = finger.tipPosition[1] if finger.tipPosition[1] < window.minY 
				window.minZ = finger.tipPosition[2] if finger.tipPosition[2] < window.minZ 


				@fingers[index].position.x = finger.tipPosition[0]
				@fingers[index].position.y = finger.tipPosition[1]
				@fingers[index].position.z = finger.tipPosition[2]


	drawRegion:(region, color='black')=>
		center  = region.center
		dimensions = region.dimensions
		@drawBox(region.center[0], region.center[1], region.center[2], dimensions[0], dimensions[1], dimensions[2], color  )

	render:=>
		@renderer.render( @scene, @camera )

	animate:=>
		requestAnimationFrame( @animate )
		@controls.update()
		@render()

module.exports = Scene