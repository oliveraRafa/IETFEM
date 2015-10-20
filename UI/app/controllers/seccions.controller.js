var app = angular.module('IETFEM');
app.controller('SeccionesCtrl',['$scope','ModelService',function($scope,ModelService){
		$scope.secciones = $scope.model.secciones;
		$scope.nuevaSeccion={
			section:0
		};

		$scope.sectionToRemove=0;
		$scope.selectedIndex=null;

		$scope.existeSeccion = function(){
			if($scope.secciones.length > 0){
				for(var i = 0; i < $scope.secciones.length ;i++){
					if($scope.secciones[i].id == $scope.nuevaSeccion.id){
						return true;
					}
				}
			}
			return false;
		};

		$scope.addSection= function(){
			if(!$scope.existeSeccion()){
				ModelService.addSection($scope.nuevaSeccion.section,$scope.model);
				$scope.nuevaSeccion={
					id: 0,
					section:0
				};
				$scope.seccionForm.$setPristine();
			}
		};

		var getIndex= function(){
			for(var i = 0; i < $scope.secciones.length ;i++){
				if($scope.secciones[i].section === $scope.sectionToRemove){
					return i;
				}
			}
			return -1;
		};

		$scope.removeSection= function(){
			if($scope.selectedIndex != null){	
				$scope.secciones.splice(getIndex($scope.sectionToRemove),1);
			}
		};

		$scope.setSectionToRemove= function(m,indexOfTable){
			if($scope.selectedIndex != indexOfTable){// Si seleccione otra entrada
				$scope.sectionToRemove=m.section;
				$scope.selectedIndex= indexOfTable;
			}else{// Si seleccione el q ya estaba seleccionado
				$scope.sectionToRemove=null;
				$scope.selectedIndex= null;
			}
		};

		$scope.getSelectedIndex= function(){
			return $scope.selectedIndex;
		};

	}]);