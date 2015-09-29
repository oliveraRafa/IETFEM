var app = angular.module('IETFEM');
	app.controller('editOutputCtrl',['$scope','ModelService', 'DeformedService', function($scope, ModelService, DeformedService){
	
	$scope.$watch('structureView', function() {
	    if ($scope.structureView === 'normal'){
	    	ModelService.setModelOpaque($scope.scene, $scope.model);
	    	DeformedService.setDeformedTransparent($scope.scene, $scope.deformed);
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
	    DeformedService.colorizeDeformed($scope.scene, $scope.deformed, $scope.structureColors, $scope.structureView === 'normal');
	    $scope.render();
	});	


	}]);