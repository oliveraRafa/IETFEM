var app = angular.module('IETFEM');
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