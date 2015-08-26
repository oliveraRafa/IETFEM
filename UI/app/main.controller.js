(function(){
var app = angular.module('IETFEM', []);
app.controller(
    'mainCtrl',
	[	'$scope',
		'ModelService',
		'SpaceService',
		'leftMenuService',
		'PtoSelecService',
        function($scope, ModelService, SpaceService,leftMenuService,PtoSelecService){
		
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

				renderer = new THREE.WebGLRenderer( { antialiasing: true } );
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
				
				//UI staff
				setMenuIzqSize();
				$(function () {// Activa el plugin de los ToolTips
				  $('[data-toggle="tooltip"]').tooltip()
				})

			}

			//--- Defino función de Render
			function render() {

				renderer.render( scene, camera );
					
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
				viewportHeight=(window.innerHeight-46);

				camera.aspect = viewportWidth / viewportHeight;
				camera.updateProjectionMatrix();

				renderer.setSize( $("#viewportContainer").width(), window.innerHeight-46 );

				render();

				setMenuIzqSize();
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
				viewportHeight=(window.innerHeight-46);
				offsetIzq=$("#menuIzquierda").outerWidth(true);
				

				if ((event.button == 0) && (mouseX == event.clientX) && (mouseY == event.clientY)){
					
				 var vector = new THREE.Vector3( ( 
					(event.clientX-offsetIzq) / viewportWidth) * 2 - 1, 
					- ( (event.clientY-46) / (viewportHeight) ) * 2 + 1, 
					0.5 
				);
				
				vector.unproject( camera );

				var ray = new THREE.Raycaster( camera.position, vector.sub( camera.position ).normalize() );

				//FUNCION OBTENGO punto seleccionado
				if(leftMenuService.getSelecting()){
					var pointIntersection = ray.intersectObjects(puntosEscena);
					
					if(pointIntersection.length > 0){
						PtoSelecService.setPunto(ModelService.getPointById(pointIntersection[0].object.id,model));
						PtoSelecService.resetForm();
						$scope.$apply();//Es necesario avisarle a angular que cambiamos el puntoSeleccionado
						alert('Seleccionado!! id: ' + PtoSelecService.getPunto().id);
					}
				}
				//----------------------------------
				
				var intersects = ray.intersectObjects( helpObjects );
				if ( intersects.length > 0 ) {
					
					if (!leftMenuService.getAddingLines() && leftMenuService.getAddingNodes()){
						//Agrego el punto
						intersects[0].object.material = new THREE.MeshBasicMaterial( {color: 0x000000} );
						ModelService.addPointToModel(intersects[0].object.position.x, intersects[0].object.position.y, intersects[0].object.position.z, intersects[0].object.id, model);
						puntosEscena.push(intersects[0].object);	
					} else if(leftMenuService.getAddingLines() && !leftMenuService.getAddingNodes()){
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
				SpaceService.drawPoint($scope.posX, $scope.posY, $scope.posZ, scene, puntosEscena, helpObjects);
				
				var sceneId = SpaceService.getScenePointIdByCoords($scope.posX, $scope.posY, $scope.posZ, scene);
				ModelService.addPointToModel($scope.posX, $scope.posY, $scope.posZ, sceneId, model);
				render();
				//Reseteo form
				$scope.nodoCoordenadaForm.$setPristine();
				$scope.posX=undefined;
				$scope.posY=undefined;
				$scope.posZ=undefined;
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
						SpaceService.drawPoint(nodeMatrix[i][0], nodeMatrix[i][2], nodeMatrix[i][1], scene, puntosEscena, helpObjects);
						var sceneId = SpaceService.getScenePointIdByCoords(nodeMatrix[i][0], nodeMatrix[i][2], nodeMatrix[i][1], scene);
						ModelService.addPointToModel(nodeMatrix[i][0], nodeMatrix[i][2], nodeMatrix[i][1], sceneId, model);
						console.log(i+'/'+nodeMatrix.length);
					}
					
					for (i = 0; i < conectivityMatrix.length; i++) {
					
						var a1 = parseInt(nodeMatrix[conectivityMatrix[i][3]-1][0]);
						var a2 = parseInt(nodeMatrix[conectivityMatrix[i][3]-1][2]);
						var a3 = parseInt(nodeMatrix[conectivityMatrix[i][3]-1][1]);
						var b1 = parseInt(nodeMatrix[conectivityMatrix[i][4]-1][0]);
						var b2 = parseInt(nodeMatrix[conectivityMatrix[i][4]-1][2]);
						var b3 = parseInt(nodeMatrix[conectivityMatrix[i][4]-1][1]);
						SpaceService.drawLine(a1, a2, a3, b1, b2, b3, new THREE.LineBasicMaterial({color: 0x000000}), 0.05, scene);
						
						ModelService.addLineToModel(a1, a2, a3, b1, b2, b3, model);
						console.log(i+'/'+conectivityMatrix.length);
					}
						
					render();
				};
				reader.readAsText($scope.theFile);
			}
			
			setFile = function(element) {
					$scope.theFile = element.files[0];
					console.log($scope.theFile)
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
			
			// --- Inicializa variables
			var viewport, viewportWidth, viewportHeight, puntoSeleccionado;	
			var camera, controls, scene, renderer, tridimensional, grid;
			var mouseX,  mouseY;
			
			
			var firstPointLine = null;
			var idFirstPoint = 0;
			var helpObjects = [];
			var puntosEscena = [];
			var model = {};
			model.points = [];
			model.lines = [];
			
			
			// --- Inicializa escena
			
			init();
			render();
			
		}
	]);

	app.controller('leftMenusCtrl',['$scope','leftMenuService',function($scope,leftMenuService){
		
		$scope.dibujarNodos = function(){
			leftMenuService.setAddingLines(false);
			leftMenuService.setAddingNodes(true);
			leftMenuService.setAddingGrillas(false);
			leftMenuService.setSelecting(false);
		};

		$scope.dibujarLineas = function(){
			leftMenuService.setAddingLines(true);
			leftMenuService.setAddingNodes(false);
			leftMenuService.setAddingGrillas(false);
			leftMenuService.setSelecting(false);
		};

		$scope.dibujarGrillas = function(){
			leftMenuService.setAddingLines(false);
			leftMenuService.setAddingNodes(false);
			leftMenuService.setAddingGrillas(true);
			leftMenuService.setSelecting(false);
		};

		$scope.seleccionar = function(){
			leftMenuService.setAddingLines(false);
			leftMenuService.setAddingNodes(false);
			leftMenuService.setAddingGrillas(false);
			leftMenuService.setSelecting(true);
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


	}]);

	app.service('leftMenuService',function(){
		var addingLines = false;
		var addingNodes=false;
		var addingGrillas=false;
		var selecting=false;

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
			}
		}
	});
	
	app.controller('editPointCtrl',['$scope','ModelService','PtoSelecService',function($scope,ModelService,PtoSelecService){
		$scope.miPunto=PtoSelecService.getPunto();//Es una copia del punto del modelo!
		this.updated= function(){
			var puntoModelo= PtoSelecService.getPuntoReal();
			if( typeof puntoModelo != 'undefined' &&
				puntoModelo.xCondicion== $scope.miPunto.xCondicion &&
				puntoModelo.yCondicion== $scope.miPunto.yCondicion &&
				puntoModelo.zCondicion== $scope.miPunto.zCondicion &&
				puntoModelo.xForce== $scope.miPunto.xForce &&
				puntoModelo.yForce== $scope.miPunto.yForce &&
				puntoModelo.zForce== $scope.miPunto.zForce
			){
				return true;
			}else{
				
				return false;
			}
		};
		
		this.updatePoint= function(){
			var puntoModelo= PtoSelecService.getPuntoReal();
			PtoSelecService.setInfoPuntoForm($scope.infoPuntoForm);
			if(typeof puntoModelo != 'undefined'){
				puntoModelo.xCondicion= $scope.miPunto.xCondicion;
				puntoModelo.yCondicion= $scope.miPunto.yCondicion;
				puntoModelo.zCondicion= $scope.miPunto.zCondicion;

				puntoModelo.xForce= $scope.miPunto.xForce;
				puntoModelo.yForce= $scope.miPunto.yForce;
				puntoModelo.zForce= $scope.miPunto.zForce;
				PtoSelecService.resetForm();
			}
		};		

	}]);
	
	app.service('PtoSelecService', function(){
  		var puntoSeleccionado={
			  id:0,
			  sceneId:0,
			  xCondicion:0,
			  yCondicion:0,
			  zCondicion:0,
			  xForce:0,
			  yForce:0,
			  zForce:0,
			  coords: {
					x: 0,
					y: 0,
					z: 0
				}
		  };

		var puntoReal;
		var infoPuntoForm;
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
				puntoSeleccionado.coords=value.coords;
			},
			setInfoPuntoForm: function(f){
				infoPuntoForm=f;
			},
			resetForm: function(){
				if(typeof infoPuntoForm != 'undefined'){
				    infoPuntoForm.$setPristine();
			   }
			}
		}
	});
	
	
})();
