var app = angular.module('IETFEM');
app.controller('leftMenusCtrl',['$scope','leftMenuService','PtoSelecService',function($scope,leftMenuService,PtoSelecService){
		
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