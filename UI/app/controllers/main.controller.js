var app = angular.module('IETFEM', []);
app.controller(
    'mainCtrl',
	[	'$scope',
		'ModelService',
		'SpaceService',
		'leftMenuService',
		'PtoSelecService',
		'LineaSelecService',
        function($scope, ModelService, SpaceService,leftMenuService,PtoSelecService,LineaSelecService){
		
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

				//Asigno controles de la camara
				controls = new THREE.OrbitControls( camera, viewport );
				controls.damping = 0.1;
				controls.addEventListener( 'change', render );

				//Creo la escena dentro del viewport, pongo grilla auxiliar
				$scope.scene = new THREE.Scene();
				grid = new THREE.GridHelper( 1000, 1 );
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

				renderer.render( $scope.scene, camera );
					
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
					var pointIntersection = ray.intersectObjects(puntosEscena);
					var puntoModeloSelec;
					if(pointIntersection.length > 0){
						puntoModeloSelec=ModelService.getPointById(pointIntersection[0].object.id,$scope.model);
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
					var lineIntersection = ray.intersectObjects(lineasEscena);
					var lineaModeloSelec;
					if(lineIntersection.length >0){
						lineaModeloSelec=ModelService.getLineById(lineIntersection[0].object.id,$scope.model);
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

				var intersects = ray.intersectObjects( helpObjects );
				if ( intersects.length > 0 ) {
					
					if (!leftMenuService.getAddingLines() && leftMenuService.getAddingNodes()){
						//Agrego el punto
						if(!$scope.yaExistePuntoCoords(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z)){
							intersects[0].object.material = new THREE.MeshBasicMaterial( {color: 0x000000} );
							ModelService.addPointToModel(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, intersects[0].object.id, $scope.model);
							puntosEscena.push(intersects[0].object);	
						}
					} else if(leftMenuService.getAddingLines() && !leftMenuService.getAddingNodes()){
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
								var lineSceneId = SpaceService.drawLine(firstPointLine.x, firstPointLine.y, firstPointLine.z, intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, new THREE.LineBasicMaterial({color: 0x000000}), 0.035, $scope.scene,lineasEscena);
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
				
				var line, geometry, i, j;

				var material = new THREE.LineBasicMaterial({color: 0xFF0000, transparent: true, opacity: 0.15});
				
				for (i=0; i < $scope.largoY * $scope.separatorY ; i = i + $scope.separatorY){
					for (j=0; j < $scope.largoX * $scope.separatorX; j = j + $scope.separatorX){
						SpaceService.drawLine($scope.posX + j, $scope.posY + i, $scope.posZ, $scope.posX + j, $scope.posY + i, $scope.posZ + ($scope.largoZ - 1) * $scope.separatorZ, material, 0.01, $scope.scene,null)
					}
					for (j=0; j < $scope.largoZ * $scope.separatorZ; j = j + $scope.separatorZ){
						SpaceService.drawLine($scope.posX, $scope.posY + i, $scope.posZ + j, $scope.posX + ($scope.largoX - 1) * $scope.separatorX, $scope.posY + i, $scope.posZ + j, material, 0.01, $scope.scene,null)
						for (k=0; k < $scope.largoX * $scope.separatorX; k = k + $scope.separatorX){
							var sphereGeometry = new THREE.SphereGeometry(  0.1, 10, 10  );
							var sphereMaterial = new THREE.MeshBasicMaterial( {color: 0xFF0000, transparent: true, opacity: 0.15} );
							var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
							sphere.position.x = $scope.posX+k
							sphere.position.y = $scope.posY+i
							sphere.position.z = $scope.posZ+j
							$scope.scene.add(sphere);
							helpObjects.push(sphere);
							if (i > 0){
								SpaceService.drawLine($scope.posX + k, $scope.posY + i - $scope.separatorY, $scope.posZ + j, $scope.posX + k, $scope.posY + i, $scope.posZ + j, material, 0.01, $scope.scene,null)
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
			
			};
			
			//Agrega un punto
			$scope.addPoint = function(){
				if(SpaceService.getScenePointIdByCoords($scope.posX, $scope.posY, $scope.posZ, $scope.scene)==0){// Se podria usar una funcion mas performante
					var sceneId = SpaceService.drawPoint($scope.posX, $scope.posY, $scope.posZ, $scope.scene, puntosEscena, helpObjects);
					
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
				$scope.validModel = {};
				$('#obtenerTextoModal').modal('show');
			}

			$scope.goToProcessOutput = function(){
				$('#transitionModal').modal('hide');
				$('#processOutputModal').modal('show');
			}

			$scope.processOutput = function(){

				//Aca hay que hacer la importacion

				$scope.programMode = 'CROSSLINK_OUTPUT';

				$('#processOutputModal').modal('hide');
			}

			$scope.importModel = function(){

				var reader = new FileReader();
				reader.onload = function(){
				
					var text = reader.result;
					
					var nodeMatrix = [];
					var beginNodeMatrix = text.search("Zs")+4;
					var endNodeMatrix = text.search("Conectivity")-3;
					var temp = text.slice(beginNodeMatrix, endNodeMatrix).split("\n");
					for (i = 0; i < temp.length; i++) { 
						var row = temp[i].split("\t")
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
						var sceneId = SpaceService.drawPoint(nodeMatrix[i][0], nodeMatrix[i][2], nodeMatrix[i][1], $scope.scene, puntosEscena, helpObjects);
						ModelService.addPointToModel(nodeMatrix[i][0], nodeMatrix[i][2], nodeMatrix[i][1], sceneId, $scope.model);
						console.log(i+'/'+nodeMatrix.length);
					}
					
					for (i = 0; i < conectivityMatrix.length; i++) {
					
						var a1 = parseInt(nodeMatrix[conectivityMatrix[i][3]-1][0]);
						var a2 = parseInt(nodeMatrix[conectivityMatrix[i][3]-1][2]);
						var a3 = parseInt(nodeMatrix[conectivityMatrix[i][3]-1][1]);
						var b1 = parseInt(nodeMatrix[conectivityMatrix[i][4]-1][0]);
						var b2 = parseInt(nodeMatrix[conectivityMatrix[i][4]-1][2]);
						var b3 = parseInt(nodeMatrix[conectivityMatrix[i][4]-1][1]);
						
						var sceneId=SpaceService.drawLine(a1, a2, a3, b1, b2, b3, new THREE.LineBasicMaterial({color: 0x000000}), 0.05, $scope.scene,lineasEscena);
						
						ModelService.addLineToModel(a1, a2, a3, b1, b2, b3,sceneId, $scope.model);
						console.log(i+'/'+conectivityMatrix.length);
					}
						
					render();
				};
				reader.readAsText($scope.theFile);
			}
			
			setFile = function(element) {
					$scope.theFile = element.files[0];
			};

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
			
			// --- Inicializa variables
			var viewport, viewportWidth, viewportHeight;	
			var camera, controls, renderer, tridimensional, grid;
			var mouseX,  mouseY;

			$scope.scene;
			
			var firstPointLine = null;
			var idFirstPoint = 0;
			var helpObjects = [];
			var puntosEscena = [];
			var lineasEscena = [];
			$scope.model = {};
			$scope.model.points = [];
			$scope.model.lines = [];
			$scope.model.materiales = [];
			$scope.model.secciones= [];
			$scope.programMode = 'CROSSLINK_INPUT';

			$scope.render=render;

			ModelService.addMaterial("Oro",1,1,1,1,$scope.model);
			ModelService.addMaterial("Plata",0,0,0,0,$scope.model);
			
			// --- Inicializa escena
			init();
			render();
			
		}
	]);
