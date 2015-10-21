var app = angular.module('IETFEM');
	app.controller('editPointCtrl',['$scope','ModelService','PtoSelecService','SpaceService',function($scope,ModelService,PtoSelecService,SpaceService){
		$scope.miPunto=PtoSelecService.getPunto();//Es una copia del punto del modelo!
		$scope.statusFuerzas=$scope.fuerzas;
		$scope.statusSupports=$scope.supports;


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

				puntoModelo.xForce= parseFloat($scope.miPunto.xForce)/$scope.statusFuerzas.escala;
				puntoModelo.yForce= parseFloat($scope.miPunto.yForce)/$scope.statusFuerzas.escala;
				puntoModelo.zForce= parseFloat($scope.miPunto.zForce)/$scope.statusFuerzas.escala;

				//Actualizo flecha de fuerzas del nodo
				if($scope.statusFuerzas.visible){
					var origen= new THREE.Vector3( puntoModelo.coords.x-puntoModelo.xForce, puntoModelo.coords.y-puntoModelo.yForce, puntoModelo.coords.z-puntoModelo.zForce );
					var largo= Math.sqrt( Math.pow(puntoModelo.xForce,2) + Math.pow(puntoModelo.yForce,2) + Math.pow(puntoModelo.zForce,2))-0.1;
					var direccion = new THREE.Vector3( puntoModelo.xForce/ (largo+0.1), puntoModelo.yForce/ (largo+0.1), puntoModelo.zForce/(largo+0.1) );
					var newArrow=new THREE.ArrowHelper(direccion, origen, largo, 0x0B3B17);
					if(puntoModelo.forceArrowId != 0){// Si ya tenia la flecha generada la borro para crear la nueva
						SpaceService.removeObjectById(puntoModelo.forceArrowId,$scope.scene);
					}
					puntoModelo.forceArrowId= newArrow.id;
					$scope.scene.add(newArrow);
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