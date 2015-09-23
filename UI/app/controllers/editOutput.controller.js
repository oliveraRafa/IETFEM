var app = angular.module('IETFEM');
	app.controller('editOutputCtrl',['$scope','ModelService', 'DeformedService', function($scope, ModelService, DeformedService){
	
	$scope.$watch('structureView', function() {
	    if ($scope.structureView === 'normal'){
	    	ModelService.setModelMaterial($scope.scene, $scope.model, new THREE.MeshBasicMaterial( {color: 0x000000} ));
	    	DeformedService.setDeformedMaterial($scope.scene, $scope.deformed, new THREE.MeshBasicMaterial({color: 0x29088A, transparent: true, opacity: 0.15}));
	    } else {
	    	ModelService.setModelMaterial($scope.scene, $scope.model, new THREE.MeshBasicMaterial( {color: 0x000000, transparent: true, opacity: 0.15} ));
	    	DeformedService.setDeformedMaterial($scope.scene, $scope.deformed, new THREE.MeshBasicMaterial({color: 0x29088A}));
	    }
	    $scope.render();
	});	

	$scope.$watch('scaleStructure', function() {
	    DeformedService.scaleDeformed($scope.scene, $scope.deformed, $scope.model, $scope.scaleStructure);
	    $scope.render();
	});	


	}]);