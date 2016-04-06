angular.module('IETFEM', [])
.controller(
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
				if(leftMenuService.getSelecting() && $scope.programMode === 'CROSSLINK_INPUT'){// Si esta en modo seleccion
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
				$scope.futureScale = 1;
				$('#processOutputModal').modal('show');
			}

			$scope.startProcessOutput= function(){
					$scope.procesing = true;
					setTimeout($scope.processOutput,0);// encolamos el llamado a la funcion para dar tiempo a la UI a renderizarse
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

							var pointX = parseFloat(point.coords.x) + $scope.futureScale*displacementX
							var pointY = parseFloat(point.coords.y) + $scope.futureScale*displacementY
							var pointZ = parseFloat(point.coords.z) + $scope.futureScale*displacementZ

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
						
					//DeformedService.scaleDeformed($scope.scene, $scope.deformed, $scope.model, $scope.futureScale);
					$scope.scaleStructure = $scope.futureScale;
					$scope.scaleStructureAux = $scope.futureScale;

					$('#processOutputModal').modal('hide');
					$scope.procesing = false;
					$scope.$apply();
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
			
				var intersected=null;
				var firstPointLine = null;
				var idFirstPoint = 0;
				
				LineaSelecService.resetLineaSeleccionada();
				PtoSelecService.resetPuntoSeleccionado();

				$scope.fuerzas={visible:true};
				//maxModule= (Max{DeltaX,DeltaY,DeltaZ}) * 0.2
				$scope.fuerzas.escala={factorEscala:1,maxModule:1,maxX:null,minX:null,maxY:null,minY:null,maxZ:null,minZ:null};

				$scope.supports={visible:true};
				$scope.resortes={visible:true};

				$scope.model.unitForce = 'XX'
				$scope.model.unitLength = 'XX'
				
				var largoNodos=$scope.model.points
				for (var i=0; i<largoNodos; i++){
					$scope.model.points.pop();
				};
				
				var largoBarras=$scope.model.lines.length
				for (var i=0; i<largoBarras; i++){
					$scope.model.lines.pop();
				};
				
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
					$scope.model.unitForce = auxModel.unitForce;
					$scope.model.unitLength = auxModel.unitLength;
					
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
				//$scope.deformed = {};
				
				var largoNodos=$scope.deformed.points
				for (var i=0; i<largoNodos; i++){
					$scope.deformed.points.pop();
				};
				
				var largoBarras=$scope.model.lines
				for (var i=0; i<largoBarras; i++){
					$scope.deformed.lines.pop();
				};
				//$scope.deformed.points = [];
				//$scope.deformed.lines = [];
				
				var intersected=null;
				
				var firstPointLine = null;
				var idFirstPoint = 0;
				
				LineaSelecService.resetLineaSeleccionada();
				PtoSelecService.resetPuntoSeleccionado();
				

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
				
				$scope.spaceAux={helpObjects: {}};
				$scope.spaceAux.helpObjects.grilla= [];

				$scope.spaceAux.scenePoints = [];
				$scope.spaceAux.sceneLines = [];
				
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

angular.module('IETFEM')
.controller('editLineCtrl',['$scope','ModelService','LineaSelecService','DefaultsService',function($scope,ModelService,LineaSelecService,DefaultsService){
		
		$scope.miLinea=LineaSelecService.getLinea();//Es una copia del punto del modelo!
		$scope.misMateriales= $scope.model.materiales;
		$scope.misSecciones= $scope.model.secciones;

		$scope.materialDefecto==0;
		$scope.seccionDefecto==0;

		this.updateDefaults = function(){
			DefaultsService.setLineMaterial($scope.materialDefecto);
			DefaultsService.setLineSection($scope.seccionDefecto);
		};

		this.updatedDefaults = function(){
			if($scope.materialDefecto == DefaultsService.getLineMaterial() &&
				$scope.seccionDefecto == DefaultsService.getLineSection()){
				return true;
			}else{
				return false;
			}
		};

		this.updated= function(){
			var lineaModelo= LineaSelecService.getLineaReal();
			if( typeof lineaModelo != 'undefined' &&
				lineaModelo.material == $scope.miLinea.material &&
				lineaModelo.section == $scope.miLinea.section
			){
				return true;
			}else{
				
				return false;
			}
		};

		
		this.updateLine= function(){
			
			var lineaModelo= LineaSelecService.getLineaReal();
			LineaSelecService.setInfoLineaForm($scope.infoLineaForm);
			if(typeof lineaModelo != 'undefined'){
				lineaModelo.material= $scope.miLinea.material;
				lineaModelo.section= $scope.miLinea.section;
				LineaSelecService.resetForm();
			}
		};	

		this.existsLineToRemove= function(){
			return LineaSelecService.getLinea().id != 0;
		};	

		this.deleteLine = function(){
			var lineToRemove= LineaSelecService.getLinea();
			var sceneObject =$scope.scene.getObjectById(lineToRemove.sceneId);
			
			ModelService.removeLineFromModel(lineToRemove.id,$scope.model);
			ModelService.removeObjFromArray(lineToRemove.sceneId,$scope.spaceAux.sceneLines);
			LineaSelecService.resetLineaSeleccionada();
			$scope.scene.remove(sceneObject);

			$scope.render();
			console.log($scope.scene);
		};

	}]);
	
angular.module('IETFEM')
.controller('editOutputCtrl',['$scope','ModelService', 'DeformedService', function($scope, ModelService, DeformedService){
	
	//$scope.scaleStructureAux=1;

	$scope.$watch('structureView', function() {
	    if ($scope.structureView === 'normal'){
	    	ModelService.setModelOpaque($scope.scene, $scope.model);
	    	DeformedService.setDeformedTransparent($scope.scene, $scope.deformed);
	    	$scope.structureColors = 'normal'
	    } else {
	    	ModelService.setModelTransparent($scope.scene, $scope.model);
	    	DeformedService.setDeformedOpaque($scope.scene, $scope.deformed);
	    }
	    $scope.render();
	});	

	$scope.$watch('scaleStructure', function() {
	    DeformedService.scaleDeformed($scope.scene, $scope.deformed, $scope.model, $scope.scaleStructure);
	    $scope.render();
	});	

	$scope.$watch('structureColors', function() {
		if ($scope.structureColors != 'normal'){
			DeformedService.hideDeformed($scope.scene, $scope.deformed);
		} else {
			DeformedService.setDeformedTransparent($scope.scene, $scope.deformed);
		}
	    ModelService.colorizeModel($scope.scene, $scope.model, $scope.deformed, $scope.structureColors, $scope.structureView != 'normal');
	    $scope.render();
	});

	$scope.toggleScaleStructure = function(isRange){
		//Arreglos para slider con distinta escala!! Utilizo valor auxiliar en el range y ajusto el factor de escala real acorde
		if(!isNaN(parseFloat($scope.scaleStructure))){
			$scope.scaleStructure=parseFloat($scope.scaleStructure);
		}
		if(isRange){
			
				$scope.scaleStructure=$scope.scaleStructureAux;
			
		}else{
				if($scope.scaleStructure > 1000){
					$scope.scaleStructure=1000;
				}
				$scope.scaleStructureAux=$scope.scaleStructure;
		}
	}	


	}]);
	
angular.module('IETFEM')
.controller('editPointCtrl',['$scope','ModelService','PtoSelecService','SpaceService',function($scope,ModelService,PtoSelecService,SpaceService){
		$scope.miPunto=PtoSelecService.getPunto();//Es una copia del punto del modelo!
		$scope.statusFuerzas=$scope.fuerzas;
		$scope.statusSupports=$scope.supports;
		$scope.statusSprings=$scope.resortes;


		this.updated= function(){
			var puntoModelo= PtoSelecService.getPuntoReal();
			if( typeof puntoModelo != 'undefined' &&
				puntoModelo.xCondicion== $scope.miPunto.xCondicion &&
				puntoModelo.yCondicion== $scope.miPunto.yCondicion &&
				puntoModelo.zCondicion== $scope.miPunto.zCondicion &&
				puntoModelo.xForce== $scope.miPunto.xForce &&
				puntoModelo.yForce== $scope.miPunto.yForce &&
				puntoModelo.zForce== $scope.miPunto.zForce &&
				puntoModelo.xSpring== $scope.miPunto.xSpring &&
				puntoModelo.ySpring== $scope.miPunto.ySpring &&
				puntoModelo.zSpring== $scope.miPunto.zSpring
			){
				return true;
			}else{
				
				return false;
			}
		};

		var getMaxForce= function(){//Obtengo la fuerza mas grande para realizar regla de 3 y escalar el resto de las fuerzas
		var maxFuerza=0;
		for(var i = 0; i < $scope.model.points.length ;i++){
			var punto=$scope.model.points[i];
			if(punto.xForce !=0 || punto.yForce !=0 || punto.zForce !=0){
				var xForce = punto.xForce;
				var yForce = punto.yForce;
				var zForce = punto.zForce;
				var largo= Math.sqrt( Math.pow(xForce,2) + Math.pow(yForce,2) + Math.pow(zForce,2))-0.1;
				if(largo > maxFuerza){
					maxFuerza=largo;
				}
			}
		}
		return maxFuerza;
		};
		
		this.updatePoint= function(){
			var puntoModelo= PtoSelecService.getPuntoReal();
			
			PtoSelecService.setInfoPuntoForm($scope.infoPuntoForm);
			if(typeof puntoModelo != 'undefined'){
				puntoModelo.xCondicion= $scope.miPunto.xCondicion;
				puntoModelo.yCondicion= $scope.miPunto.yCondicion;
				puntoModelo.zCondicion= $scope.miPunto.zCondicion;

				puntoModelo.xSpring= parseFloat($scope.miPunto.xSpring);
				puntoModelo.ySpring= parseFloat($scope.miPunto.ySpring);
				puntoModelo.zSpring= parseFloat($scope.miPunto.zSpring);

				//Para los calculos de las flechas
				var auxFlecha={};
				auxFlecha.xForce= parseFloat($scope.miPunto.xForce);
				auxFlecha.yForce= parseFloat($scope.miPunto.yForce);
				auxFlecha.zForce= parseFloat($scope.miPunto.zForce);

				//Seteo fuerzas reales en el modelo
				puntoModelo.xForce= parseFloat($scope.miPunto.xForce);
				puntoModelo.yForce= parseFloat($scope.miPunto.yForce);
				puntoModelo.zForce= parseFloat($scope.miPunto.zForce);

				//Actualizo flecha de fuerzas del nodo
				
				if($scope.statusFuerzas.visible){
					//No actualizo las flechas las apago
					
					/*var largo= Math.sqrt( Math.pow(auxFlecha.xForce,2) + Math.pow(auxFlecha.yForce,2) + Math.pow(auxFlecha.zForce,2))-0.1;
					
					var direccion = new THREE.Vector3( auxFlecha.xForce/ (largo+0.1), auxFlecha.yForce/ (largo+0.1), auxFlecha.zForce/(largo+0.1) );

					var fuerzaMaxima= getMaxForce();
					largo= (largo * $scope.fuerzas.escala.maxModule) / fuerzaMaxima;
					largo= largo / $scope.fuerzas.escala.factorEscala;

					var aux= ($scope.fuerzas.escala.maxModule) / (fuerzaMaxima * $scope.fuerzas.escala.factorEscala);

					var origen= new THREE.Vector3( puntoModelo.coords.x-(auxFlecha.xForce * aux), puntoModelo.coords.y-(auxFlecha.yForce * aux), puntoModelo.coords.z-(auxFlecha.zForce * aux) );

					var newArrow=new THREE.ArrowHelper(direccion, origen, largo, 0x0B3B17);
					if(puntoModelo.forceArrowId != 0){// Si ya tenia la flecha generada la borro para crear la nueva
						SpaceService.removeObjectById(puntoModelo.forceArrowId,$scope.scene);
					}
					puntoModelo.forceArrowId= newArrow.id;
					$scope.scene.add(newArrow);*/
					$( "#toggle-forces" ).trigger( "click" );
					$( "#toggle-forces" ).trigger( "click" );
				}
				//-----------------------------------------------------
				//Actualizo piramides de apoyos
				if($scope.statusSupports.visible){
					if(parseFloat(puntoModelo.xCondicion) == 0){
						if(puntoModelo.supportXId != 0){// Si ya tenia una la elimino
							SpaceService.removeObjectById(puntoModelo.supportXId,$scope.scene);
						}
						idSupport=SpaceService.drawPyramidSupport(puntoModelo.coords.x, puntoModelo.coords.y, puntoModelo.coords.z,true,false,false,$scope.scene);
						puntoModelo.supportXId=idSupport;
					}else{
						SpaceService.removeObjectById(puntoModelo.supportXId,$scope.scene);
					}
					if(parseFloat(puntoModelo.yCondicion) == 0){
						if(puntoModelo.supportYId != 0){// Si ya tenia una la elimino
							SpaceService.removeObjectById(puntoModelo.supportYId,$scope.scene);
						}
						idSupport=SpaceService.drawPyramidSupport(puntoModelo.coords.x, puntoModelo.coords.y, puntoModelo.coords.z,false,true,false,$scope.scene);
						puntoModelo.supportYId=idSupport;
					}else{
						SpaceService.removeObjectById(puntoModelo.supportYId,$scope.scene);
					}
					if(parseFloat(puntoModelo.zCondicion) == 0){
						if(puntoModelo.supportZId != 0){// Si ya tenia una la elimino
							SpaceService.removeObjectById(puntoModelo.supportZId,$scope.scene);
						}
						idSupport=SpaceService.drawPyramidSupport(puntoModelo.coords.x, puntoModelo.coords.y, puntoModelo.coords.z,false,false,true,$scope.scene);
						puntoModelo.supportZId=idSupport;
					}else{
						SpaceService.removeObjectById(puntoModelo.supportZId,$scope.scene);
					}
				}

				//Actualizo piramides de resortes
				if($scope.statusSprings.visible){
					if(parseFloat(puntoModelo.xSpring) != 0){
						if(puntoModelo.springXId != 0){// Si ya tenia una la elimino
							SpaceService.removeObjectById(puntoModelo.springXId,$scope.scene);
						}
						if(parseFloat(puntoModelo.xCondicion) != 0){//Si no hay un apoyo, dado que el apoyo tiene preferencia
							idSpring=SpaceService.drawPyramidSupport(puntoModelo.coords.x, puntoModelo.coords.y, puntoModelo.coords.z,true,false,false,$scope.scene,true);
							puntoModelo.springXId=idSpring;
						}else{
							puntoModelo.springXId=0;
						}
					}else{
						SpaceService.removeObjectById(puntoModelo.springXId,$scope.scene);
					}
					if(parseFloat(puntoModelo.ySpring) != 0){
						if(puntoModelo.springYId != 0){// Si ya tenia una la elimino
							SpaceService.removeObjectById(puntoModelo.springYId,$scope.scene);
						}
						if(parseFloat(puntoModelo.yCondicion) != 0){//Si no hay un apoyo, dado que el apoyo tiene preferencia
							idSpring=SpaceService.drawPyramidSupport(puntoModelo.coords.x, puntoModelo.coords.y, puntoModelo.coords.z,false,true,false,$scope.scene,true);
							puntoModelo.springYId=idSpring;
						}else{
							puntoModelo.springYId=0;
						}
					}else{
						SpaceService.removeObjectById(puntoModelo.springYId,$scope.scene);
					}
					if(parseFloat(puntoModelo.zSpring) != 0){
						if(puntoModelo.springZId != 0){// Si ya tenia una la elimino
							SpaceService.removeObjectById(puntoModelo.springZId,$scope.scene);
						}
						if(parseFloat(puntoModelo.zCondicion) != 0){//Si no hay un apoyo, dado que el apoyo tiene preferencia
							idSpring=SpaceService.drawPyramidSupport(puntoModelo.coords.x, puntoModelo.coords.y, puntoModelo.coords.z,false,false,true,$scope.scene,true);
							puntoModelo.springZId=idSpring;
						}else{
							puntoModelo.springZId=0;
						}
					}else{
						SpaceService.removeObjectById(puntoModelo.springZId,$scope.scene);
					}
				}



				//-------------------------------------------------------------------------------------------------
				PtoSelecService.resetForm();
				
				$scope.render();
			}
		};		

		this.existsPointToRemove= function(){
			return PtoSelecService.getPunto().id != 0;
		};

		this.deleteNode = function(){
			var nodeToRemove= PtoSelecService.getPuntoReal();
			var coordX= nodeToRemove.coords.x;
			var coordY= nodeToRemove.coords.y;
			var coordZ= nodeToRemove.coords.z;

			var sceneObjectFirst = $scope.scene.getObjectById(nodeToRemove.sceneId);

			var lineasImplicadas= getLinesByNode(nodeToRemove.id);
			for (var i = 0; i < lineasImplicadas.length ;i++){//Elimino tambien lineas que tenian ese nodo
				var lineToRemove= lineasImplicadas[i];
				var sceneObject =$scope.scene.getObjectById(lineToRemove.sceneId);
				
				ModelService.removeLineFromModel(lineToRemove.id,$scope.model);
				ModelService.removeObjFromArray(lineToRemove.sceneId,$scope.spaceAux.sceneLines);
				$scope.scene.remove(sceneObject);
			}

			PtoSelecService.resetPuntoSeleccionado();
			ModelService.removePointFromModel(nodeToRemove.id,$scope.model);
			ModelService.removeObjFromArray(nodeToRemove.sceneId,$scope.spaceAux.scenePoints);
			if(nodeToRemove.forceArrowId != 0){
				SpaceService.removeObjectById(nodeToRemove.forceArrowId,$scope.scene);
			}
			$scope.scene.remove(sceneObjectFirst);

			$scope.setScaleValues(coordX,coordY,coordZ,true);
			if($scope.statusFuerzas.visible){
				$( "#toggle-forces" ).trigger( "click" );
				$( "#toggle-forces" ).trigger( "click" );
			}
			$scope.render();

		};

		function getLinesByNode(nodeId){
			var allLines=[];
			for (var i = 0; i < $scope.model.lines.length ;i++){
				if($scope.model.lines[i].start == nodeId || $scope.model.lines[i].end == nodeId){
					allLines.push($scope.model.lines[i]);	
				}
			}
			return allLines;
		};

	}]);
	
angular.module('IETFEM')
.controller('leftMenusCtrl',['$scope','leftMenuService','PtoSelecService',function($scope,leftMenuService,PtoSelecService){
		
		$scope.dibujarNodos = function(){
			leftMenuService.setAddingLines(false);
			leftMenuService.setAddingNodes(true);
			leftMenuService.setAddingGrillas(false);
			leftMenuService.setSelecting(false);
			leftMenuService.setViewOptions(false);
		};

		$scope.dibujarLineas = function(){
			leftMenuService.setAddingLines(true);
			leftMenuService.setAddingNodes(false);
			leftMenuService.setAddingGrillas(false);
			leftMenuService.setSelecting(false);
			leftMenuService.setViewOptions(false);
		};

		$scope.dibujarGrillas = function(){
			leftMenuService.setAddingLines(false);
			leftMenuService.setAddingNodes(false);
			leftMenuService.setAddingGrillas(true);
			leftMenuService.setSelecting(false);
			leftMenuService.setViewOptions(false);
		};

		$scope.seleccionar = function(){
			leftMenuService.setAddingLines(false);
			leftMenuService.setAddingNodes(false);
			leftMenuService.setAddingGrillas(false);
			leftMenuService.setSelecting(true);
			leftMenuService.setViewOptions(false);
		};

		$scope.viewOptions = function(){
			leftMenuService.setAddingLines(false);
			leftMenuService.setAddingNodes(false);
			leftMenuService.setAddingGrillas(false);
			leftMenuService.setSelecting(false);
			leftMenuService.setViewOptions(true);
		};

		$scope.seleccionando = function(){
			return leftMenuService.getSelecting();
		};

		$scope.dibujandoGrillas = function(){
			return leftMenuService.getAddingGrillas();
		};

		$scope.dibujandoNodos = function(){
			return leftMenuService.getAddingNodes();
		};

		$scope.dibujandoLineas = function(){
			return leftMenuService.getAddingLines();
		};

		$scope.viewingOptions = function(){
			return leftMenuService.getViewOptions();
		};


	}]);
	
angular.module('IETFEM')
.controller('MaterialesCtrl',['$scope','ModelService',function($scope,ModelService){
		$scope.materiales = $scope.model.materiales;
		
		$scope.nuevoMaterial={};
		$scope.aEditarMaterialIndex=null;
		$scope.editando=false;

		$scope.nameToRemove="";
		$scope.selectedIndex=null;

		$scope.existeMaterial = function(){
			if($scope.materiales.length > 0){
				for(var i = 0; i < $scope.materiales.length ;i++){
					if($scope.materiales[i].name == $scope.nuevoMaterial.name){
						return true;
					}
				}
			}
			return false;
		};

		$scope.addMaterial= function(){
			if(!$scope.existeMaterial()){
				ModelService.addMaterial($scope.nuevoMaterial.name,$scope.nuevoMaterial.youngModule,$scope.nuevoMaterial.gamma,$scope.nuevoMaterial.alpha,$scope.nuevoMaterial.nu,$scope.model);
				$scope.nuevoMaterial={
					id: 0,
					name:"Nuevo Material",
					youngModule:0,
					gamma:0,
					alpha:0,
					nu:0
				};
				$scope.materialForm.$setPristine();
			}
		};

		var getIndex= function(){
			for(var i = 0; i < $scope.materiales.length ;i++){
				if($scope.materiales[i].name === $scope.nameToRemove){
					return i;
				}
			}
			return -1;
		};

		$scope.removeMaterial= function(){
			if($scope.selectedIndex != null){	
				$scope.materiales.splice(getIndex($scope.nameToRemove),1);
			}
		};

		$scope.setMaterialToRemove= function(m,indexOfTable){
			if($scope.selectedIndex != indexOfTable){// Si seleccione otra entrada
				$scope.nameToRemove=m.name;
				$scope.selectedIndex= indexOfTable;

				$scope.aEditarMaterialIndex=null;
				$scope.editando=false;
			}else{// Si seleccione el q ya estaba seleccionado
				$scope.nameToRemove=null;
				$scope.selectedIndex= null;
				
				$scope.aEditarMaterialIndex=null;
				$scope.editando=false;
			}
		};

		$scope.getSelectedIndex= function(){
			return $scope.selectedIndex;
		};

		$scope.editMaterial= function(){
			if($scope.aEditarMaterialIndex == null){
				//Seteamos el formulario con el material a editar.
				$scope.aEditarMaterialIndex= $scope.selectedIndex;
				$scope.editando=true;

				$scope.nuevoMaterial.id= $scope.materiales[$scope.selectedIndex].id;
				
				$scope.nuevoMaterial.name= $scope.materiales[$scope.selectedIndex].name;
				
				$scope.nuevoMaterial.youngModule= $scope.materiales[$scope.selectedIndex].youngModule;

				$scope.nuevoMaterial.gamma= $scope.materiales[$scope.selectedIndex].gamma;

				$scope.nuevoMaterial.alpha= $scope.materiales[$scope.selectedIndex].alpha;

				$scope.nuevoMaterial.nu= $scope.materiales[$scope.selectedIndex].nu;
				
			}else{
				$scope.materiales[$scope.aEditarMaterialIndex].id= $scope.nuevoMaterial.id;
				$scope.materiales[$scope.aEditarMaterialIndex].name= $scope.nuevoMaterial.name;
				$scope.materiales[$scope.aEditarMaterialIndex].youngModule= $scope.nuevoMaterial.youngModule;
				$scope.materiales[$scope.aEditarMaterialIndex].gamma= $scope.nuevoMaterial.gamma;
				$scope.materiales[$scope.aEditarMaterialIndex].alpha= $scope.nuevoMaterial.alpha;
				$scope.materiales[$scope.aEditarMaterialIndex].nu = $scope.nuevoMaterial.nu;

				//deja el modo edicion y deselecciona el index seleccionado
				$scope.aEditarMaterialIndex= null;
				$scope.editando=false;
				$scope.selectedIndex=null;
				//limpio el formulario
				$scope.nuevoMaterial={
					id: 0,
					name:"Nuevo Material",
					youngModule:0,
					gamma:0,
					alpha:0,
					nu:0
				};
			}
		};

		$scope.isEditing= function(){
			return $scope.editando;
		};

	}]);
	
angular.module('IETFEM')
.controller('SeccionesCtrl',['$scope','ModelService',function($scope,ModelService){
		$scope.secciones = $scope.model.secciones;
		$scope.nuevaSeccion={};
		$scope.aEditarSeccionIndex=null;
		$scope.editando=false;

		$scope.sectionToRemove=0;
		$scope.selectedIndex=null;

		$scope.existeSeccion = function(){
			if($scope.secciones.length > 0){
				for(var i = 0; i < $scope.secciones.length ;i++){
					if($scope.secciones[i].name == $scope.nuevaSeccion.name){
						return true;
					}
				}
			}
			return false;
		};

		$scope.addSection= function(){
			if(!$scope.existeSeccion()){
				ModelService.addSection($scope.nuevaSeccion.name,$scope.nuevaSeccion.section,$scope.model);
				$scope.nuevaSeccion={
					id: 0,
					section:0,
					name:"Nueva Seccion"
				};
				$scope.seccionForm.$setPristine();
			}
		};

		var getIndex= function(){
			for(var i = 0; i < $scope.secciones.length ;i++){
				if($scope.secciones[i].section === $scope.sectionToRemove){
					return i;
				}
			}
			return -1;
		};

		$scope.removeSection= function(){
			if($scope.selectedIndex != null){	
				$scope.secciones.splice(getIndex($scope.sectionToRemove),1);
			}
		};

		$scope.setSectionToRemove= function(m,indexOfTable){
			if($scope.selectedIndex != indexOfTable){// Si seleccione otra entrada
				$scope.sectionToRemove=m.section;
				$scope.selectedIndex= indexOfTable;

				$scope.aEditarSeccionIndex=null;
				$scope.editando=false;
			}else{// Si seleccione el q ya estaba seleccionado
				$scope.sectionToRemove=null;
				$scope.selectedIndex= null;

				$scope.aEditarSeccionIndex=null;
				$scope.editando=false;
			}
		};

		$scope.getSelectedIndex= function(){
			return $scope.selectedIndex;
		};

		$scope.editSeccion= function(){
			if($scope.aEditarSeccionIndex == null){
				//Seteamos el formulario con el material a editar.
				$scope.aEditarSeccionIndex= $scope.selectedIndex;
				$scope.editando=true;

				$scope.nuevaSeccion.section= $scope.secciones[$scope.selectedIndex].section;
				
				$scope.nuevaSeccion.name= $scope.secciones[$scope.selectedIndex].name;
				
			}else{
				$scope.secciones[$scope.aEditarSeccionIndex].section= $scope.nuevaSeccion.section;
				$scope.secciones[$scope.aEditarSeccionIndex].name= $scope.nuevaSeccion.name;
			

				//deja el modo edicion y deselecciona el index seleccionado
				$scope.aEditarSeccionIndex= null;
				$scope.editando=false;
				$scope.selectedIndex=null;
				//limpio el formulario
				$scope.nuevaSeccion={
					section:0,
					name:"Nueva Seccion"
				};
			}
		};

		$scope.isEditing= function(){
			return $scope.editando;
		};

	}]);
	
angular.module('IETFEM')
.controller('viewOptionsInputCntrl',['$scope','ModelService','SpaceService',function($scope,ModelService,SpaceService){

	$scope.gridInfos= $scope.model.helpObjects.grillas; // gridInfos de las grillas del espacio
	$scope.statusFuerzas=$scope.fuerzas;
	$scope.auxFactor=100;
	$scope.statusSupports=$scope.supports;
	$scope.statusSprings=$scope.resortes;

	$scope.toggleGrid= function(gridInfo){
		for(var i = 0; i < $scope.gridInfos.length ;i++){
			if($scope.gridInfos[i].gridId == gridInfo.gridId){
				for(var j = 0; j < $scope.gridInfos[i].objects.length ;j++){
					SpaceService.hideShowObject($scope.gridInfos[i].objects[j].sceneId,gridInfo.viewStatus,$scope.scene);
				}
			}
		}
		$scope.render();
	};

	var getMaxForce= function(){//Obtengo la fuerza mas grande para realizar regla de 3 y escalar el resto de las fuerzas
		var maxFuerza=0;
		for(var i = 0; i < $scope.model.points.length ;i++){
			var punto=$scope.model.points[i];
			if(punto.xForce !=0 || punto.yForce !=0 || punto.zForce !=0){
				var xForce = punto.xForce;
				var yForce = punto.yForce;
				var zForce = punto.zForce;
				var largo= Math.sqrt( Math.pow(xForce,2) + Math.pow(yForce,2) + Math.pow(zForce,2));
				if(largo > maxFuerza){
					maxFuerza=largo;
				}
			}
		}
		return maxFuerza;
	};

	$scope.toggleForces = function(isRange){
		//Arreglos para slider con distinta escala!! Utilizo valor auxiliar en el range y ajusto el factor de escala real acorde
		if(!isNaN(parseFloat($scope.statusFuerzas.escala.factorEscala))){
			$scope.statusFuerzas.escala.factorEscala=parseFloat($scope.statusFuerzas.escala.factorEscala);
		}
		if(isRange){
			if($scope.auxFactor >= 0 && $scope.auxFactor <=10){
				$scope.statusFuerzas.escala.factorEscala=0.10;
			}else if($scope.auxFactor > 10  && $scope.auxFactor <=20){
				$scope.statusFuerzas.escala.factorEscala=0.20;
			}else if($scope.auxFactor > 20  && $scope.auxFactor <=30){
				$scope.statusFuerzas.escala.factorEscala=0.30;
			}else if($scope.auxFactor > 30  && $scope.auxFactor <=40){
				$scope.statusFuerzas.escala.factorEscala=0.40;
			}else if($scope.auxFactor > 40  && $scope.auxFactor <=50){
				$scope.statusFuerzas.escala.factorEscala=0.50;
			}else if($scope.auxFactor > 50  && $scope.auxFactor <=60){
				$scope.statusFuerzas.escala.factorEscala=0.60;
			}else if($scope.auxFactor > 60  && $scope.auxFactor <=70){
				$scope.statusFuerzas.escala.factorEscala=0.70;
			}else if($scope.auxFactor > 70  && $scope.auxFactor <=80){
				$scope.statusFuerzas.escala.factorEscala=0.80;
			}else if($scope.auxFactor > 80  && $scope.auxFactor <=90){
				$scope.statusFuerzas.escala.factorEscala=0.90;
			}else if($scope.auxFactor > 90  && $scope.auxFactor <=100){
				$scope.statusFuerzas.escala.factorEscala=1;
			}else{
				$scope.statusFuerzas.escala.factorEscala=$scope.auxFactor-100;
			}
		}else{
			if($scope.statusFuerzas.escala.factorEscala >= 0 && $scope.statusFuerzas.escala.factorEscala <= 0.10){
				$scope.auxFactor=0;
			}else if($scope.statusFuerzas.escala.factorEscala >= 0.10 && $scope.statusFuerzas.escala.factorEscala <= 0.20){
				$scope.auxFactor=10;
			}else if($scope.statusFuerzas.escala.factorEscala >= 0.20 && $scope.statusFuerzas.escala.factorEscala <= 0.30){
				$scope.auxFactor=20;
			}else if($scope.statusFuerzas.escala.factorEscala >= 0.30 && $scope.statusFuerzas.escala.factorEscala <= 0.40){
				$scope.auxFactor=30;
			}else if($scope.statusFuerzas.escala.factorEscala >= 0.40 && $scope.statusFuerzas.escala.factorEscala <= 0.50){
				$scope.auxFactor=40;
			}else if($scope.statusFuerzas.escala.factorEscala >= 0.50 && $scope.statusFuerzas.escala.factorEscala <= 0.60){
				$scope.auxFactor=50;
			}else if($scope.statusFuerzas.escala.factorEscala >= 0.60 && $scope.statusFuerzas.escala.factorEscala <= 0.70){
				$scope.auxFactor=60;
			}else if($scope.statusFuerzas.escala.factorEscala >= 0.70 && $scope.statusFuerzas.escala.factorEscala <= 0.80){
				$scope.auxFactor=70;
			}else if($scope.statusFuerzas.escala.factorEscala >= 0.80 && $scope.statusFuerzas.escala.factorEscala <= 0.90){
				$scope.auxFactor=80;
			}else if($scope.statusFuerzas.escala.factorEscala >= 0.90 && $scope.statusFuerzas.escala.factorEscala <= 1){
				$scope.auxFactor=100;
			}
			else{
				if($scope.statusFuerzas.escala.factorEscala > 100){
					$scope.statusFuerzas.escala.factorEscala=100;
				}
				$scope.auxFactor=$scope.statusFuerzas.escala.factorEscala+100;
			}
		}
		if($scope.statusFuerzas.visible){// Genera las flechas de todos los puntos, si ya tenia la regenera

				//Calculo el maxModule de la fuerza
				if($scope.fuerzas.escala.maxX != null){//Verifico q haya algun punto ingresado si no fallaria
					var deltaX= Math.sqrt(Math.pow($scope.fuerzas.escala.maxX-$scope.fuerzas.escala.minX,2));
					var deltaY= Math.sqrt(Math.pow($scope.fuerzas.escala.maxY-$scope.fuerzas.escala.minY,2));
					var deltaZ= Math.sqrt(Math.pow($scope.fuerzas.escala.maxZ-$scope.fuerzas.escala.minZ,2));

					var maxDelta= Math.max(deltaX,deltaY,deltaZ);

					$scope.fuerzas.escala.maxModule= maxDelta * 0.2;
					if($scope.fuerzas.escala.maxModule < 1){
						$scope.fuerzas.escala.maxModule = 1;
					}
				}

			for(var i = 0; i < $scope.model.points.length ;i++){
				var punto=$scope.model.points[i];
				if(punto.xForce !=0 || punto.yForce !=0 || punto.zForce !=0){

					var xForce = punto.xForce;
					var yForce = punto.yForce;
					var zForce = punto.zForce;

					
					var largo= Math.sqrt( Math.pow(xForce,2) + Math.pow(yForce,2) + Math.pow(zForce,2))-0.1;

					var direccion = new THREE.Vector3(xForce/ (largo+0.1), yForce/(largo+0.1), zForce/(largo+0.1) );

					largo=largo+0.1;
					var fuerzaMaxima= getMaxForce();
					largo= (largo * $scope.fuerzas.escala.maxModule) / fuerzaMaxima;
					largo= largo * $scope.fuerzas.escala.factorEscala;

					var aux= ($scope.fuerzas.escala.maxModule * $scope.fuerzas.escala.factorEscala) / (fuerzaMaxima);
					var origen= new THREE.Vector3( punto.coords.x-(xForce * aux), punto.coords.y-(yForce * aux), punto.coords.z-(zForce * aux) );
				
					
					var newArrow=new THREE.ArrowHelper(direccion, origen, largo, 0x0B3B17);
					if(punto.forceArrowId != 0){// Si ya tenia la flecha generada la borro para crear la nueva
						SpaceService.removeObjectById(punto.forceArrowId,$scope.scene);
					}
					punto.forceArrowId= newArrow.id;
					$scope.scene.add(newArrow);
				}
			}
			
			$scope.render();
		}else{
			for(var i = 0; i < $scope.model.points.length ;i++){//Esconde todas las flechas
				var punto=$scope.model.points[i];
				if(punto.forceArrowId!=0){
					SpaceService.hideShowObject(punto.forceArrowId,false,$scope.scene);
				}
			}
			
			$scope.render();
		}

	};
	
	$scope.toggleSupports = function(){
		//para sincronizar el input range y el number
		if($scope.statusSupports.visible){
			for(var i = 0; i < $scope.model.points.length ;i++){
				var punto=$scope.model.points[i];
				var idSupport=0;
				if(parseFloat(punto.xCondicion) == 0){
					if(punto.supportXId != 0){// Si ya tenia una la elimino
						SpaceService.removeObjectById(punto.supportXId,$scope.scene);
					}
					idSupport=SpaceService.drawPyramidSupport(punto.coords.x, punto.coords.y, punto.coords.z,true,false,false,$scope.scene);
					punto.supportXId=idSupport;
				}
				if(parseFloat(punto.yCondicion) == 0){
					if(punto.supportYId != 0){// Si ya tenia una la elimino
						SpaceService.removeObjectById(punto.supportYId,$scope.scene);
					}
					idSupport=SpaceService.drawPyramidSupport(punto.coords.x, punto.coords.y, punto.coords.z,false,true,false,$scope.scene);
					punto.supportYId=idSupport;
				}
				if(parseFloat(punto.zCondicion) == 0){
					if(punto.supportZId != 0){// Si ya tenia una la elimino
						SpaceService.removeObjectById(punto.supportZId,$scope.scene);
					}
					idSupport=SpaceService.drawPyramidSupport(punto.coords.x, punto.coords.y, punto.coords.z,false,false,true,$scope.scene);
					punto.supportZId=idSupport;
				}
			
			}
			
			$scope.render();
		}else{//Si ya estaban visible las escondo
			for(var i = 0; i < $scope.model.points.length ;i++){//Esconde todas las flechas
				var punto=$scope.model.points[i];
				if(punto.supportXId != 0){
					SpaceService.hideShowObject(punto.supportXId,false,$scope.scene);
				}
				if(punto.supportYId != 0){
					SpaceService.hideShowObject(punto.supportYId,false,$scope.scene);
				}
				if(punto.supportZId != 0){
					SpaceService.hideShowObject(punto.supportZId,false,$scope.scene);
				}
			}
			
			$scope.render();
		}
	};

	$scope.toggleSprings = function (){
		if($scope.statusSprings.visible){
			for(var i = 0; i < $scope.model.points.length ;i++){
				var punto=$scope.model.points[i];
				var idSpring=0;
				if(parseFloat(punto.xSpring) != 0 && parseFloat(punto.xCondicion) !=0){
					if(punto.springXId != 0){// Si ya tenia no hago nada
						SpaceService.removeObjectById(punto.springXId,$scope.scene);
					}
					idSpring=SpaceService.drawPyramidSupport(punto.coords.x, punto.coords.y, punto.coords.z,true,false,false,$scope.scene,true);
					punto.springXId=idSpring;
					
				}
				if(parseFloat(punto.ySpring) != 0 && parseFloat(punto.yCondicion) !=0){
					if(punto.springYId != 0){// Si ya tenia una la elimino
						SpaceService.removeObjectById(punto.springYId,$scope.scene);
					}
					IdSpring=SpaceService.drawPyramidSupport(punto.coords.x, punto.coords.y, punto.coords.z,false,true,false,$scope.scene,true);
					punto.springYId=IdSpring;
				}
				if(parseFloat(punto.zSpring) != 0 && parseFloat(punto.zCondicion) !=0){
					if(punto.springZId != 0){// Si ya tenia una la elimino
						SpaceService.removeObjectById(punto.springZId,$scope.scene);
					}
					IdSpring=SpaceService.drawPyramidSupport(punto.coords.x, punto.coords.y, punto.coords.z,false,false,true,$scope.scene,true);
					punto.springZId=IdSpring;
				}
			}

			}else{
				for(var i = 0; i < $scope.model.points.length ;i++){//Escondo los resortes
					var punto=$scope.model.points[i];
					if(punto.springXId != 0){
						SpaceService.hideShowObject(punto.springXId,false,$scope.scene);
					}
					if(punto.springYId != 0){
						SpaceService.hideShowObject(punto.springYId,false,$scope.scene);
					}
					if(punto.springZId != 0){
						SpaceService.hideShowObject(punto.springZId,false,$scope.scene);
					}
				}
			}

	};

	$(function() {
	    $('#toggle-event').change(function() {
	      $scope.toggleForces();
	    });
	    $(".toggle-event2").change(function() {
	      $scope.toggleSupports();
	    });
	    $(".toggle-event3").change(function() {
	      $scope.toggleSprings();
	    });

	  });
	
	$scope.toggleForces();
	$scope.toggleSupports();
	$scope.toggleSprings();

}]);

angular.module('IETFEM')
.factory('DefaultsService',[function() {

	var LineaMaterial=null;
	var LineaSection=null;

	//Geometrias
	var esferaEstandar= new THREE.SphereGeometry(  0.1, 4, 4  );
	var esferaGrande = new THREE.SphereGeometry( 0.15, 4, 4 );
	

	//Materiales
	var materialGrilla=new THREE.MeshBasicMaterial( {color: 0xFF0000, transparent: true, opacity: 0.15} );
	var materialNegro= new THREE.MeshBasicMaterial( {color: 0x000000} );
	var materialResaltado = new THREE.MeshBasicMaterial( {color: 0x0084ca} );
	var materialSeleccion = new THREE.MeshBasicMaterial( {color: 0x088A08} );
	var materialCreacionLinea = new THREE.MeshBasicMaterial( {color: 0x8B0000} );

	var getMaterialGrilla = function(){
		return materialGrilla;
	};

	var getMaterialNegro = function(){
		return materialNegro;
	};

	var getMaterialResaltado = function(){
		return materialResaltado;
	};

	var getMaterialSeleccion = function(){
		return materialSeleccion;
	};

	var getMaterialCreacionLinea = function(){
		return materialCreacionLinea;
	};

	var getEsferaEstandar = function(){
		return esferaEstandar;
	};

	var getEsferaGrande = function(){
		return esferaGrande;
	};

	//-------------------------------------------------------------------------

	var getLineMaterial = function(){
		return LineaMaterial;
	};

	var getLineSection = function(){
		return LineaSection;
	};

	var setLineMaterial = function(m){
		LineaMaterial=m;
	};

	var setLineSection = function(s){
		LineaSection=s;
	};

	return {
		getLineMaterial: getLineMaterial,
		getLineSection: getLineSection,
		setLineMaterial: setLineMaterial,
		setLineSection: setLineSection,
		getEsferaEstandar: getEsferaEstandar,
		getEsferaGrande: getEsferaGrande,
		getMaterialGrilla: getMaterialGrilla,
		getMaterialNegro: getMaterialNegro,
		getMaterialResaltado: getMaterialResaltado,
		getMaterialSeleccion: getMaterialSeleccion,
		getMaterialCreacionLinea: getMaterialCreacionLinea
	}

	}]);
	
	angular.module('IETFEM')
.factory('DeformedService', ['SpaceService', function(SpaceService) {
	
	//Obtener punto del deformado por id de escena
	var getDeformedPointById = function(id, deformed) {
			for (var i = 0; i < deformed.points.length ;i++){
				if (deformed.points[i].id==id){
					return deformed.points[i];
				}
			};
	};

	//Obtener linea del deformado por id de escena
	var getDeformedLineBySceneId = function(id, deformed) {
			for (var i = 0; i < deformed.lines.length ;i++){
				if (deformed.lines[i].id==id){
					return deformed.lines[i];
				}
			};
	};

	var getDeformedPointBySceneId = function(id, deformed) {
			for (var i = 0; i < deformed.points.length ;i++){
				if (deformed.points[i].sceneId==id){
					return deformed.points[i];
				}
			};
	};

	//Obtener linea del deformado por id de escena
	var getDeformedLineById = function(id, deformed) {
			for (var i = 0; i < deformed.lines.length ;i++){
				if (deformed.lines[i].sceneId==id){
					return deformed.lines[i];
				}
			};
	};
	
	//Agrega un punto al deformado
	var addPointToDeformed = function(pX,pY,pZ,uX,uY,uZ, id, sceneId, deformed) {
			
		var point = {};
		point.id = id;
		point.sceneId = sceneId;

		point.coords = {
			x: pX,
			y: pY,
			z: pZ
		};
		point.displacements = {
			x: uX,
			y: uY,
			z: uZ
		};
		deformed.points.push(point);
	};
	
	//Agrega una línea al deformado
	var addLineToDeformed = function(p1, p2, id, lineSceneId, deformation, force, tension, model) {		
		var line = {};
		line.id = id
		line.sceneId= lineSceneId;
		line.start = p1;
		line.end = p2;
		line.deformation= deformation;
		line.force= force;
		line.tension= tension;
		
		model.lines.push(line);
	};

	var setDeformedMaterial = function(scene, deformed, material){
		if (deformed.points.length > 0){
			for (var i = 0; i < deformed.points.length ;i++){
				SpaceService.setMaterial(deformed.points[i].sceneId, scene, material);
			};
			for (var i = 0; i < deformed.lines.length ;i++){
				SpaceService.setMaterial(deformed.lines[i].sceneId, scene, material);
			};
		};
	};

	var setDeformedOpaque = function(scene, deformed){
		if (deformed.points.length > 0){
			var material = SpaceService.getMaterial(deformed.points[0].sceneId, scene);
			material = new THREE.MeshBasicMaterial( {color: material.color} );
			for (var i = 0; i < deformed.points.length ;i++){
				SpaceService.setMaterial(deformed.points[i].sceneId, scene, material);
			};
			for (var i = 0; i < deformed.lines.length ;i++){
				SpaceService.setMaterial(deformed.lines[i].sceneId, scene, material);
			};
		};
	};

	var setDeformedTransparent = function(scene, deformed){
		var material = new THREE.MeshBasicMaterial( {color: 0x29088A, transparent: true, opacity: 0.15} );
		for (var i = 0; i < deformed.points.length ;i++){
			SpaceService.setMaterial(deformed.points[i].sceneId, scene, material);
		};
		for (var i = 0; i < deformed.lines.length ;i++){
			SpaceService.setMaterial(deformed.lines[i].sceneId, scene, material);
		};
	};

	var hideDeformed = function(scene, deformed){
		material = new THREE.MeshBasicMaterial( {color: 0x29088A, transparent: true, opacity: 0} );
		for (var i = 0; i < deformed.points.length ;i++){
			SpaceService.setMaterial(deformed.points[i].sceneId, scene, material);
		};
		for (var i = 0; i < deformed.lines.length ;i++){
			SpaceService.setMaterial(deformed.lines[i].sceneId, scene, material);
		};
	};

	var scaleDeformed = function(scene, deformed, model, scaleFactor){
		//var material = SpaceService.getMaterial(deformed.points[0].sceneId, scene, scaleFactor) || null;
		var material = new THREE.MeshBasicMaterial( {color: 0x000000} );
		for (var i = 0; i < deformed.points.length ;i++){

			var x = parseFloat(deformed.points[i].coords.x) + parseFloat(deformed.points[i].displacements.x)*parseFloat(scaleFactor);
			var y = parseFloat(deformed.points[i].coords.y) + parseFloat(deformed.points[i].displacements.y)*parseFloat(scaleFactor);
			var z = parseFloat(deformed.points[i].coords.z) + parseFloat(deformed.points[i].displacements.z)*parseFloat(scaleFactor);

			SpaceService.movePoint(deformed.points[i].sceneId, scene, x, y, z);
		};
		for (var i = 0; i < deformed.lines.length ;i++){

			var start = getDeformedPointById(deformed.lines[i].start, deformed);
			var end = getDeformedPointById(deformed.lines[i].end, deformed);
			var x1 = parseFloat(start.coords.x) + parseFloat(start.displacements.x)*parseFloat(scaleFactor);
			var y1 = parseFloat(start.coords.y) + parseFloat(start.displacements.y)*parseFloat(scaleFactor);
			var z1 = parseFloat(start.coords.z) + parseFloat(start.displacements.z)*parseFloat(scaleFactor);
			var x2 = parseFloat(end.coords.x) + parseFloat(end.displacements.x)*parseFloat(scaleFactor);
			var y2 = parseFloat(end.coords.y) + parseFloat(end.displacements.y)*parseFloat(scaleFactor);
			var z2 = parseFloat(end.coords.z) + parseFloat(end.displacements.z)*parseFloat(scaleFactor);

			deformed.lines[i].sceneId = SpaceService.moveLine(deformed.lines[i].sceneId, scene, x1, y1, z1, x2, y2, z2);
		};
	};
	
	return {
		getDeformedPointById: getDeformedPointById,
		getDeformedLineById: getDeformedLineById,
		addPointToDeformed: addPointToDeformed,
		addLineToDeformed: addLineToDeformed,
		setDeformedMaterial: setDeformedMaterial,
		setDeformedTransparent: setDeformedTransparent,
		setDeformedOpaque: setDeformedOpaque,
		hideDeformed: hideDeformed,
		scaleDeformed: scaleDeformed,
	};
}])

angular.module('IETFEM')
.factory('leftMenuService', [function() {
		var addingLines = false;
		var addingNodes=false;
		var addingGrillas=false;
		var viewOptions=false;
		var selecting=false;
		var lastSelected=null;//Puede ser "LINEA" o "NODO"
		

		return {
			getAddingLines: function(){
				return addingLines;
			},
			getAddingNodes: function(){
				return addingNodes;
			},
			getAddingGrillas: function(){
				return addingGrillas;
			},
			getSelecting: function(){
				return selecting;
			},
			getViewOptions: function(val){
				return viewOptions;
			},
			setSelecting: function(val){
				selecting=val;
			},
			setAddingGrillas: function(val){
				addingGrillas=val;
			},
			setAddingLines: function(val){
				addingLines=val;
			},
			setAddingNodes: function(val){
				addingNodes=val;
			},
			setViewOptions: function(val){
				viewOptions=val;
			},
			getLastSelected: function(){
				return lastSelected;
			},
			setLastSelected: function(val){
				lastSelected=val;
			}
		}
	}]);
	
	angular.module('IETFEM')
.factory('LineaSelecService', ['leftMenuService',function(leftMenuService){
  		var lineaSeleccionada={
			id: 0,
			sceneId: 0,
			material:0,
			section:0,
			start: 0,
			end: 0
		  };

		var lineaReal;// La que esta en el modelo
		var infoLineaForm;// Es el formulario, para poder resetearlo
    	return {
    		getLineaReal: function() {
            	return lineaReal;
       		},
        	getLinea: function() {
            	return lineaSeleccionada;
       		},
			setLinea: function(value) {
				lineaReal=value;

				lineaSeleccionada.id=value.id;
				lineaSeleccionada.sceneId=value.sceneId;
				lineaSeleccionada.material=value.material;
				lineaSeleccionada.section=value.section;
				lineaSeleccionada.start=value.start;
				lineaSeleccionada.end=value.end;
				leftMenuService.setLastSelected("LINEA");
				
			},
			setInfoLineaForm: function(f){
				infoLineaForm=f;
			},
			resetLineaSeleccionada: function(){
				lineaSeleccionada.id=0;
				lineaSeleccionada.sceneId=0;
				lineaSeleccionada.materiales=0;
				lineaSeleccionada.sections=0;
				lineaSeleccionada.start=0;
				lineaSeleccionada.end=0;
			},
			resetForm: function(){
				if(typeof infoLineaForm != 'undefined'){
				    infoLineaForm.$setPristine();    
			   }
			}
		}
	}]);
	
	angular.module('IETFEM')
.factory('ModelService',['DefaultsService', 'SpaceService',function(DefaultsService, SpaceService) {

	// Funciones internas

	//Genera un nuevo identificador
	var newPointIdentifier = function(model) {
		var id = 0;
		for (var i = 0; i < model.points.length; i++){
			if (model.points[i].id > id)
				id = model.points[i].id
		}
		return id+1;
	};

	var newLineIdentifier = function(model) {
		var id = 0;
		for (var i = 0; i < model.lines.length; i++){
			if (model.lines[i].id > id)
				id = model.lines[i].id
		}					
		return id+1;
	};

	var newMaterialIdentifier = function(model) {
		var id = 0;
		for (var i = 0; i < model.materiales.length; i++){
			if (model.materiales[i].id > id)
				id = model.materiales[i].id
		}					
		return id+1;
	};

	var newSectionIdentifier = function(model) {
		var id = 0;
		for (var i = 0; i < model.secciones.length; i++){
			if (model.secciones[i].id > id)
				id = model.secciones[i].id
		}					
		return id+1;
	};
	
	//Obtiene un punto del modelo dadas sus coordenadas
	var getPointIdByCoords = function(x,y,z,model) {
		var id = 0;
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].coords.x == x && model.points[i].coords.y == y && model.points[i].coords.z == z)
				id = model.points[i].id;
		};
		return id;
	};
	//--- Fin internas

	//Obtener punto del modelo por id
	var getPointById = function(id, model) {
			for (var i = 0; i < model.points.length ;i++){
				if (model.points[i].id==id){
					return model.points[i];
				}
			};
	};

	//Obtener linea del modelo por id
	var getLineById = function(id, model) {
			for (var i = 0; i < model.lines.length ;i++){
				if (model.lines[i].id==id){
					return model.lines[i];
				}
			};
	};
	//Obtener punto del modelo por id de escena
	var getPointBySceneId = function(id, model) {
			for (var i = 0; i < model.points.length ;i++){
				if (model.points[i].sceneId==id){
					return model.points[i];
				}
			};
	};

	//Obtener linea del modelo por id de escena
	var getLineBySceneId = function(id, model) {
			for (var i = 0; i < model.lines.length ;i++){
				if (model.lines[i].sceneId==id){
					return model.lines[i];
				}
			};
	};
	
	//Agrega un punto al modelo
	var addPointToModel = function(pX,pY,pZ, sceneId, model) {
			
		var point = {};
		point.id = newPointIdentifier( model);
		point.sceneId = sceneId;
		//Displacement conditions
		point.xCondicion='F';
		point.yCondicion='F';
		point.zCondicion='F';
		//Forces applied
		point.xForce=0;
		point.yForce=0;
		point.zForce=0;

		//springs
		point.xSpring=0;
		point.ySpring=0;
		point.zSpring=0;

		point.coords = {
			x: pX,
			y: pY,
			z: pZ
		};

		point.forceArrowId=0;
		point.supportXId=0;
		point.supportYId=0;
		point.supportZId=0;

		point.springXId=0;
		point.springYId=0;
		point.springZId=0;

		model.points.push(point);
	};
	
	//Agrega una línea al modelo
	var addLineToModel = function(pX1, pY1, pZ1, pX2, pY2, pZ2, lineSceneId,model) {		
		var line = {};
		line.id = newLineIdentifier(model);
		line.sceneId= lineSceneId;
		if(DefaultsService.getLineMaterial()!= null){
			line.material=DefaultsService.getLineMaterial().id;
		}
		if(DefaultsService.getLineSection()!= null){
			line.section=DefaultsService.getLineSection().id;
		}
		line.start = getPointIdByCoords(pX1, pY1, pZ1,model);
		line.end = getPointIdByCoords(pX2, pY2, pZ2, model);
		
		model.lines.push(line);
	};

	var createGridInfo = function(modelGrids){
		//Obtengo el id del nuevo grid (max+1)
		var miGridId=0;
		for (var i = 0; i < modelGrids.length ;i++){
			if(modelGrids[i].gridId >= miGridId){
				miGridId=modelGrids[i].gridId;
			}
		}
		miGridId++;

		var gridInfo={};
		gridInfo.gridId=miGridId;
		gridInfo.viewStatus=true;
		gridInfo.objects= [];

		modelGrids.push(gridInfo);
		return gridInfo;
	};

		//Agrega un punto al modelo de las grillas
	var addGridPointToModel = function(pX,pY,pZ, sceneId, gridInfo) {
		var point = {};
		point.type = "POINT"
		point.sceneId = sceneId;
		point.coords = {
			x: pX,
			y: pY,
			z: pZ
		}

		gridInfo.objects.push(point);
		
	};

	//Agrega una línea al modelo
	var addGridLineToModel = function(pX1, pY1, pZ1, pX2, pY2, pZ2, lineSceneId,gridInfo) {		
		var line = {};
		line.type = "LINE"
		line.sceneId= lineSceneId;
		line.start = {
			x: pX1,
			y: pY1,
			z: pZ1
		}
		line.end = {
			x: pX2,
			y: pY2,
			z: pZ2
		}
	
		gridInfo.objects.push(line);
	};


	var removeLineFromModel = function(lineId,model){
		var index=null;
		for (var i = 0; i < model.lines.length ;i++){
			if(model.lines[i].id== lineId){
				index=i;
				break;
			}
		}
		if(index != null){
			model.lines.splice(index,1);
		}
	};

	// Para eliminar objetos de las estructuras auxiliares x sceneId (en realidad los objetos son de la scene Three)
	var removeObjFromArray = function(sceneId,aux){
		var index=null;
		for (var i = 0; i < aux.length ;i++){
			if(aux[i].id== sceneId){
				index=i;
				break;
			}
		}
		if(index != null){
			aux.splice(index,1);
		}
	};

	var removePointFromModel = function(pointId,model){
		var index=null;
		for (var i = 0; i < model.points.length ;i++){
			if(model.points[i].id== pointId){
				index=i;
				break;
			}
		}
		if(index != null){
			model.points.splice(index,1);
		}
	};

	//Agrega un material al modelo
	var addMaterial = function(name,ym,g,a,nu,model) {		
		var material = {};
		
		material.id = newMaterialIdentifier(model)
		material.name=name;
		material.youngModule=ym;
		material.gamma=g;
		material.alpha=a;
		material.nu=nu;
		
		model.materiales.push(material);
	};

	//Agrega un material al modelo
	var addSection = function(n,s,model) {		
		var section = {};
		
		section.id= newSectionIdentifier(model);
		section.name=n;
		section.section=s;
		
		model.secciones.push(section);
	};
	
	//Verifica si un punto está en el modelo
	var isInModel = function(x,y,z, model) {
		var drawed = true;
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].coords.x == x && model.points[i].coords.y == y && model.points[i].coords.z == z)
				return true
		};
		return false;
	};
	
	//Genera txt a partir del modelo
	var getText = function(model) {
		var text;
		var materials = [];
		var sections = [];

		text = 'Input for a 3D with large deformation (You must respect line breaks):' + '\n\n' + 'Force Magnitude' + '\n' + model.unitForce + '\n\n' + 'Length Magnitude' + '\n' + model.unitLength + '\n\n'
			   + 'Number of degrees of freedom per node' + '\n' + '3' + '\n\n' + 'Number of nodes per element' + '\n' + '2' + '\n\n';

		text +=  'Number of materials' + '\n' + model.materiales.length + '\n\n';
		
		text += 'Materials:' + '\n' + 'Young Modulus	gamma	alpha (1/C)	nu' + '\n';
		for (var i = 0; i < model.materiales.length ;i++){
			text += model.materiales[i].youngModule + '\t' + model.materiales[i].gamma + '\t' + model.materiales[i].alpha + '\t' + model.materiales[i].nu + '\n'; 
			materials[model.materiales[i].id] = i+1;
		}
		text += '\n' + 'Number of temperature cases' + '\n' + '0' + '\n\n' + 'Temperature cases:' + '\n' + 'Value' + '\n\n';
		
		text +=  'Number of sections' + '\n' + model.secciones.length + '\n\n';

		text += 'Sections:' + '\n' + 'Area' + '\n';
		for (var i = 0; i < model.secciones.length ;i++){
			text += model.secciones[i].section + '\n';
			sections[model.secciones[i].id] = i+1;
		}
		
		text += '\n' + 'Number of nodes' + '\n' + model.points.length + '\n\n';
		
		text += 'Node matrix ' + '\n';
		text += 'Xs     Ys     Zs' + '\n';
		for (var i = 0; i < model.points.length ;i++){
			text += model.points[i].coords.x + '\t' + model.points[i].coords.y + '\t' + model.points[i].coords.z + '\n'; 
		}
		text+= 	'\n' + 'Number of elements' + '\n' + model.lines.length + '\n\n';

		text += 'Conectivity matrix' + '\n';
		text += 'material     section     tempcase     start     end' + '\n';
		for (var i = 0; i < model.lines.length ;i++){
			text += materials[model.lines[i].material] + '\t' + sections[model.lines[i].section] + '\t' + 0 + '\t' + model.lines[i].start + '\t' + model.lines[i].end + '\n'; 
		}
		var displacementNodes = [];
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].xCondicion != 'F' || model.points[i].yCondicion != 'F' || model.points[i].zCondicion != 'F'){
				displacementNodes.push(model.points[i]);
			}
		}
		text += '\n' + 'Number of displacement conditions nodes' + '\n' + displacementNodes.length + '\n\n' + 'Displacement conditions nodes matrix' + '\n' + 'Displacement node  X condition   Y condition   Z condition' + '\n'
		for (var i = 0; i < displacementNodes.length ;i++){
			text += displacementNodes[i].id + '\t' + displacementNodes[i].xCondicion + '\t' + displacementNodes[i].yCondicion + '\t' + displacementNodes[i].zCondicion + '\n'; 
		}
		
		var loadNodes = [];
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].xForce != 0 || model.points[i].yForce != 0 || model.points[i].zForce != 0){
				loadNodes.push(model.points[i]);
			}
		}
		text += '\n' + 'Number of puntual load conditions' + '\n' + loadNodes.length + '\n\n' + 'Puntual loads conditions nodes matrix' + '\n' + 'Load node       FX            FY           FZ' + '\n'
		for (var i = 0; i < loadNodes.length ;i++){
			text += loadNodes[i].id + '\t' + loadNodes[i].xForce + '\t' + loadNodes[i].yForce + '\t' + loadNodes[i].zForce + '\n'; 
		}
		
		//Agrega las opciones de salida al final
		text += '\n' + 'Number of dead volume load conditions' + '\n' + '0' +'\n\n' + 'Dead volume loads conditions matrix' + '\n' + 'Element           bx                  by                  bz' + '\n';

		var springNodes = [];
		for (var i = 0; i < model.points.length ;i++){
			if (model.points[i].xSpring != 0 || model.points[i].ySpring != 0 || model.points[i].zSpring != 0){
				springNodes.push(model.points[i]);
			}
		}

		text += '\n' + 'Number of springs conditions nodes' + '\n' + springNodes.length + '\n\n' + 'Springs conditions nodes matrix' + '\n' + 'Spring node  X condition   Y condition   Z condition ' + '\n'
		for (var i = 0; i < springNodes.length ;i++){
			text += springNodes[i].id + '\t' + springNodes[i].xSpring + '\t' + springNodes[i].ySpring + '\t' + springNodes[i].zSpring + '\n'; 
		}

		//text +=  '\n' + 'Scale Factor' + '\n' + 'SD_Deformed   Supports    Areas    Forces    Frames    Numbers    LD_Deformed' + '\n' + '   70           1         1         1         0.05         1         70' + '\n\n' + 'What you wanna see? (Yes=1, No=0)' + '\n' + 'Indeformed   SD_Deformed   SD_Axial   LD_Deformed    LD_Axial     Convergence' + '\n' + '	1                 1            1          1             1              1' + '\n\n' + 'Of selectet plots, wich of them you wanna print in a .png image? (Yes=1, No=0)' + '\n' + '	Indeformed   SD_Deformed  SD_Axial   LD_Deformed   LD_Axial     Convergence' + '\n' + '	1                 1            1          1            1             1' + '\n\n' + 'How many images do you wanna see for small deformation?' + '\n' + 'SD_Deformed   SD_Axial  ' + '\n' + '	1               1' + '\n\n' + 'What you wanna see in plots? (Yes=1, No=0)' + '\n' + 'Supports   Node_Numbers   Elements_Numbers   Forces          Axial_Force_Value' + '\n' + '	1               0                0              1                   0' + '\n\n' + 'For 3D plots, what you wanna see? (Yes=1, No=0)' + '\n' + 'If you choose Dif_View=1 IETFEM use default AZIMUTH and ELEVATION, if you choose Dif_View=0 you must type aximuth and elevation in degrees.' + '\n' + 'XY_plane    XZ_plane    YZ_plane    Dif_View   AZIMUTH(degree)   ELEVATION(degree)   ' + '\n' + '	   1            1           1           0           150               15   ' + '\n\n' + 'Text output format (Yes=1, No=0)' + '\n' + 'TXT  TEX' + '\n' + '1     1' + '\n';

		return text;
		
	};

	var validModel = function(model) {
		var validObj = {
			valid:true,
			emptyStructure:false,
			invalidStructure:false
		};
		if (model.lines.length == 0){
			validObj.emptyStructure = true
			validObj.valid = false
		}
		for (var i = 0; i < model.lines.length ;i++){
			if(!model.lines[i].material || !model.lines[i].section) {
				validObj.invalidStructure = true;
				validObj.valid = false
			}
		}
		return validObj;
	};

	var setModelMaterial = function(scene, model, material){
		for (var i = 0; i < model.points.length ;i++){
			SpaceService.setMaterial(model.points[i].sceneId, scene, material);
		};
		for (var i = 0; i < model.lines.length ;i++){
			SpaceService.setMaterial(model.lines[i].sceneId, scene, material);
		};
	};

	var setModelOpaque = function(scene, model){
		if (model.points.length > 0){
			var material = SpaceService.getMaterial(model.points[0].sceneId, scene);
			material = new THREE.MeshBasicMaterial( {color: material.color} );
			for (var i = 0; i < model.points.length ;i++){
				SpaceService.setMaterial(model.points[i].sceneId, scene, material);
			};
			for (var i = 0; i < model.lines.length ;i++){
				SpaceService.setMaterial(model.lines[i].sceneId, scene, material);
			};
		};	
	};

	var setModelTransparent = function(scene, model){
		if (model.points.length > 0){
			var material = SpaceService.getMaterial(model.points[0].sceneId, scene);
			material = new THREE.MeshBasicMaterial( {color: material.color, transparent: true, opacity: 0.15} );
			for (var i = 0; i < model.points.length ;i++){
				SpaceService.setMaterial(model.points[i].sceneId, scene, material);
			};
			for (var i = 0; i < model.lines.length ;i++){
				SpaceService.setMaterial(model.lines[i].sceneId, scene, material);
			};
		};	
	};

	var colorizeModel = function(scene, model, deformed, type, transparent){

		var color, index, max, min;
		var maxs = {};
		var mins = {};

		max = 0;
		min = 9999;
		if (type != 'normal'){
			for (var i = 0; i < model.lines.length ;i++){
				switch(type){
					case "deformation":
						if (deformed.lines[i].deformation > max)
							max = deformed.lines[i].deformation;
						if (deformed.lines[i].deformation < min)
							min = deformed.lines[i].deformation;
						break;
					case "force":
						if (deformed.lines[i].force > max)
							max = deformed.lines[i].force;
						if (deformed.lines[i].force < min)
							min = deformed.lines[i].force;
						break;
					case "tension":
						if (deformed.lines[i].tension > max)
							max = deformed.lines[i].tension;
						if (deformed.lines[i].tension < min)
							min = deformed.lines[i].tension;
						break;		
				}			
			};
		};

		for (var i = 0; i < model.lines.length ;i++){
				switch(type){
					case "normal":
						color = 0x000000;
						break;
					case "deformation":
						index = 0;
						if (deformed.lines[i].deformation > 0){
							for (var j = 0; j <= max; j+=max/5){
								if (deformed.lines[i].deformation > j)
									index +=1
							}
						} else{
							for (var j = 0; j <= -min; j+=-min/5){
									if (-deformed.lines[i].deformation > j)
										index +=1
								}
								index = -index;
						}
						color = SpaceService.getColor(index);
						break;
					case "force":
						index = 0;
							if (deformed.lines[i].force > 0){
								for (var j = 0; j <= max; j+=max/5){
									if (deformed.lines[i].force > j)
										index +=1
								}
							} else{
								for (var j = 0; j <= -min; j+=-min/5){
									if (-deformed.lines[i].force > j)
										index +=1
								}
								index = -index;
							}
							color = SpaceService.getColor(index);
							break;
					case "tension":
						index = 0;
							if (deformed.lines[i].tension > 0){
								for (var j = 0; j <= max; j+=max/5){
									if (deformed.lines[i].tension > j)
										index +=1
								}
							} else{
								for (var j = 0; j <= -min; j+=-min/5){
									if (-deformed.lines[i].tension > j)
										index +=1
								}
								index = -index;
							}
							color = SpaceService.getColor(index);
							break;
				}
				if (transparent){
					var material = new THREE.MeshBasicMaterial( {color: color, transparent: true, opacity: 0.15} );
				} else {
					var material = new THREE.MeshBasicMaterial( {color: color} );
				}

				SpaceService.setMaterial(model.lines[i].sceneId, scene, material);
		};
	};	

	return {
		addMaterial: addMaterial,
		addSection: addSection,
		getPointById: getPointById,
		getLineById: getLineById,
		getPointBySceneId: getPointBySceneId,
		getLineBySceneId: getLineBySceneId,
		getPointIdByCoords: getPointIdByCoords,
		removeLineFromModel: removeLineFromModel,
		removeObjFromArray: removeObjFromArray,
		removePointFromModel: removePointFromModel,
		addPointToModel: addPointToModel,
		addLineToModel: addLineToModel,
		isInModel: isInModel,
		getText: getText,
		validModel: validModel,
		setModelMaterial: setModelMaterial,
		setModelTransparent: setModelTransparent,
		setModelOpaque: setModelOpaque,
		addGridLineToModel: addGridLineToModel,
		addGridPointToModel: addGridPointToModel,
		createGridInfo: createGridInfo,
		colorizeModel: colorizeModel
	};
}]);

