% =====================================================
% =============      IETFEM     =======================
% =====================================================
%
% Instituto de Estructuras y Transporte
% Finite Element Method solver
% Facultad de Ingeniería
% Universidad de la República
% Uruguay
%
% Project Leaders:
%   Pablo Castrillo Green
%   Jorge Martín Perez Zerpa
%
% Colaborators:
%   A. Spalvier
%   ARCHFEM: Mihdi Caballero / Yessica Rodriguez / Francisco Vidovich
%   anybody who would like to contribute...
%
% site:
%   
%
% Last update:  Mar-2015  v.2.11
%
% Developed for GNU-Octave 3.6.4
% View license.txt for licensing information (inside tutoriales folder).
%
% =======================================================
%

tiempo = reading_time + preprocess_time + process_time + posprocess_time;
tiempo_TXT = 0;
if TEXT(1) == 1
  if Lenguage == 1
    fprintf('\nIETFEM start TXT output module.\n')
  else
    fprintf('\nIETFEM inicio el modulo de salida TXT.\n')
  end
  cd TXT
		cd Linear
			Complete_txt_lin
			Axial_force_txt_lin
			Deformed_txt_lin
			Reac_txt_lin
			Strain_txt_lin
			Stress_txt_lin
		cd ..
    if SD_LD ~= 1
			cd Finite
				Complete_txt_fin
				Convergence_txt_fin
				Axial_force_txt_fin
				Deformed_txt_fin
				Reac_txt_fin
				Strain_txt_fin
				Stress_txt_fin
			cd ..
		end
  cd ..
  if Lenguage == 1
    fprintf(' - After %6.3f seconds, IETFEM complete TXT output modele.\n',tiempo_TXT)
  else
    fprintf(' - Luego de %6.3f segundos, IETFEM competo el modulo de salida TXT.\n',tiempo_TXT)
  end
end
tiempo_TEX = 0;
if TEXT(2) == 1
  if Lenguage == 1
    fprintf('\nIETFEM start TEX output module.\n')
  else
    fprintf('\nIETFEM inicio el modulo de salida TEX.\n')
  end
  cd TEX
		cd Linear
			Complete_tex_lin
			Axial_force_tex_lin
			Deformed_tex_lin
			Reac_tex_lin
			Strain_tex_lin
			Stress_tex_lin
		cd ..	
		if SD_LD ~= 1
			cd Finite
				Complete_tex_fin
				Convergence_tex_fin
				Axial_force_tex_fin
				Deformed_tex_fin
				Reac_tex_fin
				Strain_tex_fin
				Stress_tex_fin
			cd ..
    end
  cd ..
  if Lenguage == 1
    fprintf(' - After %6.3f seconds, IETFEM complete TEX output modele.\n',tiempo_TEX)
  else
    fprintf(' - Luego de %6.3f segundos, IETFEM competo el modulo de salida TEX.\n',tiempo_TEX)
  end
end

tiempo = tiempo + tiempo_TXT+tiempo_TEX;

if Lenguage == 1
  fprintf('\nIETFEM end after %6.3f seconds.\n',tiempo)
else
  fprintf('\nIETFEM finalizo luego de %6.3f segundos.\n',tiempo)
end
