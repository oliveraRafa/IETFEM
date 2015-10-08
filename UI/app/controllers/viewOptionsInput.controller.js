var app = angular.module('IETFEM');
app.controller('viewOptionsInputCntrl',['$scope','ModelService','SpaceService',function($scope,ModelService,SpaceService){

	$scope.gridInfos= $scope.model.helpObjects.grillas; // gridInfos de las grillas del espacio
	$scope.statusFuerzas=$scope.fuerzas;
	$scope.statusSupports=$scope.supports;

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
		
		if(!$scope.statusFuerzas.visible){// Genera las flechas de todos los puntos, si ya tenia la regenera
			for(var i = 0; i < $scope.model.points.length ;i++){
				var punto=$scope.model.points[i];
				if(punto.xForce !=0 || punto.yForce !=0 || punto.zForce !=0){
					var origen= new THREE.Vector3( punto.coords.x-punto.xForce, punto.coords.y-punto.yForce, punto.coords.z-punto.zForce );
					var largo= Math.sqrt( Math.pow(punto.xForce,2) + Math.pow(punto.yForce,2) + Math.pow(punto.zForce,2))-0.1;
					var direccion = new THREE.Vector3( punto.xForce/ (largo+0.1), punto.yForce/(largo+0.1), punto.zForce/(largo+0.1) );
					var newArrow=new THREE.ArrowHelper(direccion, origen, largo, 0x0B3B17);
					if(punto.forceArrowId != 0){// Si ya tenia la flecha generada la borro para crear la nueva
						SpaceService.removeObjectById(punto.forceArrowId,$scope.scene);
					}
					punto.forceArrowId= newArrow.id;
					$scope.scene.add(newArrow);
				}
			}
			$scope.statusFuerzas.visible=true;
			$scope.render();
		}else{
			for(var i = 0; i < $scope.model.points.length ;i++){//Esconde todas las flechas
				var punto=$scope.model.points[i];
				if(punto.forceArrowId!=0){
					SpaceService.hideShowObject(punto.forceArrowId,false,$scope.scene);
				}
			}
			$scope.statusFuerzas.visible=false;
			$scope.render();
		}

	};
	
	$scope.toggleSupports = function(){
		if(!$scope.statusSupports.visible){
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
			$scope.statusSupports.visible=true;
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
			$scope.statusSupports.visible=false;
			$scope.render();
		}
	};

	$(function() {
	    $('#toggle-event').change(function() {
	      $scope.toggleForces();
	    });
	    $('#toggle-event2').change(function() {
	      $scope.toggleSupports();
	    })

	  });
	
	$scope.toggleForces();
	$scope.toggleSupports();

}]);