angular.module('IETFEM')
.factory('PtoSelecService', ['leftMenuService',function(leftMenuService){
  		var puntoSeleccionado={
			  id:0,
			  sceneId:0,
			  xCondicion:'F',
			  yCondicion:'F',
			  zCondicion:'F',
			  xForce:0,
			  yForce:0,
			  zForce:0,
			  xSpring:0,
			  ySpring:0,
			  zSpring:0,
			  forceArrowId:0,
			  coords: {
					x: 0,
					y: 0,
					z: 0
				}
		  };

		var puntoReal;
		var infoPuntoForm;// Es el formulario, para poder resetearlo
    	return {
    		getPuntoReal: function() {
            	return puntoReal;
       		},
        	getPunto: function() {
            	return puntoSeleccionado;
       		},
			setPunto: function(value,ptoReal) {
				puntoReal=value;

				puntoSeleccionado.id=value.id;
				puntoSeleccionado.sceneId=value.sceneId;
				puntoSeleccionado.xCondicion=value.xCondicion;
				puntoSeleccionado.yCondicion=value.yCondicion;
				puntoSeleccionado.zCondicion=value.zCondicion;
				puntoSeleccionado.xForce=value.xForce;
				puntoSeleccionado.yForce=value.yForce;
				puntoSeleccionado.zForce=value.zForce;
				puntoSeleccionado.xSpring=value.xSpring;
				puntoSeleccionado.ySpring=value.ySpring;
				puntoSeleccionado.zSpring=value.zSpring;
				puntoSeleccionado.coords=value.coords;
				puntoSeleccionado.forceArrowId= value.forceArrowId;
				
				leftMenuService.setLastSelected("NODO");
			},
			setInfoPuntoForm: function(f){
				infoPuntoForm=f;
			},
			resetPuntoSeleccionado: function(){
				puntoSeleccionado.id=0;
				puntoSeleccionado.sceneId=0;
				puntoSeleccionado.xCondicion='F';
				puntoSeleccionado.yCondicion='F';
				puntoSeleccionado.zCondicion='F';
				puntoSeleccionado.xForce=0;
				puntoSeleccionado.yForce=0;
				puntoSeleccionado.zForce=0;
				puntoSeleccionado.xSpring=0;
				puntoSeleccionado.ySpring=0;
				puntoSeleccionado.zSpring=0;
				puntoSeleccionado.coords={
											x: 0,
											y: 0,
											z: 0
										};
			},
			resetForm: function(){
				if(typeof infoPuntoForm != 'undefined'){
				    infoPuntoForm.$setPristine();    
			   }
			}
		}
	}]);
	
