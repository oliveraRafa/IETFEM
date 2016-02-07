var app = angular.module('IETFEM');
app.controller('SeccionesCtrl',['$scope','ModelService',function($scope,ModelService){
		$scope.secciones = $scope.model.secciones;
		$scope.nuevaSeccion={};
		$scope.aEditarSeccionIndex=null;
		$scope.editando=false;

		$scope.sectionToRemove=0;
		$scope.selectedIndex=null;

		$scope.existeSeccion = function(){
			if($scope.secciones.length > 0){
				for(var i = 0; i < $scope.secciones.length ;i++){
					if($scope.secciones[i].name == $scope.nuevaSeccion.name){
						return true;
					}
				}
			}
			return false;
		};

		$scope.addSection= function(){
			if(!$scope.existeSeccion()){
				ModelService.addSection($scope.nuevaSeccion.name,$scope.nuevaSeccion.section,$scope.model);
				$scope.nuevaSeccion={
					id: 0,
					section:0,
					name:"Nueva Seccion"
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

				$scope.aEditarSeccionIndex=null;
				$scope.editando=false;
			}else{// Si seleccione el q ya estaba seleccionado
				$scope.sectionToRemove=null;
				$scope.selectedIndex= null;

				$scope.aEditarSeccionIndex=null;
				$scope.editando=false;
			}
		};

		$scope.getSelectedIndex= function(){
			return $scope.selectedIndex;
		};

		$scope.editSeccion= function(){
			if($scope.aEditarSeccionIndex == null){
				//Seteamos el formulario con el material a editar.
				$scope.aEditarSeccionIndex= $scope.selectedIndex;
				$scope.editando=true;

				$scope.nuevaSeccion.section= $scope.secciones[$scope.selectedIndex].section;
				
				$scope.nuevaSeccion.name= $scope.secciones[$scope.selectedIndex].name;
				
			}else{
				$scope.secciones[$scope.aEditarSeccionIndex].section= $scope.nuevaSeccion.section;
				$scope.secciones[$scope.aEditarSeccionIndex].name= $scope.nuevaSeccion.name;
			

				//deja el modo edicion y deselecciona el index seleccionado
				$scope.aEditarSeccionIndex= null;
				$scope.editando=false;
				$scope.selectedIndex=null;
				//limpio el formulario
				$scope.nuevaSeccion={
					section:0,
					name:"Nueva Seccion"
				};
			}
		};

		$scope.isEditing= function(){
			return $scope.editando;
		};

	}]);