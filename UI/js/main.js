function init() {

	//Obtengo el viewport (donde se dibuja)
	viewport = document.getElementById( 'viewport' );

	//Seteo la camara
	camera = new THREE.PerspectiveCamera( 60, window.innerWidth/4*3 / (window.innerHeight-46), 1, 1000 );
	camera.position.y = 10;

	//Asigno controles de la camara
	controls = new THREE.OrbitControls( camera, viewport );
	controls.damping = 0.1;
	controls.addEventListener( 'change', render );

	//Creo la escena dentro del viewport, pongo grilla auxiliar
	scene = new THREE.Scene();
	grid = new THREE.GridHelper( 1000, 1 );
	grid.setColors( new THREE.Color(0x838383), new THREE.Color(0xD0D0D0) );
	grid.position.set(0,0,0);
	scene.add(grid);
	
	// Seteo el renderer(manejador de objetos en la escena)

	renderer = new THREE.WebGLRenderer( { antialias: false } );
	renderer.setPixelRatio( window.devicePixelRatio );
	renderer.setSize( window.innerWidth/4*3, window.innerHeight-46 );
	renderer.setClearColor( 0xEEEEEE, 1 );

	viewport.appendChild( renderer.domElement );

	//Agrego eventos del usuario
	window.addEventListener( 'resize', onWindowResize, false );
	window.addEventListener( 'mouseup', onMouseUp, false );
	window.addEventListener( 'mousedown', onMouseDown, false );
	
	//Agrego el origen
	IETFEM.addParticle(0,0,0);

}

//Cuando se cambia el tamaño de la ventana
function onWindowResize() {

	camera.aspect = window.innerWidth/4*3 / (window.innerHeight-46);
	camera.updateProjectionMatrix();

	renderer.setSize( window.innerWidth/4*3, window.innerHeight-46 );

	render();

}

//Cuando se presiona el click izquierdo
function onMouseDown( event ) {
	if (event.button == 0){
		mouseX = event.clientX;
		mouseY = event.clientY;
	}
}

//Cuando se levanta el click izquierdo
function onMouseUp( event ) {  

	if ((event.button == 0) && (mouseX == event.clientX) && (mouseY == event.clientY)){
	
	 var vector = new THREE.Vector3( ( 
		event.clientX / (window.innerWidth/4*3)) * 2 - 1, 
		- ( (event.clientY-46) / (window.innerHeight-46) ) * 2 + 1, 
		0.5 
	);

	vector.unproject( camera );

	var ray = new THREE.Raycaster( camera.position, vector.sub( camera.position ).normalize() );
	
	var intersects = ray.intersectObjects( helpObjects );

	if ( intersects.length > 0 ) {
	
		if (!addingLines){
			intersects[0].object.material = new THREE.MeshBasicMaterial( {color: 0x000000} );
			Model.addPointToModel(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z);
		} else {
			if (Model.isInModel(intersects[0].object.position.x, intersects[0].object.position.y,intersects[0].object.position.z)){
				if (firstPointLine == null){
					firstPointLine = {};
					firstPointLine.x = intersects[0].object.position.x;
					firstPointLine.y = intersects[0].object.position.y;
					firstPointLine.z = intersects[0].object.position.z;
					idFirstPoint = intersects[0].object.id;
					intersects[0].object.material = new THREE.MeshBasicMaterial( {color: 0x8B0000} );
					intersects[0].object.geometry = new THREE.SphereGeometry( 0.1, 50, 50 );
					
				} else {
					if (firstPointLine.x != intersects[0].object.position.x || firstPointLine.y != intersects[0].object.position.y || firstPointLine.z != intersects[0].object.position.z){
						Space.drawLine(firstPointLine.x, firstPointLine.y, firstPointLine.z, intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, new THREE.LineBasicMaterial({color: 0x000000}));
						Model.addLineToModel(firstPointLine.x, firstPointLine.y, firstPointLine.z, intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z);
						Space.getScenePointById(idFirstPoint).material = new THREE.MeshBasicMaterial( {color: 0x000000} );
						Space.getScenePointById(idFirstPoint).geometry = new THREE.SphereGeometry( 0.05, 50, 50 );
						idFirstPoint = 0;
						firstPointLine = null;
					}
					firstPointLine = null;
				}
			}
		}
	}
	
	render();
	}
}

//Renderiza la escena
function render() {

	renderer.render( scene, camera );

}