angular.module('IETFEM')
.factory('SpaceService', ['DefaultsService',function(DefaultsService) {

	var colorRange = [
		{index:-5, color:0x610B0B},
		{index:-4, color:0xB40404},
		{index:-3, color:0xFF0000},
		{index:-2, color:0xFA5858},
		{index:-1, color:0xF5A9A9},
		{index:0, color:0x2E9AFE},
		{index:1, color:0xA9F5A9},
		{index:2, color:0x58FA58},
		{index:3, color:0x00FF00},
		{index:4, color:0x04B404},
		{index:5, color:0x0B610B},
	]

	var arrayGeometriasBarras=[];

	// Funciones internas
	var	cylinderMesh = function( point1, point2, material, width, applyCacheGeometry){

		/* edge from X to Y */
		var direction = new THREE.Vector3().subVectors( point2, point1 );
		var orientation = new THREE.Matrix4();
		/* THREE.Object3D().up (=Y) default orientation for all objects */
		orientation.lookAt(point1, point2, new THREE.Object3D().up);
		/* rotation around axis X by -90 degrees 
		 * matches the default orientation Y 
		 * with the orientation of looking Z */
		var matrix4 = new THREE.Matrix4();
		matrix4.set(1,0,0,0,
					0,0,1,0, 
					0,-1,0,0,
					0,0,0,1);
		orientation.multiply(matrix4);

		/* cylinder: radiusAtTop, radiusAtBottom, 
			height, radiusSegments, heightSegments */
		
		var result=$.grep(arrayGeometriasBarras, function(e){ return e.largo == direction.length(); });
		var edgeGeometry;
		if(result.length > 0 && applyCacheGeometry){
			edgeGeometry= result[0].geometry;
		}else{
			edgeGeometry= new THREE.CylinderGeometry( width, width, direction.length(), 3, 1);
			arrayGeometriasBarras.push({largo:direction.length(),geometry: edgeGeometry});
		}
		//var edgeGeometry = new THREE.CylinderGeometry( width, width, direction.length(), 4, 1);
		
		var edge = new THREE.Mesh( edgeGeometry, 
				material);

		edge.applyMatrix(orientation)
		edge.applyMatrix( new THREE.Matrix4().makeTranslation((point1.x + point2.x)/2,(point1.y + point2.y)/2,(point1.z + point2.z)/2) );
		return edge;
	};

	var	pyramidMesh = function( point1, point2, material, width){

		/* edge from X to Y */
		var direction = new THREE.Vector3().subVectors( point2, point1 );
		var orientation = new THREE.Matrix4();
		/* THREE.Object3D().up (=Y) default orientation for all objects */
		orientation.lookAt(point1, point2, new THREE.Object3D().up);
		/* rotation around axis X by -90 degrees 
		 * matches the default orientation Y 
		 * with the orientation of looking Z */
		var matrix4 = new THREE.Matrix4();
		matrix4.set(1,0,0,0,
					0,0,1,0, 
					0,-1,0,0,
					0,0,0,1);
		orientation.multiply(matrix4);

		/* cylinder: radiusAtTop, radiusAtBottom, 
			height, radiusSegments, heightSegments */
		//var edgeGeometry = new THREE.CylinderGeometry( 1, width, 3, 4);
		var edgeGeometry = new THREE.CylinderGeometry( 0.1, 0, direction.length(), 4);
		
		var edge = new THREE.Mesh( edgeGeometry, 
				material);

		edge.applyMatrix(orientation)
		edge.applyMatrix( new THREE.Matrix4().makeTranslation((point1.x + point2.x)/2,(point1.y + point2.y)/2,(point1.z + point2.z)/2) );
		return edge;
	};

	//--- Fin internas
	
	//Dibuja una linea entre 2 puntos
	var drawLine = function(xi, yi, zi, xf, yf, zf, material, width, scene,lineasEscena, applyCacheGeometry){
		var cylinder = cylinderMesh(new THREE.Vector3(xi, yi, zi), new THREE.Vector3(xf, yf, zf), material, width, applyCacheGeometry);
		scene.add( cylinder );

		if(lineasEscena != null){//Se pasa null en la grilla x ejemplo
			lineasEscena.push(cylinder);
		}

		return cylinder.id;
	};

	//Dibuja un punto
	var drawPoint = function(x, y, z, scene, puntosEscena, sphereMaterial, helpObjects){
		var sphereGeometry = DefaultsService.getEsferaEstandar();
		var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
		sphere.position.x = x
		sphere.position.y = y
		sphere.position.z = z
		scene.add(sphere);
		
		puntosEscena.push(sphere);
		if(helpObjects != null){
			helpObjects.push(sphere);	
		}
		return sphere.id;	
	};

	// Se le pasa las coordenadas de un punto y un booleano para el eje que es el apoyo
	var drawPyramidSupport = function(x,y,z,isX,isY,isZ,scene,isSpring){
		var material;
		if(isSpring){
			material = new THREE.MeshBasicMaterial( {color: 0x587272} );
		}else{
			material = new THREE.MeshBasicMaterial( {color: 0x0B0B61} );
		}
		if(isX){
			if(x>=0){
				var pyramid = pyramidMesh(new THREE.Vector3(x-0.1, y, z), new THREE.Vector3(x-0.3, y, z), material,2);
			}else{
				var pyramid = pyramidMesh(new THREE.Vector3(x+0.1, y, z), new THREE.Vector3(x+0.3, y, z), material,2);
			}
			scene.add(pyramid);
			return pyramid.id;
		}else if(isY){
			if(y>=0){
				var pyramid = pyramidMesh(new THREE.Vector3(x, y-0.1, z), new THREE.Vector3(x, y-0.3, z), material,2);
			}else{
				var pyramid = pyramidMesh(new THREE.Vector3(x, y+0.1, z), new THREE.Vector3(x, y+0.3, z), material,2);
			}
			scene.add(pyramid);
			return pyramid.id;
		}else if(isZ){
			if(z>=0){
				var pyramid = pyramidMesh(new THREE.Vector3(x, y, z-0.1), new THREE.Vector3(x, y, z-0.3), material,2);
			}else{
				var pyramid = pyramidMesh(new THREE.Vector3(x, y, z+0.1), new THREE.Vector3(x, y, z+0.3), material,2);
			}
			scene.add(pyramid);
			return pyramid.id;
		}
	};

	//Dibuja el modelo entero
	var drawModel = function(scene, model, puntosEscena, lineasEscena, helpObjects){

		var material = DefaultsService.getMaterialNegro();
		var start = {};
		var end = {};

		for (i=0; i<model.points.length; i++){
			model.points[i].sceneId = drawPoint(model.points[i].coords.x, model.points[i].coords.y, model.points[i].coords.z, scene, puntosEscena, material, null);	
		}
			$('#toggle-event').click();
			$('#toggle-event').click();
			$('#toggle-event2').click();
			$('#toggle-event2').click();

		for (i=0; i<model.lines.length; i++){

			for (j=0; j<model.points.length; j++){
				if (model.lines[i].start==model.points[j].id){
					start.x = model.points[j].coords.x;
					start.y = model.points[j].coords.y;
					start.z = model.points[j].coords.z;
				}
				if (model.lines[i].end==model.points[j].id){
					end.x = model.points[j].coords.x;
					end.y = model.points[j].coords.y;
					end.z = model.points[j].coords.z;
				}
			};
			model.lines[i].sceneId = drawLine(start.x, start.y, start.z, end.x, end.y, end.z, material, 0.05, scene ,lineasEscena);
		}
	};
	
	//Obtiene un punto dibujado dado el id
	var getScenePointById = function(id, scene) {
		var obj = null;
		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && scene.children[i].id == id)
				obj = scene.children[i]
		};
		return obj;
	};

	//Obtiene una linea dibujada dado el id
	var getSceneLineById = function(id, scene) {
		var obj = null;
		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && scene.children[i].id == id)
				return scene.children[i]
		};
	};
	
	//Obtiene el Id de un punto dibujado dadas sus coordenadas
	var getScenePointIdByCoords = function(x,y,z, scene) {
		var id = 0;
		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && getScenePointById(i, scene) == null && scene.children[i].position.x == x && scene.children[i].position.y == y && scene.children[i].position.z == z)
				id = scene.children[i].id;
		};
		return id;
	};


	var getMaterial = function(id, scene) {
		return getScenePointById(id, scene).material;
	};

	var setMaterial = function(id, scene, material) {
		getScenePointById(id, scene).material = material;
	};

	var movePoint = function(id, scene, x, y, z) {
		getScenePointById(id, scene).position.x = x;
		getScenePointById(id, scene).position.y = z;
		getScenePointById(id, scene).position.z = y;
	};

	var moveLine = function(id, scene, x1, y1, z1, x2, y2, z2) {

		var material = getMaterial(id, scene);
		var rotated = cylinderMesh(new THREE.Vector3(x1, z1, y1), new THREE.Vector3(x2, z2, y2), material, 0.05, false);
		
		scene.add(rotated);

		for (var i = 0; i < scene.children.length ;i++){
			if (scene.children[i] instanceof THREE.Mesh && scene.children[i].id == id)
				scene.remove(scene.children[i]);
		};

		return scene.children[scene.children.length-1].id;

		//drawLine(x1, y1, z1, x2, y2, z2, material, 0.05, scene,[])

	};
	var hideShowObject =  function(id,visible,scene){
		var obj= scene.getObjectById( id, true );
		if(obj != null){
			obj.visible=visible;
		}

	};

	var removeObjectById = function(id,scene){
		var obj= scene.getObjectById( id, true );
		scene.remove(obj);
	};

	var getColor = function(index){
		for (var i = 0; i < colorRange.length ;i++){
			if (colorRange[i].index === index)
				return colorRange[i].color;
		};
	};


	
	return {
		drawLine: drawLine,
		drawPoint: drawPoint,
		drawPyramidSupport: drawPyramidSupport,
		drawModel: drawModel,
		getSceneLineById:getSceneLineById,
		getScenePointById: getScenePointById,
		getScenePointIdByCoords: getScenePointIdByCoords,
		getMaterial: getMaterial,
		setMaterial: setMaterial,
		movePoint: movePoint,
		moveLine: moveLine,
		hideShowObject: hideShowObject,
		removeObjectById: removeObjectById,
		getColor: getColor
	};

}]);

