var app = angular.module('IETFEM');
app.controller('viewOptionsInputCntrl',['$scope','ModelService','SpaceService',function($scope,ModelService,SpaceService){

	$scope.gridInfos= $scope.model.helpObjects.grillas; // gridInfos de las grillas del espacio
	$scope.statusFuerzas=$scope.fuerzas;
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
				var largo= Math.sqrt( Math.pow(xForce,2) + Math.pow(yForce,2) + Math.pow(zForce,2))-0.1;
				if(largo > maxFuerza){
					maxFuerza=largo;
				}
			}
		}
		return maxFuerza;
	};

	$scope.toggleForces = function(){
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

					var fuerzaMaxima= getMaxForce();
					largo= (largo * $scope.fuerzas.escala.maxModule) / fuerzaMaxima;
					largo= largo / $scope.fuerzas.escala.factorEscala;

					var aux= ($scope.fuerzas.escala.maxModule) / (fuerzaMaxima * $scope.fuerzas.escala.factorEscala);
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