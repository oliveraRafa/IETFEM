var app = angular.module('IETFEM');
	app.controller('editOutputCtrl',['$scope','ModelService', 'DeformedService', function($scope, ModelService, DeformedService){
	
	$scope.scaleStructureAux=1;

	$scope.$watch('structureView', function() {
	    if ($scope.structureView === 'normal'){
	    	ModelService.setModelOpaque($scope.scene, $scope.model);
	    	DeformedService.setDeformedTransparent($scope.scene, $scope.deformed);
	    	$scope.structureColors = 'normal'
	    } else {
	    	ModelService.setModelTransparent($scope.scene, $scope.model);
	    	DeformedService.setDeformedOpaque($scope.scene, $scope.deformed);
	    }
	    $scope.render();
	});	

	$scope.$watch('scaleStructure', function() {
	    DeformedService.scaleDeformed($scope.scene, $scope.deformed, $scope.model, $scope.scaleStructure);
	    $scope.render();
	});	

	$scope.$watch('structureColors', function() {
		if ($scope.structureColors != 'normal'){
			DeformedService.hideDeformed($scope.scene, $scope.deformed);
		} else {
			DeformedService.setDeformedTransparent($scope.scene, $scope.deformed);
		}
	    ModelService.colorizeModel($scope.scene, $scope.model, $scope.deformed, $scope.structureColors, $scope.structureView != 'normal');
	    $scope.render();
	});

	$scope.toggleScaleStructure = function(isRange){
		//Arreglos para slider con distinta escala!! Utilizo valor auxiliar en el range y ajusto el factor de escala real acorde
		if(!isNaN(parseFloat($scope.scaleStructure))){
			$scope.scaleStructure=parseFloat($scope.scaleStructure);
		}
		if(isRange){
			
				$scope.scaleStructure=$scope.scaleStructureAux;
			
		}else{
				if($scope.scaleStructure > 1000){
					$scope.scaleStructure=1000;
				}
				$scope.scaleStructureAux=$scope.scaleStructure;
		}
	}	


	}]);