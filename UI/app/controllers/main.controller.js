var app = angular.module('IETFEM', []);
app.controller(
    'mainCtrl',
	[	'$scope',
		'ModelService',
		'DeformedService',
		'SpaceService',
		'leftMenuService',
		'PtoSelecService',
		'LineaSelecService',
		'DefaultsService',
		'$timeout',
        function($scope, ModelService, DeformedService, SpaceService,leftMenuService,PtoSelecService,LineaSelecService,DefaultsService,$timeout){
		
			//--- splash-screen
			setTimeout(function() {
			   document.getElementById("splash").className += "fadeOut animated";
			}, 500);
			setTimeout(function() {
			   document.getElementById("splash").style.display = "none";
			}, 2000);

			//--- Defino función de inicialización
			function init() {

				//Obtengo el viewport (donde se dibuja)
				viewport = document.getElementById( 'viewport' );
				
				viewportWidth=$("#viewportContainer").width();
				viewportHeight=(window.innerHeight-53);

				//Seteo la camara
				camera = new THREE.PerspectiveCamera( 60, viewportWidth / viewportHeight, 1, 1000 );
				camera.position.z = 10;
				camera.near = 0.1;
				camera.up = new THREE.Vector3( 0, 0, 1 );
				camera.lookAt(new THREE.Vector3( 0, 0, 0 ));

				//Asigno controles de la camara
				controls = new THREE.OrbitControls( camera, viewport );
				controls.damping = 0.1;
				controls.addEventListener( 'change', render );

				//Creo la escena dentro del viewport, pongo grilla auxiliar
				$scope.scene = new THREE.Scene();
				grid = new THREE.GridHelper( 100, 1 );
				grid.rotation.x = Math.PI/2;
				grid.setColors( new THREE.Color(0x838383), new THREE.Color(0xD0D0D0) );
				grid.position.set(0,0,0);
				$scope.scene.add(grid);
			
				var dir = new THREE.Vector3( 1, 0, 0 );
				var origin = new THREE.Vector3( 0, 0, 0 );
				var length = 3;
				var hex = 0xff0000;

				// pongo los ejes
				$scope.scene.add( new THREE.ArrowHelper( new THREE.Vector3( 1, 0, 0 ), origin, length, 0xff0000 ) );
				$scope.scene.add( new THREE.ArrowHelper( new THREE.Vector3( 0, 1, 0 ), origin, length, 0x00ff00 ) );
				$scope.scene.add( new THREE.ArrowHelper( new THREE.Vector3( 0, 0, 1 ), origin, length, 0x0000ff ) );

				rendererStats  = new THREEx.RendererStats();
				rendererStats.domElement.style.position   = 'absolute'
				rendererStats.domElement.style.left  = '0px'
				rendererStats.domElement.style.bottom    = '0px'
				//document.body.appendChild( rendererStats.domElement )

				renderer = new THREE.WebGLRenderer( { antialiasing: false } );
				renderer.setPixelRatio( window.devicePixelRatio );
				renderer.setSize( viewportWidth, viewportHeight );
				renderer.setClearColor( 0xEEEEEE, 1 );
				
				viewport.appendChild( renderer.domElement );

				//Agrego eventos del usuario
				window.addEventListener( 'resize', onWindowResize, false );
				window.addEventListener( 'mouseup', onMouseUp, false );
				window.addEventListener( 'mousedown', onMouseDown, false );
				window.addEventListener( 'keyup', onEscapeUp, false );
				window.addEventListener( 'mousemove', onDocumentMouseMove, false );
				
				// dom
				viewportAxis = document.getElementById('viewportAxis');

				// renderer
				rendererAxis = new THREE.WebGLRenderer();
				rendererAxis.setSize( $("#viewportAxisContainer").width(), $("#viewportAxisContainer").height() );
				rendererAxis.setClearColor( 0xf0f0f0, 1 );
				viewportAxis.appendChild( rendererAxis.domElement );

				// scene
				$scope.sceneAxis = new THREE.Scene();

				// camera
				cameraAxis = new THREE.PerspectiveCamera( 10, $("#viewportAxisContainer").width() / $("#viewportAxisContainer").height(), 1, 1000 );
				cameraAxis.up = camera.up; // important!
				cameraAxis.position.y = 10;

				// axes
				axes2 = new THREE.AxisHelper( 5 );
				$scope.sceneAxis.add( axes2 );

				//$scope.sceneAxis.add( new THREE.ArrowHelper( new THREE.Vector3( 1, 0, 0 ), new THREE.Vector3( 0, 0, 0 ), 1, 0xff0000 ) );
				//$scope.sceneAxis.add( new THREE.ArrowHelper( new THREE.Vector3( 0, 1, 0 ), new THREE.Vector3( 0, 0, 0 ), 1, 0x00ff00 ) );
				//$scope.sceneAxis.add( new THREE.ArrowHelper( new THREE.Vector3( 0, 0, 1 ), new THREE.Vector3( 0, 0, 0 ), 1, 0x0000ff ) );

				//Agrego el origen
				$scope.addParticle(0,0,0);
				
				//UI staff
				setMenuIzqSize();
				$(function () {// Activa el plugin de los ToolTips
				  $('[data-toggle="tooltip"]').tooltip()
				})

				
				
			}

			//--- Defino función de Render
			var render=function render() {

				cameraAxis.position.copy( camera.position );

				cameraAxis.position.sub( controls.target ); // added by @libe

				cameraAxis.position.setLength( 10 );
				cameraAxis.up = camera.up;

			    cameraAxis.lookAt( $scope.sceneAxis.position );

 				rendererStats.update(renderer);
 
				renderer.render( $scope.scene, camera );
				rendererAxis.render( $scope.sceneAxis, cameraAxis );	
			} 

			// Auxiliares de UI
			function setMenuIzqSize(){
				
				$(".botonMenuIzq").css("padding","0");
				$(".botonMenuIzq").width($("#menuIzquierda").width());
				$(".botonMenuIzq").height($("#menuIzquierda").width());
			} 
			
			//--- Defino Eventos de usuario
			
			//Cuando se cambia el tamaño de la ventana
			function onWindowResize() {
				
				viewportWidth=$("#viewportContainer").width();
				viewportHeight=(window.innerHeight-53);

				camera.aspect = viewportWidth / viewportHeight;
				camera.updateProjectionMatrix();

				renderer.setSize( $("#viewportContainer").width(), window.innerHeight-53 );

				render();

				setMenuIzqSize();
			}

			//Cuando se presione escape
			function onEscapeUp( event ) {
				if (event.keyCode == 27) {
					if(leftMenuService.getSelecting()){//Si esta en modo seleccion quito la seleccion actual
						var miPuntoSelec= PtoSelecService.getPuntoReal();
						var miLineaSelec= LineaSelecService.getLineaReal();
						if(miPuntoSelec != null){
							var miPuntoEscena= SpaceService.getScenePointById(miPuntoSelec.sceneId,$scope.scene);
							miPuntoEscena.material= DefaultsService.getMaterialNegro();
							PtoSelecService.resetPuntoSeleccionado();
						}
						if(miLineaSelec != null){
							var miLineaEscena= SpaceService.getSceneLineById(miLineaSelec.sceneId,$scope.scene);
							miLineaEscena.material= DefaultsService.getMaterialNegro();
							LineaSelecService.resetLineaSeleccionada();
						}
						render();
						leftMenuService.setLastSelected(null);
						$scope.$apply();
						
					}else{// Si esta en otro modo paso al de seleccion
						leftMenuService.setAddingLines(false);
						leftMenuService.setAddingNodes(false);
						leftMenuService.setAddingGrillas(false);
						leftMenuService.setSelecting(true);
						$scope.$apply();
					}
				}
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
				  $scope.xCondicion =puntoSeleccionado.xCondicion;
			}

			//Efecto de resaltar al pasar por arriva
			function onDocumentMouseMove(event){
				if($scope.programMode == 'CROSSLINK_INPUT'){//leftMenuService.getSelecting()){// Si esta en modo seleccion
					viewportWidth=$("#viewportContainer").width();
					viewportHeight=(window.innerHeight-53);
					offsetIzq=$("#menuIzquierda").outerWidth(true);
				
								
				 var vector = new THREE.Vector3( ( 
					(event.clientX-offsetIzq) / viewportWidth) * 2 - 1, 
					- ( (event.clientY-53) / (viewportHeight) ) * 2 + 1, 
					0.5 
				);

				vector.unproject( camera );
				var ray = new THREE.Raycaster( camera.position, vector.sub( camera.position ).normalize() );
				var nodosBarrasEscena=$scope.spaceAux.scenePoints.concat($scope.spaceAux.sceneLines);

				var intersection = ray.intersectObjects(nodosBarrasEscena);

					if(intersection.length > 0){
						idIntersected=intersection[0].object.id;
						//Si no es el que ya esta resaltado| (nodo | barra seleccionado) | el primer punto al crear una linea
						if(intersected != intersection[0].object && PtoSelecService.getPunto().sceneId != idIntersected 
							&& LineaSelecService.getLinea().sceneId != idIntersected && idFirstPoint != idIntersected){ 
							if(intersected != null){// Si tenia alguno lo paso a la normalidad
								intersected.material= DefaultsService.getMaterialNegro();
							}
							intersected=intersection[0].object;
							intersection[0].object.material = DefaultsService.getMaterialResaltado();//Resalto
						}
					}else{// Si no esta intersectando ninguno desmarco el anterior
						if(intersected !=null){
							if(PtoSelecService.getPunto().sceneId != intersected.id
								&& LineaSelecService.getLinea().sceneId != intersected.id && idFirstPoint != intersected.id){
								
								if(intersected != null){// Si tenia alguno que no este resaltado por seleccion lo paso a la normalidad
									intersected.material=DefaultsService.getMaterialNegro();
								}
							}
						}
						intersected=null;
					}

				}else{
					if(intersected != null){
						intersected.material=DefaultsService.getMaterialNegro();
					}else{
						intersected= null;
					}
				}
				render();
			}  

			//Cuando se levanta el click izquierdo
			function onMouseUp( event ) { 

				viewportWidth=$("#viewportContainer").width();
				viewportHeight=(window.innerHeight-53);
				offsetIzq=$("#menuIzquierda").outerWidth(true);
			
					
				 var vector = new THREE.Vector3( ( 
					(event.clientX-offsetIzq) / viewportWidth) * 2 - 1, 
					- ( (event.clientY-53) / (viewportHeight) ) * 2 + 1, 
					0.5 
				);
				
				vector.unproject( camera );

				var ray = new THREE.Raycaster( camera.position, vector.sub( camera.position ).normalize() );

				var isSelectionBlocked=false;

				//FUNCION OBTENGO punto seleccionado
				if(leftMenuService.getSelecting()){// Si esta en modo seleccion
					var pointIntersection = ray.intersectObjects($scope.spaceAux.scenePoints);
					var puntoModeloSelec;
					if(pointIntersection.length > 0){
						puntoModeloSelec=ModelService.getPointBySceneId(pointIntersection[0].object.id,$scope.model);
						if(PtoSelecService.getPunto().id != puntoModeloSelec.id){// Si el punto no esta seleccionado lo prendo
							if(PtoSelecService.getPunto().sceneId != 0){// Si habia un punto seleccionado lo apago
								SpaceService.getScenePointById(PtoSelecService.getPunto().sceneId,$scope.scene).material = DefaultsService.getMaterialNegro();
							}
							PtoSelecService.setPunto(puntoModeloSelec);
							pointIntersection[0].object.material = DefaultsService.getMaterialSeleccion();
						}else{// Si el punto estaba seleccionado lo des selecciono
							PtoSelecService.resetPuntoSeleccionado();
							pointIntersection[0].object.material = DefaultsService.getMaterialNegro();
						}
						isSelectionBlocked=true;
						PtoSelecService.resetForm();
						$scope.$apply();//Es necesario avisarle a angular que cambiamos el puntoSeleccionado
						//alert('Seleccionado!! id: ' + PtoSelecService.getPunto().id);
					}
				}
				//-----------------------------------------------------------------------------------------------------

				//FUNCION OBTENGO linea seleccionada
				if(!isSelectionBlocked){
					if(leftMenuService.getSelecting()){// Si esta en modo seleccion
						var lineIntersection = ray.intersectObjects($scope.spaceAux.sceneLines);
						var lineaModeloSelec;
						if(lineIntersection.length >0){
							lineaModeloSelec=ModelService.getLineBySceneId(lineIntersection[0].object.id,$scope.model);
							if(LineaSelecService.getLinea().id != lineaModeloSelec.id){// Si la linea no esta seleccionado lo prendo
								if(LineaSelecService.getLinea().sceneId != 0){// Si habia una linea seleccionada la apago
									SpaceService.getSceneLineById(LineaSelecService.getLinea().sceneId,$scope.scene).material = DefaultsService.getMaterialNegro();
								}
								LineaSelecService.setLinea(lineaModeloSelec);
								lineIntersection[0].object.material = DefaultsService.getMaterialSeleccion();
							
							}else{// Si la linea estaba seleccionada la des selecciono
								LineaSelecService.resetLineaSeleccionada();
								lineIntersection[0].object.material = DefaultsService.getMaterialNegro();
							}
						LineaSelecService.resetForm();
						$scope.$apply();
						}
					}
				}

				//-------------------------------------------------------------------------------------------------------

				var intersects = ray.intersectObjects( $scope.spaceAux.helpObjects.grilla );
				if ( intersects.length > 0 ) {
					
					if (!leftMenuService.getAddingLines() && leftMenuService.getAddingNodes()){
						//Agrego el punto
						if(!$scope.yaExistePuntoCoords(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z)){
							/*
							intersects[0].object.material = new THREE.MeshBasicMaterial( {color: 0x000000} ); ya no es necesario*/
							var newNodeId=SpaceService.drawPoint(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, $scope.scene, $scope.spaceAux.scenePoints, DefaultsService.getMaterialNegro() , null);
							ModelService.addPointToModel(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, newNodeId, $scope.model);
							$scope.setScaleValues(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z,false);
							/*puntosEscena.push(intersects[0].object);	ya no es necesario creamos un nuevo nodo*/
						}
					} 
				}

				var intersects = ray.intersectObjects($scope.spaceAux.scenePoints);
				if ( intersects.length > 0 ) {
					if(leftMenuService.getAddingLines() && !leftMenuService.getAddingNodes()){
						if (ModelService.isInModel(intersects[0].object.position.x, intersects[0].object.position.y,intersects[0].object.position.z, $scope.model)){
							if (firstPointLine == null){
								firstPointLine = {};
								firstPointLine.x = intersects[0].object.position.x;
								firstPointLine.y = intersects[0].object.position.y;
								firstPointLine.z = intersects[0].object.position.z;
								idFirstPoint = intersects[0].object.id;
								intersects[0].object.material = DefaultsService.getMaterialCreacionLinea();
								intersects[0].object.geometry = new THREE.SphereGeometry( 0.15, 4, 4 );
								
							} else {
								if(firstPointLine.x != intersects[0].object.position.x || firstPointLine.y != intersects[0].object.position.y || firstPointLine.z != intersects[0].object.position.z){
									var lineSceneId = SpaceService.drawLine(firstPointLine.x, firstPointLine.y, firstPointLine.z, intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, DefaultsService.getMaterialNegro(), 0.035, $scope.scene,$scope.spaceAux.sceneLines);
									ModelService.addLineToModel(firstPointLine.x, firstPointLine.y, firstPointLine.z, intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, lineSceneId,$scope.model);
								}
								SpaceService.getScenePointById(idFirstPoint, $scope.scene).material = DefaultsService.getMaterialNegro();
								SpaceService.getScenePointById(idFirstPoint, $scope.scene).geometry = new THREE.SphereGeometry( 0.1, 4, 4 );
								idFirstPoint = 0;
								firstPointLine = null;
							}
						}
					}
				}
				
				
				render();
			}
			
			// Funciones principales accesadas desde la view
			
			//Agrega una grilla
			$scope.addGrid = function() {
				
				var miGridInfo=ModelService.createGridInfo($scope.model.helpObjects.grillas);
				var line, geometry, i, j;

				//var material = new THREE.LineBasicMaterial({color: 0xFF0000, transparent: true, opacity: 0.15});
				var material = DefaultsService.getMaterialGrilla();

				for (i=0; i < $scope.largoY * $scope.separatorY ; i = i + $scope.separatorY){
					for (j=0; j < $scope.largoX * $scope.separatorX; j = j + $scope.separatorX){
						var sceneIdGridLine=SpaceService.drawLine($scope.posX + j, $scope.posY + i, $scope.posZ, $scope.posX + j, $scope.posY + i, $scope.posZ + ($scope.largoZ - 1) * $scope.separatorZ, material, 0.01, $scope.scene,null, true);
						ModelService.addGridLineToModel($scope.posX + j, $scope.posY + i, $scope.posZ, $scope.posX + j, $scope.posY + i, $scope.posZ + ($scope.largoZ - 1) * $scope.separatorZ, sceneIdGridLine,miGridInfo);
					}
					for (j=0; j < $scope.largoZ * $scope.separatorZ; j = j + $scope.separatorZ){
						var sceneIdGridLine=SpaceService.drawLine($scope.posX, $scope.posY + i, $scope.posZ + j, $scope.posX + ($scope.largoX - 1) * $scope.separatorX, $scope.posY + i, $scope.posZ + j, material, 0.01, $scope.scene,null, true);
						ModelService.addGridLineToModel($scope.posX, $scope.posY + i, $scope.posZ + j, $scope.posX + ($scope.largoX - 1) * $scope.separatorX, $scope.posY + i, $scope.posZ + j, sceneIdGridLine,miGridInfo);
						for (k=0; k < $scope.largoX * $scope.separatorX; k = k + $scope.separatorX){
							//var sphereGeometry = new THREE.SphereGeometry(  0.1, 4, 4  );
							var sphereGeometry= DefaultsService.getEsferaEstandar();
							//var sphereMaterial = new THREE.MeshBasicMaterial( {color: 0xFF0000, transparent: true, opacity: 0.15} );
							var sphereMaterial = DefaultsService.getMaterialGrilla();

							var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
							sphere.position.x = $scope.posX+k;
							sphere.position.y = $scope.posY+i;
							sphere.position.z = $scope.posZ+j;
							$scope.scene.add(sphere);

							ModelService.addGridPointToModel($scope.posX+k,$scope.posY+i,$scope.posZ+j, sphere.id, miGridInfo);
							$scope.spaceAux.helpObjects.grilla.push(sphere);
							if (i > 0){
								var sceneIdGridLine= SpaceService.drawLine($scope.posX + k, $scope.posY + i - $scope.separatorY, $scope.posZ + j, $scope.posX + k, $scope.posY + i, $scope.posZ + j, material, 0.01, $scope.scene,null, true);
								ModelService.addGridLineToModel($scope.posX + k, $scope.posY + i - $scope.separatorY, $scope.posZ + j, $scope.posX + k, $scope.posY + i, $scope.posZ + j, sceneIdGridLine,miGridInfo);
							}
						}
					}
				}

				render();
				//Reseteo form
				$scope.grillaForm.$setPristine();
				$scope.posX=undefined;
				$scope.posY=undefined;
				$scope.posZ=undefined;
				$scope.largoX=undefined;
				$scope.separatorX=undefined;
				$scope.largoY=undefined;
				$scope.separatorY=undefined;
				$scope.largoZ=undefined;
				$scope.separatorZ=undefined;

				$scope.model.helpObjects.idLastGrilla++;
			
			};

			var reCalcularEscala= function(){//Obtengo la fuerza mas grande para realizar regla de 3 y escalar el resto de las fuerzas
				for(var i = 0; i < $scope.model.points.length ;i++){
					if($scope.fuerzas.escala.maxX != null && $scope.fuerzas.escala.minX !=null && 
						$scope.fuerzas.escala.maxY != null && $scope.fuerzas.escala.minY !=null && 
						$scope.fuerzas.escala.maxZ != null && $scope.fuerzas.escala.minZ !=null){
						//Si no quedan valores en null quiere decir que ya no debo hacer mas calculos
						break;
					}
					var punto=$scope.model.points[i];
					$scope.setScaleValues(punto.coords.x,punto.coords.y,punto.coords.z,false);
				}
			};

			//Funcion para setear valores para calculo de escala de las fuerzas
			//x,y,z son coordenadas de un nodo
			$scope.setScaleValues= function(x,y,z,reset){
				if(reset){//Se utiliza cuando se elimina un nodo
					//Si alguna de las coordenadas del punto es alguna coordenada max o min del sistema recalculo
					var cambio=false;
					if(x == $scope.fuerzas.escala.maxX || x == $scope.fuerzas.escala.minX){
						$scope.fuerzas.escala.maxX=null;
						$scope.fuerzas.escala.minX=null;
						cambio=true;
					}
					if(y == $scope.fuerzas.escala.maxY || y == $scope.fuerzas.escala.minY){
						$scope.fuerzas.escala.maxY=null;
						$scope.fuerzas.escala.minY=null;
						cambio=true;
					}
					if(z == $scope.fuerzas.escala.maxZ || z == $scope.fuerzas.escala.minZ){
						$scope.fuerzas.escala.maxZ=null;
						$scope.fuerzas.escala.minZ=null;
						cambio=true;
					}
					if(cambio){
						reCalcularEscala();
					}

				}else{

					//Seteo los valores si corresponde
					if(($scope.fuerzas.escala.maxX != null) && (x > $scope.fuerzas.escala.maxX)){
						$scope.fuerzas.escala.maxX = x;
						
					}else if($scope.fuerzas.escala.minX != null && x < $scope.fuerzas.escala.minX){
						$scope.fuerzas.escala.minX = x;
					}else{
						$scope.fuerzas.escala.maxX = x;
						$scope.fuerzas.escala.minX = x;
					}

					//Seteo los valores si corresponde
					if($scope.fuerzas.escala.maxY != null && y > $scope.fuerzas.escala.maxY){
						$scope.fuerzas.escala.maxY = y;
					}else if($scope.fuerzas.escala.minY != null && y < $scope.fuerzas.escala.minY){
						$scope.fuerzas.escala.minY = y;
					}else{
						$scope.fuerzas.escala.maxY = y;
						$scope.fuerzas.escala.minY = y;
					}

					//Seteo los valores si corresponde
					if($scope.fuerzas.escala.maxZ != null && z > $scope.fuerzas.escala.maxZ){
						$scope.fuerzas.escala.maxZ = z;
					}else if($scope.fuerzas.escala.minZ != null && z < $scope.fuerzas.escala.minZ){
						$scope.fuerzas.escala.minZ = z;
					}else{
						$scope.fuerzas.escala.maxZ = z;
						$scope.fuerzas.escala.minZ = z;
					}

				
				}
				
			};
			
			//Agrega un punto
			$scope.addPoint = function(){
				var material= new THREE.MeshBasicMaterial( {color: 0x000000} );
				if(SpaceService.getScenePointIdByCoords($scope.posX, $scope.posY, $scope.posZ, $scope.scene)==0){// Se podria usar una funcion mas performante
					var sceneId = SpaceService.drawPoint($scope.posX, $scope.posY, $scope.posZ, $scope.scene, $scope.spaceAux.scenePoints, material, $scope.spaceAux.helpObjects.grilla);
					
					ModelService.addPointToModel($scope.posX, $scope.posY, $scope.posZ, sceneId, $scope.model);
					//Actualizo valores para escala de las fuerzas
					$scope.setScaleValues($scope.posX, $scope.posY, $scope.posZ,false);

					render();
					//Reseteo form
					$scope.nodoCoordenadaForm.$setPristine();
					$scope.posX=undefined;
					$scope.posY=undefined;
					$scope.posZ=undefined;
				}
			};

			$scope.yaExistePunto= function(){
				if(ModelService.getPointIdByCoords($scope.posX, $scope.posY, $scope.posZ, $scope.model)==0){
					return false;
				}else{
					return true;
				}
			};

			$scope.yaExistePuntoCoords= function(x,y,z){
				if(ModelService.getPointIdByCoords(x, y, z, $scope.model)==0){
					return false;
				}else{
					return true;
				}
			};
			
			//Agrega una partícula
			$scope.addParticle = function(x,y,z){
				var particleGeometry  = new THREE.Geometry;
				var point = new THREE.Vector3(x,y,z);
				particleGeometry.vertices.push(point);
				var particleMaterial = new THREE.PointCloudMaterial({color: 0x000000,size: 0.2});
				var particle = new THREE.PointCloud(particleGeometry, particleMaterial);	
				$scope.scene.add(particle);
				render();
			},
			
			
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
				$scope.validModel = ModelService.validModel($scope.model);
				if ($scope.validModel.valid){
					$scope.modelText = ModelService.getText($scope.model)

					var a = window.document.createElement('a');
					a.href = window.URL.createObjectURL(new Blob([$scope.modelText], {type: 'text/txt'}));
					a.download = 'model.txt';
					document.body.appendChild(a)
					a.click();
					document.body.removeChild(a)

					$('#obtenerTextoModal').modal('hide');
					$('#transitionModal').modal('show');
				}		
			}

			$scope.goToDownloadModel = function(){
				console.log($scope.model);
				$scope.validModel = {valid:true};
				$('#obtenerTextoModal').modal('show');
			}

			$scope.goToProcessOutput = function(){
				$('#transitionModal').modal('hide');
				$('#processOutputModal').modal('show');
			}

			$scope.processOutput = function(){
				

				var outputReader = new FileReader();
				outputReader.onload = function(){
				
					var material = new THREE.LineBasicMaterial({color: 0x29088A, transparent: true, opacity: 0.15});
					var text = outputReader.result;
			
					var input = text.slice(0,text.search("RESULTADOS")-1);
					
					//Validacion de que el input sea igual al texto generado
					//var generatedInput = ModelService.getText($scope.model);
					//if (input === generatedInput){
					//		
					//}

					var displacementMatrix = [];
					var beginDisplacementMatrix = text.search("u_z")+4;
					var endDisplacementeMatrix = text.search("Parametros en barras")-2;
					var temp = text.slice(beginDisplacementMatrix, endDisplacementeMatrix).split("\n");

					for (i = 0; i < temp.length; i++) { 
						var row = temp[i].split("\t")
						displacementMatrix.push(row);
					}
					

					var forcesMatrix = [];
					var beginForcesMatrix = text.search("Tension")+8;
					var endForcesMatrix = text.length-1;
					temp = text.slice(beginForcesMatrix, endForcesMatrix).split("\n");
					for (i = 0; i < temp.length; i++) { 
						row = temp[i].split("\t")
						forcesMatrix.push(row);
					}
					var end = 0;
					for (i = 0; end < displacementMatrix.length; i++) {
						var point = ModelService.getPointById(i+1, $scope.model);

						if (point){
							var displacementX = parseFloat(displacementMatrix[end][0].split("e")[0]) * Math.pow(10,parseFloat(displacementMatrix[end][0].split("e")[1]));
							var displacementY = parseFloat(displacementMatrix[end][1].split("e")[0]) * Math.pow(10,parseFloat(displacementMatrix[end][1].split("e")[1]));
							var displacementZ = parseFloat(displacementMatrix[end][2].split("e")[0]) * Math.pow(10,parseFloat(displacementMatrix[end][2].split("e")[1]));

							var pointX = parseFloat(point.coords.x) + displacementX
							var pointY = parseFloat(point.coords.y) + displacementY
							var pointZ = parseFloat(point.coords.z) + displacementZ

							var sceneId = SpaceService.drawPoint(pointX, pointY, pointZ, $scope.scene, $scope.spaceAux.scenePoints, material, null);

							DeformedService.addPointToDeformed(point.coords.x, point.coords.z, point.coords.y,displacementX, displacementZ, displacementY, point.id, sceneId, $scope.deformed);
							end += 1;
						}
					}
					
					end = 0;
					for (i = 0; end < forcesMatrix.length; i++) {
						var line = $scope.model.lines[i];

						if (line){

							var point1 = DeformedService.getDeformedPointById(line.start, $scope.deformed);
							var point2 = DeformedService.getDeformedPointById(line.end, $scope.deformed);

							var a1 = parseFloat(point1.coords.x) + parseFloat(point1.displacements.x);
							var a2 = parseFloat(point1.coords.z) + parseFloat(point1.displacements.z);
							var a3 = parseFloat(point1.coords.y) + parseFloat(point1.displacements.y);
							var b1 = parseFloat(point2.coords.x) + parseFloat(point2.displacements.x);
							var b2 = parseFloat(point2.coords.z) + parseFloat(point2.displacements.z);
							var b3 = parseFloat(point2.coords.y) + parseFloat(point2.displacements.y);
							var sceneId=SpaceService.drawLine(a1, a2, a3, b1, b2, b3, material, 0.05, $scope.scene,[]);

							var deformation = parseFloat(forcesMatrix[end][0].split("e")[0]) * Math.pow(10,parseFloat(forcesMatrix[end][0].split("e")[1])); 
							var force = parseFloat(forcesMatrix[end][1].split("e")[0]) * Math.pow(10,parseFloat(forcesMatrix[end][1].split("e")[1])); 
							var tension = parseFloat(forcesMatrix[end][2].split("e")[0]) * Math.pow(10,parseFloat(forcesMatrix[end][2].split("e")[1])); 

							DeformedService.addLineToDeformed(line.start, line.end, line.id, sceneId, deformation, force, tension,$scope.deformed);
							end += 1;
						}
					}
						

					$('#processOutputModal').modal('hide');
					
					render();
				};
				
				outputReader.readAsText($scope.theFile);
				$scope.programMode = 'CROSSLINK_OUTPUT';
				$scope.structureView = 'normal';
				$scope.scaleStructure = 1
				$scope.structureColors = 'normal';

			}

			$scope.startImportModel= function(){
				if($scope.theFile!= null){
					$scope.importing = true;
					$scope.$apply();
					setTimeout($scope.importModel,0);// encolamos el llamado a la funcion para dar tiempo a la UI a renderizarse
				}
			}

			$scope.importModel = function(){

				$scope.importing = true;

				var reader = new FileReader();
				reader.onload = function(){
				
					var material = DefaultsService.getMaterialNegro();
					var text = reader.result;
					text.replace("/r/n", "/n");
					
					var nodeMatrix = [];
					var beginNodeMatrix = text.search("Zs")+4;
					var endNodeMatrix = text.search("Conectivity")-3;
					var temp = text.slice(beginNodeMatrix, endNodeMatrix).split("\n");
					for (i = 0; i < temp.length; i++) { 
						var row = temp[i].split("\t")
						for (var j = 0; j < row.length; j++) { 
							row[j] = parseFloat(row[j]/3);
						}
						nodeMatrix.push(row);
					}


					var conectivityMatrix = [];
					var beginConectivityMatrix = text.search("end")+5;
					var endConectivityMatrix = text.length;
					temp = text.slice(beginConectivityMatrix, endConectivityMatrix).split("\n");
					for (i = 0; i < temp.length; i++) { 
						row = temp[i].split("\t")
						conectivityMatrix.push(row);
					}
					
					
					for (i = 0; i < nodeMatrix.length; i++) {
						var sceneId = SpaceService.drawPoint(nodeMatrix[i][0], nodeMatrix[i][1], nodeMatrix[i][2], $scope.scene, $scope.spaceAux.scenePoints, material, null);
						ModelService.addPointToModel(nodeMatrix[i][0], nodeMatrix[i][1], nodeMatrix[i][2], sceneId, $scope.model);
						$scope.setScaleValues(nodeMatrix[i][0], nodeMatrix[i][1], nodeMatrix[i][2],false);
					}

					
					for (i = 0; i < conectivityMatrix.length; i++) {
					
						var a1 = parseFloat(nodeMatrix[conectivityMatrix[i][3]-1][0]);
						var a2 = parseFloat(nodeMatrix[conectivityMatrix[i][3]-1][1]);
						var a3 = parseFloat(nodeMatrix[conectivityMatrix[i][3]-1][2]);
						var b1 = parseFloat(nodeMatrix[conectivityMatrix[i][4]-1][0]);
						var b2 = parseFloat(nodeMatrix[conectivityMatrix[i][4]-1][1]);
						var b3 = parseFloat(nodeMatrix[conectivityMatrix[i][4]-1][2]);
						
						var sceneId=SpaceService.drawLine(a1, a2, a3, b1, b2, b3, DefaultsService.getMaterialNegro(), 0.05, $scope.scene,$scope.spaceAux.sceneLines);
						
						ModelService.addLineToModel(a1, a2, a3, b1, b2, b3,sceneId, $scope.model);
					}
					
						
					render();

					$('#importModelModal').modal('hide');
					$scope.importing = false;
					$scope.$apply();
					
				};
				reader.readAsText($scope.theFile);

			}
			
			setFile = function(element) {
					$scope.theFile = element.files[0];
			};

			$scope.goToSaveModel = function(){
				$scope.saveModelOnExit = true;
				$('#newModelModal').modal('hide');
				$('#saveModelModal').modal('show');
			};

			$scope.saveModel = function(){

				var textModel = angular.toJson($scope.model);
				var a = window.document.createElement('a');
				a.href = window.URL.createObjectURL(new Blob([textModel], {type: 'text/txt'}));
				a.download = $scope.modelName+'.iet';
				document.body.appendChild(a)
				a.click();
				document.body.removeChild(a)

				if ($scope.saveModelOnExit){
					$scope.saveModelOnExit = false;
					$scope.newModel('#saveModelModal');
				} else {
					$('#saveModelModal').modal('hide');						
				}
			};

			$scope.newModel = function(modal){

				var firstPointLine = null;
				var idFirstPoint = 0;
				
				LineaSelecService.resetLineaSeleccionada();
				PtoSelecService.resetPuntoSeleccionado();

				$scope.fuerzas.visible=false;
				//maxModule= (Max{DeltaX,DeltaY,DeltaZ}) * 0.2
				$scope.fuerzas.escala={factorEscala:1,maxModule:1,maxX:null,minX:null,maxY:null,minY:null,maxZ:null,minZ:null};

				$scope.supports.visible=false;
				$scope.resortes.visible=false;

				//$scope.model = {helpObjects: {}};
				$scope.model.points = [];
				$scope.model.lines = [];
				//$scope.model.helpObjects = {};
				//$scope.model.materiales = [];
				//$scope.model.secciones= [];		

				var largoMateriales=$scope.model.materiales.length;
				for (var i=0; i<largoMateriales; i++){
					$scope.model.materiales.pop();
				};
				var largoSecciones=$scope.model.secciones.length;
				for (var i=0; i<largoSecciones; i++){
					$scope.model.secciones.pop();
				};
				var largoGrillas=$scope.model.helpObjects.grillas.length
				for (var i=0; i<largoGrillas; i++){
					$scope.model.helpObjects.grillas.pop();
				};
				//$scope.model.helpObjects.grillas=[];//Conjunto de infoGrid tienen info+ array de objetos del modelo

				$scope.spaceAux={helpObjects: {}};
				$scope.spaceAux.helpObjects.grilla= [];

				$scope.spaceAux.scenePoints = [];
				$scope.spaceAux.sceneLines = [];

				$scope.deformed = {};
				$scope.deformed.points = [];
				$scope.deformed.lines = [];

				$scope.programMode = 'CROSSLINK_INPUT';

				$(modal).modal('hide');

				//Creo la escena dentro del viewport, pongo grilla auxiliar
				$scope.scene = new THREE.Scene();
				grid = new THREE.GridHelper( 100, 1 );
				grid.rotation.x = Math.PI/2;
				grid.setColors( new THREE.Color(0x838383), new THREE.Color(0xD0D0D0) );
				grid.position.set(0,0,0);
				$scope.scene.add(grid);
			
				var dir = new THREE.Vector3( 1, 0, 0 );
				var origin = new THREE.Vector3( 0, 0, 0 );
				var length = 3;
				var hex = 0xff0000;

				// pongo los ejes
				$scope.scene.add( new THREE.ArrowHelper( new THREE.Vector3( 1, 0, 0 ), origin, length, 0xff0000 ) );
				$scope.scene.add( new THREE.ArrowHelper( new THREE.Vector3( 0, 1, 0 ), origin, length, 0x00ff00 ) );
				$scope.scene.add( new THREE.ArrowHelper( new THREE.Vector3( 0, 0, 1 ), origin, length, 0x0000ff ) );

				render();
			};


			$scope.startOpenModel= function(){
				if($scope.theFile!= null){
					$scope.opening = true;
					$scope.$apply();
					$scope.newModel('');
					setTimeout($scope.openModel,0);// encolamos el llamado a la funcion para dar tiempo a la UI a renderizarse
				}
			}

			$scope.openModel = function(){

				var reader = new FileReader();
				reader.onload = function(){
				
					$scope.newModel();
					var text = reader.result;


					//Modelo importado directamente
					var auxModel = angular.fromJson(text);
					$scope.model.points = auxModel.points;
					$scope.model.lines = auxModel.lines;

					for (i=0; i < auxModel.materiales.length ; i++){
						$scope.model.materiales.push(auxModel.materiales[i])
					};

					for (i=0; i < auxModel.secciones.length ; i++){
						$scope.model.secciones.push(auxModel.secciones[i])
					};

					for (var i=0; i < auxModel.helpObjects.grillas.length; i++){
						var grilla = auxModel.helpObjects.grillas[i];
						var material = DefaultsService.getMaterialGrilla();
						for (var j=0; j < grilla.objects.length; j++){
							if(grilla.objects[j].type == 'POINT'){
								var sphereGeometry= DefaultsService.getEsferaEstandar();
								var sphereMaterial = DefaultsService.getMaterialGrilla();
								var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
								sphere.position.x = grilla.objects[j].coords.x;
								sphere.position.y = grilla.objects[j].coords.y;
								sphere.position.z = grilla.objects[j].coords.z;
								$scope.scene.add(sphere);
								$scope.spaceAux.helpObjects.grilla.push(sphere);
								grilla.objects[j].sceneId = sphere.id;
							} else {
								var sceneIdGridLine= SpaceService.drawLine(grilla.objects[j].start.x, grilla.objects[j].start.y, grilla.objects[j].start.z, grilla.objects[j].end.x, grilla.objects[j].end.y, grilla.objects[j].end.z, material, 0.01, $scope.scene,null, true);
								grilla.objects[j].sceneId = sceneIdGridLine;
							}
						}

						$scope.model.helpObjects.grillas.push(grilla);
					};

					for (i=0; i < $scope.model.points.length ; i++){
						$scope.model.points[i].forceArrowId = 0;
						$scope.model.points[i].supportXId = 0;
						$scope.model.points[i].supportYId = 0;
						$scope.model.points[i].supportZId = 0;
						$scope.model.points[i].springXId = 0;
						$scope.model.points[i].springYId = 0;
						$scope.model.points[i].springZId = 0;
					};

					SpaceService.drawModel($scope.scene,$scope.model, $scope.spaceAux.scenePoints, $scope.spaceAux.sceneLines, $scope.spaceAux.helpObjects);

					$('#openModelModal').modal('hide');
					$scope.$apply();
					render();

				};
				reader.readAsText($scope.theFile);
				$scope.opening = false;
			}

			$scope.returnToEdit = function(){
				$scope.programMode = "CROSSLINK_INPUT"
				$scope.deformed = {};
				$scope.deformed.points = [];
				$scope.deformed.lines = [];

				//Creo la escena dentro del viewport, pongo grilla auxiliar
				$scope.scene = new THREE.Scene();
				grid = new THREE.GridHelper( 100, 1 );
				grid.rotation.x = Math.PI/2;
				grid.setColors( new THREE.Color(0x838383), new THREE.Color(0xD0D0D0) );
				grid.position.set(0,0,0);
				$scope.scene.add(grid);
			
				var dir = new THREE.Vector3( 1, 0, 0 );
				var origin = new THREE.Vector3( 0, 0, 0 );
				var length = 3;
				var hex = 0xff0000;

				// pongo los ejes
				$scope.scene.add( new THREE.ArrowHelper( new THREE.Vector3( 1, 0, 0 ), origin, length, 0xff0000 ) );
				$scope.scene.add( new THREE.ArrowHelper( new THREE.Vector3( 0, 1, 0 ), origin, length, 0x00ff00 ) );
				$scope.scene.add( new THREE.ArrowHelper( new THREE.Vector3( 0, 0, 1 ), origin, length, 0x0000ff ) );

				SpaceService.drawModel($scope.scene,$scope.model, $scope.spaceAux.scenePoints, $scope.spaceAux.sceneLines, $scope.spaceAux.helpObjects);
				

			}

			// Ver si dejamos estas funciones aca o hacemos otro controlador o algo
			$scope.dibujandoNodos = function(){
				return leftMenuService.getAddingNodes();
			};

			$scope.dibujandoGrillas = function(){
				return leftMenuService.getAddingGrillas();
			};

			$scope.seleccionando = function(){
				return leftMenuService.getSelecting();
			};

			$scope.ultimoSeleccionado = function(){
				return leftMenuService.getLastSelected();
			};

			$scope.dibujandoLineas = function(){
				return leftMenuService.getAddingLines();
			};

			$scope.viewingOptions = function(){
				return leftMenuService.getViewOptions();
			};

			// Variables para progressBar de importar Modelo
			$scope.progress=0;
			//----------------------------------------------

			// --- Inicializa variables
			var viewport, viewportWidth, viewportHeight;	
			var camera, cameraAxis, controls, renderer, rendererAxis, tridimensional, grid;
			var mouseX,  mouseY;

			//objeto actual resaltado mouseover
			var intersected=null;
			
			var firstPointLine = null;
			var idFirstPoint = 0;

			//$scope.fuerzas={visible:true, escala:1};
			$scope.fuerzas={visible:true};
			//maxModule= (Max{DeltaX,DeltaY,DeltaZ}) * 0.2
			$scope.fuerzas.escala={factorEscala:1,maxModule:1,maxX:null,minX:null,maxY:null,minY:null,maxZ:null,minZ:null};
			$scope.supports={visible:true};
			$scope.resortes={visible:true};


			$scope.model = {helpObjects: {}};
			$scope.model.points = [];
			$scope.model.lines = [];
			$scope.model.materiales = [];
			$scope.model.secciones= [];		
			$scope.model.unitForce= "XX";	
			$scope.model.unitLength= "XX";	

			$scope.model.helpObjects.grillas=[];//Conjunto de infoGrid tienen info+ array de objetos del modelo

			$scope.spaceAux={helpObjects: {}};
			$scope.spaceAux.helpObjects.grilla= [];
			$scope.spaceAux.scenePoints = [];
			$scope.spaceAux.sceneLines = [];

			$scope.deformed = {};
			$scope.deformed.points = [];
			$scope.deformed.lines = [];

			$scope.programMode = 'CROSSLINK_INPUT';

			

			$scope.render=render;//Para re renderizar desde otros lugares

			// --- Inicializa escena
			init();
			render();
			
		}
	]);
