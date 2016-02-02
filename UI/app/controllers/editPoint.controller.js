var app = angular.module('IETFEM');
	app.controller('editPointCtrl',['$scope','ModelService','PtoSelecService','SpaceService',function($scope,ModelService,PtoSelecService,SpaceService){
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