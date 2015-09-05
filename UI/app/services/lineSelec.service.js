angular.module('IETFEM')
.factory('LineaSelecService', ['leftMenuService',function(leftMenuService){
  		var lineaSeleccionada={
			id: 0,
			sceneId: 0,
			material:null,
			section:null,
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
				lineaSeleccionada.materiales=null;
				lineaSeleccionada.sections=null;
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