#
# The stage view appears while playing.
#

module.exports = class StageView extends Backbone.View
	idName: 'stage'
	rotationSpeed: 0.02

	render: =>
		super
		@$el.attr('id', @idName)
		@threeInit()
		@


	threeInit: =>
		@scene = new THREE.Scene()
		@scene.fog = new THREE.FogExp2 0xffffff, 0
		@camera = new THREE.PerspectiveCamera 20, 1, 1, 1000
		@camera.position.set 0, 10, 100
		# @camera.rotation.set Math.PI / 180 * -60, 0, 0
		@scene.add @camera
		@viewport =
			top: -1
			left: -1
			bottom: 1
			right: 1
		@projector = new THREE.Projector()
		@loadLights()
		# Renderer.
		highQuality = true#false
		if highQuality
			@renderer = new THREE.WebGLRenderer
				precision: 'highp'
				antialias: true
			@renderer.shadowMapEnabled = true
			@renderer.shadowMapType = THREE.PCFSoftShadowMap
		else
			@renderer = new THREE.WebGLRenderer
				precision: 'lowp'
				antialias: false
			@renderer.shadowMapEnabled = false
			@renderer.shadowMapType = THREE.BasicShadowMap
		@renderer.autoClear = false
		@domElement = $(@renderer.domElement).css
			width: '100%'
			height: '100%'
		@$el.append @domElement
		# Subscribe DOM-Events.
		$(window).resize @resize
		
		setTimeout @resize, 1 # stupid hack, find right callback later
		@animate()
		@generateObjects()
		
	# Setup a simple three point light system.
	loadLights: =>
		# Directional light (key light).
		@directionalLightVector = new THREE.Vector3 12, 23, 10
		@directionalLight = new THREE.DirectionalLight 0xffffff, 0.9
		@directionalLight.position = @directionalLightVector.clone()
		# Directional shadow.
		#@directionalLight.castShadow = true
		#@directionalLight.shadowCameraVisible = true
		d = 5
		@directionalLight.shadowCameraLeft   = -d
		@directionalLight.shadowCameraRight  =  d
		@directionalLight.shadowCameraTop    =  d
		@directionalLight.shadowCameraBottom = -d
		@directionalLight.shadowCameraNear 	= 1
		@directionalLight.shadowCameraFar 	= 100
		@directionalLight.shadowMapWidth 	= 1024
		@directionalLight.shadowMapHeight 	= 1024
		#@directionalLight.shadowBias 	 	= -0.0001
		@directionalLight.shadowDarkness 	= 0.5
		@scene.add @directionalLight
		# Hemisphere light (fill and rim light).
		hemisphereLight = new THREE.HemisphereLight 0x89ccff, 0xffffff, 0.2
		hemisphereLight.position.set 0, 100, 100
		@scene.add hemisphereLight
		return

	resize: =>
		@renderer.setSize @domElement.width(), @domElement.height(), false
		@resizeCamera()
		return

	resizeCamera: =>
		if @camera?
			@camera.aspect = @domElement.width() / @domElement.height()
			@camera.updateProjectionMatrix()
		return
	
	animate: =>
		x = @camera.position.x
		z = @camera.position.z
		@camera.position.x = x * Math.cos(@rotationSpeed) + z * Math.sin(@rotationSpeed)
		@camera.position.z = z * Math.cos(@rotationSpeed) - x * Math.sin(@rotationSpeed)
		@camera.lookAt @scene.position
		@renderer.render @scene, @camera
		requestAnimationFrame @animate
		return

	generateObjects: =>
		material = new THREE.MeshLambertMaterial
			color: 0xCC0000
			shading: THREE.FlatShading
		sphere = new THREE.Mesh(new OctahedronGeometry(5,0), material)
		@scene.add sphere
		

class OctahedronGeometry extends THREE.Geometry
	vertices: [
		1,0,0,   -1,0,0,   0,1,0,   0,-1,0,   0,0,1,     0,0,-1, 

	]

	indices: [
		0,2,4, 0,4,3, 0,3,5, 0,5,2
		1,2,5, 1,5,3, 1,3,4, 1,4,2
	]

	constructor: (radius, detail) ->
		THREE.PolyhedronGeometry.call this, @vertices, @indices, radius, detail