THREE.OrbitControls = function ( object, domElement ) {

	this.object = object;
	this.domElement = ( domElement !== undefined ) ? domElement : document;

	// API

	// Set to false to disable this control
	this.enabled = true;

	// "target" sets the location of focus, where the control orbits around
	// and where it pans with respect to.
	this.target = new THREE.Vector3();

	// center is old, deprecated; use "target" instead
	this.center = this.target;

	// This option actually enables dollying in and out; left as "zoom" for
	// backwards compatibility
	this.noZoom = false;
	this.zoomSpeed = 1.0;

	// Limits to how far you can dolly in and out ( PerspectiveCamera only )
	this.minDistance = 0;
	this.maxDistance = Infinity;

	// Limits to how far you can zoom in and out ( OrthographicCamera only )
	this.minZoom = 0;
	this.maxZoom = Infinity;

	// Set to true to disable this control
	this.noRotate = false;
	this.rotateSpeed = 1.0;

	// Set to true to disable this control
	this.noPan = false;
	this.keyPanSpeed = 7.0;	// pixels moved per arrow key push

	// Set to true to automatically rotate around the target
	this.autoRotate = false;
	this.autoRotateSpeed = 2.0; // 30 seconds per round when fps is 60

	// How far you can orbit vertically, upper and lower limits.
	// Range is 0 to Math.PI radians.
	this.minPolarAngle = 0; // radians
	this.maxPolarAngle = Math.PI; // radians

	// How far you can orbit horizontally, upper and lower limits.
	// If set, must be a sub-interval of the interval [ - Math.PI, Math.PI ].
	this.minAzimuthAngle = - Infinity; // radians
	this.maxAzimuthAngle = Infinity; // radians

	// Set to true to disable use of the keys
	this.noKeys = false;

	// The four arrow keys
	this.keys = { LEFT: 37, UP: 38, RIGHT: 39, BOTTOM: 40 };

	// Mouse buttons
	this.mouseButtons = { ORBIT: THREE.MOUSE.LEFT, ZOOM: THREE.MOUSE.MIDDLE, PAN: THREE.MOUSE.RIGHT };

	////////////
	// internals

	var scope = this;

	var EPS = 0.000001;

	var rotateStart = new THREE.Vector2();
	var rotateEnd = new THREE.Vector2();
	var rotateDelta = new THREE.Vector2();

	var panStart = new THREE.Vector2();
	var panEnd = new THREE.Vector2();
	var panDelta = new THREE.Vector2();
	var panOffset = new THREE.Vector3();

	var offset = new THREE.Vector3();

	var dollyStart = new THREE.Vector2();
	var dollyEnd = new THREE.Vector2();
	var dollyDelta = new THREE.Vector2();

	var theta;
	var phi;
	var phiDelta = 0;
	var thetaDelta = 0;
	var scale = 1;
	var pan = new THREE.Vector3();

	var lastPosition = new THREE.Vector3();
	var lastQuaternion = new THREE.Quaternion();

	var STATE = { NONE : -1, ROTATE : 0, DOLLY : 1, PAN : 2, TOUCH_ROTATE : 3, TOUCH_DOLLY : 4, TOUCH_PAN : 5 };

	var state = STATE.NONE;

	// for reset

	this.target0 = this.target.clone();
	this.position0 = this.object.position.clone();
	this.zoom0 = this.object.zoom;

	// so camera.up is the orbit axis

	var quat = new THREE.Quaternion().setFromUnitVectors( object.up, new THREE.Vector3( 0, 1, 0 ) );
	var quatInverse = quat.clone().inverse();

	// events

	var changeEvent = { type: 'change' };
	var startEvent = { type: 'start' };
	var endEvent = { type: 'end' };

	this.rotateLeft = function ( angle ) {

		if ( angle === undefined ) {

			angle = getAutoRotationAngle();

		}

		thetaDelta -= angle;

	};

	this.rotateUp = function ( angle ) {

		if ( angle === undefined ) {

			angle = getAutoRotationAngle();

		}

		phiDelta -= angle;

	};

	// pass in distance in world space to move left
	this.panLeft = function ( distance ) {

		var te = this.object.matrix.elements;

		// get X column of matrix
		panOffset.set( te[ 0 ], te[ 1 ], te[ 2 ] );
		panOffset.multiplyScalar( - distance );

		pan.add( panOffset );

	};

	// pass in distance in world space to move up
	this.panUp = function ( distance ) {

		var te = this.object.matrix.elements;

		// get Y column of matrix
		panOffset.set( te[ 4 ], te[ 5 ], te[ 6 ] );
		panOffset.multiplyScalar( distance );

		pan.add( panOffset );

	};

	// pass in x,y of change desired in pixel space,
	// right and down are positive
	this.pan = function ( deltaX, deltaY ) {

		var element = scope.domElement === document ? scope.domElement.body : scope.domElement;

		if ( scope.object instanceof THREE.PerspectiveCamera ) {

			// perspective
			var position = scope.object.position;
			var offset = position.clone().sub( scope.target );
			var targetDistance = offset.length();

			// half of the fov is center to top of screen
			targetDistance *= Math.tan( ( scope.object.fov / 2 ) * Math.PI / 180.0 );

			// we actually don't use screenWidth, since perspective camera is fixed to screen height
			scope.panLeft( 2 * deltaX * targetDistance / element.clientHeight );
			scope.panUp( 2 * deltaY * targetDistance / element.clientHeight );

		} else if ( scope.object instanceof THREE.OrthographicCamera ) {

			// orthographic
			scope.panLeft( deltaX * (scope.object.right - scope.object.left) / element.clientWidth );
			scope.panUp( deltaY * (scope.object.top - scope.object.bottom) / element.clientHeight );

		} else {

			// camera neither orthographic or perspective
			console.warn( 'WARNING: OrbitControls.js encountered an unknown camera type - pan disabled.' );

		}

	};

	this.dollyIn = function ( dollyScale ) {

		if ( dollyScale === undefined ) {

			dollyScale = getZoomScale();

		}

		if ( scope.object instanceof THREE.PerspectiveCamera ) {

			scale /= dollyScale;

		} else if ( scope.object instanceof THREE.OrthographicCamera ) {

			scope.object.zoom = Math.max( this.minZoom, Math.min( this.maxZoom, this.object.zoom * dollyScale ) );
			scope.object.updateProjectionMatrix();
			scope.dispatchEvent( changeEvent );

		} else {

			console.warn( 'WARNING: OrbitControls.js encountered an unknown camera type - dolly/zoom disabled.' );

		}

	};

	this.dollyOut = function ( dollyScale ) {

		if ( dollyScale === undefined ) {

			dollyScale = getZoomScale();

		}

		if ( scope.object instanceof THREE.PerspectiveCamera ) {

			scale *= dollyScale;

		} else if ( scope.object instanceof THREE.OrthographicCamera ) {

			scope.object.zoom = Math.max( this.minZoom, Math.min( this.maxZoom, this.object.zoom / dollyScale ) );
			scope.object.updateProjectionMatrix();
			scope.dispatchEvent( changeEvent );

		} else {

			console.warn( 'WARNING: OrbitControls.js encountered an unknown camera type - dolly/zoom disabled.' );

		}

	};

	this.update = function () {

		var position = this.object.position;

		offset.copy( position ).sub( this.target );

		// rotate offset to "y-axis-is-up" space
		offset.applyQuaternion( quat );

		// angle from z-axis around y-axis

		theta = Math.atan2( offset.x, offset.z );

		// angle from y-axis

		phi = Math.atan2( Math.sqrt( offset.x * offset.x + offset.z * offset.z ), offset.y );

		if ( this.autoRotate && state === STATE.NONE ) {

			this.rotateLeft( getAutoRotationAngle() );

		}

		theta += thetaDelta;
		phi += phiDelta;

		// restrict theta to be between desired limits
		theta = Math.max( this.minAzimuthAngle, Math.min( this.maxAzimuthAngle, theta ) );

		// restrict phi to be between desired limits
		phi = Math.max( this.minPolarAngle, Math.min( this.maxPolarAngle, phi ) );

		// restrict phi to be betwee EPS and PI-EPS
		phi = Math.max( EPS, Math.min( Math.PI - EPS, phi ) );

		var radius = offset.length() * scale;

		// restrict radius to be between desired limits
		radius = Math.max( this.minDistance, Math.min( this.maxDistance, radius ) );

		// move target to panned location
		this.target.add( pan );

		offset.x = radius * Math.sin( phi ) * Math.sin( theta );
		offset.y = radius * Math.cos( phi );
		offset.z = radius * Math.sin( phi ) * Math.cos( theta );

		// rotate offset back to "camera-up-vector-is-up" space
		offset.applyQuaternion( quatInverse );

		position.copy( this.target ).add( offset );

		this.object.lookAt( this.target );

		thetaDelta = 0;
		phiDelta = 0;
		scale = 1;
		pan.set( 0, 0, 0 );

		// update condition is:
		// min(camera displacement, camera rotation in radians)^2 > EPS
		// using small-angle approximation cos(x/2) = 1 - x^2 / 8

		if ( lastPosition.distanceToSquared( this.object.position ) > EPS
		    || 8 * (1 - lastQuaternion.dot(this.object.quaternion)) > EPS ) {

			this.dispatchEvent( changeEvent );

			lastPosition.copy( this.object.position );
			lastQuaternion.copy (this.object.quaternion );

		}

	};


	this.reset = function () {

		state = STATE.NONE;

		this.target.copy( this.target0 );
		this.object.position.copy( this.position0 );
		this.object.zoom = this.zoom0;

		this.object.updateProjectionMatrix();
		this.dispatchEvent( changeEvent );

		this.update();

	};

	this.getPolarAngle = function () {

		return phi;

	};

	this.getAzimuthalAngle = function () {

		return theta

	};

	function getAutoRotationAngle() {

		return 2 * Math.PI / 60 / 60 * scope.autoRotateSpeed;

	}

	function getZoomScale() {

		return Math.pow( 0.95, scope.zoomSpeed );

	}

	function onMouseDown( event ) {

		if ( scope.enabled === false ) return;
		event.preventDefault();

		if ( event.button === scope.mouseButtons.ORBIT ) {
			if ( scope.noRotate === true ) return;

			state = STATE.ROTATE;

			rotateStart.set( event.clientX, event.clientY );

		} else if ( event.button === scope.mouseButtons.ZOOM ) {
			if ( scope.noZoom === true ) return;

			state = STATE.DOLLY;

			dollyStart.set( event.clientX, event.clientY );

		} else if ( event.button === scope.mouseButtons.PAN ) {
			if ( scope.noPan === true ) return;

			state = STATE.PAN;

			panStart.set( event.clientX, event.clientY );

		}

		if ( state !== STATE.NONE ) {
			document.addEventListener( 'mousemove', onMouseMove, false );
			document.addEventListener( 'mouseup', onMouseUp, false );
			scope.dispatchEvent( startEvent );
		}

	}

	function onMouseMove( event ) {

		if ( scope.enabled === false ) return;

		event.preventDefault();

		var element = scope.domElement === document ? scope.domElement.body : scope.domElement;

		if ( state === STATE.ROTATE ) {

			if ( scope.noRotate === true ) return;

			rotateEnd.set( event.clientX, event.clientY );
			rotateDelta.subVectors( rotateEnd, rotateStart );

			// rotating across whole screen goes 360 degrees around
			scope.rotateLeft( 2 * Math.PI * rotateDelta.x / element.clientWidth * scope.rotateSpeed );

			// rotating up and down along whole screen attempts to go 360, but limited to 180
			scope.rotateUp( 2 * Math.PI * rotateDelta.y / element.clientHeight * scope.rotateSpeed );

			rotateStart.copy( rotateEnd );

		} else if ( state === STATE.DOLLY ) {

			if ( scope.noZoom === true ) return;

			dollyEnd.set( event.clientX, event.clientY );
			dollyDelta.subVectors( dollyEnd, dollyStart );

			if ( dollyDelta.y > 0 ) {

				scope.dollyIn();

			} else if ( dollyDelta.y < 0 ) {

				scope.dollyOut();

			}

			dollyStart.copy( dollyEnd );

		} else if ( state === STATE.PAN ) {

			if ( scope.noPan === true ) return;

			panEnd.set( event.clientX, event.clientY );
			panDelta.subVectors( panEnd, panStart );

			scope.pan( panDelta.x, panDelta.y );

			panStart.copy( panEnd );

		}

		if ( state !== STATE.NONE ) scope.update();

	}

	function onMouseUp( /* event */ ) {

		if ( scope.enabled === false ) return;

		document.removeEventListener( 'mousemove', onMouseMove, false );
		document.removeEventListener( 'mouseup', onMouseUp, false );
		scope.dispatchEvent( endEvent );
		state = STATE.NONE;

	}

	function onMouseWheel( event ) {

		if ( scope.enabled === false || scope.noZoom === true || state !== STATE.NONE ) return;

		event.preventDefault();
		event.stopPropagation();

		var delta = 0;

		if ( event.wheelDelta !== undefined ) { // WebKit / Opera / Explorer 9

			delta = event.wheelDelta;

		} else if ( event.detail !== undefined ) { // Firefox

			delta = - event.detail;

		}

		if ( delta > 0 ) {

			scope.dollyOut();

		} else if ( delta < 0 ) {

			scope.dollyIn();

		}

		scope.update();
		scope.dispatchEvent( startEvent );
		scope.dispatchEvent( endEvent );

	}

	function onKeyDown( event ) {

		if ( scope.enabled === false || scope.noKeys === true || scope.noPan === true ) return;

		switch ( event.keyCode ) {

			case scope.keys.UP:
				scope.pan( 0, scope.keyPanSpeed );
				scope.update();
				break;

			case scope.keys.BOTTOM:
				scope.pan( 0, - scope.keyPanSpeed );
				scope.update();
				break;

			case scope.keys.LEFT:
				scope.pan( scope.keyPanSpeed, 0 );
				scope.update();
				break;

			case scope.keys.RIGHT:
				scope.pan( - scope.keyPanSpeed, 0 );
				scope.update();
				break;

		}

	}

	function touchstart( event ) {

		if ( scope.enabled === false ) return;

		switch ( event.touches.length ) {

			case 1:	// one-fingered touch: rotate

				if ( scope.noRotate === true ) return;

				state = STATE.TOUCH_ROTATE;

				rotateStart.set( event.touches[ 0 ].pageX, event.touches[ 0 ].pageY );
				break;

			case 2:	// two-fingered touch: dolly

				if ( scope.noZoom === true ) return;

				state = STATE.TOUCH_DOLLY;

				var dx = event.touches[ 0 ].pageX - event.touches[ 1 ].pageX;
				var dy = event.touches[ 0 ].pageY - event.touches[ 1 ].pageY;
				var distance = Math.sqrt( dx * dx + dy * dy );
				dollyStart.set( 0, distance );
				break;

			case 3: // three-fingered touch: pan

				if ( scope.noPan === true ) return;

				state = STATE.TOUCH_PAN;

				panStart.set( event.touches[ 0 ].pageX, event.touches[ 0 ].pageY );
				break;

			default:

				state = STATE.NONE;

		}

		if ( state !== STATE.NONE ) scope.dispatchEvent( startEvent );

	}

	function touchmove( event ) {

		if ( scope.enabled === false ) return;

		event.preventDefault();
		event.stopPropagation();

		var element = scope.domElement === document ? scope.domElement.body : scope.domElement;

		switch ( event.touches.length ) {

			case 1: // one-fingered touch: rotate

				if ( scope.noRotate === true ) return;
				if ( state !== STATE.TOUCH_ROTATE ) return;

				rotateEnd.set( event.touches[ 0 ].pageX, event.touches[ 0 ].pageY );
				rotateDelta.subVectors( rotateEnd, rotateStart );

				// rotating across whole screen goes 360 degrees around
				scope.rotateLeft( 2 * Math.PI * rotateDelta.x / element.clientWidth * scope.rotateSpeed );
				// rotating up and down along whole screen attempts to go 360, but limited to 180
				scope.rotateUp( 2 * Math.PI * rotateDelta.y / element.clientHeight * scope.rotateSpeed );

				rotateStart.copy( rotateEnd );

				scope.update();
				break;

			case 2: // two-fingered touch: dolly

				if ( scope.noZoom === true ) return;
				if ( state !== STATE.TOUCH_DOLLY ) return;

				var dx = event.touches[ 0 ].pageX - event.touches[ 1 ].pageX;
				var dy = event.touches[ 0 ].pageY - event.touches[ 1 ].pageY;
				var distance = Math.sqrt( dx * dx + dy * dy );

				dollyEnd.set( 0, distance );
				dollyDelta.subVectors( dollyEnd, dollyStart );

				if ( dollyDelta.y > 0 ) {

					scope.dollyOut();

				} else if ( dollyDelta.y < 0 ) {

					scope.dollyIn();

				}

				dollyStart.copy( dollyEnd );

				scope.update();
				break;

			case 3: // three-fingered touch: pan

				if ( scope.noPan === true ) return;
				if ( state !== STATE.TOUCH_PAN ) return;

				panEnd.set( event.touches[ 0 ].pageX, event.touches[ 0 ].pageY );
				panDelta.subVectors( panEnd, panStart );

				scope.pan( panDelta.x, panDelta.y );

				panStart.copy( panEnd );

				scope.update();
				break;

			default:

				state = STATE.NONE;

		}

	}

	function touchend( /* event */ ) {

		if ( scope.enabled === false ) return;

		scope.dispatchEvent( endEvent );
		state = STATE.NONE;

	}

	this.domElement.addEventListener( 'contextmenu', function ( event ) { event.preventDefault(); }, false );
	this.domElement.addEventListener( 'mousedown', onMouseDown, false );
	this.domElement.addEventListener( 'mousewheel', onMouseWheel, false );
	this.domElement.addEventListener( 'DOMMouseScroll', onMouseWheel, false ); // firefox

	this.domElement.addEventListener( 'touchstart', touchstart, false );
	this.domElement.addEventListener( 'touchend', touchend, false );
	this.domElement.addEventListener( 'touchmove', touchmove, false );

	window.addEventListener( 'keydown', onKeyDown, false );

	// force an update at start
	this.update();

};

