var app = angular.module('IETFEM');
app.controller('MaterialesCtrl',['$scope','ModelService',function($scope,ModelService){
		$scope.materiales = $scope.model.materiales;
		
		$scope.nuevoMaterial={};
		$scope.aEditarMaterialIndex=null;
		$scope.editando=false;

		$scope.nameToRemove="";
		$scope.selectedIndex=null;

		$scope.existeMaterial = function(){
			if($scope.materiales.length > 0){
				for(var i = 0; i < $scope.materiales.length ;i++){
					if($scope.materiales[i].name == $scope.nuevoMaterial.name){
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

				$scope.aEditarMaterialIndex=null;
				$scope.editando=false;
			}else{// Si seleccione el q ya estaba seleccionado
				$scope.nameToRemove=null;
				$scope.selectedIndex= null;
				
				$scope.aEditarMaterialIndex=null;
				$scope.editando=false;
			}
		};

		$scope.getSelectedIndex= function(){
			return $scope.selectedIndex;
		};

		$scope.editMaterial= function(){
			if($scope.aEditarMaterialIndex == null){
				//Seteamos el formulario con el material a editar.
				$scope.aEditarMaterialIndex= $scope.selectedIndex;
				$scope.editando=true;

				$scope.nuevoMaterial.id= $scope.materiales[$scope.selectedIndex].id;
				
				$scope.nuevoMaterial.name= $scope.materiales[$scope.selectedIndex].name;
				
				$scope.nuevoMaterial.youngModule= $scope.materiales[$scope.selectedIndex].youngModule;

				$scope.nuevoMaterial.gamma= $scope.materiales[$scope.selectedIndex].gamma;

				$scope.nuevoMaterial.alpha= $scope.materiales[$scope.selectedIndex].alpha;

				$scope.nuevoMaterial.nu= $scope.materiales[$scope.selectedIndex].nu;
				
			}else{
				$scope.materiales[$scope.aEditarMaterialIndex].id= $scope.nuevoMaterial.id;
				$scope.materiales[$scope.aEditarMaterialIndex].name= $scope.nuevoMaterial.name;
				$scope.materiales[$scope.aEditarMaterialIndex].youngModule= $scope.nuevoMaterial.youngModule;
				$scope.materiales[$scope.aEditarMaterialIndex].gamma= $scope.nuevoMaterial.gamma;
				$scope.materiales[$scope.aEditarMaterialIndex].alpha= $scope.nuevoMaterial.alpha;
				$scope.materiales[$scope.aEditarMaterialIndex].nu = $scope.nuevoMaterial.nu;

				//deja el modo edicion y deselecciona el index seleccionado
				$scope.aEditarMaterialIndex= null;
				$scope.editando=false;
				$scope.selectedIndex=null;
				//limpio el formulario
				$scope.nuevoMaterial={
					id: 0,
					name:"Nuevo Material",
					youngModule:0,
					gamma:0,
					alpha:0,
					nu:0
				};
			}
		};

		$scope.isEditing= function(){
			return $scope.editando;
		};

	}]);