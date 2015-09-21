angular.module('IETFEM')
.factory('DefaultsService',function() {

	var LineaMaterial=null;
	var LineaSection=null;

	var getLineMaterial = function(){
		return LineaMaterial;
	};

	var getLineSection = function(){
		return LineaSection;
	};

	var setLineMaterial = function(m){
		LineaMaterial=m;
	};

	var setLineSection = function(s){
		LineaSection=s;
	};

	return {
		getLineMaterial: getLineMaterial,
		getLineSection: getLineSection,
		setLineMaterial: setLineMaterial,
		setLineSection: setLineSection
	}

	});