THREE.OrbitControls.prototype = Object.create( THREE.EventDispatcher.prototype );
THREE.OrbitControls.prototype.constructor = THREE.OrbitControls;

var THREEx	= THREEx || {}

THREEx.RendererStats	= function (){

	var msMin	= 100;
	var msMax	= 0;

	var container	= document.createElement( 'div' );
	container.style.cssText = 'width:80px;opacity:0.9;cursor:pointer';

	var msDiv	= document.createElement( 'div' );
	msDiv.style.cssText = 'padding:0 0 3px 3px;text-align:left;background-color:#200;';
	container.appendChild( msDiv );

	var msText	= document.createElement( 'div' );
	msText.style.cssText = 'color:#f00;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px';
	msText.innerHTML= 'WebGLRenderer';
	msDiv.appendChild( msText );
	
	var msTexts	= [];
	var nLines	= 9;
	for(var i = 0; i < nLines; i++){
		msTexts[i]	= document.createElement( 'div' );
		msTexts[i].style.cssText = 'color:#f00;background-color:#311;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px';
		msDiv.appendChild( msTexts[i] );		
		msTexts[i].innerHTML= '-';
	}


	var lastTime	= Date.now();
	return {
		domElement: container,

		update: function(webGLRenderer){
			// sanity check
			console.assert(webGLRenderer instanceof THREE.WebGLRenderer)

			// refresh only 30time per second
			if( Date.now() - lastTime < 1000/30 )	return;
			lastTime	= Date.now()

			var i	= 0;
			msTexts[i++].textContent = "== Memory =====";
			msTexts[i++].textContent = "Programs: "	+ webGLRenderer.info.memory.programs;
			msTexts[i++].textContent = "Geometries: "+webGLRenderer.info.memory.geometries;
			msTexts[i++].textContent = "Textures: "	+ webGLRenderer.info.memory.textures;

			msTexts[i++].textContent = "== Render =====";
			msTexts[i++].textContent = "Calls: "	+ webGLRenderer.info.render.calls;
			msTexts[i++].textContent = "Vertices: "	+ webGLRenderer.info.render.vertices;
			msTexts[i++].textContent = "Faces: "	+ webGLRenderer.info.render.faces;
			msTexts[i++].textContent = "Points: "	+ webGLRenderer.info.render.points;
		}
	}	
};