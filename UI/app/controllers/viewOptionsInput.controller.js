var app = angular.module('IETFEM');
app.controller('viewOptionsInputCntrl',['$scope','ModelService','SpaceService',function($scope,ModelService,SpaceService){

	$scope.gridInfos= $scope.model.helpObjects.grillas; // gridInfos de las grillas del espacio
	var fuerzasVisibles=false;

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

	$scope.toggleForces = function(){
		
		if(!fuerzasVisibles){// Genera las flechas de todos los puntos, si ya tenia la regenera
			for(var i = 0; i < $scope.model.points.length ;i++){
				var punto=$scope.model.points[i];
				if(punto.xForce !=0 || punto.yForce !=0 || punto.zForce !=0){
					var origen= new THREE.Vector3( punto.coords.x, punto.coords.y, punto.coords.z );
					var largo= Math.sqrt( Math.pow(punto.xForce,2) + Math.pow(punto.yForce,2) + Math.pow(punto.zForce,2));
					var direccion = new THREE.Vector3( punto.xForce/ largo, punto.yForce/largo, punto.zForce/largo );
					var newArrow=new THREE.ArrowHelper(direccion, origen, largo, 0x000000);
					if(punto.forceArrowId != 0){// Si ya tenia la flecha generada la borro para crear la nueva
						SpaceService.removeObjectById(punto.forceArrowId,$scope.scene);
					}
					punto.forceArrowId= newArrow.id;
					$scope.scene.add(newArrow);
				}
			}
			$scope.render();
			fuerzasVisibles=true;
		}else{
			for(var i = 0; i < $scope.model.points.length ;i++){//Esconde todas las flechas
				var punto=$scope.model.points[i];
				SpaceService.hideShowObject(punto.forceArrowId,false,$scope.scene);
			}
			fuerzasVisibles=false;
			$scope.render();
		}

	};


}]);