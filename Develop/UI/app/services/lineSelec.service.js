angular.module('IETFEM')
.factory('LineaSelecService', ['leftMenuService',function(leftMenuService){
  		var lineaSeleccionada={
			id: 0,
			sceneId: 0,
			material:0,
			section:0,
			start: 0,
			end: 0
		  };

		var lineaReal;// La que esta en el modelo
		var infoLineaForm;// Es el formulario, para poder resetearlo
    	return {
    		getLineaReal: function() {
            	return lineaReal;
       		},
        	getLinea: function() {
            	return lineaSeleccionada;
       		},
			setLinea: function(value) {
				lineaReal=value;

				lineaSeleccionada.id=value.id;
				lineaSeleccionada.sceneId=value.sceneId;
				lineaSeleccionada.material=value.material;
				lineaSeleccionada.section=value.section;
				lineaSeleccionada.start=value.start;
				lineaSeleccionada.end=value.end;
				leftMenuService.setLastSelected("LINEA");
				
			},
			setInfoLineaForm: function(f){
				infoLineaForm=f;
			},
			resetLineaSeleccionada: function(){
				lineaSeleccionada.id=0;
				lineaSeleccionada.sceneId=0;
				lineaSeleccionada.materiales=0;
				lineaSeleccionada.sections=0;
				lineaSeleccionada.start=0;
				lineaSeleccionada.end=0;
			},
			resetForm: function(){
				if(typeof infoLineaForm != 'undefined'){
				    infoLineaForm.$setPristine();    
			   }
			}
		}
	}]);