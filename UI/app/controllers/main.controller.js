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
		'$timeout',
        function($scope, ModelService, DeformedService, SpaceService,leftMenuService,PtoSelecService,LineaSelecService,$timeout){
		
			//--- splash-screen
			setTimeout(function() {
			   document.getElementById("splash").className += "fadeOut animated";
			}, 500);
			setTimeout(function() {
			   document.getElementById("splash").style.display = "none";
			}, 1000);

			//--- Defino función de inicialización
			function init() {

				//Obtengo el viewport (donde se dibuja)
				viewport = document.getElementById( 'viewport' );
				
				viewportWidth=$("#viewportContainer").width();
				viewportHeight=(window.innerHeight-53);

				//Seteo la camara
				camera = new THREE.PerspectiveCamera( 60, viewportWidth / viewportHeight, 1, 1000 );
				camera.position.y = 10;
				camera.near = 0.1;

				//Asigno controles de la camara
				controls = new THREE.OrbitControls( camera, viewport );
				controls.damping = 0.1;
				controls.addEventListener( 'change', render );

				//Creo la escena dentro del viewport, pongo grilla auxiliar
				$scope.scene = new THREE.Scene();
				grid = new THREE.GridHelper( 100, 1 );
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

				renderer = new THREE.WebGLRenderer( { antialiasing: true } );
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
							miPuntoEscena.material= new THREE.MeshBasicMaterial( {color: 0x000000} );
							PtoSelecService.resetPuntoSeleccionado();
						}
						if(miLineaSelec != null){
							var miLineaEscena= SpaceService.getSceneLineById(miLineaSelec.sceneId,$scope.scene);
							miLineaEscena.material= new THREE.MeshBasicMaterial( {color: 0x000000} );
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
								intersected.material=new THREE.MeshBasicMaterial( {color: 0x000000} );
							}
							intersected=intersection[0].object;
							intersection[0].object.material = new THREE.MeshBasicMaterial( {color: 0x0084ca} );//Resalto
						}
					}else{// Si no esta intersectando ninguno desmarco el anterior
						if(intersected !=null){
							if(PtoSelecService.getPunto().sceneId != intersected.id
								&& LineaSelecService.getLinea().sceneId != intersected.id && idFirstPoint != intersected.id){
								
								if(intersected != null){// Si tenia alguno que no este resaltado por seleccion lo paso a la normalidad
									intersected.material=new THREE.MeshBasicMaterial( {color: 0x000000} );
								}
							}
						}
						intersected=null;
					}

				}else{
					if(intersected != null){
						intersected.material=new THREE.MeshBasicMaterial( {color: 0x000000} );
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
				

				if ((event.button == 0) && (mouseX == event.clientX) && (mouseY == event.clientY)){
					
				 var vector = new THREE.Vector3( ( 
					(event.clientX-offsetIzq) / viewportWidth) * 2 - 1, 
					- ( (event.clientY-53) / (viewportHeight) ) * 2 + 1, 
					0.5 
				);
				
				vector.unproject( camera );

				var ray = new THREE.Raycaster( camera.position, vector.sub( camera.position ).normalize() );

				//FUNCION OBTENGO punto seleccionado
				if(leftMenuService.getSelecting()){// Si esta en modo seleccion
					var pointIntersection = ray.intersectObjects($scope.spaceAux.scenePoints);
					var puntoModeloSelec;
					if(pointIntersection.length > 0){
						puntoModeloSelec=ModelService.getPointBySceneId(pointIntersection[0].object.id,$scope.model);
						if(PtoSelecService.getPunto().id != puntoModeloSelec.id){// Si el punto no esta seleccionado lo prendo
							if(PtoSelecService.getPunto().sceneId != 0){// Si habia un punto seleccionado lo apago
								SpaceService.getScenePointById(PtoSelecService.getPunto().sceneId,$scope.scene).material = new THREE.MeshBasicMaterial( {color: 0x000000} );
							}
							PtoSelecService.setPunto(puntoModeloSelec);
							pointIntersection[0].object.material = new THREE.MeshBasicMaterial( {color: 0x088A08} );
						}else{// Si el punto estaba seleccionado lo des selecciono
							PtoSelecService.resetPuntoSeleccionado();
							pointIntersection[0].object.material = new THREE.MeshBasicMaterial( {color: 0x000000} );
						}
						PtoSelecService.resetForm();
						$scope.$apply();//Es necesario avisarle a angular que cambiamos el puntoSeleccionado
						//alert('Seleccionado!! id: ' + PtoSelecService.getPunto().id);
					}
				}
				//-----------------------------------------------------------------------------------------------------

				//FUNCION OBTENGO linea seleccionada
				if(leftMenuService.getSelecting()){// Si esta en modo seleccion
					var lineIntersection = ray.intersectObjects($scope.spaceAux.sceneLines);
					var lineaModeloSelec;
					if(lineIntersection.length >0){
						lineaModeloSelec=ModelService.getLineBySceneId(lineIntersection[0].object.id,$scope.model);
						if(LineaSelecService.getLinea().id != lineaModeloSelec.id){// Si la linea no esta seleccionado lo prendo
							if(LineaSelecService.getLinea().sceneId != 0){// Si habia una linea seleccionada la apago
								SpaceService.getSceneLineById(LineaSelecService.getLinea().sceneId,$scope.scene).material = new THREE.MeshBasicMaterial( {color: 0x000000} );
							}
							LineaSelecService.setLinea(lineaModeloSelec);
							lineIntersection[0].object.material = new THREE.MeshBasicMaterial( {color: 0x088A08} );
						
						}else{// Si la linea estaba seleccionada la des selecciono
							LineaSelecService.resetLineaSeleccionada();
							lineIntersection[0].object.material = new THREE.MeshBasicMaterial( {color: 0x000000} );
						}
					LineaSelecService.resetForm();
					$scope.$apply();
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
							var newNodeId=SpaceService.drawPoint(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, $scope.scene, $scope.spaceAux.scenePoints, new THREE.LineBasicMaterial({color: 0x000000}) , $scope.spaceAux.helpObjects.grilla);
							ModelService.addPointToModel(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, newNodeId, $scope.model);
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
								intersects[0].object.material = new THREE.MeshBasicMaterial( {color: 0x8B0000} );
								intersects[0].object.geometry = new THREE.SphereGeometry( 0.15, 10, 10 );
								
							} else {
								var lineSceneId = SpaceService.drawLine(firstPointLine.x, firstPointLine.y, firstPointLine.z, intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, new THREE.LineBasicMaterial({color: 0x000000}), 0.035, $scope.scene,$scope.spaceAux.sceneLines);
								ModelService.addLineToModel(firstPointLine.x, firstPointLine.y, firstPointLine.z, intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, lineSceneId,$scope.model);
								SpaceService.getScenePointById(idFirstPoint, $scope.scene).material = new THREE.MeshBasicMaterial( {color: 0x000000} );
								SpaceService.getScenePointById(idFirstPoint, $scope.scene).geometry = new THREE.SphereGeometry( 0.1, 10, 10 );
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
				
				var miGridInfo=ModelService.createGridInfo($scope.model.helpObjects.grillas);
				var line, geometry, i, j;

				var material = new THREE.LineBasicMaterial({color: 0xFF0000, transparent: true, opacity: 0.15});
				
				for (i=0; i < $scope.largoY * $scope.separatorY ; i = i + $scope.separatorY){
					for (j=0; j < $scope.largoX * $scope.separatorX; j = j + $scope.separatorX){
						var sceneIdGridLine=SpaceService.drawLine($scope.posX + j, $scope.posY + i, $scope.posZ, $scope.posX + j, $scope.posY + i, $scope.posZ + ($scope.largoZ - 1) * $scope.separatorZ, material, 0.01, $scope.scene,null);
						ModelService.addGridLineToModel($scope.posX + j, $scope.posY + i, $scope.posZ, $scope.posX + j, $scope.posY + i, $scope.posZ + ($scope.largoZ - 1) * $scope.separatorZ, sceneIdGridLine,miGridInfo);
					}
					for (j=0; j < $scope.largoZ * $scope.separatorZ; j = j + $scope.separatorZ){
						var sceneIdGridLine=SpaceService.drawLine($scope.posX, $scope.posY + i, $scope.posZ + j, $scope.posX + ($scope.largoX - 1) * $scope.separatorX, $scope.posY + i, $scope.posZ + j, material, 0.01, $scope.scene,null);
						ModelService.addGridLineToModel($scope.posX, $scope.posY + i, $scope.posZ + j, $scope.posX + ($scope.largoX - 1) * $scope.separatorX, $scope.posY + i, $scope.posZ + j, sceneIdGridLine,miGridInfo);
						for (k=0; k < $scope.largoX * $scope.separatorX; k = k + $scope.separatorX){
							var sphereGeometry = new THREE.SphereGeometry(  0.1, 10, 10  );
							var sphereMaterial = new THREE.MeshBasicMaterial( {color: 0xFF0000, transparent: true, opacity: 0.15} );
							var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
							sphere.position.x = $scope.posX+k;
							sphere.position.y = $scope.posY+i;
							sphere.position.z = $scope.posZ+j;
							$scope.scene.add(sphere);

							ModelService.addGridPointToModel($scope.posX+k,$scope.posY+i,$scope.posZ+j, sphere.id, miGridInfo);
							$scope.spaceAux.helpObjects.grilla.push(sphere);
							if (i > 0){
								var sceneIdGridLine= SpaceService.drawLine($scope.posX + k, $scope.posY + i - $scope.separatorY, $scope.posZ + j, $scope.posX + k, $scope.posY + i, $scope.posZ + j, material, 0.01, $scope.scene,null);
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
			
			//Agrega un punto
			$scope.addPoint = function(){
				var material= new THREE.MeshBasicMaterial( {color: 0x000000} );
				if(SpaceService.getScenePointIdByCoords($scope.posX, $scope.posY, $scope.posZ, $scope.scene)==0){// Se podria usar una funcion mas performante
					var sceneId = SpaceService.drawPoint($scope.posX, $scope.posY, $scope.posZ, $scope.scene, $scope.spaceAux.scenePoints, material, $scope.spaceAux.helpObjects.grilla);
					
					ModelService.addPointToModel($scope.posX, $scope.posY, $scope.posZ, sceneId, $scope.model);
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
				//$scope.validModel = ModelService.validModel($scope.model);
				//if ($scope.validModel.valid){
					$scope.modelText = ModelService.getText($scope.model)

					var a = window.document.createElement('a');
					a.href = window.URL.createObjectURL(new Blob([$scope.modelText], {type: 'text/txt'}));
					a.download = 'model.txt';
					document.body.appendChild(a)
					a.click();
					document.body.removeChild(a)

					$('#obtenerTextoModal').modal('hide');
					$('#transitionModal').modal('show');
				//}		
			}

			$scope.goToDownloadModel = function(){
				$scope.validModel = {};
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
					var beginDisplacementMatrix = text.search("u_z")+5;
					var endDisplacementeMatrix = text.search("Parametros en barras")-3;
					var temp = text.slice(beginDisplacementMatrix, endDisplacementeMatrix).split("\n");

					for (i = 0; i < temp.length; i++) { 
						var row = temp[i].split("\t")
						displacementMatrix.push(row);
					}
					


					var forcesMatrix = [];
					var beginForcesMatrix = text.search("Tension")+9;
					var endForcesMatrix = text.length;
					temp = text.slice(beginForcesMatrix, endForcesMatrix).split("\n");
					for (i = 0; i < temp.length; i++) { 
						row = temp[i].split("\t")
						forcesMatrix.push(row);
					}
					
					for (i = 0; i < displacementMatrix.length; i++) {
						var point = ModelService.getPointById(i+1, $scope.model);

						var displacementX = parseFloat(displacementMatrix[i][0].split("e")[0]) * Math.pow(10,parseFloat(displacementMatrix[i][0].split("e")[1]));
						var displacementY = parseFloat(displacementMatrix[i][1].split("e")[0]) * Math.pow(10,parseFloat(displacementMatrix[i][1].split("e")[1]));
						var displacementZ = parseFloat(displacementMatrix[i][2].split("e")[0]) * Math.pow(10,parseFloat(displacementMatrix[i][2].split("e")[1]));

						var pointX = parseFloat(point.coords.x) + displacementX
						var pointY = parseFloat(point.coords.y) + displacementY
						var pointZ = parseFloat(point.coords.z) + displacementZ

						var sceneId = SpaceService.drawPoint(pointX, pointY, pointZ, $scope.scene, $scope.spaceAux.scenePoints, material, $scope.spaceAux.helpObjects.grilla);

						DeformedService.addPointToDeformed(point.coords.x, point.coords.z, point.coords.y,displacementX, displacementZ, displacementY, point.id, sceneId, $scope.deformed);
					}
					

					for (i = 0; i < forcesMatrix.length; i++) {
						var line = $scope.model.lines[i];
						var point1 = DeformedService.getDeformedPointById(line.start, $scope.deformed);
						var point2 = DeformedService.getDeformedPointById(line.end, $scope.deformed);

						var a1 = parseFloat(point1.coords.x) + parseFloat(point1.displacements.x);
						var a2 = parseFloat(point1.coords.z) + parseFloat(point1.displacements.z);
						var a3 = parseFloat(point1.coords.y) + parseFloat(point1.displacements.y);
						var b1 = parseFloat(point2.coords.x) + parseFloat(point2.displacements.x);
						var b2 = parseFloat(point2.coords.z) + parseFloat(point2.displacements.z);
						var b3 = parseFloat(point2.coords.y) + parseFloat(point2.displacements.y);
						var sceneId=SpaceService.drawLine(a1, a2, a3, b1, b2, b3, material, 0.05, $scope.scene,[]);

						var deformation = parseFloat(forcesMatrix[i][0].split("E")[0]) * Math.pow(10,parseFloat(forcesMatrix[i][0].split("E")[1])); 
						var force = parseFloat(forcesMatrix[i][1].split("E")[0]) * Math.pow(10,parseFloat(forcesMatrix[i][1].split("E")[1])); 
						var tension = parseFloat(forcesMatrix[i][2].split("E")[0]) * Math.pow(10,parseFloat(forcesMatrix[i][2].split("E")[1])); 

						DeformedService.addLineToDeformed(line.start, line.end, line.id, sceneId, deformation, force, tension,$scope.deformed);
					}
					
					$scope.programMode = 'CROSSLINK_OUTPUT';
					$scope.structureView = 'normal';
					$scope.scaleStructure = 1
					$scope.structureColors = 'normal';

					$('#processOutputModal').modal('hide');
					
					render();
				};
				outputReader.readAsText($scope.theFile);

			}

			$scope.startImportModel= function(){
				if($scope.theFile!= null){
					$scope.importing = true;
					$scope.$apply();
					$timeout($scope.importModel,0);// encolamos el llamado a la funcion para dar tiempo a la UI a renderizarse
				}
			}

			$scope.importModel = function(){

				$scope.importing = true;

				var reader = new FileReader();
				reader.onload = function(){
				
					var material = new THREE.MeshBasicMaterial( {color: 0x000000} );
					var text = reader.result;
					
					var nodeMatrix = [];
					var beginNodeMatrix = text.search("Zs")+4;
					var endNodeMatrix = text.search("Conectivity")-3;
					var temp = text.slice(beginNodeMatrix, endNodeMatrix).split("\n");
					for (i = 0; i < temp.length; i++) { 
						var row = temp[i].split("\t")
						for (var j = 0; j < row.length; j++) { 
							row[j] = parseFloat(row[j]);
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
						var sceneId = SpaceService.drawPoint(nodeMatrix[i][0], nodeMatrix[i][2], nodeMatrix[i][1], $scope.scene, $scope.spaceAux.scenePoints, material, $scope.spaceAux.helpObjects.grilla);
						ModelService.addPointToModel(nodeMatrix[i][0], nodeMatrix[i][2], nodeMatrix[i][1], sceneId, $scope.model);
					}

					
					for (i = 0; i < conectivityMatrix.length; i++) {
					
						var a1 = parseFloat(nodeMatrix[conectivityMatrix[i][3]-1][0]);
						var a2 = parseFloat(nodeMatrix[conectivityMatrix[i][3]-1][2]);
						var a3 = parseFloat(nodeMatrix[conectivityMatrix[i][3]-1][1]);
						var b1 = parseFloat(nodeMatrix[conectivityMatrix[i][4]-1][0]);
						var b2 = parseFloat(nodeMatrix[conectivityMatrix[i][4]-1][2]);
						var b3 = parseFloat(nodeMatrix[conectivityMatrix[i][4]-1][1]);
						
						var sceneId=SpaceService.drawLine(a1, a2, a3, b1, b2, b3, new THREE.LineBasicMaterial({color: 0x000000}), 0.05, $scope.scene,$scope.spaceAux.sceneLines);
						
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
				
				$scope.model = {helpObjects: {}};
				$scope.model.points = [];
				$scope.model.lines = [];
				$scope.model.materiales = [];
				$scope.model.secciones= [];

				$scope.spaceAux={helpObjects: {}};
				$scope.spaceAux.helpObjects.grilla = [];
				$scope.spaceAux.scenePoints = [];
				$scope.spaceAux.sceneLines = [];

				$scope.deformed = {};
				$scope.deformed.points = [];
				$scope.deformed.lines = [];

				$scope.programMode = 'CROSSLINK_INPUT';

				ModelService.addMaterial("Hormigon",1,1,1,1,$scope.model);
				ModelService.addMaterial("Metal",0,0,0,0,$scope.model);

				$(modal).modal('hide');

				//Creo la escena dentro del viewport, pongo grilla auxiliar
				$scope.scene = new THREE.Scene();
				grid = new THREE.GridHelper( 100, 1 );
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

			$scope.openModel = function(){

				var reader = new FileReader();
				reader.onload = function(){
				
					$scope.newModel();
					var text = reader.result;
					$scope.model = angular.fromJson(text);
					
					SpaceService.drawModel($scope.scene,$scope.model, $scope.spaceAux.scenePoints, $scope.spaceAux.sceneLines);

					render();

					$('#openModelModal').modal('hide');

				};
				reader.readAsText($scope.theFile);
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

			$scope.fuerzas={visible:false};
			$scope.supports={visible:false};

			$scope.model = {helpObjects: {}};
			$scope.model.points = [];
			$scope.model.lines = [];
			$scope.model.materiales = [];
			$scope.model.secciones= [];		

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

			ModelService.addMaterial("Hormigon",1,1,1,1,$scope.model);
			ModelService.addMaterial("Metal",0,0,0,0,$scope.model);
			
			// --- Inicializa escena
			init();
			render();
			
		}
	]);
