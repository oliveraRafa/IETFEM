var IETFEM = {
			
	//Agrega una grilla
	addGrid: function() {
				
		var line, geometry, i, j;
		var posX = parseFloat(document.getElementById("posX").value);
		var posY = parseFloat(document.getElementById("posY").value);
		var posZ = parseFloat(document.getElementById("posZ").value);
		var largoX = parseFloat(document.getElementById("largoX").value);
		var largoY = parseFloat(document.getElementById("largoY").value);
		var largoZ = parseFloat(document.getElementById("largoZ").value);
		var separatorX = parseFloat(document.getElementById("separatorX").value);
		var separatorY = parseFloat(document.getElementById("separatorY").value);
		var separatorZ = parseFloat(document.getElementById("separatorZ").value);
		var material = new THREE.LineBasicMaterial({color: 0xFF0000, transparent: true, opacity: 0.15});
		
		for (i=0;i<largoY*separatorY;i=i+separatorY){
			for (j=0;j<largoX*separatorX;j=j+separatorX){
				Space.drawLine(posX+j, posY+i, posZ+0, posX+j, posY+i, posZ+(largoZ-1)*separatorZ, material)
			}
			for (j=0;j<largoZ*separatorZ;j=j+separatorZ){
				Space.drawLine(posX+0, posY+i, posZ+j, posX+(largoX-1)*separatorX, posY+i, posZ+j, material)
				for (k=0;k<largoX*separatorX;k=k+separatorX){
					var sphereGeometry = new THREE.SphereGeometry( 0.05, 10, 10 );
					var sphereMaterial = new THREE.MeshBasicMaterial( {color: 0xFF0000, transparent: true, opacity: 0.15} );
					var sphere = new THREE.Mesh( sphereGeometry, sphereMaterial );
					sphere.position.x = posX+k
					sphere.position.y = posY+i
					sphere.position.z = posZ+j
					scene.add(sphere);
					helpObjects.push(sphere);
					if (i > 0){
						Space.drawLine(posX+k, posY+i-separatorY, posZ+j, posX+k, posY+i, posZ+j, material)
					}
				}
			}
		}

		render()
	
	},
			
	//Agrega un punto
	addPoint: function(){
		var x = parseFloat(document.getElementById("posX").value);
		var y = parseFloat(document.getElementById("posY").value);
		var z = parseFloat(document.getElementById("posZ").value);
		Space.drawPoint(x,y,z);
		Model.addPointToModel(x,y,z);
		render();
	},
			
	//Agrega una pertícula
	addParticle: function(x,y,z){
		var particleGeometry  = new THREE.Geometry;
		var point = new THREE.Vector3(x,y,z);
		particleGeometry.vertices.push(point);
		var particleMaterial = new THREE.PointCloudMaterial({color: 0x000000,size: 0.2});
		var particle = new THREE.PointCloud(particleGeometry, particleMaterial);	
		scene.add(particle);
		render();
	},

	//Setea vista 2D
	set2D: function(){
		tridimensional = false;
		camera.position.x = 0;		
		camera.position.y = 10;		
		camera.position.z = 0;		
		camera.lookAt(new THREE.Vector3(0,0,0));
		controls.removeEventListener( 'change', render );
		render();				
	},
			
	//Setea vista 3D
	set3D: function (){
		tridimensional = true;
		camera.position.x = 5;
		camera.position.y = 10;
		camera.position.z = 5;	
		camera.lookAt(new THREE.Vector3(0,0,0));				
		controls.addEventListener( 'change', render );
		render();				
	}
};