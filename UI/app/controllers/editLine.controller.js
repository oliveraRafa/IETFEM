var app = angular.module('IETFEM');
app.controller('editLineCtrl',['$scope','ModelService','LineaSelecService',function($scope,ModelService,LineaSelecService){
		$scope.miLinea=LineaSelecService.getLinea();//Es una copia del punto del modelo!
		$scope.misMateriales= $scope.model.materiales;
		$scope.misSecciones= $scope.model.secciones;


		this.updated= function(){
			var lineaModelo= LineaSelecService.getLineaReal();
			if( typeof lineaModelo != 'undefined' &&
				lineaModelo.material == $scope.miLinea.material &&
				lineaModelo.section == $scope.miLinea.section
			){
				return true;
			}else{
				
				return false;
			}
		};


		
		this.updateLine= function(){
			
			var lineaModelo= LineaSelecService.getLineaReal();
			LineaSelecService.setInfoLineaForm($scope.infoLineaForm);
			if(typeof lineaModelo != 'undefined'){
				lineaModelo.material= $scope.miLinea.material;
				lineaModelo.section= $scope.miLinea.section;
				LineaSelecService.resetForm();
			}
		};	

		this.existsLineToRemove= function(){
			return LineaSelecService.getLinea().id != 0;
		};	

		this.deleteLine = function(){
			var lineToRemove= LineaSelecService.getLinea();
			var sceneObject =$scope.scene.getObjectById(lineToRemove.sceneId);
			
			ModelService.removeLineFromModel(lineToRemove.id,$scope.model);
			LineaSelecService.resetLineaSeleccionada();
			$scope.scene.remove(sceneObject);

			$scope.render();
		};

	}]);