angular.module('IETFEM')
.factory('leftMenuService', function() {
		var addingLines = false;
		var addingNodes=false;
		var addingGrillas=false;
		var viewOptions=false;
		var selecting=false;
		var lastSelected=null;//Puede ser "LINEA" o "NODO"
		

		return {
			getAddingLines: function(){
				return addingLines;
			},
			getAddingNodes: function(){
				return addingNodes;
			},
			getAddingGrillas: function(){
				return addingGrillas;
			},
			getSelecting: function(){
				return selecting;
			},
			getViewOptions: function(val){
				return viewOptions;
			},
			setSelecting: function(val){
				selecting=val;
			},
			setAddingGrillas: function(val){
				addingGrillas=val;
			},
			setAddingLines: function(val){
				addingLines=val;
			},
			setAddingNodes: function(val){
				addingNodes=val;
			},
			setViewOptions: function(val){
				viewOptions=val;
			},
			getLastSelected: function(){
				return lastSelected;
			},
			setLastSelected: function(val){
				lastSelected=val;
			}
		}
	});