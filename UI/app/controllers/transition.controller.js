var app = angular.module('IETFEM');
	app.controller('transitionCtrl',['$scope',function($scope){
	
		$scope.transitionModals = function(){
			$('#importModelModal').modal('hide');
			$('#transitionModal').modal('show');
		}

	}]
);