var app = angular.module('IETFEM');
app.controller('MaterialesCtrl',['$scope','ModelService',function($scope,ModelService){
		$scope.materiales = $scope.model.materiales;
		$scope.nuevoMaterial={};

		$scope.nameToRemove="";
		$scope.selectedIndex=null;

		$scope.existeMaterial = function(){
			if($scope.materiales.length > 0){
				for(var i = 0; i < $scope.materiales.length ;i++){
					if($scope.materiales[i].id == $scope.nuevoMaterial.id){
						return true;
					}
				}
			}
			return false;
		};

		$scope.addMaterial= function(){
			if(!$scope.existeMaterial()){
				ModelService.addMaterial($scope.nuevoMaterial.name,$scope.nuevoMaterial.youngModule,$scope.nuevoMaterial.gamma,$scope.nuevoMaterial.alpha,$scope.nuevoMaterial.nu,$scope.model);
				$scope.nuevoMaterial={
					id: 0,
					name:"Nuevo Material",
					youngModule:0,
					gamma:0,
					alpha:0,
					nu:0
				};
				$scope.materialForm.$setPristine();
			}
		};

		var getIndex= function(){
			for(var i = 0; i < $scope.materiales.length ;i++){
				if($scope.materiales[i].name === $scope.nameToRemove){
					return i;
				}
			}
			return -1;
		};

		$scope.removeMaterial= function(){
			if($scope.selectedIndex != null){	
				$scope.materiales.splice(getIndex($scope.nameToRemove),1);
			}
		};

		$scope.setMaterialToRemove= function(m,indexOfTable){
			if($scope.selectedIndex != indexOfTable){// Si seleccione otra entrada
				$scope.nameToRemove=m.name;
				$scope.selectedIndex= indexOfTable;
			}else{// Si seleccione el q ya estaba seleccionado
				$scope.nameToRemove=null;
				$scope.selectedIndex= null;
			}
		};

		$scope.getSelectedIndex= function(){
			return $scope.selectedIndex;
		};

	}]);