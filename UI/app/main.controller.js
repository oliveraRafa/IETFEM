var app = angular.module('IETFEM', []);
app.controller(
    'mainCtrl',
	[	'$scope',
		'ModelService',
		'SpaceService',
        function($scope, ModelService, SpaceService){
		
			//--- Defino función de inicialización
			function init() {

				//Obtengo el viewport (donde se dibuja)
				viewport = document.getElementById( 'viewport' );
				
				viewportWidth=$("#viewportContainer").width();
				viewportHeight=(window.innerHeight-46);
				
				//Seteo la camara
				camera = new THREE.PerspectiveCamera( 60, viewportWidth / viewportHeight, 1, 1000 );
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
				renderer.setSize( viewportWidth, viewportHeight );
				renderer.setClearColor( 0xEEEEEE, 1 );

				viewport.appendChild( renderer.domElement );

				//Agrego eventos del usuario
				window.addEventListener( 'resize', onWindowResize, false );
				window.addEventListener( 'mouseup', onMouseUp, false );
				window.addEventListener( 'mousedown', onMouseDown, false );
				
				//Agrego el origen
				$scope.addParticle(0,0,0);

			}

			//--- Defino función de Render
			function render() {

				renderer.render( scene, camera );
					
			}  
			
			//--- Defino Eventos de usuario
			
			//Cuando se cambia el tamaño de la ventana
			function onWindowResize() {
				
				viewportWidth=$("#viewportContainer").width();
				viewportHeight=(window.innerHeight-46);

				camera.aspect = viewportWidth / viewportHeight;
				camera.updateProjectionMatrix();

				renderer.setSize( $("#viewportContainer").width(), window.innerHeight-46 );

				render();

			}

			//Cuando se presiona el click izquierdo
			function onMouseDown( event ) {
				if (event.button == 0){
					mouseX = event.clientX;
					mouseY = event.clientY;
				}
			}
			
			//Pone la informacion del punto en los controles de la UI
			$scope.getInfoPuntoInterfaz = function() {
				  $scope.puntoId = puntoSeleccionado.id;
				  $scope.xCondition =puntoSeleccionado.xCondition;
			}
			//Cuando se levanta el click izquierdo
			function onMouseUp( event ) {  
				
				viewportWidth=$("#viewportContainer").width();
				viewportHeight=(window.innerHeight-46);
				
				if ((event.button == 0) && (mouseX == event.clientX) && (mouseY == event.clientY)){

				 var vector = new THREE.Vector3( ( 
					event.clientX / viewportWidth) * 2 - 1, 
					- ( (event.clientY-46) / (viewportHeight) ) * 2 + 1, 
					0.5 
				);
				
				vector.unproject( camera );

				var ray = new THREE.Raycaster( camera.position, vector.sub( camera.position ).normalize() );
				
				//FUNCION OBTENGO punto seleccionado
				var pointIntersection = ray.intersectObjects(puntosEscena);
				
				if(pointIntersection.length > 0){
					puntoSeleccionado= ModelService.getPointById(pointIntersection[0].object.id,model);
					//Salert(puntoSeleccionado.sceneId);
				}
				//----------------------------------
				var intersects = ray.intersectObjects( helpObjects );
				if ( intersects.length > 0 ) {
					
					if (!addingLines){
						//Agrego el punto
						intersects[0].object.material = new THREE.MeshBasicMaterial( {color: 0x000000} );
						ModelService.addPointToModel(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, intersects[0].object.id, model);
						puntosEscena.push(intersects[0].object);	
					} else {
						if (ModelService.isInModel(intersects[0].object.position.x, intersects[0].object.position.y,intersects[0].object.position.z, model)){
							if (firstPointLine == null){
								firstPointLine = {};
								firstPointLine.x = intersects[0].object.position.x;
								firstPointLine.y = intersects[0].object.position.y;
								firstPointLine.z = intersects[0].object.position.z;
								idFirstPoint = intersects[0].object.id;
								intersects[0].object.material = new THREE.MeshBasicMaterial( {color: 0x8B0000} );
								intersects[0].object.geometry = new THREE.SphereGeometry( 0.1, 50, 50 );
								
							} else {
								SpaceService.drawLine(firstPointLine.x, firstPointLine.y, firstPointLine.z, intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, new THREE.LineBasicMaterial({color: 0x000000}), 0.015, scene);
								ModelService.addLineToModel(firstPointLine.x, firstPointLine.y, firstPointLine.z, intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, model);
								SpaceService.getScenePointById(idFirstPoint, scene).material = new THREE.MeshBasicMaterial( {color: 0x000000} );
								SpaceService.getScenePointById(idFirstPoint, scene).geometry = new THREE.SphereGeometry( 0.05, 50, 50 );
								idFirstPoint = 0;
								firstPointLine = null;
							}
						}
					}
				}
				
				render();
				}
			}
			
			// Funciones principales accesadas desde la view
			
			//Agrega una grilla
			$scope.addGrid = function() {
						
				var line, geometry, i, j;

				var material = new THREE.LineBasicMaterial({color: 0xFF0000, transparent: true, opacity: 0.15});
				
				for (i=0; i < $scope.largoY * $scope.separatorY ; i = i + $scope.separatorY){
					for (j=0; j < $scope.largoX * $scope.separatorX; j = j + $scope.separatorX){
						SpaceService.drawLine($scope.posX + j, $scope.posY + i, $scope.posZ, $scope.posX + j, $scope.posY + i, $scope.posZ + ($scope.largoZ - 1) * $scope.separatorZ, material, 0.01, scene)
					}
					for (j=0; j < $scope.largoZ * $scope.separatorZ; j = j + $scope.separatorZ){
						SpaceService.drawLine($scope.posX, $scope.posY + i, $scope.posZ + j, $scope.posX + ($scope.largoX - 1) * $scope.separatorX, $scope.posY + i, $scope.posZ + j, material, 0.01, scene)
						for (k=0; k < $scope.largoX * $scope.separatorX; k = k + $scope.separatorX){
							var sphereGeometry = new THREE.SphereGeometry( 0.05, 10, 10 );
							var sphereMaterial = new THREE.MeshBasicMaterial( {color: 0xFF0000, transparent: true, opacity: 0.15} );
							var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
							sphere.position.x = $scope.posX+k
							sphere.position.y = $scope.posY+i
							sphere.position.z = $scope.posZ+j
							scene.add(sphere);
							helpObjects.push(sphere);
							if (i > 0){
								SpaceService.drawLine($scope.posX + k, $scope.posY + i - $scope.separatorY, $scope.posZ + j, $scope.posX + k, $scope.posY + i, $scope.posZ + j, material, 0.01, scene)
							}
						}
					}
				}

				render()
			
			};
			
			//Agrega un punto
			$scope.addPoint = function(){
				SpaceService.drawPoint($scope.posX, $scope.posY, $scope.posZ, scene, puntosEscena, helpObjects);
				
				var sceneId = SpaceService.getScenePointIdByCoords($scope.posX, $scope.posY, $scope.posZ, scene);
				ModelService.addPointToModel($scope.posX, $scope.posY, $scope.posZ, sceneId, model);
				render();
			};
			
			//Agrega una partícula
			$scope.addParticle = function(x,y,z){
				var particleGeometry  = new THREE.Geometry;
				var point = new THREE.Vector3(x,y,z);
				particleGeometry.vertices.push(point);
				var particleMaterial = new THREE.PointCloudMaterial({color: 0x000000,size: 0.2});
				var particle = new THREE.PointCloud(particleGeometry, particleMaterial);	
				scene.add(particle);
				render();
			},
			
			$scope.alternateLinesPoints = function(){
				if (addingLines) {
					addingLines = false;
					firsPointLine = null;
					$scope.linesButton = "Agregar líneas"
				} else {
					addingLines = true;
					$scope.linesButton = "Agregar puntos"
				}
			};
			
			//Setea vista 2D
			$scope.set2D = function(){
				tridimensional = false;
				camera.position.x = 0;		
				camera.position.y = 10;		
				camera.position.z = 0;		
				camera.lookAt(new THREE.Vector3(0,0,0));
				controls.removeEventListener( 'change', render );
				render();				
			},
					
			//Setea vista 3D
			$scope.set3D = function (){
				tridimensional = true;
				camera.position.x = 5;
				camera.position.y = 10;
				camera.position.z = 5;	
				camera.lookAt(new THREE.Vector3(0,0,0));				
				controls.addEventListener( 'change', render );
				render();				
			}
			
			$scope.modelToText = function(){
				$scope.modelText = ModelService.getText(model)
			}

			$scope.importModel = function(){
				var reader = new FileReader();
				reader.onload = function(){
					var text = reader.result;
					
					var beginNodeMatrix = text.search("Zs")+3;
					var endNodeMatrix = text.search("Conectivity")-3;
					var nodeMatrix = text.slice(beginNodeMatrix, endNodeMatrix);
					
					var beginConectivityMatrix = text.search("end")+4;
					var endConectivityMatrix = text.length;
					var conectivityMatrix = text.slice(beginConectivityMatrix, endConectivityMatrix);
									
					console.log(nodeMatrix);
					console.log(conectivityMatrix);
				};
				reader.readAsText($scope.theFile);
			}
			
			setFile = function(element) {
					$scope.theFile = element.files[0];
					console.log($scope.theFile)
			};
			
			// --- Inicializa variables
			var viewport, viewportWidth, viewportHeight, puntoSeleccionado;	
			var camera, controls, scene, renderer, tridimensional, grid;
			var mouseX,  mouseY;
			
			var addingLines = false;
			var firstPointLine = null;
			var idFirstPoint = 0;
			var helpObjects = [];
			var puntosEscena = [];
			var model = {};
			model.points = [];
			model.lines = [];
			
			$scope.linesButton = "Agregar líneas"
			
			// --- Inicializa escena
			
			init();
			render();
			
		}
	]);